include_directories(../../third_party/googletest/googletest/include)

set(unittest_SOURCES
  type-builder.cpp
)

binaryen_add_executable(binaryen-unittests "${unittest_SOURCES}")
target_link_libraries(binaryen-unittests gtest gtest_main)
