SET(emscripten-optimizer_SOURCES
  optimizer-shared.cpp
  parser.cpp
  simple_ast.cpp
)
ADD_LIBRARY(emscripten-optimizer STATIC ${emscripten-optimizer_SOURCES})
