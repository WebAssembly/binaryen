SET(ast_SOURCES
  ExpressionAnalyzer.cpp
  ExpressionManipulator.cpp
  LocalGraph.cpp
)
ADD_LIBRARY(ast STATIC ${ast_SOURCES})
