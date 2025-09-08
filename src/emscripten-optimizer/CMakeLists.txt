FILE(GLOB emscripten-optimizer_HEADERS *.h)
set(emscripten-optimizer_SOURCES
  optimizer-shared.cpp
  parser.cpp
  simple_ast.cpp
  ${emscripten-optimizer_HEADERS}
)
target_sources(binaryen PRIVATE ${emscripten-optimizer_SOURCES})
