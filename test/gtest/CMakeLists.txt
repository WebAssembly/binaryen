if(BUILD_FUZZTEST)
  include_directories(SYSTEM ${PROJECT_SOURCE_DIR}/third_party/fuzztest)
else()
  include_directories(SYSTEM ${PROJECT_SOURCE_DIR}/third_party/googletest/googletest/include)
  include_directories(SYSTEM ${PROJECT_SOURCE_DIR}/third_party/googletest/googlemock/include)
endif()

set(unittest_SOURCES
  arena.cpp
  cfg.cpp
  dfa_minimization.cpp
  disjoint_sets.cpp
  interpreter.cpp
  intervals.cpp
  json.cpp
  lattices.cpp
  local-graph.cpp
  possible-contents.cpp
  printing.cpp
  scc.cpp
  stringify.cpp
  suffix_tree.cpp
  topological-sort.cpp
  type-builder.cpp
  wat-lexer.cpp
  validator.cpp
)

if(BUILD_FUZZTEST)
  set(unittest_SOURCES ${unittest_SOURCES} type-domains.cpp)
else()
  set(unittest_SOURCES ${unittest_SOURCES} source-map.cpp)
endif()

# suffix_tree.cpp includes LLVM header using std::iterator (deprecated in C++17)
if (NOT MSVC)
  set_source_files_properties(suffix_tree.cpp PROPERTIES COMPILE_FLAGS -Wno-deprecated-declarations)
endif()

enable_testing()
include(GoogleTest)
binaryen_add_executable(binaryen-unittests "${unittest_SOURCES}")
if(BUILD_FUZZTEST)
  link_fuzztest(binaryen-unittests)
  gtest_discover_tests(binaryen-unittests)
else()
  target_link_libraries(binaryen-unittests PRIVATE gtest gtest_main)
endif()
