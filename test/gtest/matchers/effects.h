/*
 * Copyright 2026 WebAssembly Community Group participants
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

// Matchers for EffectAnalyzer

#ifndef WASM_TEST_GTEST_MATCHERS_EFFECTS_H
#define WASM_TEST_GTEST_MATCHERS_EFFECTS_H

#include "gmock/gmock.h"

namespace wasm {

MATCHER(BranchesOut, "") { return arg->branchesOut; }
MATCHER(Calls, "") { return arg->calls; }
MATCHER(ReadsMemory, "") { return arg->readsMemory; }
MATCHER(WritesMemory, "") { return arg->writesMemory; }
MATCHER(ReadsSharedMemory, "") { return arg->readsSharedMemory; }
MATCHER(WritesSharedMemory, "") { return arg->writesSharedMemory; }
MATCHER(ReadsTable, "") { return arg->readsTable; }
MATCHER(WritesTable, "") { return arg->writesTable; }
MATCHER(ReadsMutableStruct, "") { return arg->readsMutableStruct; }
MATCHER(WritesStruct, "") { return arg->writesStruct; }
MATCHER(ReadsSharedMutableStruct, "") { return arg->readsSharedMutableStruct; }
MATCHER(WritesSharedStruct, "") { return arg->writesSharedStruct; }
MATCHER(ReadsMutableArray, "") { return arg->readsMutableArray; }
MATCHER(WritesArray, "") { return arg->writesArray; }
MATCHER(ReadsSharedMutableArray, "") { return arg->readsSharedMutableArray; }
MATCHER(WritesSharedArray, "") { return arg->writesSharedArray; }
MATCHER(Traps, "") { return arg->trap; }
MATCHER(ImplicitTraps, "") { return arg->implicitTrap; }
MATCHER(Throws, "") { return arg->throws_; }
MATCHER(DanglingPop, "") { return arg->danglingPop; }
MATCHER(MayNotReturn, "") { return arg->mayNotReturn; }
MATCHER(HasReturnCallThrow, "") { return arg->hasReturnCallThrow; }

} // namespace wasm

#endif // WASM_TEST_GTEST_MATCHERS_EFFECTS_H
