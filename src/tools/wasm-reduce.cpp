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

#include <memory>
#include <cstdio>
#include <cstdlib>

#include "pass.h"
#include "support/command-line.h"
#include "support/file.h"
#include "wasm-io.h"
#include "wasm-builder.h"
#include "ast/literal-utils.h"
#include "wasm-printing.h"

using namespace wasm;

static void canonicalize(std::string input, std::string output) {
  // reading and writing may alter the size
  int counter = 0;
  while (1) {
    auto oldSize = file_size(input);
    auto code = system(("bin/wasm-opt --dce --vacuum " + input + " -o " + output).c_str());
    assert(code == 0);
    auto newSize = file_size(output);
    if (newSize <= oldSize) break;
    std::cout << "|  <canonicalization: " << oldSize << " => " << newSize << ">\n";
    // do more work, now the input is the output
    input = output;
    counter++;
    assert(counter < 100);
  }
}

struct ProgramResult {
  int code;
  std::string stdout;

  ProgramResult() {}
  ProgramResult(std::string command) {
    getFromExecution(command);
  }

  // runs the command and notes the output
  void getFromExecution(std::string command) {
    // do this using just core stdio.h and stdlib.h, for portability
    // sadly this requires two invokes
    code = system(("timeout 2s " + command + " > /dev/null 2> /dev/null").c_str());
    const int MAX_BUFFER = 1024;
    char buffer[MAX_BUFFER];
    FILE *stream = popen(("timeout 2s " + command + " 2> /dev/null").c_str(), "r");
    while (fgets(buffer, MAX_BUFFER, stream) != NULL) {
      stdout.append(buffer);
    }
    pclose(stream);
  }

  bool operator==(ProgramResult& other) {
    return code == other.code && stdout == other.stdout;
  }
  bool operator!=(ProgramResult& other) {
    return !(*this == other);
  }

  bool failed() {
    return code != 0;
  }

  void dump() {
    std::cout << "[ProgramResult] code: " << code << " stdout: \n" << stdout << "[/ProgramResult]\n";
  }
};

ProgramResult expected;

struct Reducer : public WalkerPass<PostWalker<Reducer, UnifiedExpressionVisitor<Reducer>>> {
  std::string command, test, working;
  bool verbose;

  // test is the file we write to that the command will operate on
  // working is the current temporary state, the reduction so far
  Reducer(std::string command, std::string test, std::string working, bool verbose) : command(command), test(test), working(working), verbose(verbose) {}

  // runs passes in order to reduce, until we can't reduce any more
  // the criterion here is wasm binary size
  void reduceUsingPasses() {
    // run optimization passes until we can't shrink it any more
    std::vector<std::string> passes = {
      "-Oz",
      "-Os",
      "-O1",
      "-O2",
      "-O3",
      "--coalesce-locals --vacuum",
      "--dce",
      "--duplicate-function-elimination",
      "--inlining",
      "--inlining-optimizing",
      "--optimize-level=3 --inlining-optimizing",
      "--local-cse --vacuum",
      "--memory-packing",
      "--remove-unused-names --merge-blocks --vacuum",
      "--optimize-instructions",
      "--precompute",
      "--remove-imports",
      "--remove-memory",
      "--remove-unused-names --remove-unused-brs",
      "--remove-unused-module-elements",
      "--reorder-functions",
      "--reorder-locals",
      "--simplify-locals --vacuum",
      "--simplify-locals-notee --vacuum",
      "--simplify-locals-nostructure --vacuum",
      "--simplify-locals-notee-nostructure --vacuum",
      "--vacuum"
    };
    auto oldSize = file_size(working);
    bool more = true;
    while (more) {
      //std::cout << "|    starting passes loop iteration\n";
      more = false;
      for (auto pass : passes) {
        auto currCommand = "bin/wasm-opt --dce --vacuum " + working + " -o " + test + " " + pass;
        if (verbose) std::cout << "|    trying pass command: " << currCommand << "\n";
        if (!ProgramResult(currCommand).failed()) {
          canonicalize(test, test);
          auto newSize = file_size(test);
          if (newSize < oldSize) {
            // the pass didn't fail, and the size looks smaller, so promising
            // see if it is still has the property we are preserving
            if (ProgramResult(command) == expected) {
              std::cout << "|    command \"" << currCommand << "\" succeeded, reduced size to " << newSize << ", and preserved the property\n";
              copy_file(test, working);
              more = true;
              oldSize = newSize;
            }
          }
        }
      }
    }
    if (verbose) std::cout << "|    done with passes for now\n";
  }

  // does one pass of slow and destructive reduction. returns whether it
  // succeeded or not
  // the criterion here is a logical change in the program. this may actually
  // increase wasm size in some cases, but it should allow more reduction later.
  // @param factor how much to ignore. starting with a high factor skips through
  //               most of the file, which is often faster than going one by one
  //               from the start
  bool reduceDestructively(int factor_) {
    factor = factor_;
    Module wasm;
    ModuleReader reader;
    reader.read(working, wasm);
    // clean up
    PassRunner runner(&wasm);
    runner.add("dce");
    runner.add("vacuum");
    runner.run();
    // prepare
    reduced = 0;
    builder = make_unique<Builder>(wasm);
    funcsSeen = 0;
    // before we do any changes, it should be valid to write out the module:
    // size should be as expected, and output should be as expected
    setModule(&wasm);
    assert(writeAndTestReduction());
    // destroy!
    walkModule(&wasm);
    return reduced;
  }

  // destructive reduction state

  Index reduced;
  Expression* beforeReduction;
  std::unique_ptr<Builder> builder;
  Index funcsSeen;
  int factor;

  // write the module and see if the command still fails on it as expected
  bool writeAndTestReduction() {
    ProgramResult result;
    return writeAndTestReduction(result);
  }

  bool writeAndTestReduction(ProgramResult& out) {
    // write the module out
    ModuleWriter writer;
    writer.setBinary(true);
    writer.write(*getModule(), test);
    canonicalize(test, test);
    if (file_size(test) > file_size(working)) {
      // sometimes a destructive change increases the size (e.g. replace a small node with a const
      // that happens to take more bytes), but this should not risk an infinite loop since we
      // are actually changing behavior in a breaking way each time we find a destructive reduction
      //std::cout << "|      odd sizes " << file_size(test) << " !>! " << file_size(working) << '\n';
      //return false;
    }
    // test it
    out.getFromExecution(command);
    return out == expected;
  }

  bool shouldTryToReduce() {
    static int counter = 0;
    return counter++ % factor == 0;
  }

  // tests a reduction on the current traversal node, and undos if it failed
  bool tryToReplaceCurrent(Expression* with) {
    auto* curr = getCurrent();
    //std::cout << "try " << curr << " => " << with << '\n';
    if (curr->type != with->type) return false;
    if (!shouldTryToReduce()) return false;
    replaceCurrent(with);
    if (!writeAndTestReduction()) {
      replaceCurrent(curr);
      return false;
    }
    std::cout << "|      tryToReplaceCurrent succeeded (in " << getLocation() << ")\n";
    noteReduction();
    return true;
  }

  void noteReduction() {
    reduced++;
    copy_file(test, working);
  }

  // tests a reduction on an arbitrary child
  bool tryToReplaceChild(Expression*& child, Expression* with) {
    if (child->type != with->type) return false;
    if (!shouldTryToReduce()) return false;
    auto* before = child;
    child = with;
    if (!writeAndTestReduction()) {
      child = before;
      return false;
    }
    std::cout << "|      tryToReplaceChild succeeded (in " << getLocation() << ")\n";
    //std::cout << "|      " << before << " => " << with << '\n';
    noteReduction();
    return true;
  }

  std::string getLocation() {
    if (getFunction()) return getFunction()->name.str;
    return "(non-function context)";
  }

  // visitors. in each we try to remove code in a destructive and nontrivial way.
  // "nontrivial" means something that optimization passes can't achieve, since we
  // don't need to duplicate work that they do

  void visitExpression(Expression* curr) {
    if (curr->type == none) {
      if (tryToReduceCurrentToNone()) return;
    } else if (isConcreteWasmType(curr->type)) {
      if (tryToReduceCurrentToConst()) return;
    } else {
      assert(curr->type == unreachable);
      if (tryToReduceCurrentToUnreachable()) return;
    }
    // specific reductions
    if (auto* iff = curr->dynCast<If>()) {
      if (iff->type == none) {
        // perhaps we need just the condition?
        if (tryToReplaceCurrent(builder->makeDrop(iff->condition))) {
          return;
        }
      }
      handleCondition(iff->condition);
    } else if (auto* br = curr->dynCast<Break>()) {
      handleCondition(br->condition);
    } else if (auto* select = curr->dynCast<Select>()) {
      handleCondition(select->condition);
    } else if (auto* sw = curr->dynCast<Switch>()) {
      handleCondition(sw->condition);
    } else if (auto* set = curr->dynCast<SetLocal>()) {
      if (set->isTee()) {
        // maybe we don't need the set
        tryToReplaceCurrent(set->value);
      }
    } else if (auto* unary = curr->dynCast<Unary>()) {
      // maybe we can pass through
      tryToReplaceCurrent(unary->value);
    } else if (auto* binary = curr->dynCast<Binary>()) {
      // maybe we can pass through
      if (!tryToReplaceCurrent(binary->left)) {
        tryToReplaceCurrent(binary->right);
      }
    } else if (auto* call = curr->dynCast<Call>()) {
      handleCall(call);
    } else if (auto* call = curr->dynCast<CallImport>()) {
      handleCall(call);
    } else if (auto* call = curr->dynCast<CallIndirect>()) {
      if (tryToReplaceCurrent(call->target)) return;
      handleCall(call);
    }
  }

  void visitFunction(Function* curr) {
    // extra chance to work on the function toplevel element, as if it can
    // be reduced it's great
    visitExpression(curr->body);
    // finish function
    funcsSeen++;
    static int last = 0;
    int percentage = (100 * funcsSeen) / getModule()->functions.size();
    if (std::abs(percentage - last) >= 5) {
      std::cout << "|    " << percentage << "% of funcs complete\n";
      last = percentage;
    }
  }

  // TODO: bisection on segment shrinking?

  void visitTable(Table* curr) {
    std::cout << "|    try to simplify table\n";
    visitSegmented(curr);
  }

  void visitMemory(Memory* curr) {
    std::cout << "|    try to simplify memory\n";
    visitSegmented(curr);
  }

  template<typename T>
  void visitSegmented(T* curr) {
    // try to reduce to first function
    // shrink segment elements
    for (auto& segment : curr->segments) {
      auto& data = segment.data;
      size_t skip = 1; // when we succeed, try to shrink by more and more, similar to bisection
      for (size_t i = 0; i < data.size() && !data.empty(); i++) {
        if (!shouldTryToReduce()) continue;
        auto save = data;
        for (size_t j = 0; j < skip; j++) {
          if (!data.empty()) data.pop_back();
        }
        if (writeAndTestReduction()) {
          std::cout << "|      shrank segment (skip: " << skip << ")\n";
          noteReduction();
          skip = std::min(size_t(factor), 2 * skip);
        } else {
          data = save;
          break;
        }
      }
    }
    // the "opposite" of shrinking: copy to the first
    // the start
    for (auto& segment : curr->segments) {
      if (segment.data.empty()) continue;
      auto first = segment.data[0];
      for (auto& item : segment.data) {
        if (!shouldTryToReduce()) continue;
        if (item == first) continue;
        auto save = item;
        item = first;
        if (writeAndTestReduction()) {
          std::cout << "|      firstized segment\n";
          noteReduction();
        } else {
          item = save;
        }
      }
    }
  }

  void visitModule(Module* curr) {
    // try to remove exports
    std::cout << "|    try to remove exports\n";
    std::vector<Export> exports;
    for (auto& exp : curr->exports) {
      exports.push_back(*exp);
    }
    for (auto& exp : exports) {
      curr->removeExport(exp.name);
      if (!writeAndTestReduction()) {
        curr->addExport(new Export(exp));
      } else {
        std::cout << "|      removed export " << exp.name << '\n';
        noteReduction();
      }
    }
  }

  // helpers

  // try to replace condition with always true and always false
  void handleCondition(Expression*& condition) {
    if (!condition) return;
    if (condition->is<Const>()) return;
    auto* c = builder->makeConst(Literal(int32_t(0)));
    if (!tryToReplaceChild(condition, c)) {
      c->value = Literal(int32_t(1));
      tryToReplaceChild(condition, c);
    }
  }

  template<typename T>
  void handleCall(T* call) {
    for (auto* op : call->operands) {
      if (tryToReplaceCurrent(op)) return;
    }
  }

  bool tryToReduceCurrentToNone() {
    auto* curr = getCurrent();
    if (curr->is<Nop>()) return false;
    // try to replace with a trivial value
    Nop nop;
    if (tryToReplaceCurrent(&nop)) {
      replaceCurrent(builder->makeNop());
      return true;
    }
    return false;
  }

  // try to replace a concrete value with a trivial constant
  bool tryToReduceCurrentToConst() {
    auto* curr = getCurrent();
    if (curr->is<Const>()) return false;
    // try to replace with a trivial value
    Const* c = builder->makeConst(Literal(int32_t(0)));
    if (tryToReplaceCurrent(c)) return true;
    c->value = LiteralUtils::makeLiteralFromInt32(1, curr->type);
    c->type = curr->type;
    return tryToReplaceCurrent(c);
  }

  bool tryToReduceCurrentToUnreachable() {
    auto* curr = getCurrent();
    if (curr->is<Unreachable>()) return false;
    // try to replace with a trivial value
    Unreachable un;
    if (tryToReplaceCurrent(&un)) {
      replaceCurrent(builder->makeUnreachable());
      return true;
    }
    // maybe a return? TODO
    return false;
  }
};

//
// main
//

int main(int argc, const char* argv[]) {
  std::string input, test, working, command;
  bool verbose = false;
  Options options("wasm-reduce", "Reduce a wasm file to a smaller one that has the same behavior on a given command");
  options
      .add("--command", "-cmd", "The command to run on the test, that we want to reduce while keeping the command's output identical. "
                                "We look at the command's return code and stdout here (TODO: stderr), "
                                "and we reduce while keeping those unchanged.",
           Options::Arguments::One,
           [&](Options* o, const std::string& argument) {
             command = argument;
           })
      .add("--test", "-t", "Test file (this will be written to to test, the given command should read it when we call it)",
           Options::Arguments::One,
           [&](Options* o, const std::string& argument) {
             test = argument;
           })
      .add("--working", "-w", "Working file (this will contain the current good state while doing temporary computations, "
                              "and will contain the final best result at the end)",
           Options::Arguments::One,
           [&](Options* o, const std::string& argument) {
             working = argument;
           })
      .add("--verbose", "-v", "Verbose output mode",
           Options::Arguments::Zero,
           [&](Options* o, const std::string& argument) {
             verbose = true;
           })
      .add_positional("INFILE", Options::Arguments::One,
                      [&](Options* o, const std::string& argument) {
                        input = argument;
                      });
  options.parse(argc, argv);

  if (test.size() == 0) Fatal() << "test file not provided\n";
  if (working.size() == 0) Fatal() << "working file not provided\n";

  std::cout << "|input: " << input << '\n';
  std::cout << "|test: " << test << '\n';
  std::cout << "|working: " << working << '\n';

  // get the expected output
  copy_file(input, test);
  expected.getFromExecution(command);

  std::cout << "|expected result:\n";
  expected.dump();

  // sanity check - we should start with an invalid module, and one
  // that we can read and write TODO: allow reducing things we can't
  // even do that with
  std::cout << "|checking that command has expected behavior on canonicalized (read-written) binary\n";
  {
    canonicalize(input, test);
    ProgramResult result(command);
    if (result != expected) {
      result.dump();
      Fatal() << "running command on the canonicalized module should give the same results";
    }
  }

  // copy test file (that was just written) to working, which we will use from now on
  // starting from the binary binaryen output canonicalizes, so we are not on text
  // input or input from somewhere else
  copy_file(test, working);
  std::cout << "|canonicalized input size: " << file_size(working) << "\n";

  std::cout << "|starting reduction!\n";

  int factor = 4096;

  while (1) {
    Reducer reducer(command, test, working, verbose);

    // run binaryen optimization passes to reduce. passes are fast to run
    // and can often reduce large amounts of code efficiently, as opposed
    // to detructive reduction (i.e., that doesn't preserve correctness as
    // passes do) since destrucive must operate one change at a time
    std::cout << "|  reduce using passes...\n";
    auto oldSize = file_size(working);
    reducer.reduceUsingPasses();
    auto newSize = file_size(working);

    // if we reduced quited a lot using passes, we don't need to decrease
    // the factor - it's almost like we're on another file, so keep going
    // in similar wide sweeps
    if ((100*newSize)/oldSize <= 90) {
      // don't change
    } else {
      if (factor > 10) {
        factor = (factor / 2) - 1; // avoid being on the same multiples of 2 all the time
      } else {
        factor = (factor + 1) / 2; // stable on 1
      }
    }

    // no point in a factor lorger than the size
    assert(newSize > 1); // wasm modules are >4 bytes anyhow
    factor = std::min(factor, int(newSize));

    // try to reduce destructively. if a high factor fails to find anything,
    // quickly try a lower one (no point in doing passes until we reduce
    // destructively at least a little)
    while (1) {
      std::cout << "|  reduce destructively... (factor: " << factor << ")\n";
      if (reducer.reduceDestructively(factor)) break;
      // we failed to reduce destructively
      if (factor == 1) {
        factor = 0; // halt
        break;
      }
      factor = std::max(1, factor / 10); // quickly now, try to find *something* we can reduce
    }
    if (factor == 0) break; // halt

    std::cout << "|  destructive reduction led to size: " << file_size(working) << '\n';
  }
  std::cout << "|finished, final size: " << file_size(working) << "\n";
  copy_file(working, test); // just to avoid confusion
}

