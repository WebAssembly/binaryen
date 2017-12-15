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

#ifndef wasm_ir_local_graph_h
#define wasm_ir_local_graph_h

namespace wasm {

//
// Finds the connections between get_locals and set_locals, creating
// a graph of those ties. This is useful for "ssa-style" optimization,
// in which you want to know exactly which sets are relevant for a
// a get, so it is as if each get has just one set, logically speaking
// (see the SSA pass for actually creating new local indexes based
// on this).
//
// TODO: the algorithm here is pretty simple, but also pretty slow,
//       we should optimize it.
struct LocalGraph : public PostWalker<LocalGraph> {
  // main API

  // the constructor computes getSetses, the sets affecting each get
  LocalGraph(Function* func, Module* module);

  // the set_locals relevant for an index or a get.
  typedef std::set<SetLocal*> Sets;

  // externally useful information
  std::map<GetLocal*, Sets> getSetses; // the sets affecting each get. a nullptr set means the initial
                                       // value (0 for a var, the received value for a param)
  std::map<Expression*, Expression**> locations; // where each get and set is (for easy replacing)

  // optional computation: compute the influence graphs between sets and gets
  // (useful for algorithms that propagate changes)

  std::unordered_map<GetLocal*, std::unordered_set<SetLocal*>> getInfluences; // for each get, the sets whose values are influenced by that get
  std::unordered_map<SetLocal*, std::unordered_set<GetLocal*>> setInfluences; // for each set, the gets whose values are influenced by that set

  void computeInfluences();

private:
  // we map local index => the set_locals for that index.
  // a nullptr set means there is a virtual set, from a param
  // initial value or the zero init initial value.
  typedef std::vector<Sets> Mapping;

  // internal state
  Index numLocals;
  Mapping currMapping;
  std::vector<Mapping> mappingStack; // used in ifs, loops
  std::map<Name, std::vector<Mapping>> breakMappings; // break target => infos that reach it
  std::vector<std::vector<GetLocal*>> loopGetStack; //  stack of loops, all the gets in each, so we can update them for back branches

public:
  void doWalkFunction(Function* func);

  // control flow

  void visitBlock(Block* curr);

  void finishIf();

  static void afterIfCondition(LocalGraph* self, Expression** currp);
  static void afterIfTrue(LocalGraph* self, Expression** currp);
  static void afterIfFalse(LocalGraph* self, Expression** currp);
  static void beforeLoop(LocalGraph* self, Expression** currp);
  void visitLoop(Loop* curr);
  void visitBreak(Break* curr);
  void visitSwitch(Switch* curr);
  void visitReturn(Return *curr);
  void visitUnreachable(Unreachable *curr);

  // local usage

  void visitGetLocal(GetLocal* curr);
  void visitSetLocal(SetLocal* curr);

  // traversal

  static void scan(LocalGraph* self, Expression** currp);

  // helpers

  void setUnreachable(Mapping& mapping);

  bool isUnreachable(Mapping& mapping);

  // merges a bunch of infos into one.
  // if we need phis, writes them into the provided vector. the caller should
  // ensure those are placed in the right location
  Mapping& merge(std::vector<Mapping>& mappings);
};

} // namespace wasm

#endif // wasm_ir_local_graph_h

