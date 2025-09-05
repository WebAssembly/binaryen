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
#include "ir/branch-utils.h"
#include "ir/utils.h"
#include "support/file.h"
#include "support/path.h"
#include "support/timing.h"
#include "wasm-io.h"
#include "wasm-validator.h"

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

size_t Reducer::reduceDestructively(int factor_) {
  factor = factor_;
  // prepare
  loadWorking();
  reduced = 0;
  funcsSeen = 0;
  // Before we do any changes, it should be valid to write out the module:
  // size should be as expected, and output should be as expected.
  ProgramResult result;
  if (!writeAndTestReduction(result)) {
    std::cerr << "\n|! WARNING: writing before destructive reduction fails, "
                 "very unlikely reduction can work\n"
              << result << '\n';
  }
  // destroy!
  walkModule(getModule());
  return reduced;
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
  writer.write(*getModule(), test);
  // note that it is ok for the destructively-reduced module to be bigger
  // than the previous - each destructive reduction removes logical code,
  // and so is strictly better, even if the wasm binary format happens to
  // encode things slightly less efficiently.
  // test it
  out.getFromExecution(command);
  return out == expected;
}

void Reducer::loadWorking() {
  module = std::make_unique<Module>();

  toolOptions.applyOptionsBeforeParse(*module);

  // Assume we may need all features.
  module->features = FeatureSet::All;

  ModuleReader reader;
  try {
    reader.read(working, *module);
  } catch (ParseException& p) {
    p.dump(std::cerr);
    std::cerr << '\n';
    Fatal() << "error in parsing working wasm binary";
  }

  toolOptions.applyOptionsAfterParse(*module);

  builder = std::make_unique<Builder>(*module);
  setModule(module.get());
}

bool Reducer::shouldTryToReduce(size_t bonus) {
  assert(bonus > 0);
  // Increment to avoid returning the same result each time.
  decisionCounter += bonus;
  return (decisionCounter % factor) <= bonus;
}

// Returns a random number in the range [0, max). This is deterministic given
// all the previous work done in the reducer.
size_t Reducer::deterministicRandom(size_t max) {
  assert(max > 0);
  hash_combine(decisionCounter, max);
  return decisionCounter % max;
}

bool Reducer::isOkReplacement(Expression* with) {
  if (deNan) {
    if (auto* c = with->dynCast<Const>()) {
      if (c->value.isNaN()) {
        return false;
      }
    }
  }
  return true;
}

// tests a reduction on the current traversal node, and undos if it failed
bool Reducer::tryToReplaceCurrent(Expression* with) {
  if (!isOkReplacement(with)) {
    return false;
  }
  auto* curr = getCurrent();
  // std::cerr << "try " << curr << " => " << with << '\n';
  if (curr->type != with->type) {
    return false;
  }
  if (!shouldTryToReduce()) {
    return false;
  }
  replaceCurrent(with);
  if (!writeAndTestReduction()) {
    replaceCurrent(curr);
    return false;
  }
  std::cerr << "|      tryToReplaceCurrent succeeded (in " << getLocation()
            << ")\n";
  noteReduction();
  return true;
}

void Reducer::noteReduction(size_t amount) {
  reduced += amount;
  applyTestToWorking();
}

// tests a reduction on an arbitrary child
bool Reducer::tryToReplaceChild(Expression*& child, Expression* with) {
  if (!isOkReplacement(with)) {
    return false;
  }
  if (child->type != with->type) {
    return false;
  }
  if (!shouldTryToReduce()) {
    return false;
  }
  auto* before = child;
  child = with;
  if (!writeAndTestReduction()) {
    child = before;
    return false;
  }
  std::cerr << "|      tryToReplaceChild succeeded (in " << getLocation()
            << ")\n";
  // std::cerr << "|      " << before << " => " << with << '\n';
  noteReduction();
  return true;
}

std::string Reducer::getLocation() {
  if (getFunction()) {
    return getFunction()->name.toString();
  }
  return "(non-function context)";
}

// visitors. in each we try to remove code in a destructive and nontrivial
// way. "nontrivial" means something that optimization passes can't achieve,
// since we don't need to duplicate work that they do

void Reducer::visitExpression(Expression* curr) {
  // type-based reductions
  if (curr->type == Type::none) {
    if (tryToReduceCurrentToNop()) {
      return;
    }
  } else if (curr->type.isConcrete()) {
    if (tryToReduceCurrentToConst()) {
      return;
    }
  } else {
    assert(curr->type == Type::unreachable);
    if (tryToReduceCurrentToUnreachable()) {
      return;
    }
  }
  // specific reductions
  if (auto* iff = curr->dynCast<If>()) {
    if (iff->type == Type::none) {
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
    if (!shouldTryToReduce()) {
      return;
    }
    // replace a singleton
    auto& list = block->list;
    if (list.size() == 1 &&
        !BranchUtils::BranchSeeker::has(block, block->name)) {
      if (tryToReplaceCurrent(block->list[0])) {
        return;
      }
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
    if (shouldTryToReduce() &&
        !BranchUtils::BranchSeeker::has(loop, loop->name)) {
      tryToReplaceCurrent(loop->body);
    }
    return; // nothing more to do
  } else if (curr->is<Drop>()) {
    if (curr->type == Type::none) {
      // We can't improve this: the child has a different type than us. Return
      // here to avoid reaching the code below that tries to add a drop on
      // children (which would recreate the current state).
      return;
    }
  } else if (auto* structNew = curr->dynCast<StructNew>()) {
    // If all the fields are defaultable, try to replace this with a
    // struct.new_with_default.
    if (!structNew->isWithDefault() && structNew->type != Type::unreachable) {
      auto& fields = structNew->type.getHeapType().getStruct().fields;
      if (std::all_of(fields.begin(), fields.end(), [&](auto& field) {
            return field.type.isDefaultable();
          })) {
        ExpressionList operands(getModule()->allocator);
        operands.swap(structNew->operands);
        assert(structNew->isWithDefault());
        if (tryToReplaceCurrent(structNew)) {
          return;
        } else {
          structNew->operands.swap(operands);
          assert(!structNew->isWithDefault());
        }
      }
    }
  }
  // Finally, try to replace with a child.
  for (auto* child : ChildIterator(curr)) {
    if (child->type.isConcrete() && curr->type == Type::none) {
      if (tryToReplaceCurrent(builder->makeDrop(child))) {
        return;
      }
    } else {
      if (tryToReplaceCurrent(child)) {
        return;
      }
    }
  }
  // If that didn't work, try to replace with a child + a unary conversion,
  // but not if it's already unary
  if (curr->type.isSingle() && !curr->is<Unary>()) {
    for (auto* child : ChildIterator(curr)) {
      if (child->type == curr->type) {
        continue; // already tried
      }
      if (!child->type.isSingle()) {
        continue; // no conversion
      }
      Expression* fixed = nullptr;
      if (!curr->type.isBasic() || !child->type.isBasic()) {
        // TODO: handle compound types
        continue;
      }
      switch (curr->type.getBasic()) {
        case Type::i32: {
          TODO_SINGLE_COMPOUND(child->type);
          switch (child->type.getBasic()) {
            case Type::i32:
              WASM_UNREACHABLE("invalid type");
            case Type::i64:
              fixed = builder->makeUnary(WrapInt64, child);
              break;
            case Type::f32:
              fixed = builder->makeUnary(TruncSFloat32ToInt32, child);
              break;
            case Type::f64:
              fixed = builder->makeUnary(TruncSFloat64ToInt32, child);
              break;
            // not implemented yet
            case Type::v128:
              continue;
            case Type::none:
            case Type::unreachable:
              WASM_UNREACHABLE("unexpected type");
          }
          break;
        }
        case Type::i64: {
          TODO_SINGLE_COMPOUND(child->type);
          switch (child->type.getBasic()) {
            case Type::i32:
              fixed = builder->makeUnary(ExtendSInt32, child);
              break;
            case Type::i64:
              WASM_UNREACHABLE("invalid type");
            case Type::f32:
              fixed = builder->makeUnary(TruncSFloat32ToInt64, child);
              break;
            case Type::f64:
              fixed = builder->makeUnary(TruncSFloat64ToInt64, child);
              break;
            // not implemented yet
            case Type::v128:
              continue;
            case Type::none:
            case Type::unreachable:
              WASM_UNREACHABLE("unexpected type");
          }
          break;
        }
        case Type::f32: {
          TODO_SINGLE_COMPOUND(child->type);
          switch (child->type.getBasic()) {
            case Type::i32:
              fixed = builder->makeUnary(ConvertSInt32ToFloat32, child);
              break;
            case Type::i64:
              fixed = builder->makeUnary(ConvertSInt64ToFloat32, child);
              break;
            case Type::f32:
              WASM_UNREACHABLE("unexpected type");
            case Type::f64:
              fixed = builder->makeUnary(DemoteFloat64, child);
              break;
            // not implemented yet
            case Type::v128:
              continue;
            case Type::none:
            case Type::unreachable:
              WASM_UNREACHABLE("unexpected type");
          }
          break;
        }
        case Type::f64: {
          TODO_SINGLE_COMPOUND(child->type);
          switch (child->type.getBasic()) {
            case Type::i32:
              fixed = builder->makeUnary(ConvertSInt32ToFloat64, child);
              break;
            case Type::i64:
              fixed = builder->makeUnary(ConvertSInt64ToFloat64, child);
              break;
            case Type::f32:
              fixed = builder->makeUnary(PromoteFloat32, child);
              break;
            case Type::f64:
              WASM_UNREACHABLE("unexpected type");
            // not implemented yet
            case Type::v128:
              continue;
            case Type::none:
            case Type::unreachable:
              WASM_UNREACHABLE("unexpected type");
          }
          break;
        }
        // not implemented yet
        case Type::v128:
          continue;
        case Type::none:
        case Type::unreachable:
          WASM_UNREACHABLE("unexpected type");
      }
      assert(fixed->type == curr->type);
      if (tryToReplaceCurrent(fixed)) {
        return;
      }
    }
  }
}

void Reducer::visitFunction(Function* curr) {
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

void Reducer::visitDataSegment(DataSegment* curr) {
  // try to reduce to first function. first, shrink segment elements.
  // while we are shrinking successfully, keep going exponentially.
  bool shrank = false;
  shrank = shrinkByReduction(curr, 2);
  // the "opposite" of shrinking: copy a 'zero' element
  reduceByZeroing(
    curr, 0, [](char item) { return item == 0; }, 2, shrank);
}

void Reducer::shrinkElementSegments() {
  std::cerr << "|    try to simplify elem segments\n";

  // First, shrink segment elements.
  bool shrank = false;
  for (auto& segment : module->elementSegments) {
    // Try to shrink all the segments (code in shrinkByReduction will decide
    // which to actually try to shrink, based on the current factor), and note
    // if we shrank anything at all (which we'll use later down).
    shrank = shrinkByReduction(segment.get(), 1) || shrank;
  }

  // Second, try to replace elements with a "zero".
  auto it =
    std::find_if_not(module->elementSegments.begin(),
                     module->elementSegments.end(),
                     [&](auto& segment) { return segment->data.empty(); });

  Expression* first = nullptr;
  if (it != module->elementSegments.end()) {
    first = it->get()->data[0];
  }
  if (first == nullptr) {
    // The elements are all empty, nothing left to do.
    return;
  }

  // the "opposite" of shrinking: copy a 'zero' element
  for (auto& segment : module->elementSegments) {
    reduceByZeroing(
      segment.get(),
      first,
      [&](Expression* elem) {
        if (elem->is<RefNull>()) {
          // We don't need to replace a ref.null.
          return true;
        }
        // Is the element equal to our first "zero" element?
        return ExpressionAnalyzer::equal(first, elem);
      },
      1,
      shrank);
  }
}

// Reduces entire functions at a time. Returns whether we did a significant
// amount of reduction that justifies doing even more.
bool Reducer::reduceFunctions() {
  // try to remove functions
  std::vector<Name> functionNames;
  for (auto& func : module->functions) {
    functionNames.push_back(func->name);
  }
  auto numFuncs = functionNames.size();
  if (numFuncs == 0) {
    return false;
  }
  size_t skip = 1;
  size_t maxSkip = 1;
  // If we just removed some functions in the previous iteration, keep trying
  // to remove more as this is one of the most efficient ways to reduce.
  bool justReduced = true;
  // Start from a new place each time.
  size_t base = deterministicRandom(numFuncs);
  std::cerr << "|    try to remove functions (base: " << base
            << ", decisionCounter: " << decisionCounter << ", numFuncs "
            << numFuncs << ")\n";
  for (size_t x = 0; x < functionNames.size(); x++) {
    size_t i = (base + x) % numFuncs;
    if (!justReduced && functionsWeTriedToRemove.count(functionNames[i]) == 1 &&
        !shouldTryToReduce(std::max((factor / 5) + 1, 20000))) {
      continue;
    }
    std::vector<Name> names;
    for (size_t j = 0; names.size() < skip && i + j < functionNames.size();
         j++) {
      auto name = functionNames[i + j];
      if (module->getFunctionOrNull(name)) {
        names.push_back(name);
        functionsWeTriedToRemove.insert(name);
      }
    }
    if (names.size() == 0) {
      continue;
    }
    std::cerr << "|     trying at i=" << i << " of size " << names.size()
              << "\n";
    // Try to remove functions and/or empty them. Note that
    // tryToRemoveFunctions() will reload the module if it fails, which means
    // function names may change - for that reason, run it second.
    justReduced = tryToEmptyFunctions(names) || tryToRemoveFunctions(names);
    if (justReduced) {
      noteReduction(names.size());
      // Subtract 1 since the loop increments us anyhow by one: we want to
      // skip over the skipped functions, and not any more.
      x += skip - 1;
      skip = std::min(size_t(factor), 2 * skip);
      maxSkip = std::max(skip, maxSkip);
    } else {
      skip = std::max(skip / 2, size_t(1)); // or 1?
      x += factor / 100;
    }
  }
  // If maxSkip is 1 then we never reduced at all. If it is 2 then we did
  // manage to reduce individual functions, but all our attempts at
  // exponential growth failed. Only suggest doing a new iteration of this
  // function if we did in fact manage to grow, which indicated there are lots
  // of opportunities here, and it is worth focusing on this.
  return maxSkip > 2;
}

void Reducer::visitModule([[maybe_unused]] Module* curr) {
  // The initial module given to us is our global object. As we continue to
  // process things here, we may replace the module, so we should never again
  // refer to curr.
  assert(curr == module.get());
  curr = nullptr;

  // Reduction of entire functions at a time is very effective, and we do it
  // with exponential growth and backoff, so keep doing it while it works.
  while (reduceFunctions()) {
  }

  shrinkElementSegments();

  // try to remove exports
  std::cerr << "|    try to remove exports (with factor " << factor << ")\n";
  std::vector<Export> exports;
  for (auto& exp : module->exports) {
    exports.push_back(*exp);
  }
  size_t skip = 1;
  for (size_t i = 0; i < exports.size(); i++) {
    if (!shouldTryToReduce(std::max((factor / 100) + 1, 1000))) {
      continue;
    }
    std::vector<Export> currExports;
    for (size_t j = 0; currExports.size() < skip && i + j < exports.size();
         j++) {
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
  bool allTablesEmpty =
    std::all_of(module->elementSegments.begin(),
                module->elementSegments.end(),
                [&](auto& segment) { return segment->data.empty(); });

  if (module->functions.size() == 1 && module->exports.empty() &&
      allTablesEmpty) {
    auto* func = module->functions[0].get();
    // We can't remove something that might have breaks to it.
    if (!func->imported() && !Properties::isNamedControlFlow(func->body)) {
      auto funcType = func->type;
      auto* funcBody = func->body;
      for (auto* child : ChildIterator(func->body)) {
        if (!(child->type.isConcrete() || child->type == Type::none)) {
          continue; // not something a function can return
        }
        // Try to replace the body with the child, fixing up the function
        // to accept it.
        func->type = Signature(funcType.getSignature().params, child->type);
        func->body = child;
        if (writeAndTestReduction()) {
          // great, we succeeded!
          std::cerr << "|    altered function result type\n";
          noteReduction(1);
          break;
        }
        // Undo.
        func->type = funcType;
        func->body = funcBody;
      }
    }
  }
}

// Try to empty out the bodies of some functions.
bool Reducer::tryToEmptyFunctions(std::vector<Name> names) {
  std::vector<Expression*> oldBodies;
  size_t actuallyEmptied = 0;
  for (auto name : names) {
    auto* func = module->getFunction(name);
    auto* oldBody = func->body;
    oldBodies.push_back(oldBody);
    // Nothing to do for imported functions (body is nullptr) or for bodies
    // that have already been as reduced as we can make them.
    if (func->imported() || oldBody->is<Unreachable>() || oldBody->is<Nop>()) {
      continue;
    }
    actuallyEmptied++;
    bool useUnreachable = func->getResults() != Type::none;
    if (useUnreachable) {
      func->body = builder->makeUnreachable();
    } else {
      func->body = builder->makeNop();
    }
  }
  if (actuallyEmptied > 0 && writeAndTestReduction()) {
    std::cerr << "|        emptied " << actuallyEmptied << " / " << names.size()
              << " functions\n";
    return true;
  } else {
    // Restore the bodies.
    for (size_t i = 0; i < names.size(); i++) {
      module->getFunction(names[i])->body = oldBodies[i];
    }
    return false;
  }
}

// Try to actually remove functions. If they are somehow referred to, we will
// get a validation error and undo it.
bool Reducer::tryToRemoveFunctions(std::vector<Name> names) {
  for (auto name : names) {
    module->removeFunction(name);
  }

  // remove all references to them
  struct FunctionReferenceRemover
    : public PostWalker<FunctionReferenceRemover> {
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
    void visitRefFunc(RefFunc* curr) {
      if (names.count(curr->func)) {
        replaceCurrent(Builder(*getModule()).replaceWithIdenticalType(curr));
      }
    }
    void visitExport(Export* curr) {
      if (auto* name = curr->getInternalName(); name && names.count(*name)) {
        exportsToRemove.push_back(curr->name);
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

  if (WasmValidator().validate(
        *module, WasmValidator::Globally | WasmValidator::Quiet) &&
      writeAndTestReduction()) {
    std::cerr << "|        removed " << names.size() << " functions\n";
    return true;
  } else {
    loadWorking(); // restore it from orbit
    return false;
  }
}

// helpers

// try to replace condition with always true and always false
void Reducer::handleCondition(Expression*& condition) {
  if (!condition) {
    return;
  }
  if (condition->is<Const>()) {
    return;
  }
  auto* c = builder->makeConst(int32_t(0));
  if (!tryToReplaceChild(condition, c)) {
    c->value = Literal(int32_t(1));
    tryToReplaceChild(condition, c);
  }
}

bool Reducer::tryToReduceCurrentToNop() {
  auto* curr = getCurrent();
  if (curr->is<Nop>()) {
    return false;
  }
  // try to replace with a trivial value
  Nop nop;
  if (tryToReplaceCurrent(&nop)) {
    replaceCurrent(builder->makeNop());
    return true;
  }
  return false;
}

// Try to replace a concrete value with a trivial constant.
bool Reducer::tryToReduceCurrentToConst() {
  auto* curr = getCurrent();

  // References.
  if (curr->type.isNullable() && !curr->is<RefNull>()) {
    RefNull* n = builder->makeRefNull(curr->type.getHeapType());
    return tryToReplaceCurrent(n);
  }

  // Tuples.
  if (curr->type.isTuple() && curr->type.isDefaultable()) {
    Expression* n =
      builder->makeConstantExpression(Literal::makeZeros(curr->type));
    if (ExpressionAnalyzer::equal(n, curr)) {
      return false;
    }
    return tryToReplaceCurrent(n);
  }

  // Numbers. We try to replace them with a 0 or a 1.
  if (!curr->type.isNumber()) {
    return false;
  }
  auto* existing = curr->dynCast<Const>();
  if (existing && existing->value.isZero()) {
    // It's already a zero.
    return false;
  }
  auto* c = builder->makeConst(Literal::makeZero(curr->type));
  if (tryToReplaceCurrent(c)) {
    return true;
  }
  // It's not a zero, and can't be replaced with a zero. Try to make it a one,
  // if it isn't already.
  if (existing &&
      existing->value == Literal::makeFromInt32(1, existing->type)) {
    // It's already a one.
    return false;
  }
  c->value = Literal::makeOne(curr->type);
  return tryToReplaceCurrent(c);
}

bool Reducer::tryToReduceCurrentToUnreachable() {
  auto* curr = getCurrent();
  if (curr->is<Unreachable>()) {
    return false;
  }
  // try to replace with a trivial value
  Unreachable un;
  if (tryToReplaceCurrent(&un)) {
    replaceCurrent(builder->makeUnreachable());
    return true;
  }
  // maybe a return? TODO
  return false;
}

} // namespace wasm
