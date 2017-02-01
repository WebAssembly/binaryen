SET(ast_SOURCES
  ExpressionAnalyzer.cpp
  ExpressionManipulator.cpp
)
ADD_LIBRARY(ast STATIC ${ast_SOURCES})
