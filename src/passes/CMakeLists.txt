# Python 3.5 is the version shipped in Ubuntu Xenial
find_package(PythonInterp 3.5 REQUIRED)

add_custom_command(
  OUTPUT WasmIntrinsics.cpp
  COMMAND ${PYTHON_EXECUTABLE} ${PROJECT_SOURCE_DIR}/scripts/embedwat.py ${PROJECT_SOURCE_DIR}/src/passes/wasm-intrinsics.wat ${CMAKE_CURRENT_BINARY_DIR}/WasmIntrinsics.cpp
  DEPENDS ${PROJECT_SOURCE_DIR}/scripts/embedwat.py wasm-intrinsics.wat)

FILE(GLOB passes_HEADERS *.h)
set(passes_SOURCES
  pass.cpp
  AlignmentLowering.cpp
  Asyncify.cpp
  AvoidReinterprets.cpp
  CoalesceLocals.cpp
  CodePushing.cpp
  CodeFolding.cpp
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
  I64ToI32Lowering.cpp
  Inlining.cpp
  InstrumentLocals.cpp
  InstrumentMemory.cpp
  LegalizeJSInterface.cpp
  LimitSegments.cpp
  LocalCSE.cpp
  LogExecution.cpp
  LoopInvariantCodeMotion.cpp
  Memory64Lowering.cpp
  MemoryPacking.cpp
  MergeBlocks.cpp
  MergeLocals.cpp
  Metrics.cpp
  MinifyImportsAndExports.cpp
  NameList.cpp
  NameTypes.cpp
  NoExitRuntime.cpp
  OptimizeAddedConstants.cpp
  OptimizeInstructions.cpp
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
  SafeHeap.cpp
  SimplifyGlobals.cpp
  SimplifyLocals.cpp
  Souperify.cpp
  StackCheck.cpp
  SSAify.cpp
  Untee.cpp
  Vacuum.cpp
  ${CMAKE_CURRENT_BINARY_DIR}/WasmIntrinsics.cpp
  ${passes_HEADERS}
)
add_library(passes OBJECT ${passes_SOURCES})
