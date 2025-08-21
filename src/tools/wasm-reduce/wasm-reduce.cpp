/*
 * Copyright 2017 WebAssembly Community Group participants
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

//
// Tries to reduce the input wasm into the smallest possible wasm
// that still generates the same result on a given command. This is
// useful to reduce bug testcases, for example, if a file crashes
// the optimizer, you can reduce it to find the smallest file that
// also crashes it (which generally will show the same bug, in a
// much more debuggable manner).
//

#include <cstdio>
#include <cstdlib>

#include "reducer.h"
#include "support/colors.h"
#include "support/command-line.h"
#include "support/file.h"
#include "support/path.h"
#include "tools/tool-options.h"
#include "wasm-io.h"

#include "tools/wasm-reduce/reducer.h"

namespace wasm {

// A timeout on every execution of the command.
size_t timeout = 2;

// Whether to save all intermediate working files as we go.
bool saveAllWorkingFiles = false;

// A string of feature flags and other things to pass while reducing. The
// default of enabling all features should work in most cases.
std::string extraFlags = "-all";

ProgramResult expected;

// Removing functions is extremely beneficial and efficient. We aggressively
// try to remove functions, unless we've seen they can't be removed, in which
// case we may try again but much later.
std::unordered_set<Name> functionsWeTriedToRemove;

// The index of the working file we save, when saveAllWorkingFiles. We must
// store this globally so that the difference instances of Reducer do not
// overlap.
size_t workingFileIndex = 0;

} // namespace wasm

using namespace wasm;

int main(int argc, const char* argv[]) {
  std::string input, test, working, command;
  // By default, look for binaries alongside our own binary.
  std::string binDir = Path::getDirName(argv[0]);
  bool binary = true, deNan = false, verbose = false, debugInfo = false,
       force = false;

  const std::string WasmReduceOption = "wasm-reduce options";

  ToolOptions options(
    "wasm-reduce",
    R"(Reduce a wasm file to a smaller one with the same behavior on a given command.

Typical usage:

  wasm-reduce orig.wasm '--command=bash a.sh' --test t.wasm --working w.wasm

The original file orig.wasm is where we begin. We then repeatedly test a small
reduction of it by writing that modification to the 'test file' (specified by
'--test'), and we run the command, in this example 'bash a.sh'. That command
should use the test file (and not the original file or any other one). Whenever
the reduction works, we write that new smaller file to the 'working file'
(specified by '--working'). The reduction 'works' if it correctly preserves the
behavior of the command on the original input, specifically, that it has the
same stdout and the result return code. Each time reduction works we continue to
reduce from that point (and each time it fails, we go back and try something
else).

As mentioned above, the command should run on the test file. That is, the first
thing that wasm-reduce does on the example above is, effectively,

  cp orig.wasm t.wasm
  bash a.sh

In other words, it copies the original to the test file, and runs the command.
Whatever the command does, we will preserve as we copy progressively smaller
files to t.wasm. As we make progress, the smallest file will be written to
the working file, w.wasm, and when reduction is done you will find the final
result there.

Comparison to creduce:

1. creduce requires the command to return 0. wasm-reduce is often used to reduce
   crashes, which have non-zero return codes, so it is natural to allow any
   return code. As mentioned above, we preserve the return code as we reduce.
2. creduce ignores stdout. wasm-reduce preserves stdout as it reduces, as part
   of the principle of preserving the original behavior of the command (if your
   stdout varies in uninteresting ways, your command can be a script that runs
   the real command and captures stdout to /dev/null, or filters it).
3. creduce tramples the original input file as it reduces. wasm-reduce never
   modifies the input (to avoid mistakes that cause data loss). Instead,
   when reductions work we write to the 'working file' as mentioned above, and
   the final reduction will be there.
4. creduce runs the command in a temp directory. That is safer in general, but
   it is not how the original command ran, and in particular forces additional
   work if you have multiple files (which, for wasm-reduce, is common, e.g. if
   the testcase is a combination of JavaScript and wasm). wasm-reduce runs the
   command in the current directory (of course, your command can be a script
   that changes directory to anywhere else).

More documentation can be found at

  https://github.com/WebAssembly/binaryen/wiki/Fuzzing#reducing
                      )");
  options
    .add("--command",
         "-cmd",
         "The command to run on the test, that we want to reduce while keeping "
         "the command's output identical. "
         "We look at the command's return code and stdout here (TODO: stderr), "
         "and we reduce while keeping those unchanged.",
         WasmReduceOption,
         Options::Arguments::One,
         [&](Options* o, const std::string& argument) { command = argument; })
    .add("--test",
         "-t",
         "Test file (this will be written to test, the given command should "
         "read it when we call it)",
         WasmReduceOption,
         Options::Arguments::One,
         [&](Options* o, const std::string& argument) { test = argument; })
    .add("--working",
         "-w",
         "Working file (this will contain the current good state while doing "
         "temporary computations, "
         "and will contain the final best result at the end)",
         WasmReduceOption,
         Options::Arguments::One,
         [&](Options* o, const std::string& argument) { working = argument; })
    .add("--binaries",
         "-b",
         "binaryen binaries location (bin/ directory)",
         WasmReduceOption,
         Options::Arguments::One,
         [&](Options* o, const std::string& argument) {
           // Add separator just in case
           binDir = argument + Path::getPathSeparator();
         })
    .add("--text",
         "-S",
         "Emit intermediate files as text, instead of binary (also make sure "
         "the test and working files have a .wat or .wast suffix)",
         WasmReduceOption,
         Options::Arguments::Zero,
         [&](Options* o, const std::string& argument) { binary = false; })
    .add("--denan",
         "",
         "Avoid nans when reducing",
         WasmReduceOption,
         Options::Arguments::Zero,
         [&](Options* o, const std::string& argument) { deNan = true; })
    .add("--verbose",
         "-v",
         "Verbose output mode",
         WasmReduceOption,
         Options::Arguments::Zero,
         [&](Options* o, const std::string& argument) { verbose = true; })
    .add("--debugInfo",
         "-g",
         "Keep debug info in binaries",
         WasmReduceOption,
         Options::Arguments::Zero,
         [&](Options* o, const std::string& argument) { debugInfo = true; })
    .add("--force",
         "-f",
         "Force the reduction attempt, ignoring problems that imply it is "
         "unlikely to succeed",
         WasmReduceOption,
         Options::Arguments::Zero,
         [&](Options* o, const std::string& argument) { force = true; })
    .add("--timeout",
         "-to",
         "A timeout to apply to each execution of the command, in seconds "
         "(default: 2)",
         WasmReduceOption,
         Options::Arguments::One,
         [&](Options* o, const std::string& argument) {
           timeout = atoi(argument.c_str());
           std::cout << "|applying timeout: " << timeout << "\n";
         })
    .add("--extra-flags",
         "-ef",
         "Extra commandline flags to pass to wasm-opt while reducing. "
         "(default: --enable-all)",
         WasmReduceOption,
         Options::Arguments::One,
         [&](Options* o, const std::string& argument) {
           extraFlags = argument;
           std::cout << "|applying extraFlags: " << extraFlags << "\n";
         })
    .add("--save-all-working",
         "-saw",
         "Save all intermediate working files, as $WORKING.0, .1, .2 etc",
         WasmReduceOption,
         Options::Arguments::Zero,
         [&](Options* o, const std::string& argument) {
           saveAllWorkingFiles = true;
           std::cout << "|saving all intermediate working files\n";
         })
    .add_positional(
      "INFILE",
      Options::Arguments::One,
      [&](Options* o, const std::string& argument) { input = argument; });
  options.parse(argc, argv);

  if (debugInfo) {
    extraFlags += " -g ";
  }

  if (test.size() == 0) {
    Fatal() << "test file not provided\n";
  }
  if (working.size() == 0) {
    Fatal() << "working file not provided\n";
  }

  if (!binary) {
    Colors::setEnabled(false);
  }

  Path::setBinaryenBinDir(binDir);

  std::cerr << "|wasm-reduce\n";
  std::cerr << "|input: " << input << '\n';
  std::cerr << "|test: " << test << '\n';
  std::cerr << "|working: " << working << '\n';
  std::cerr << "|bin dir: " << binDir << '\n';
  std::cerr << "|extra flags: " << extraFlags << '\n';

  // get the expected output
  copy_file(input, test);
  expected.getFromExecution(command);

  std::cerr << "|expected result:\n" << expected << '\n';
  std::cerr << "|!! Make sure the above is what you expect! !!\n\n";

  auto stopIfNotForced = [&](std::string message, ProgramResult& result) {
    std::cerr << "|! " << message << '\n' << result << '\n';
    if (!force) {
      Fatal() << "|! stopping, as it is very unlikely reduction can succeed "
                 "(use -f to ignore this check)";
    }
  };

  if (expected.time + 1 >= timeout) {
    stopIfNotForced("execution time is dangerously close to the timeout - you "
                    "should probably increase the timeout",
                    expected);
  }

  if (!force) {
    std::cerr << "|checking that command has different behavior on different "
                 "inputs (this "
                 "verifies that the test file is used by the command)\n";
    // Try it on an invalid input.
    {
      std::ofstream dst(test, std::ios::binary);
      dst << "waka waka\n";
    }
    ProgramResult resultOnInvalid(command);
    if (resultOnInvalid == expected) {
      // Try it on a valid input.
      Module emptyModule;
      ModuleWriter writer(options.passOptions);
      writer.setBinary(true);
      writer.write(emptyModule, test);
      ProgramResult resultOnValid(command);
      if (resultOnValid == expected) {
        Fatal()
          << "running the command on the given input gives the same result as "
             "when running it on either a trivial valid wasm or a file with "
             "nonsense in it. does the script not look at the test file (" +
               test + ")? (use -f to ignore this check)";
      }
    }
  }

  std::cerr << "|checking that command has expected behavior on canonicalized "
               "(read-written) binary\n";
  {
    // read and write it
    auto cmd = Path::getBinaryenBinaryTool("wasm-opt") + " " + input + " -o " +
               test + " " + extraFlags;
    if (!binary) {
      cmd += " -S ";
    }
    ProgramResult readWrite(cmd);
    if (readWrite.failed()) {
      stopIfNotForced("failed to read and write the binary", readWrite);
    } else {
      ProgramResult result(command);
      if (result != expected) {
        stopIfNotForced("running command on the canonicalized module should "
                        "give the same results",
                        result);
      }
    }
  }

  copy_file(input, working);
  auto workingSize = file_size(working);
  std::cerr << "|input size: " << workingSize << "\n";

  std::cerr << "|starting reduction!\n";

  int factor = binary ? workingSize * 2 : workingSize / 10;

  size_t lastDestructiveReductions = 0;
  size_t lastPostPassesSize = 0;

  bool stopping = false;

  while (1) {
    Reducer reducer(
      command, test, working, binary, deNan, verbose, debugInfo, options);

    // run binaryen optimization passes to reduce. passes are fast to run
    // and can often reduce large amounts of code efficiently, as opposed
    // to detructive reduction (i.e., that doesn't preserve correctness as
    // passes do) since destrucive must operate one change at a time
    std::cerr << "|  reduce using passes...\n";
    auto oldSize = file_size(working);
    reducer.reduceUsingPasses();
    auto newSize = file_size(working);
    auto passProgress = oldSize - newSize;
    std::cerr << "|  after pass reduction: " << newSize << "\n";

    // always stop after a pass reduction attempt, for final cleanup
    if (stopping) {
      break;
    }

    // check if the full cycle (destructive/passes) has helped or not
    if (lastPostPassesSize && newSize >= lastPostPassesSize) {
      std::cerr << "|  progress has stopped, skipping to the end\n";
      if (factor == 1) {
        // this is after doing work with factor 1, so after the remaining work,
        // stop
        stopping = true;
      } else {
        // decrease the factor quickly
        factor = (factor + 1) / 2; // stable on 1
      }
    }
    lastPostPassesSize = newSize;

    // If destructive reductions lead to useful proportionate pass reductions,
    // keep going at the same factor, as pass reductions are far faster.
    std::cerr << "|  pass progress: " << passProgress
              << ", last destructive: " << lastDestructiveReductions << '\n';
    if (passProgress >= 4 * lastDestructiveReductions) {
      std::cerr << "|  progress is good, do not quickly decrease factor\n";
      // While the amount of pass reductions is proportionately high, we do
      // still want to reduce the factor by some amount. If we do not then there
      // is a risk that both pass and destructive reductions are very low, and
      // we get "stuck" cycling through them. In that case we simply need to do
      // more destructive reductions to make real progress. For that reason,
      // decrease the factor by some small percentage.
      factor = std::max(1, (factor * 9) / 10);
    } else {
      if (factor > 10) {
        factor = (factor / 3) + 1;
      } else {
        factor = (factor + 1) / 2; // stable on 1
      }
    }

    // no point in a factor lorger than the size
    assert(newSize > 4); // wasm modules are >4 bytes anyhow
    factor = std::min(factor, int(newSize) / 4);

    // try to reduce destructively. if a high factor fails to find anything,
    // quickly try a lower one (no point in doing passes until we reduce
    // destructively at least a little)
    while (1) {
      std::cerr << "|  reduce destructively... (factor: " << factor << ")\n";
      lastDestructiveReductions = reducer.reduceDestructively(factor);
      if (lastDestructiveReductions > 0) {
        break;
      }
      // we failed to reduce destructively
      if (factor == 1) {
        stopping = true;
        break;
      }
      factor = std::max(
        1, factor / 4); // quickly now, try to find *something* we can reduce
    }

    std::cerr << "|  destructive reduction led to size: " << file_size(working)
              << '\n';
  }
  std::cerr << "|finished, final size: " << file_size(working) << "\n";
  copy_file(working, test); // just to avoid confusion
}
