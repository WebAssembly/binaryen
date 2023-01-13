include_directories(../../third_party/googletest/googletest/include)
include_directories(../../src/wasm)

set(unittest_SOURCES
  dfa_minimization.cpp
  possible-contents.cpp
  type-builder.cpp
  wat-lexer.cpp
)

binaryen_add_executable(binaryen-unittests "${unittest_SOURCES}")
target_link_libraries(binaryen-unittests gtest gtest_main)
