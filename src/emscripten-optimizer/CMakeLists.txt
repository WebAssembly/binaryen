SET(optimizer_SOURCES
  parser.cpp
  simple_ast.cpp
  optimizer-shared.cpp
)
ADD_LIBRARY(optimizer STATIC ${optimizer_SOURCES})
