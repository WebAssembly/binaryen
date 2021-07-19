FILE(GLOB ir_HEADERS *.h)
set(ir_SOURCES
  ExpressionAnalyzer.cpp
  ExpressionManipulator.cpp
  names.cpp
  LocalGraph.cpp
  ReFinalize.cpp
  stack-utils.cpp
  table-utils.cpp
  type-updating.cpp
  module-splitting.cpp
  ${ir_HEADERS}
)
add_library(ir OBJECT ${ir_SOURCES})
