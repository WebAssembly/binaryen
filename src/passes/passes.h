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

// Normal passes:
Pass* createAlignmentLoweringPass();
Pass* createAsyncifyPass();
Pass* createAvoidReinterpretsPass();
Pass* createCoalesceLocalsPass();
Pass* createCoalesceLocalsWithLearningPass();
Pass* createCodeFoldingPass();
Pass* createCodePushingPass();
Pass* createConstHoistingPass();
Pass* createConstantFieldPropagationPass();
Pass* createDAEPass();
Pass* createDAEOptimizingPass();
Pass* createDataFlowOptsPass();
Pass* createDeadCodeEliminationPass();
Pass* createDeNaNPass();
Pass* createDeAlignPass();
Pass* createDirectizePass();
Pass* createDWARFDumpPass();
Pass* createDuplicateImportEliminationPass();
Pass* createDuplicateFunctionEliminationPass();
Pass* createEmitTargetFeaturesPass();
Pass* createExtractFunctionPass();
Pass* createExtractFunctionIndexPass();
Pass* createFlattenPass();
Pass* createFuncCastEmulationPass();
Pass* createFullPrinterPass();
Pass* createFunctionMetricsPass();
Pass* createGenerateDynCallsPass();
Pass* createGenerateI64DynCallsPass();
Pass* createGenerateStackIRPass();
Pass* createGlobalRefiningPass();
Pass* createGlobalTypeOptimizationPass();
Pass* createHeap2LocalPass();
Pass* createI64ToI32LoweringPass();
Pass* createInlineMainPass();
Pass* createInliningPass();
Pass* createInliningOptimizingPass();
Pass* createLegalizeJSInterfacePass();
Pass* createLegalizeJSInterfaceMinimallyPass();
Pass* createLimitSegmentsPass();
Pass* createLocalCSEPass();
Pass* createLocalSubtypingPass();
Pass* createLogExecutionPass();
Pass* createIntrinsicLoweringPass();
Pass* createInstrumentLocalsPass();
Pass* createInstrumentMemoryPass();
Pass* createLoopInvariantCodeMotionPass();
Pass* createMemory64LoweringPass();
Pass* createMemoryPackingPass();
Pass* createMergeBlocksPass();
Pass* createMergeLocalsPass();
Pass* createMinifiedPrinterPass();
Pass* createMinifyImportsPass();
Pass* createMinifyImportsAndExportsPass();
Pass* createMinifyImportsAndExportsAndModulesPass();
Pass* createMetricsPass();
Pass* createNameListPass();
Pass* createNameTypesPass();
Pass* createNoExitRuntimePass();
Pass* createOnceReductionPass();
Pass* createOptimizeAddedConstantsPass();
Pass* createOptimizeAddedConstantsPropagatePass();
Pass* createOptimizeInstructionsPass();
Pass* createOptimizeForJSPass();
Pass* createOptimizeStackIRPass();
Pass* createPickLoadSignsPass();
Pass* createModAsyncifyAlwaysOnlyUnwindPass();
Pass* createModAsyncifyNeverUnwindPass();
Pass* createPoppifyPass();
Pass* createPostEmscriptenPass();
Pass* createPrecomputePass();
Pass* createPrecomputePropagatePass();
Pass* createPrinterPass();
Pass* createPrintCallGraphPass();
Pass* createPrintFeaturesPass();
Pass* createPrintFunctionMapPass();
Pass* createPrintStackIRPass();
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
Pass* createRoundTripPass();
Pass* createSafeHeapPass();
Pass* createSetGlobalsPass();
Pass* createSignatureRefiningPass();
Pass* createSimplifyLocalsPass();
Pass* createSimplifyGlobalsPass();
Pass* createSimplifyGlobalsOptimizingPass();
Pass* createSimplifyLocalsNoNestingPass();
Pass* createSimplifyLocalsNoTeePass();
Pass* createSimplifyLocalsNoStructurePass();
Pass* createSimplifyLocalsNoTeeNoStructurePass();
Pass* createStackCheckPass();
Pass* createStripDebugPass();
Pass* createStripDWARFPass();
Pass* createStripProducersPass();
Pass* createStripTargetFeaturesPass();
Pass* createSouperifyPass();
Pass* createSouperifySingleUsePass();
Pass* createStubUnsupportedJSOpsPass();
Pass* createSSAifyPass();
Pass* createSSAifyNoMergePass();
Pass* createTrapModeClamp();
Pass* createTrapModeJS();
Pass* createTypeRefiningPass();
Pass* createUnteePass();
Pass* createVacuumPass();

// Test passes:
Pass* createCatchPopFixupPass();

} // namespace wasm

#endif
