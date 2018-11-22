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
Pass* createCoalesceLocalsPass();
Pass* createCoalesceLocalsWithLearningPass();
Pass* createCodeFoldingPass();
Pass* createCodePushingPass();
Pass* createConstHoistingPass();
Pass* createDAEPass();
Pass* createDAEOptimizingPass();
Pass* createDataFlowOptsPass();
Pass* createDeadCodeEliminationPass();
Pass* createDuplicateFunctionEliminationPass();
Pass* createExtractFunctionPass();
Pass* createFlattenPass();
Pass* createFuncCastEmulationPass();
Pass* createFullPrinterPass();
Pass* createFunctionMetricsPass();
Pass* createGenerateStackIRPass();
Pass* createI64ToI32LoweringPass();
Pass* createInliningPass();
Pass* createInliningOptimizingPass();
Pass* createLegalizeJSInterfacePass();
Pass* createLocalCSEPass();
Pass* createLogExecutionPass();
Pass* createInstrumentLocalsPass();
Pass* createInstrumentMemoryPass();
Pass* createLoopInvariantCodeMotionPass();
Pass* createMemoryPackingPass();
Pass* createMergeBlocksPass();
Pass* createMergeLocalsPass();
Pass* createMinifiedPrinterPass();
Pass* createMinifyImportsPass();
Pass* createMinifyImportsAndExportsPass();
Pass* createMetricsPass();
Pass* createNameListPass();
Pass* createOptimizeInstructionsPass();
Pass* createOptimizeStackIRPass();
Pass* createPickLoadSignsPass();
Pass* createPostEmscriptenPass();
Pass* createPrecomputePass();
Pass* createPrecomputePropagatePass();
Pass* createPrinterPass();
Pass* createPrintCallGraphPass();
Pass* createPrintStackIRPass();
Pass* createRelooperJumpThreadingPass();
Pass* createRemoveNonJSOpsPass();
Pass* createRemoveImportsPass();
Pass* createRemoveMemoryPass();
Pass* createRemoveUnusedBrsPass();
Pass* createRemoveUnusedModuleElementsPass();
Pass* createRemoveUnusedNonFunctionModuleElementsPass();
Pass* createRemoveUnusedNamesPass();
Pass* createReorderFunctionsPass();
Pass* createReorderLocalsPass();
Pass* createReReloopPass();
Pass* createRedundantSetEliminationPass();
Pass* createSafeHeapPass();
Pass* createSimplifyLocalsPass();
Pass* createSimplifyLocalsNoNestingPass();
Pass* createSimplifyLocalsNoTeePass();
Pass* createSimplifyLocalsNoStructurePass();
Pass* createSimplifyLocalsNoTeeNoStructurePass();
Pass* createSouperifyPass();
Pass* createSouperifySingleUsePass();
Pass* createSpillPointersPass();
Pass* createSSAifyPass();
Pass* createTrapModeClamp();
Pass* createTrapModeJS();
Pass* createUnteePass();
Pass* createVacuumPass();

}

#endif
