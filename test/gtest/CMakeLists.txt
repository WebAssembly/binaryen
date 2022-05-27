include_directories(../../third_party/googletest/googletest/include)
include_directories(../../src/wasm)

set(unittest_SOURCES
  type-builder.cpp
  wat-parser.cpp
)

binaryen_add_executable(binaryen-unittests "${unittest_SOURCES}")
target_link_libraries(binaryen-unittests gtest gtest_main)
