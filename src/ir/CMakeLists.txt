FILE(GLOB ir_HEADERS *.h)
set(ir_SOURCES
  ExpressionAnalyzer.cpp
  ExpressionManipulator.cpp
  LocalGraph.cpp
  ReFinalize.cpp
  stack-utils.cpp
  ${ir_HEADERS}
)
add_library(ir OBJECT ${ir_SOURCES})
