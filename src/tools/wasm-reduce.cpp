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
#include "support/path.h"
#include "support/timing.h"
#include "wasm-io.h"
#include "wasm-builder.h"
#include "ir/branch-utils.h"
#include "ir/iteration.h"
#include "ir/literal-utils.h"
#include "ir/properties.h"
#include "wasm-validator.h"
#ifdef _WIN32
#ifndef NOMINMAX
#define NOMINMAX
#endif
#include <Windows.h>
// Create a string with last error message
std::string GetLastErrorStdStr() {
  DWORD error = GetLastError();
  if (error) {
    LPVOID lpMsgBuf;
    DWORD bufLen = FormatMessage(
        FORMAT_MESSAGE_ALLOCATE_BUFFER | 
        FORMAT_MESSAGE_FROM_SYSTEM |
        FORMAT_MESSAGE_IGNORE_INSERTS,
        NULL,
        error,
        MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT),
        (LPTSTR) &lpMsgBuf,
        0, NULL );
    if (bufLen) {
      LPCSTR lpMsgStr = (LPCSTR)lpMsgBuf;
      std::string result(lpMsgStr, lpMsgStr+bufLen);
      LocalFree(lpMsgBuf);
      return result;
    }
  }
  return std::string();
}
#endif
using namespace wasm;

// a timeout on every execution of the command
size_t timeout = 2;

struct ProgramResult {
  int code;
  std::string output;
  double time;

  ProgramResult() {}
  ProgramResult(std::string command) {
    getFromExecution(command);
  }

#ifdef _WIN32
  void getFromExecution(std::string command) {
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
      !SetHandleInformation(hChildStd_OUT_Rd, HANDLE_FLAG_INHERIT, 0)
    ) {
      Fatal() << "CreatePipe \"" << command << "\" failed: " << GetLastErrorStdStr() << ".\n";
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
    if (!CreateProcess(NULL,   // No module name (use command line)
      (LPSTR)command.c_str(),// Command line
      NULL,           // Process handle not inheritable
      NULL,           // Thread handle not inheritable
      TRUE,           // Set handle inheritance to TRUE
      0,              // No creation flags
      NULL,           // Use parent's environment block
      NULL,           // Use parent's starting directory
      &si,            // Pointer to STARTUPINFO structure
      &pi )           // Pointer to PROCESS_INFORMATION structure
    ) {
      Fatal() << "CreateProcess \"" << command << "\" failed: " << GetLastErrorStdStr() << ".\n";
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
        if (!bSuccess || dwRead == 0) break;
        chBuf[dwRead] = 0;
        dwTotalRead += dwRead;
        output.append(chBuf);
      }
    }
    timer.stop();
    time = timer.getTotal();
  }
#else // POSIX
  // runs the command and notes the output
  // TODO: also stderr, not just stdout?
  void getFromExecution(std::string command) {
    Timer timer;
    timer.start();
    // do this using just core stdio.h and stdlib.h, for portability
    // sadly this requires two invokes
    code = system(("timeout " + std::to_string(timeout) + "s " + command + " > /dev/null 2> /dev/null").c_str());
    const int MAX_BUFFER = 1024;
    char buffer[MAX_BUFFER];
    FILE *stream = popen(("timeout " + std::to_string(timeout) + "s " + command + " 2> /dev/null").c_str(), "r");
    while (fgets(buffer, MAX_BUFFER, stream) != NULL) {
      output.append(buffer);
    }
    pclose(stream);
    timer.stop();
    time = timer.getTotal() / 2;
  }
#endif // _WIN32

  bool operator==(ProgramResult& other) {
    return code == other.code && output == other.output;
  }
  bool operator!=(ProgramResult& other) {
    return !(*this == other);
  }

  bool failed() {
    return code != 0;
  }

  void dump(std::ostream& o) {
    o << "[ProgramResult] code: " << code << " stdout: \n" << output << "[====]\nin " << time << " seconds\n[/ProgramResult]\n";
  }
};

namespace std {

inline std::ostream& operator<<(std::ostream& o, ProgramResult& result) {
  result.dump(o);
  return o;
}

}

ProgramResult expected;

// Removing functions is extremely beneficial and efficient. We aggressively
// try to remove functions, unless we've seen they can't be removed, in which
// case we may try again but much later.
static std::unordered_set<Name> functionsWeTriedToRemove;

struct Reducer : public WalkerPass<PostWalker<Reducer, UnifiedExpressionVisitor<Reducer>>> {
  std::string command, test, working;
  bool verbose, debugInfo;

  // test is the file we write to that the command will operate on
  // working is the current temporary state, the reduction so far
  Reducer(std::string command, std::string test, std::string working, bool verbose, bool debugInfo) : command(command), test(test), working(working), verbose(verbose), debugInfo(debugInfo) {}

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
      "-O4",
      "--flatten -Os",
      "--flatten -O3",
      "--flatten --local-cse -Os",
      "--coalesce-locals --vacuum",
      "--dce",
      "--duplicate-function-elimination",
      "--inlining",
      "--inlining-optimizing",
      "--optimize-level=3 --inlining-optimizing",
      "--memory-packing",
      "--remove-unused-names --merge-blocks --vacuum",
      "--optimize-instructions",
      "--precompute",
      "--remove-imports",
      "--remove-memory",
      "--remove-unused-names --remove-unused-brs",
      "--remove-unused-module-elements",
      "--remove-unused-nonfunction-module-elements",
      "--reorder-functions",
      "--reorder-locals",
      "--simplify-locals --vacuum",
      "--vacuum"
    };
    auto oldSize = file_size(working);
    bool more = true;
    while (more) {
      //std::cerr << "|    starting passes loop iteration\n";
      more = false;
      // try both combining with a generic shrink (so minor pass overhead is compensated for), and without
      for (auto pass : passes) {
        std::string currCommand = Path::getBinaryenBinaryTool("wasm-opt") + " ";
        currCommand += working + " -o " + test + " " + pass;
        if (debugInfo) currCommand += " -g ";
        if (verbose) std::cerr << "|    trying pass command: " << currCommand << "\n";
        if (!ProgramResult(currCommand).failed()) {
          auto newSize = file_size(test);
          if (newSize < oldSize) {
            // the pass didn't fail, and the size looks smaller, so promising
            // see if it is still has the property we are preserving
            if (ProgramResult(command) == expected) {
              std::cerr << "|    command \"" << currCommand << "\" succeeded, reduced size to " << newSize << ", and preserved the property\n";
              copy_file(test, working);
              more = true;
              oldSize = newSize;
            }
          }
        }
      }
    }
    if (verbose) std::cerr << "|    done with passes for now\n";
  }

  // does one pass of slow and destructive reduction. returns whether it
  // succeeded or not
  // the criterion here is a logical change in the program. this may actually
  // increase wasm size in some cases, but it should allow more reduction later.
  // @param factor how much to ignore. starting with a high factor skips through
  //               most of the file, which is often faster than going one by one
  //               from the start
  size_t reduceDestructively(int factor_) {
    factor = factor_;
    // prepare
    loadWorking();
    reduced = 0;
    funcsSeen = 0;
    // before we do any changes, it should be valid to write out the module:
    // size should be as expected, and output should be as expected
    ProgramResult result;
    if (!writeAndTestReduction(result)) {
      std::cerr << "\n|! WARNING: writing before destructive reduction fails, very unlikely reduction can work\n" << result << '\n';
    }
    // destroy!
    walkModule(getModule());
    return reduced;
  }

  void loadWorking() {
    module = make_unique<Module>();
    Module wasm;
    ModuleReader reader;
    reader.read(working, *module);
    builder = make_unique<Builder>(*module);
    setModule(module.get());
  }

  // destructive reduction state

  size_t reduced;
  Expression* beforeReduction;
  std::unique_ptr<Module> module;
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
    writer.setDebugInfo(debugInfo);
    writer.write(*getModule(), test);
    // note that it is ok for the destructively-reduced module to be bigger
    // than the previous - each destructive reduction removes logical code,
    // and so is strictly better, even if the wasm binary format happens to
    // encode things slightly less efficiently.
    // test it
    out.getFromExecution(command);
    return out == expected;
  }

  bool shouldTryToReduce(size_t bonus = 1) {
    static size_t counter = 0;
    counter += bonus;
    return (counter % factor) <= bonus;
  }

  // tests a reduction on the current traversal node, and undos if it failed
  bool tryToReplaceCurrent(Expression* with) {
    auto* curr = getCurrent();
    //std::cerr << "try " << curr << " => " << with << '\n';
    if (curr->type != with->type) return false;
    if (!shouldTryToReduce()) return false;
    replaceCurrent(with);
    if (!writeAndTestReduction()) {
      replaceCurrent(curr);
      return false;
    }
    std::cerr << "|      tryToReplaceCurrent succeeded (in " << getLocation() << ")\n";
    noteReduction();
    return true;
  }

  void noteReduction(size_t amount = 1) {
    reduced += amount;
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
    std::cerr << "|      tryToReplaceChild succeeded (in " << getLocation() << ")\n";
    //std::cerr << "|      " << before << " => " << with << '\n';
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
    // type-based reductions
    if (curr->type == none) {
      if (tryToReduceCurrentToNop()) return;
    } else if (isConcreteType(curr->type)) {
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
      // Try to replace switch targets with the default
      for (auto& target : sw->targets) {
        if (target != sw->default_) {
          auto old = target;
          target = sw->default_;
          if (!tryToReplaceCurrent(curr)) {
            target = old;
          }
        }
      }
      // Try to shorten the list of targets.
      while (sw->targets.size() > 1) {
        auto last = sw->targets.back();
        sw->targets.pop_back();
        if (!tryToReplaceCurrent(curr)) {
          sw->targets.push_back(last);
          break;
        }
      }
    } else if (auto* block = curr->dynCast<Block>()) {
      if (!shouldTryToReduce()) return;
      // replace a singleton
      auto& list = block->list;
      if (list.size() == 1 && !BranchUtils::BranchSeeker::hasNamed(block, block->name)) {
        if (tryToReplaceCurrent(block->list[0])) return;
      }
      // try to get rid of nops
      Index i = 0;
      while (list.size() > 1 && i < list.size()) {
        auto* curr = list[i];
        if (curr->is<Nop>() && shouldTryToReduce()) {
          // try to remove it
          for (Index j = i; j < list.size() - 1; j++) {
            list[j] = list[j + 1];
          }
          list.pop_back();
          if (writeAndTestReduction()) {
            std::cerr << "|      block-nop removed\n";
            noteReduction();
            return;
          }
          list.push_back(nullptr);
          // we failed; undo
          for (Index j = list.size() - 1; j > i; j--) {
            list[j] = list[j - 1];
          }
          list[i] = curr;
        }
        i++;
      }
      return; // nothing more to do
    } else if (auto* loop = curr->dynCast<Loop>()) {
      if (shouldTryToReduce() && !BranchUtils::BranchSeeker::hasNamed(loop, loop->name)) {
        tryToReplaceCurrent(loop->body);
      }
      return; // nothing more to do
    }
    // Finally, try to replace with a child.
    for (auto* child : ChildIterator(curr)) {
      if (tryToReplaceCurrent(child)) return;
    }
    // If that didn't work, try to replace with a child + a unary conversion
    if (isConcreteType(curr->type) &&
        !curr->is<Unary>()) { // but not if it's already unary
      for (auto* child : ChildIterator(curr)) {
        if (child->type == curr->type) continue; // already tried
        if (!isConcreteType(child->type)) continue; // no conversion
        Expression* fixed;
        switch (curr->type) {
          case i32: {
            switch (child->type) {
              case i64: fixed = builder->makeUnary(WrapInt64, child); break;
              case f32: fixed = builder->makeUnary(TruncSFloat32ToInt32, child); break;
              case f64: fixed = builder->makeUnary(TruncSFloat64ToInt32, child); break;
              default: WASM_UNREACHABLE();
            }
            break;
          }
          case i64: {
            switch (child->type) {
              case i32: fixed = builder->makeUnary(ExtendSInt32, child); break;
              case f32: fixed = builder->makeUnary(TruncSFloat32ToInt64, child); break;
              case f64: fixed = builder->makeUnary(TruncSFloat64ToInt64, child); break;
              default: WASM_UNREACHABLE();
            }
            break;
          }
          case f32: {
            switch (child->type) {
              case i32: fixed = builder->makeUnary(ConvertSInt32ToFloat32, child); break;
              case i64: fixed = builder->makeUnary(ConvertSInt64ToFloat32, child); break;
              case f64: fixed = builder->makeUnary(DemoteFloat64, child); break;
              default: WASM_UNREACHABLE();
            }
            break;
          }
          case f64: {
            switch (child->type) {
              case i32: fixed = builder->makeUnary(ConvertSInt32ToFloat64, child); break;
              case i64: fixed = builder->makeUnary(ConvertSInt64ToFloat64, child); break;
              case f32: fixed = builder->makeUnary(PromoteFloat32, child); break;
              default: WASM_UNREACHABLE();
            }
            break;
          }
          default: WASM_UNREACHABLE();
        }
        assert(fixed->type == curr->type);
        if (tryToReplaceCurrent(fixed)) return;
      }
    }
  }

  void visitFunction(Function* curr) {
    if (!curr->imported()) {
      // extra chance to work on the function toplevel element, as if it can
      // be reduced it's great
      visitExpression(curr->body);
    }
    // finish function
    funcsSeen++;
    static int last = 0;
    int percentage = (100 * funcsSeen) / getModule()->functions.size();
    if (std::abs(percentage - last) >= 5) {
      std::cerr << "|    " << percentage << "% of funcs complete\n";
      last = percentage;
    }
  }

  // TODO: bisection on segment shrinking?

  void visitTable(Table* curr) {
    std::cerr << "|    try to simplify table\n";
    Name first;
    for (auto& segment : curr->segments) {
      for (auto item : segment.data) {
        first = item;
        break;
      }
      if (!first.isNull()) break;
    }
    visitSegmented(curr, first, 100);
  }

  void visitMemory(Memory* curr) {
    std::cerr << "|    try to simplify memory\n";
    visitSegmented(curr, 0, 2);
  }

  template<typename T, typename U>
  void visitSegmented(T* curr, U zero, size_t bonus) {
    // try to reduce to first function. first, shrink segment elements.
    // while we are shrinking successfully, keep going exponentially.
    bool justShrank = false;
    bool shrank = false;
    for (auto& segment : curr->segments) {
      auto& data = segment.data;
      size_t skip = 1; // when we succeed, try to shrink by more and more, similar to bisection
      for (size_t i = 0; i < data.size() && !data.empty(); i++) {
        if (!justShrank && !shouldTryToReduce(bonus)) continue;
        auto save = data;
        for (size_t j = 0; j < skip; j++) {
          if (!data.empty()) data.pop_back();
        }
        auto justShrank = writeAndTestReduction();
        if (justShrank) {
          std::cerr << "|      shrank segment (skip: " << skip << ")\n";
          shrank = true;
          noteReduction();
          skip = std::min(size_t(factor), 2 * skip);
        } else {
          data = save;
          break;
        }
      }
    }
    // the "opposite" of shrinking: copy a 'zero' element
    for (auto& segment : curr->segments) {
      if (segment.data.empty()) continue;
      for (auto& item : segment.data) {
        if (!shouldTryToReduce(bonus)) continue;
        if (item == zero) continue;
        auto save = item;
        item = zero;
        if (writeAndTestReduction()) {
          std::cerr << "|      zeroed segment\n";
          noteReduction();
        } else {
          item = save;
        }
        if (shrank) {
          // zeroing is fairly inefficient. if we are managing to shrink
          // (which we do exponentially), just zero one per segment at most
          break;
        }
      }
    }
  }

  void visitModule(Module* curr) {
    assert(curr == module.get());
    // try to remove functions
    std::cerr << "|    try to remove functions\n";
    std::vector<Name> functionNames;
    for (auto& func : module->functions) {
      functionNames.push_back(func->name);
    }
    size_t skip = 1;
    // If we just removed some functions in the previous iteration, keep trying to remove more
    // as this is one of the most efficient ways to reduce.
    bool justRemoved = false;
    for (size_t i = 0; i < functionNames.size(); i++) {
      if (!justRemoved &&
          functionsWeTriedToRemove.count(functionNames[i]) == 1 &&
         !shouldTryToReduce(std::max((factor / 100) + 1, 1000))) continue;
      std::vector<Name> names;
      for (size_t j = 0; names.size() < skip && i + j < functionNames.size(); j++) {
        auto name = functionNames[i + j];
        if (module->getFunctionOrNull(name)) {
          names.push_back(name);
          functionsWeTriedToRemove.insert(name);
        }
      }
      if (names.size() == 0) continue;
      std::cout << "|    try to remove " << names.size() << " functions (skip: " << skip << ")\n";
      justRemoved = tryToRemoveFunctions(names);
      if (justRemoved) {
        noteReduction(names.size());
        i += skip;
        skip = std::min(size_t(factor), 2 * skip);
      } else {
        skip = std::max(skip / 2, size_t(1)); // or 1?
      }
    }
    // try to remove exports
    std::cerr << "|    try to remove exports (with factor " << factor << ")\n";
    std::vector<Export> exports;
    for (auto& exp : module->exports) {
      exports.push_back(*exp);
    }
    skip = 1;
    for (size_t i = 0; i < exports.size(); i++) {
      if (!shouldTryToReduce(std::max((factor / 100) + 1, 1000))) continue;
      std::vector<Export> currExports;
      for (size_t j = 0; currExports.size() < skip && i + j < exports.size(); j++) {
        auto exp = exports[i + j];
        if (module->getExportOrNull(exp.name)) {
          currExports.push_back(exp);
          module->removeExport(exp.name);
        }
      }
      ProgramResult result;
      if (!writeAndTestReduction(result)) {
        for (auto exp : currExports) {
          module->addExport(new Export(exp));
        }
        skip = std::max(skip / 2, size_t(1)); // or 1?
      } else {
        std::cerr << "|      removed " << currExports.size() << " exports\n";
        noteReduction(currExports.size());
        i += skip;
        skip = std::min(size_t(factor), 2 * skip);
      }
    }
    // If we are left with a single function that is not exported or used in
    // a table, that is useful as then we can change the return type.
    if (module->functions.size() == 1 && module->exports.empty() && module->table.segments.empty()) {
      auto* func = module->functions[0].get();
      // We can't remove something that might have breaks to it.
      if (!func->imported() && !Properties::isNamedControlFlow(func->body)) {
        auto funcType = func->type;
        auto funcResult = func->result;
        auto* funcBody = func->body;
        for (auto* child : ChildIterator(func->body)) {
          if (!(isConcreteType(child->type) || child->type == none)) {
            continue; // not something a function can return
          }
          // Try to replace the body with the child, fixing up the function
          // to accept it.
          func->type = Name();
          func->result = child->type;
          func->body = child;
          if (writeAndTestReduction()) {
            // great, we succeeded!
            std::cerr << "|    altered function result type\n";
            noteReduction(1);
            break;
          }
          // Undo.
          func->type = funcType;
          func->result = funcResult;
          func->body = funcBody;
        }
      }
    }
  }

  bool tryToRemoveFunctions(std::vector<Name> names) {
    for (auto name : names) {
      module->removeFunction(name);
    }

    // remove all references to them
    struct FunctionReferenceRemover : public PostWalker<FunctionReferenceRemover> {
      std::unordered_set<Name> names;
      std::vector<Name> exportsToRemove;

      FunctionReferenceRemover(std::vector<Name>& vec) {
        for (auto name : vec) {
          names.insert(name);
        }
      }
      void visitCall(Call* curr) {
        if (names.count(curr->target)) {
          replaceCurrent(Builder(*getModule()).replaceWithIdenticalType(curr));
        }
      }
      void visitExport(Export* curr) {
        if (names.count(curr->value)) {
          exportsToRemove.push_back(curr->name);
        }
      }
      void visitTable(Table* curr) {
        Name other;
        for (auto& segment : curr->segments) {
          for (auto name : segment.data) {
            if (!names.count(name)) {
              other = name;
              break;
            }
          }
          if (!other.isNull()) break;
        }
        if (other.isNull()) return; // we failed to find a replacement
        for (auto& segment : curr->segments) {
          for (auto& name : segment.data) {
            if (names.count(name)) {
              name = other;
            }
          }
        }
      }
      void doWalkModule(Module* module) {
        PostWalker<FunctionReferenceRemover>::doWalkModule(module);
        for (auto name : exportsToRemove) {
          module->removeExport(name);
        }
      }
    };
    FunctionReferenceRemover referenceRemover(names);
    referenceRemover.walkModule(module.get());

    if (WasmValidator().validate(*module, Feature::All, WasmValidator::Globally | WasmValidator::Quiet) &&
        writeAndTestReduction()) {
      std::cerr << "|      removed " << names.size() << " functions\n";
      return true;
    } else {
      loadWorking(); // restore it from orbit
      return false;
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

  bool tryToReduceCurrentToNop() {
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
  bool verbose = false,
       debugInfo = false,
       force = false;
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
      .add("--binaries", "-b", "binaryen binaries location (bin/ directory)",
           Options::Arguments::One,
           [&](Options* o, const std::string& argument) {
             // Add separator just in case
             Path::setBinaryenBinDir(argument + Path::getPathSeparator());
           })
      .add("--verbose", "-v", "Verbose output mode",
           Options::Arguments::Zero,
           [&](Options* o, const std::string& argument) {
             verbose = true;
           })
      .add("--debugInfo", "-g", "Keep debug info in binaries",
           Options::Arguments::Zero,
           [&](Options* o, const std::string& argument) {
             debugInfo = true;
           })
      .add("--force", "-f", "Force the reduction attempt, ignoring problems that imply it is unlikely to succeed",
           Options::Arguments::Zero,
           [&](Options* o, const std::string& argument) {
             force = true;
           })
      .add("--timeout", "-to", "A timeout to apply to each execution of the command, in seconds (default: 2)",
           Options::Arguments::One,
           [&](Options* o, const std::string& argument) {
             timeout = atoi(argument.c_str());
             std::cout << "|applying timeout: " << timeout << "\n";
           })
      .add_positional("INFILE", Options::Arguments::One,
                      [&](Options* o, const std::string& argument) {
                        input = argument;
                      });
  options.parse(argc, argv);

  if (test.size() == 0) Fatal() << "test file not provided\n";
  if (working.size() == 0) Fatal() << "working file not provided\n";

  std::cerr << "|wasm-reduce\n";
  std::cerr << "|input: " << input << '\n';
  std::cerr << "|test: " << test << '\n';
  std::cerr << "|working: " << working << '\n';

  // get the expected output
  copy_file(input, test);
  expected.getFromExecution(command);

  std::cerr << "|expected result:\n" << expected << '\n';
  std::cerr << "|!! Make sure the above is what you expect! !!\n\n";

  auto stopIfNotForced = [&](std::string message, ProgramResult& result) {
    std::cerr << "|! " << message << '\n' << result << '\n';
    if (!force) {
      Fatal() << "|! stopping, as it is very unlikely reduction can succeed (use -f to ignore this check)";
    }
  };

  if (expected.time + 1 >= timeout) {
    stopIfNotForced("execution time is dangerously close to the timeout - you should probably increase the timeout", expected);
  }

  std::cerr << "|checking that command has different behavior on invalid binary (this verifies that the test file is used by the command)\n";
  {
    {
      std::ofstream dst(test, std::ios::binary);
      dst << "waka waka\n";
    }
    ProgramResult result(command);
    if (result == expected) {
      stopIfNotForced("running command on an invalid module should give different results", result);
    }
  }

  std::cerr << "|checking that command has expected behavior on canonicalized (read-written) binary\n";
  {
    // read and write it
    ProgramResult readWrite(Path::getBinaryenBinaryTool("wasm-opt") + " " + input + " -o " + test);
    if (readWrite.failed()) {
      stopIfNotForced("failed to read and write the binary", readWrite);
    } else {
      ProgramResult result(command);
      if (result != expected) {
        stopIfNotForced("running command on the canonicalized module should give the same results", result);
      }
    }
  }

  copy_file(input, working);
  auto workingSize = file_size(working);
  std::cerr << "|input size: " << workingSize << "\n";

  std::cerr << "|starting reduction!\n";

  int factor = workingSize * 2;
  size_t lastDestructiveReductions = 0;
  size_t lastPostPassesSize = 0;

  bool stopping = false;

  while (1) {
    Reducer reducer(command, test, working, verbose, debugInfo);

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
    if (stopping) break;

    // check if the full cycle (destructive/passes) has helped or not
    if (lastPostPassesSize && newSize >= lastPostPassesSize) {
      std::cerr << "|  progress has stopped, skipping to the end\n";
      if (factor == 1) {
        // this is after doing work with factor 1, so after the remaining work, stop
        stopping = true;
      } else {
        // just try to remove all we can and finish up
        factor = 1;
      }
    }
    lastPostPassesSize = newSize;

    // if destructive reductions lead to useful proportionate pass reductions, keep
    // going at the same factor, as pass reductions are far faster
    std::cerr << "|  pass progress: " << passProgress << ", last destructive: " << lastDestructiveReductions << '\n';
    if (passProgress >= 4 * lastDestructiveReductions) {
      // don't change
      std::cerr << "|  progress is good, do not quickly decrease factor\n";
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
      if (lastDestructiveReductions > 0) break;
      // we failed to reduce destructively
      if (factor == 1) {
        stopping = true;
        break;
      }
      factor = std::max(1, factor / 4); // quickly now, try to find *something* we can reduce
    }

    std::cerr << "|  destructive reduction led to size: " << file_size(working) << '\n';
  }
  std::cerr << "|finished, final size: " << file_size(working) << "\n";
  copy_file(working, test); // just to avoid confusion
}

