/*
 * Copyright 2015 WebAssembly Community Group participants
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

#ifndef wasm_passes_h
#define wasm_passes_h

namespace wasm {

class Pass;

// All passes:
Pass *createCoalesceLocalsPass();
Pass *createCoalesceLocalsWithLearningPass();
Pass *createCodePushingPass();
Pass *createDeadCodeEliminationPass();
Pass *createDuplicateFunctionEliminationPass();
Pass *createExtractFunctionPass();
Pass *createFullPrinterPass();
Pass *createInliningPass();
Pass *createLegalizeJSInterfacePass();
Pass *createLowerIfElsePass();
Pass *createMemoryPackingPass();
Pass *createMergeBlocksPass();
Pass *createMinifiedPrinterPass();
Pass *createMetricsPass();
Pass *createNameListPass();
Pass *createNameManagerPass();
Pass *createOptimizeInstructionsPass();
Pass *createPostEmscriptenPass();
Pass *createPrinterPass();
Pass *createPrintCallGraphPass();
Pass *createRelooperJumpThreadingPass();
Pass *createRemoveImportsPass();
Pass *createRemoveMemoryPass();
Pass *createRemoveUnusedBrsPass();
Pass *createRemoveUnusedModuleElementsPass();
Pass *createRemoveUnusedNamesPass();
Pass *createReorderFunctionsPass();
Pass *createReorderLocalsPass();
Pass *createSimplifyLocalsPass();
Pass *createSimplifyLocalsNoTeePass();
Pass *createSimplifyLocalsNoStructurePass();
Pass *createSimplifyLocalsNoTeeNoStructurePass();
Pass *createVacuumPass();
Pass *createPrecomputePass();
//Pass *createLowerInt64Pass();

}

#endif
