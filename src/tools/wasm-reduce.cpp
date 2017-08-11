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

#include "pass.h"
#include "support/command-line.h"
#include "support/file.h"
#include "support/colors.h"
#include "wasm-io.h"
#include "wasm-builder.h"

struct Reducer : public WalkerPass<PostWalker<Reducer>> {
  std::string command;
  std::string output;

  bool reduced;

  Reducer(std::string command, std::string output) : command(command), output(output) {}

  Expression* beforeReduction;

  // tests a reduction on the current traversal node, and undos if it failed
  void tryToReplaceCurrent(Expression* with) {
    auto* curr = getCurrent();
    if (curr->type != with->type) return false;
    replaceCurrent(with);
    if (!stillValid()) {
      replaceCurrent(curr);
      return false;
    }
    reduced = true;
    return true;
  }

  // tests a reduction on an arbitrary child
  void tryToReplace(Expression*& child, Expression* with) {
    if (child->type != with->type) return false;
    auto* before = child;
    child = with;
    if (!stillValid()) {
      child = before;
      return false;
    }
    reduced = true;
    return true;
  }

  bool stillValid() {
    // write the module out
    ModuleWriter writer;
    writer.setBinary(true);
    writer.write(*getModule(), output);
    // test it
    auto code = system(command.c_str());
    return code == 0;
  }

  // visitors

  void visitBlock(Block* curr) {
abort();
  }
  void visitIf(If* curr) {
    if (tryToReplaceCurrent(curr->
  }
  void visitLoop(Loop* curr) {
  }
  void visitBreak(Break* curr) {
  }
  void visitSwitch(Switch* curr) {
  }
  void visitCall(Call* curr) {
  }
  void visitCallImport(CallImport* curr) {
  }
  void visitCallIndirect(CallIndirect* curr) {
  }
  void visitGetLocal(GetLocal* curr) {
  }
  void visitSetLocal(SetLocal* curr) {
  }
  void visitGetGlobal(GetGlobal* curr) {
  }
  void visitSetGlobal(SetGlobal* curr) {
  }
  void visitLoad(Load* curr) {
  }
  void visitStore(Store* curr) {
  }
  void visitAtomicRMW(AtomicRMW* curr) {
  }
  void visitAtomicCmpxchg(AtomicCmpxchg* curr) {
  }
  void visitConst(Const* curr) {
  }
  void visitUnary(Unary* curr) {
  }
  void visitBinary(Binary* curr) {
  }
  void visitSelect(Select* curr) {
  }
  void visitDrop(Drop* curr) {
  }
  void visitReturn(Return* curr) {
  }
  void visitHost(Host* curr) {
  }
};

//
// main
//

int main(int argc, const char* argv[]) {
  std::string input, output, command;
  Options options("wasm-reduce", "Reduce a wasm file to a smaller one that has the same behavior on a given command");
  options
      .add("--command", "-cmd", "The command to run on the output, that we want to reduce while keeping the command's output identical. "
                                "We look at the command's return code currently (TODO: stdout and stderr).",
           Options::Arguments::One,
           [](Options* o, const std::string& argument) {
             command = argument;
           })
      .add("--output", "-o", "Output file (this will be written to, and the given command run on it, repeatedly as we reduce)",
           Options::Arguments::One,
           [](Options* o, const std::string& argument) {
             output = argument;
           })
      .add_positional("INFILE", Options::Arguments::One,
                      [&](Options* o, const std::string& argument) {
                        input = argument;
                      });

  // read the input
  Module wasm;
  ModuleReader reader;
  reader.read(input, wasm);

  Reducer reducer(command, output);

  // sanity check - we should start with an invalid module
  reducer.setModule(wasm);
  assert(!reducer.stillValid());

  // do passes over the module, trying to reduce. stop when a full pass has
  // failed to reduce at all
// TODO: algo:
//  canonicalize (write, read; to avoid just read-write causing a size change)
//    if reading fails, just stop here (if write fails, still hope)
//  run all passes, until no pass shrinks
//    this keeps behavior the same, so limited, but can hugely reduce size quickly
//  then run our pass here, which alters behavior
//    must check after each mod, which is very slow
//  then return to running all passes etc.
  do {
    reducer.reduced = false;
    reducer.walk(wasm);
  } while (reducer.reduced);
}

