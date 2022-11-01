file(READ wasm-intrinsics.wat WASM_INTRINSICS_WAT HEX)

string(REGEX MATCHALL "([A-Fa-f0-9][A-Fa-f0-9])" SEPARATED_HEX ${WASM_INTRINSICS_WAT})

set(WASM_INTRINSICS_SIZE 1)
foreach (hex IN LISTS SEPARATED_HEX)
  string(APPEND WASM_INTRINSICS_EMBED "0x${hex},")
  math(EXPR WASM_INTRINSICS_SIZE "${WASM_INTRINSICS_SIZE}+1")
endforeach ()
string(APPEND WASM_INTRINSICS_EMBED "0x00")

configure_file(WasmIntrinsics.cpp.in WasmIntrinsics.cpp @ONLY)

FILE(GLOB passes_HEADERS *.h)
set(passes_SOURCES
  param-utils.cpp
  pass.cpp
  test_passes.cpp
  AlignmentLowering.cpp
  Asyncify.cpp
  AvoidReinterprets.cpp
  CoalesceLocals.cpp
  CodePushing.cpp
  CodeFolding.cpp
  ConstantFieldPropagation.cpp
  ConstHoisting.cpp
  DataFlowOpts.cpp
  DeadArgumentElimination.cpp
  DeadCodeElimination.cpp
  DeAlign.cpp
  DeNaN.cpp
  Directize.cpp
  DuplicateImportElimination.cpp
  DuplicateFunctionElimination.cpp
  DWARF.cpp
  ExtractFunction.cpp
  Flatten.cpp
  FuncCastEmulation.cpp
  GenerateDynCalls.cpp
  GlobalEffects.cpp
  GlobalRefining.cpp
  GlobalStructInference.cpp
  GlobalTypeOptimization.cpp
  GUFA.cpp
  Heap2Local.cpp
  I64ToI32Lowering.cpp
  Inlining.cpp
  InstrumentLocals.cpp
  InstrumentMemory.cpp
  Intrinsics.cpp
  JSPI.cpp
  LegalizeJSInterface.cpp
  LimitSegments.cpp
  LocalCSE.cpp
  LocalSubtyping.cpp
  LogExecution.cpp
  LoopInvariantCodeMotion.cpp
  Memory64Lowering.cpp
  MemoryPacking.cpp
  MergeBlocks.cpp
  MergeSimilarFunctions.cpp
  MergeLocals.cpp
  Metrics.cpp
  MinifyImportsAndExports.cpp
  MultiMemoryLowering.cpp
  NameList.cpp
  NameTypes.cpp
  OnceReduction.cpp
  OptimizeAddedConstants.cpp
  OptimizeInstructions.cpp
  OptimizeForJS.cpp
  PickLoadSigns.cpp
  Poppify.cpp
  PostEmscripten.cpp
  Precompute.cpp
  Print.cpp
  PrintCallGraph.cpp
  PrintFeatures.cpp
  PrintFunctionMap.cpp
  RoundTrip.cpp
  SetGlobals.cpp
  StackIR.cpp
  SignaturePruning.cpp
  SignatureRefining.cpp
  Strip.cpp
  StripTargetFeatures.cpp
  RedundantSetElimination.cpp
  RemoveImports.cpp
  RemoveMemory.cpp
  RemoveNonJSOps.cpp
  RemoveUnusedBrs.cpp
  RemoveUnusedNames.cpp
  RemoveUnusedModuleElements.cpp
  ReorderLocals.cpp
  ReorderFunctions.cpp
  ReReloop.cpp
  TrapMode.cpp
  TypeRefining.cpp
  SafeHeap.cpp
  SimplifyGlobals.cpp
  SimplifyLocals.cpp
  Souperify.cpp
  SpillPointers.cpp
  StackCheck.cpp
  SSAify.cpp
  Untee.cpp
  Vacuum.cpp
  ${CMAKE_CURRENT_BINARY_DIR}/WasmIntrinsics.cpp
  ${passes_HEADERS}
)
add_library(passes OBJECT ${passes_SOURCES})
