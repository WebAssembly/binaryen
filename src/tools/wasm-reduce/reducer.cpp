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

#include "tools/wasm-reduce/reducer.h"
#include "destructive-reducer.h"
#include "support/file.h"
#include "support/path.h"
#include "support/timing.h"
#include "wasm-io.h"

namespace {

#ifdef _WIN32
#ifndef NOMINMAX
#define NOMINMAX
#endif
#include <windows.h>
// Create a string with last error message
std::string GetLastErrorStdStr() {
  DWORD error = GetLastError();
  if (error) {
    LPVOID lpMsgBuf;
    DWORD bufLen = FormatMessage(FORMAT_MESSAGE_ALLOCATE_BUFFER |
                                   FORMAT_MESSAGE_FROM_SYSTEM |
                                   FORMAT_MESSAGE_IGNORE_INSERTS,
                                 NULL,
                                 error,
                                 MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT),
                                 (LPTSTR)&lpMsgBuf,
                                 0,
                                 NULL);
    if (bufLen) {
      LPCSTR lpMsgStr = (LPCSTR)lpMsgBuf;
      std::string result(lpMsgStr, lpMsgStr + bufLen);
      LocalFree(lpMsgBuf);
      return result;
    }
  }
  return std::string();
}
#endif

} // anonymous namespace

namespace wasm {

void ProgramResult::getFromExecution(std::string command) {
#ifdef _WIN32
  Timer timer;
  timer.start();
  SECURITY_ATTRIBUTES saAttr;
  saAttr.nLength = sizeof(SECURITY_ATTRIBUTES);
  saAttr.bInheritHandle = TRUE;
  saAttr.lpSecurityDescriptor = NULL;

  HANDLE hChildStd_OUT_Rd;
  HANDLE hChildStd_OUT_Wr;

  if (
    // Create a pipe for the child process's STDOUT.
    !CreatePipe(&hChildStd_OUT_Rd, &hChildStd_OUT_Wr, &saAttr, 0) ||
    // Ensure the read handle to the pipe for STDOUT is not inherited.
    !SetHandleInformation(hChildStd_OUT_Rd, HANDLE_FLAG_INHERIT, 0)) {
    Fatal() << "CreatePipe \"" << command
            << "\" failed: " << GetLastErrorStdStr() << ".\n";
  }

  STARTUPINFO si;
  PROCESS_INFORMATION pi;

  ZeroMemory(&si, sizeof(si));
  si.cb = sizeof(si);
  si.hStdError = hChildStd_OUT_Wr;
  si.hStdOutput = hChildStd_OUT_Wr;
  si.dwFlags |= STARTF_USESTDHANDLES;
  ZeroMemory(&pi, sizeof(pi));

  // Start the child process.
  if (!CreateProcess(NULL, // No module name (use command line)
                     (LPSTR)command.c_str(), // Command line
                     NULL,                   // Process handle not inheritable
                     NULL,                   // Thread handle not inheritable
                     TRUE,                   // Set handle inheritance to TRUE
                     0,                      // No creation flags
                     NULL,                   // Use parent's environment block
                     NULL,                   // Use parent's starting directory
                     &si,                    // Pointer to STARTUPINFO structure
                     &pi) // Pointer to PROCESS_INFORMATION structure
  ) {
    Fatal() << "CreateProcess \"" << command
            << "\" failed: " << GetLastErrorStdStr() << ".\n";
  }

  // Wait until child process exits.
  DWORD retVal = WaitForSingleObject(pi.hProcess, timeout * 1000);
  if (retVal == WAIT_TIMEOUT) {
    printf("Command timeout: %s", command.c_str());
    TerminateProcess(pi.hProcess, -1);
  }
  DWORD dwordExitCode;
  if (!GetExitCodeProcess(pi.hProcess, &dwordExitCode)) {
    Fatal() << "GetExitCodeProcess failed: " << GetLastErrorStdStr() << ".\n";
  }
  code = (int)dwordExitCode;

  // Close process and thread handles.
  CloseHandle(pi.hProcess);
  CloseHandle(pi.hThread);

  // Read output from the child process's pipe for STDOUT
  // Stop when there is no more data.
  {
    const int BUFSIZE = 4096;
    DWORD dwRead, dwTotal, dwTotalRead = 0;
    CHAR chBuf[BUFSIZE];
    BOOL bSuccess = FALSE;

    PeekNamedPipe(hChildStd_OUT_Rd, NULL, 0, NULL, &dwTotal, NULL);
    while (dwTotalRead < dwTotal) {
      bSuccess = ReadFile(hChildStd_OUT_Rd, chBuf, BUFSIZE - 1, &dwRead, NULL);
      if (!bSuccess || dwRead == 0)
        break;
      chBuf[dwRead] = 0;
      dwTotalRead += dwRead;
      output.append(chBuf);
    }
  }
  timer.stop();
  time = timer.getTotal();
}
#else  // POSIX
  // TODO: also stderr, not just stdout?
  Timer timer;
  timer.start();
  const int MAX_BUFFER = 1024;
  char buffer[MAX_BUFFER];
  FILE* stream = popen(
    ("timeout " + std::to_string(timeout) + "s " + command + " 2> /dev/null")
      .c_str(),
    "r");
  while (fgets(buffer, MAX_BUFFER, stream) != NULL) {
    output.append(buffer);
  }
  code = pclose(stream);
  timer.stop();
  time = timer.getTotal();
#endif // _WIN32
}

// runs passes in order to reduce, until we can't reduce any more
// the criterion here is wasm binary size
void Reducer::reduceUsingPasses() {
  // run optimization passes until we can't shrink it any more
  std::vector<std::string> passes = {
    // Optimization modes.
    "-Oz",
    "-Os",
    "-O1",
    "-O2",
    "-O3",
    "-O4",
    // Optimization modes + passes that work well with them.
    "--flatten -Os",
    "--flatten -O3",
    "--flatten --simplify-locals-notee-nostructure --local-cse -Os",
    "--type-ssa -Os --type-merging",
    "--gufa -O1",
    // Individual passes or combinations of them.
    "--coalesce-locals --vacuum",
    "--dae",
    "--dae-optimizing",
    "--dce",
    "--duplicate-function-elimination",
    "--enclose-world",
    "--gto",
    "--inlining",
    "--inlining-optimizing",
    "--optimize-level=3 --inlining-optimizing",
    "--local-cse",
    "--memory-packing",
    "--remove-unused-names --merge-blocks --vacuum",
    "--optimize-instructions",
    "--precompute",
    "--remove-imports",
    "--remove-memory-init",
    "--remove-unused-names --remove-unused-brs",
    "--remove-unused-module-elements",
    "--remove-unused-nonfunction-module-elements",
    "--reorder-functions",
    "--reorder-locals",
    // TODO: signature* passes
    "--simplify-globals",
    "--simplify-locals --vacuum",
    "--strip",
    "--remove-unused-types --closed-world",
    "--vacuum"};
  auto oldSize = file_size(working);
  bool more = true;
  while (more) {
    // std::cerr << "|    starting passes loop iteration\n";
    more = false;
    // try both combining with a generic shrink (so minor pass overhead is
    // compensated for), and without
    for (auto pass : passes) {
      std::string currCommand = Path::getBinaryenBinaryTool("wasm-opt") + " ";
      currCommand += working + " -o " + test + " " + pass + " " + extraFlags;
      if (!binary) {
        currCommand += " -S ";
      }
      if (verbose) {
        std::cerr << "|    trying pass command: " << currCommand << "\n";
      }
      if (!ProgramResult(currCommand).failed()) {
        auto newSize = file_size(test);
        if (newSize < oldSize) {
          // the pass didn't fail, and the size looks smaller, so promising
          // see if it is still has the property we are preserving
          if (ProgramResult(command) == expected) {
            std::cerr << "|    command \"" << currCommand
                      << "\" succeeded, reduced size to " << newSize << '\n';
            applyTestToWorking();
            more = true;
            oldSize = newSize;
          }
        }
      }
    }
  }
  if (verbose) {
    std::cerr << "|    done with passes for now\n";
  }
}

// Apply the test file to the working file, after we saw that it successfully
// reduced the testcase.
void Reducer::applyTestToWorking() {
  copy_file(test, working);

  if (saveAllWorkingFiles) {
    copy_file(working, working + '.' + std::to_string(workingFileIndex++));
  }
}

size_t Reducer::reduceDestructively(int factor) {
  this->factor = factor;
  loadWorking();
  // Before we do any changes, it should be valid to write out the module:
  // size should be as expected, and output should be as expected.
  ProgramResult result;
  if (!writeAndTestReduction(result)) {
    std::cerr << "\n|! WARNING: writing before destructive reduction fails, "
                 "very unlikely reduction can work\n"
              << result << '\n';
  }
  // destroy!
  DestructiveReducer destructiveReducer(*this);
  destructiveReducer.walkModule(&wasm);
  return destructiveReducer.reduced;
}

bool Reducer::writeAndTestReduction() {
  ProgramResult result;
  return writeAndTestReduction(result);
}

bool Reducer::writeAndTestReduction(ProgramResult& out) {
  // write the module out
  ModuleWriter writer(toolOptions.passOptions);
  writer.setBinary(binary);
  writer.setDebugInfo(debugInfo);
  writer.write(wasm, test);
  // note that it is ok for the destructively-reduced module to be bigger
  // than the previous - each destructive reduction removes logical code,
  // and so is strictly better, even if the wasm binary format happens to
  // encode things slightly less efficiently.
  // test it
  out.getFromExecution(command);
  return out == expected;
}

void Reducer::loadWorking() {
  ModuleUtils::clearModule(wasm);

  toolOptions.applyOptionsBeforeParse(wasm);

  // Assume we may need all features.
  wasm.features = FeatureSet::All;

  ModuleReader reader;
  try {
    reader.read(working, wasm);
  } catch (ParseException& p) {
    p.dump(std::cerr);
    std::cerr << '\n';
    Fatal() << "error in parsing working wasm binary";
  }

  toolOptions.applyOptionsAfterParse(wasm);
}

// Returns a random number in the range [0, max). This is deterministic given
// all the previous work done in the reducer.
size_t Reducer::deterministicRandom(size_t max) {
  assert(max > 0);
  hash_combine(decisionCounter, max);
  return decisionCounter % max;
}

bool Reducer::shouldTryToReduce(size_t bonus) {
  assert(bonus > 0);
  // Increment to avoid returning the same result each time.
  decisionCounter += bonus;
  return (decisionCounter % factor) <= bonus;
}

} // namespace wasm
