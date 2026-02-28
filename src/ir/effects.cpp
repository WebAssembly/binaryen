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
  if (effects.get(wasm::EffectAnalyzer::Bits::BranchesOut)) {
    o << "branchesOut\n";
  }
  if (effects.get(wasm::EffectAnalyzer::Bits::Calls)) {
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
  if (effects.get(wasm::EffectAnalyzer::Bits::ReadsMemory)) {
    o << "readsMemory\n";
  }
  if (effects.get(wasm::EffectAnalyzer::Bits::WritesMemory)) {
    o << "writesMemory\n";
  }
  if (effects.get(wasm::EffectAnalyzer::Bits::ReadsTable)) {
    o << "readsTable\n";
  }
  if (effects.get(wasm::EffectAnalyzer::Bits::WritesTable)) {
    o << "writesTable\n";
  }
  if (effects.get(wasm::EffectAnalyzer::Bits::ReadsMutableStruct)) {
    o << "readsMutableStruct\n";
  }
  if (effects.get(wasm::EffectAnalyzer::Bits::WritesStruct)) {
    o << "writesStruct\n";
  }
  if (effects.get(wasm::EffectAnalyzer::Bits::ReadsArray)) {
    o << "readsArray\n";
  }
  if (effects.get(wasm::EffectAnalyzer::Bits::WritesArray)) {
    o << "writesArray\n";
  }
  if (effects.traps()) {
    o << "trap\n";
  }
  if (effects.get(wasm::EffectAnalyzer::Bits::ImplicitTrap)) {
    o << "implicitTrap\n";
  }
  if (effects.get(wasm::EffectAnalyzer::Bits::IsAtomic)) {
    o << "isAtomic\n";
  }
  if (effects.get(wasm::EffectAnalyzer::Bits::Throws)) {
    o << "throws_\n";
  }
  if (effects.tryDepth) {
    o << "tryDepth\n";
  }
  if (effects.catchDepth) {
    o << "catchDepth\n";
  }
  if (effects.get(wasm::EffectAnalyzer::Bits::DanglingPop)) {
    o << "danglingPop\n";
  }
  if (effects.get(wasm::EffectAnalyzer::Bits::MayNotReturn)) {
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
