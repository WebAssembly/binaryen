if(BUILD_FUZZTEST)
  add_subdirectory(fuzztest)
elseif(BUILD_TESTS)
  # fuzztest includes gtest, but if we're not building fuzztest, build gtest ourselves.
  add_library(gtest STATIC googletest/googletest/src/gtest-all.cc)
  add_library(gtest_main STATIC googletest/googletest/src/gtest_main.cc)
  target_compile_options(gtest PRIVATE "-fno-rtti")
  target_compile_options(gtest_main PRIVATE "-fno-rtti")
  include_directories(
    googletest/googletest
    googletest/googletest/include
  )
endif()

if(BUILD_LLVM_DWARF)
  add_subdirectory(llvm-project)
endif()

if(MIMALLOC_STATIC)
  # We only need the static library, nothing else.
  set(MI_BUILD_STATIC ON)
  set(MI_BUILD_SHARED OFF)
  set(MI_BUILD_OBJECT OFF)
  set(MI_BUILD_TESTS OFF)
  # Do not show debug and warning messages of the allocator by default.
  # (They can still be enabled via MIMALLOC_VERBOSE=1 wasm-opt ...)
  add_compile_definitions(MI_DEBUG=0)
  
  add_subdirectory(mimalloc)
endif()
