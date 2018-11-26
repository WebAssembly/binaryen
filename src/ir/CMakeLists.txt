SET(ir_SOURCES
  ExpressionAnalyzer.cpp
  ExpressionManipulator.cpp
  LocalGraph.cpp
  ReFinalize.cpp
)
ADD_LIBRARY(ir STATIC ${ir_SOURCES})
