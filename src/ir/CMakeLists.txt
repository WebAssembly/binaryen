set(ir_SOURCES
  ExpressionAnalyzer.cpp
  ExpressionManipulator.cpp
  LocalGraph.cpp
  ReFinalize.cpp
)
add_library(ir OBJECT ${ir_SOURCES})
