include_directories(../../third_party/googletest/googletest/include)
include_directories(../../src/wasm)

set(unittest_SOURCES
  dfa_minimization.cpp
  possible-contents.cpp
  type-builder.cpp
  wat-lexer.cpp
)
if(CMAKE_CXX_STANDARD GREATER_EQUAL 20)
  list(APPEND unittest_SOURCES coro.cpp)
endif()

binaryen_add_executable(binaryen-unittests "${unittest_SOURCES}")
target_link_libraries(binaryen-unittests gtest gtest_main)
