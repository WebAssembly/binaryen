# For now, don't include full DWARF support in JS builds, for size.
if(BUILD_LLVM_DWARF)
  if(MSVC)
    add_compile_flag("/DBUILD_LLVM_DWARF")
  else()
    add_compile_flag("-DBUILD_LLVM_DWARF")
  endif()
endif()

# Configure warnings and errors

if(MSVC)
  add_compile_flag("/wd4146") # Ignore warning "warning C4146: unary minus operator applied to unsigned type, result still unsigned", this pattern is used somewhat commonly in the code.
  # 4267 and 4244 are conversion/truncation warnings. We might want to fix these but they are currently pervasive.
  add_compile_flag("/wd4267")
  add_compile_flag("/wd4244")
  # 4722 warns that destructors never return, even with [[noreturn]].
  add_compile_flag("/wd4722")
  # "destructor was implicitly defined as deleted" caused by LLVM headers.
  add_compile_flag("/wd4624")
  add_compile_flag("/WX-")
  add_compile_flag("/D_CRT_SECURE_NO_WARNINGS")
  add_compile_flag("/D_SCL_SECURE_NO_WARNINGS")

  if(RUN_STATIC_ANALYZER)
    add_definitions(/analyze)
  endif()

else() # MSVC

  add_compile_flag("-Wall")
  if(ENABLE_WERROR)
    add_compile_flag("-Werror")
  endif()
  add_compile_flag("-Wextra")
  add_compile_flag("-Wno-unused-parameter")
  add_compile_flag("-Wno-dangling-pointer") # false positive in gcc
  # TODO(https://github.com/WebAssembly/binaryen/pull/2314): Remove these two
  # flags once we resolve the issue.
  add_compile_flag("-Wno-implicit-int-float-conversion")
  add_compile_flag("-Wno-unknown-warning-option")
  add_compile_flag("-Wswitch") # we explicitly expect this in the code
  add_compile_flag("-Wimplicit-fallthrough")
  add_compile_flag("-Wnon-virtual-dtor")

  if(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
    # Google style requires this, so make sure we compile cleanly with it.
    add_compile_flag("-Wctad-maybe-unsupported")
    # Disable a warning that started to happen on system headers (so we can't
    # fix it in our codebase) on github CI:
    # https://github.com/WebAssembly/binaryen/pull/6597
    add_compile_flag("-Wno-deprecated-declarations")
  endif()

endif()

add_subdirectory(ir)
add_subdirectory(asmjs)
add_subdirectory(cfg)
add_subdirectory(emscripten-optimizer)
add_subdirectory(interpreter)
add_subdirectory(passes)
add_subdirectory(parser)
add_subdirectory(support)
add_subdirectory(wasm)
add_subdirectory(analysis)

if(BUILD_TOOLS)
  # Build binaryen tools
  add_subdirectory(tools)
endif()

if(BUILD_TESTS)
  # Configure GTest unit tests
  add_subdirectory(gtest)
endif()

file(GLOB binaryen_HEADERS *.h)
set(binaryen_SOURCES
  binaryen-c.cpp
  ${binaryen_HEADERS}
)
target_sources(binaryen PRIVATE ${binaryen_SOURCES})
