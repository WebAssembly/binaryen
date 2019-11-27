SET(emscripten-optimizer_SOURCES
  optimizer-shared.cpp
  parser.cpp
  simple_ast.cpp
)
ADD_LIBRARY(emscripten-optimizer OBJECT ${emscripten-optimizer_SOURCES})
