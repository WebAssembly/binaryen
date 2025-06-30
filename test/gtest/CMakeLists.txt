if(BUILD_FUZZTEST)
  include_directories(SYSTEM ${PROJECT_SOURCE_DIR}/third_party/fuzztest)
else()
  include_directories(SYSTEM ${PROJECT_SOURCE_DIR}/third_party/googletest/googletest/include)
  include_directories(SYSTEM ${PROJECT_SOURCE_DIR}/third_party/googletest/googlemock/include)
endif()

set(unittest_SOURCES
  arena.cpp
  cast-check.cpp
  cfg.cpp
  dfa_minimization.cpp
  disjoint_sets.cpp
  interpreter.cpp
  intervals.cpp
  json.cpp
  lattices.cpp
  local-graph.cpp
  possible-contents.cpp
  principal-type.cpp
  printing.cpp
  public-type-validator.cpp
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
  # source-map.cpp uses the gmock-matchers.h header, which is included with the
  # "standard" upstream gtest library, but not with the one bundled into the
  # fuzztest library (and the gmock included with upstream gtest seems
  # incompatible with the one in fuzztest). For now we work around this by just
  # excluding source-map.cpp from the fuzztest build, but if we start using
  # gmock more we should figure out what the right way to hande this is.
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
