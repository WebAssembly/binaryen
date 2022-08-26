if(BUILD_LLVM_DWARF)
  add_subdirectory(llvm-project)
endif()

include_directories(
  googletest/googletest
  googletest/googletest/include
)

if(BUILD_TESTS)
  add_library(gtest STATIC googletest/googletest/src/gtest-all.cc)
  add_library(gtest_main STATIC googletest/googletest/src/gtest_main.cc)
endif()
