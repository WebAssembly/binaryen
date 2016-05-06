SET(passes_SOURCES
  LowerIfElse.cpp
  MergeBlocks.cpp
  Metrics.cpp
  NameManager.cpp
  OptimizeInstructions.cpp
  PostEmscripten.cpp
  Print.cpp
  RemoveImports.cpp
  RemoveUnusedBrs.cpp
  RemoveUnusedNames.cpp
  ReorderLocals.cpp
  SimplifyLocals.cpp
  Vacuum.cpp
)
ADD_LIBRARY(passes STATIC ${passes_SOURCES})
