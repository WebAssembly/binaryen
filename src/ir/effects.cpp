/*
 * Copyright 2024 WebAssembly Community Group participants
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

#include "ir/effects.h"
#include "wasm.h"

namespace std {

std::ostream& operator<<(std::ostream& o, wasm::EffectAnalyzer& effects) {
  o << "EffectAnalyzer {\n";
  if (effects.branchesOut) {
    o << "branchesOut\n";
  }
  if (effects.calls) {
    o << "calls\n";
  }
  if (effects.localsRead.size()) {
    o << "localsRead\n";
  }
  if (effects.localsWritten.size()) {
    o << "localsWritten\n";
  }
  if (effects.mutableGlobalsRead.size()) {
    o << "mutableGlobalsRead\n";
  }
  if (effects.globalsWritten.size()) {
    o << "globalsWritten\n";
  }
  if (effects.readsMemory) {
    o << "readsMemory\n";
  }
  if (effects.writesMemory) {
    o << "writesMemory\n";
  }
  if (effects.readsTable) {
    o << "readsTable\n";
  }
  if (effects.writesTable) {
    o << "writesTable\n";
  }
  if (effects.readsMutableStruct) {
    o << "readsMutableStruct\n";
  }
  if (effects.writesStruct) {
    o << "writesStruct\n";
  }
  if (effects.readsArray) {
    o << "readsArray\n";
  }
  if (effects.writesArray) {
    o << "writesArray\n";
  }
  if (effects.trap) {
    o << "trap\n";
  }
  if (effects.implicitTrap) {
    o << "implicitTrap\n";
  }
  if (effects.isAtomic) {
    o << "isAtomic\n";
  }
  if (effects.throws_) {
    o << "throws_\n";
  }
  if (effects.tryDepth) {
    o << "tryDepth\n";
  }
  if (effects.catchDepth) {
    o << "catchDepth\n";
  }
  if (effects.danglingPop) {
    o << "danglingPop\n";
  }
  if (effects.mayNotReturn) {
    o << "mayNotReturn\n";
  }
  if (effects.hasReturnCallThrow) {
    o << "hasReturnCallThrow\n";
  }
  if (effects.accessesLocal()) {
    o << "accessesLocal\n";
  }
  if (effects.accessesMutableGlobal()) {
    o << "accessesMutableGlobal\n";
  }
  if (effects.accessesMemory()) {
    o << "accessesMemory\n";
  }
  if (effects.accessesTable()) {
    o << "accessesTable\n";
  }
  if (effects.accessesMutableStruct()) {
    o << "accessesMutableStruct\n";
  }
  if (effects.accessesArray()) {
    o << "accessesArray\n";
  }
  if (effects.throws()) {
    o << "throws\n";
  }
  if (effects.transfersControlFlow()) {
    o << "transfersControlFlow\n";
  }
  if (effects.writesGlobalState()) {
    o << "writesGlobalState\n";
  }
  if (effects.readsMutableGlobalState()) {
    o << "readsMutableGlobalState\n";
  }
  if (effects.hasNonTrapSideEffects()) {
    o << "hasNonTrapSideEffects\n";
  }
  if (effects.hasSideEffects()) {
    o << "hasSideEffects\n";
  }
  if (effects.hasUnremovableSideEffects()) {
    o << "hasUnremovableSideEffects\n";
  }
  if (effects.hasAnything()) {
    o << "hasAnything\n";
  }
  if (effects.hasExternalBreakTargets()) {
    o << "hasExternalBreakTargets\n";
  }
  o << "}";
  return o;
}

} // namespace std
