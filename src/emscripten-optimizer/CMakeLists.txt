set(emscripten-optimizer_SOURCES
  optimizer-shared.cpp
  parser.cpp
  simple_ast.cpp
)
add_library(emscripten-optimizer OBJECT ${emscripten-optimizer_SOURCES})
