add_custom_command(
  OUTPUT WasmIntrinsics.cpp
  COMMAND python ${CMAKE_SOURCE_DIR}/scripts/embedwast.py ${CMAKE_SOURCE_DIR}/src/passes/wasm-intrinsics.wast ${CMAKE_CURRENT_BINARY_DIR}/WasmIntrinsics.cpp
  DEPENDS ${CMAKE_SOURCE_DIR}/scripts/embedwast.py wasm-intrinsics.wast)

SET(passes_SOURCES
  pass.cpp
  CoalesceLocals.cpp
  CodePushing.cpp
  CodeFolding.cpp
  ConstHoisting.cpp
  DeadCodeElimination.cpp
  DuplicateFunctionElimination.cpp
  ExtractFunction.cpp
  Flatten.cpp
  FuncCastEmulation.cpp
  Inlining.cpp
  LegalizeJSInterface.cpp
  LocalCSE.cpp
  LogExecution.cpp
  I64ToI32Lowering.cpp
  InstrumentLocals.cpp
  InstrumentMemory.cpp
  MemoryPacking.cpp
  MergeBlocks.cpp
  MergeLocals.cpp
  Metrics.cpp
  NameList.cpp
  OptimizeInstructions.cpp
  PickLoadSigns.cpp
  PostEmscripten.cpp
  Precompute.cpp
  Print.cpp
  PrintCallGraph.cpp
  RedundantSetElimination.cpp
  RelooperJumpThreading.cpp
  ReReloop.cpp
  RemoveImports.cpp
  RemoveMemory.cpp
  RemoveNonJSOps.cpp
  RemoveUnusedBrs.cpp
  RemoveUnusedNames.cpp
  RemoveUnusedModuleElements.cpp
  ReorderLocals.cpp
  ReorderFunctions.cpp
  TrapMode.cpp
  SafeHeap.cpp
  SimplifyLocals.cpp
  SpillPointers.cpp
  SSAify.cpp
  Untee.cpp
  Vacuum.cpp
  ${CMAKE_CURRENT_BINARY_DIR}/WasmIntrinsics.cpp
)
ADD_LIBRARY(passes STATIC ${passes_SOURCES})
