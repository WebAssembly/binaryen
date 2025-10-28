# Version set according the the cmake version available in Ubuntu/Focal (LTS):
# https://launchpad.net/ubuntu/focal/+source/cmake
cmake_minimum_required(VERSION 3.16.3)

# Needed for C++17 (std::variant)
# TODO(https://github.com/WebAssembly/binaryen/issues/4299): We need
# to reduce this for compatability with emsdk.
set(CMAKE_OSX_DEPLOYMENT_TARGET "10.14" CACHE STRING "Minimum OS X deployment version")

project(binaryen LANGUAGES C CXX VERSION 124)
include(GNUInstallDirs)

# The C++ standard whose features are required to build Binaryen.
# Keep in sync with scripts/test/shared.py cxx_standard
# The if condition allows embedding in a project with a higher default C++ standard set
set(REQUIRED_CXX_STANDARD 17)
if(NOT CMAKE_CXX_STANDARD)
  set(CMAKE_CXX_STANDARD ${REQUIRED_CXX_STANDARD})
elseif(CMAKE_CXX_STANDARD LESS ${REQUIRED_CXX_STANDARD})
  message(SEND_ERROR "Building with C++ standards older than C++${REQUIRED_CXX_STANDARD} is not supported, change CMAKE_CXX_STANDARD to ${REQUIRED_CXX_STANDARD} or later")
endif()
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

if(NOT CMAKE_BUILD_TYPE)
  message(STATUS "No build type selected, default to Release")
  set(CMAKE_BUILD_TYPE "Release")
endif()

# We default to assertions enabled, even in release builds so that we get
# more useful error reports from users.
option(BYN_ENABLE_ASSERTIONS "Enable assertions" ON)

if(EMSCRIPTEN AND NOT "${CMAKE_BUILD_TYPE}" MATCHES "Debug")
  # in opt builds, LTO helps so much (>20%) it's worth slow compile times,
  # so we enable LTO by default in non-debug emscripten builds.
  set(DEFAULT_LTO ON)
else()
  set(DEFAULT_LTO OFF)
endif()
option(BYN_ENABLE_LTO "Build with LTO" ${DEFAULT_LTO})

# Turn this off to avoid the dependency on gtest.
option(BUILD_TESTS "Build GTest-based tests" ON)

option(BUILD_FUZZTEST "Build fuzztest-based tests and fuzzers" OFF)

# Turn this off to build only the library.
option(BUILD_TOOLS "Build tools" ON)

option(BUILD_LLVM_DWARF "Enable full DWARF support" ON)
if(EMSCRIPTEN)
  # For now, don't include full DWARF support in JS builds, for size.
  set(BUILD_LLVM_DWARF OFF)
endif()

option(BUILD_STATIC_LIB "Build as a static library" OFF)
if(MSVC)
  # We don't have dllexport declarations set up for Windows yet.
  set(BUILD_STATIC_LIB ON)
endif()

# Advised to turn on when statically linking against musl libc (e.g., in the
# Alpine Linux build we use for producing official Linux binaries), because
# musl libc's allocator has very bad performance on heavily multi-threaded
# workloads / high core count machines. But it also works with dynamic linking
# with a small performance advantage in some cases over the glibc allocator.
# See https://github.com/WebAssembly/binaryen/issues/5561.
option(BUILD_MIMALLOC "Build with mimalloc allocator" OFF)

# Turn this off to install only tools and not static/dynamic libs.
option(INSTALL_LIBS "Install libraries" ON)

# Turn this on to build only the subset of tools needed for Emscripten.
option(BUILD_EMSCRIPTEN_TOOLS_ONLY "Build only tools needed by emscripten" OFF)

# Turn this on to build binaryen.js as ES5, with additional compatibility configuration for js_of_ocaml.
option(JS_OF_OCAML "Build binaryen.js for js_of_ocaml" OFF)

# Turn this on to compile binaryen toolchain utilities for the browser.
option(BUILD_FOR_BROWSER "Build binaryen toolchain utilities for the browser" OFF)

# Turn this on to use the Wasm EH feature instead of emscripten EH in the wasm/BinaryenJS builds
option(EMSCRIPTEN_ENABLE_WASM_EH "Enable Wasm EH feature in emscripten build" OFF)

option(EMSCRIPTEN_ENABLE_WASM64 "Enable memory64 in emscripten build" OFF)

# Turn this on to use pthreads feature in the wasm/BinaryenJS builds
option(EMSCRIPTEN_ENABLE_PTHREADS "Enable pthreads in emscripten build" OFF)

# Turn this on to generate a single .js file with the Wasm file embedded within
# it. This is useful for packaging and distrubting binaryen as a single file.
option(EMSCRIPTEN_ENABLE_SINGLE_FILE "Enable SINGLE_FILE mode in emscripten build" OFF)

option(ENABLE_WERROR "Enable -Werror" ON)

# For git users, attempt to generate a more useful version string
if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/.git)
  find_package(Git QUIET REQUIRED)
  execute_process(COMMAND
               "${GIT_EXECUTABLE}" --git-dir=${CMAKE_CURRENT_SOURCE_DIR}/.git describe --tags --match version_*
           RESULT_VARIABLE
               GIT_VERSION_RESULT
           OUTPUT_VARIABLE
               GIT_VERSION
           OUTPUT_STRIP_TRAILING_WHITESPACE)
  if(${GIT_VERSION_RESULT})
    message(WARNING "Error running git describe to determine version")
  else()
    set(PROJECT_VERSION "${PROJECT_VERSION} (${GIT_VERSION})")
  endif()
endif()

configure_file(config.h.in config.h)

# Configure threads

set(THREADS_PREFER_PTHREAD_FLAG ON)
find_package(Threads REQUIRED)

# Support functionality.

function(add_compile_flag value)
  message(STATUS "Building with ${value}")
  # You can use the optional second argument to suppress passing C++-only flags to the C compiler.
  if(ARGV1 STREQUAL "CXX_ONLY")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${value}" PARENT_SCOPE)
  else()
    foreach(variable CMAKE_C_FLAGS CMAKE_CXX_FLAGS)
      set(${variable} "${${variable}} ${value}" PARENT_SCOPE)
    endforeach(variable)
  endif()
endfunction()

function(add_debug_compile_flag value)
  if("${CMAKE_BUILD_TYPE}" MATCHES "Debug")
    message(STATUS "Building with ${value}")
  endif()
  foreach(variable CMAKE_C_FLAGS_DEBUG CMAKE_CXX_FLAGS_DEBUG)
    set(${variable} "${${variable}} ${value}" PARENT_SCOPE)
  endforeach(variable)
endfunction()

function(add_nondebug_compile_flag value)
  if(NOT "${CMAKE_BUILD_TYPE}" MATCHES "Debug")
    message(STATUS "Building with ${value}")
  endif()
  foreach(variable CMAKE_C_FLAGS_RELEASE CMAKE_CXX_FLAGS_RELEASE CMAKE_C_FLAGS_RELWITHDEBINFO CMAKE_CXX_FLAGS_RELWITHDEBINFO CMAKE_C_FLAGS_MINSIZEREL CMAKE_CXX_FLAGS_MINSIZEREL)
    set(${variable} "${${variable}} ${value}" PARENT_SCOPE)
  endforeach(variable)
endfunction()

function(add_link_flag value)
  message(STATUS "Linking with ${value}")
  foreach(variable CMAKE_EXE_LINKER_FLAGS CMAKE_SHARED_LINKER_FLAGS)
    set(${variable} "${${variable}} ${value}" PARENT_SCOPE)
  endforeach(variable)
endfunction()

function(binaryen_setup_rpath name)
  if(CMAKE_INSTALL_RPATH)
    return()
  endif()

  if(APPLE)
    set(_install_name_dir INSTALL_NAME_DIR "@rpath")
    set(_install_rpath "@loader_path/../lib")
  elseif(UNIX)
    set(_install_rpath "\$ORIGIN/../lib")
    if(${CMAKE_SYSTEM_NAME} MATCHES "(FreeBSD|DragonFly)")
      set_property(TARGET ${name} APPEND_STRING PROPERTY
                   LINK_FLAGS " -Wl,-z,origin ")
    endif()
  else()
    return()
  endif()

  set_target_properties(${name} PROPERTIES
                        BUILD_WITH_INSTALL_RPATH On
                        INSTALL_RPATH "${_install_rpath}"
                        ${_install_name_dir})
endfunction()

function(binaryen_add_executable name sources)
  add_executable(${name} ${sources})
  target_link_libraries(${name} PRIVATE Threads::Threads)
  target_link_libraries(${name} PRIVATE binaryen)
  binaryen_setup_rpath(${name})
  install(TARGETS ${name} DESTINATION ${CMAKE_INSTALL_BINDIR})
endfunction()

# Compiler setup. Use SYSTEM to avoid warnings and errors from third-party headers.

include_directories(${CMAKE_CURRENT_SOURCE_DIR}/src)
include_directories(SYSTEM ${CMAKE_CURRENT_SOURCE_DIR}/third_party/FP16/include)
if(BUILD_LLVM_DWARF)
  include_directories(SYSTEM ${CMAKE_CURRENT_SOURCE_DIR}/third_party/llvm-project/include)
endif()

# Add output directory to include path so config.h can be found
include_directories(${CMAKE_CURRENT_BINARY_DIR})

# Configure output locations.

# Force output to bin/ and lib/. This is to suppress CMake multigenerator output paths and avoid bin/Debug, bin/Release/ and so on, which is CMake default.
foreach(SUFFIX "_DEBUG" "_RELEASE" "_RELWITHDEBINFO" "_MINSIZEREL" "")
  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY${SUFFIX} "${PROJECT_BINARY_DIR}/bin")
  set(CMAKE_LIBRARY_OUTPUT_DIRECTORY${SUFFIX} "${PROJECT_BINARY_DIR}/lib")
  set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY${SUFFIX} "${PROJECT_BINARY_DIR}/lib")
endforeach()

# Compiler setup for both 1P and 3P code.

if(NOT MSVC AND NOT EMSCRIPTEN)
  if(CMAKE_SYSTEM_PROCESSOR MATCHES "^i.86$")
    # wasm doesn't allow for x87 floating point math
    add_compile_flag("-msse2")
    add_compile_flag("-mfpmath=sse")
  elseif(CMAKE_SYSTEM_PROCESSOR MATCHES "^armv[2-6]" AND NOT CMAKE_CXX_FLAGS MATCHES "-mfpu=")
    add_compile_flag("-mfpu=vfpv3")
  endif()
endif()

if(BYN_ENABLE_LTO)
  if(NOT CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    message(FATAL_ERROR "ThinLTO is only supported by clang")
  endif()
  add_link_flag("-fuse-ld=lld")
  set_property(GLOBAL APPEND PROPERTY JOB_POOLS link_job_pool=2)
  set(CMAKE_JOB_POOL_LINK link_job_pool)
  add_compile_flag("-flto=thin")
  if(EMSCRIPTEN)
    # Under emscripten we also add `-flto` to the linker flags to tell the
    # compiler driver to choose LTO versions of the system libraries.
    add_link_flag("-flto=thin")
  endif()
endif()

if(MSVC)
  if(NOT CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    # multi-core build.
    add_compile_flag("/MP")
    if(CMAKE_CXX_COMPILER_VERSION VERSION_LESS "19.0")
      # VS2013 and older explicitly need /arch:sse2 set, VS2015 no longer has that option, but always enabled.
      add_compile_flag("/arch:sse2")
    endif()
  endif()

  add_debug_compile_flag("/Od")
  add_nondebug_compile_flag("/O2")

  # workaround for https://github.com/WebAssembly/binaryen/issues/3661
  add_compile_flag("/D_SILENCE_CXX17_ITERATOR_BASE_CLASS_DEPRECATION_WARNING")
  # Visual Studio 2018 15.8 implemented conformant support for std::aligned_storage, but the conformant support is only enabled when the following flag is passed, to avoid
  # breaking backwards compatibility with code that relied on the non-conformant behavior (the old nonconformant behavior is not used with Binaryen)
  add_compile_flag("/D_ENABLE_EXTENDED_ALIGNED_STORAGE")
  # Don't warn about using "strdup" as a reserved name.
  add_compile_flag("/D_CRT_NONSTDC_NO_DEPRECATE")

  if(BYN_ENABLE_ASSERTIONS)
    # On non-Debug builds cmake automatically defines NDEBUG, so we
    # explicitly undefine it:
    add_nondebug_compile_flag("/UNDEBUG") # Keep asserts.
  endif()
  # Also remove /D NDEBUG to avoid MSVC warnings about conflicting defines.
  if( NOT CMAKE_BUILD_TYPE MATCHES "Debug" )
    foreach(flags_var_to_scrub
        CMAKE_CXX_FLAGS_RELEASE
        CMAKE_CXX_FLAGS_RELWITHDEBINFO
        CMAKE_CXX_FLAGS_MINSIZEREL
        CMAKE_C_FLAGS_RELEASE
        CMAKE_C_FLAGS_RELWITHDEBINFO
        CMAKE_C_FLAGS_MINSIZEREL)
      string(REGEX REPLACE "(^| )[/-]D *NDEBUG($| )" " "
        "${flags_var_to_scrub}" "${${flags_var_to_scrub}}")
    endforeach()
    # Compile with `/MT` to link against `libcmt.lib`, removing a dependency
    # on `msvcrt.dll`. May result in slightly larger binaries but they should
    # be more portable across systems.
    set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded")
  endif()

  add_link_flag("/STACK:8388608")

else() # MSVC

  add_compile_flag("-fno-omit-frame-pointer")
  if(NOT BUILD_FUZZTEST)
    # fuzztest depends on RTTIs.
    add_compile_flag("-fno-rtti" "CXX_ONLY")
  endif()
  if(WIN32)
    add_compile_flag("-D_GNU_SOURCE")
    add_compile_flag("-D__STDC_FORMAT_MACROS")
    if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
      add_link_flag("-Wl,/stack:8388608")
    else()
      add_link_flag("-Wl,--stack,8388608")
    endif()
  elseif(NOT EMSCRIPTEN)
    add_compile_flag("-fPIC")
  endif()
  add_debug_compile_flag("-g3")
  if(BYN_ENABLE_ASSERTIONS)
    # On non-Debug builds cmake automatically defines NDEBUG, so we
    # explicitly undefine it:
    add_nondebug_compile_flag("-UNDEBUG")
  endif()
endif()

if(EMSCRIPTEN)
  # Note: to debug with DWARF you will usually want to enable BIGINT support, as
  # that helps avoid running Binaryen on the wasm after link. Binaryen's DWARF
  # rewriting has known limitations, so avoiding it during link is recommended
  # where possible (like local debugging).
  #
  # Note that this is debug info for Binaryen itself, that is, when you are
  # debugging Binaryen source code. This flag has no impact on what Binaryen
  # does when run on wasm files.
  option(ENABLE_BIGINT "Enable wasm BigInt support" OFF)
  if(ENABLE_BIGINT)
    add_link_flag("-sWASM_BIGINT")
   else()
    add_link_flag("-sWASM_BIGINT=0")
  endif()

  if("${CMAKE_BUILD_TYPE}" MATCHES "Release")
    # Extra check that cmake has set -O3 in its release flags.
    # This is really as an assertion that cmake is behaving as we expect.
    if(NOT CMAKE_CXX_FLAGS_RELEASE_INIT MATCHES "-O3")
      message(FATAL_ERROR "Expected -O3 to be in release link flags")
    endif()
  endif()

  add_link_flag("-sALLOW_MEMORY_GROWTH")
  add_link_flag("-sSTACK_SIZE=5MB")
  if(EMSCRIPTEN_ENABLE_WASM_EH)
    add_compile_flag("-fwasm-exceptions")
  else()
    add_compile_flag("-sDISABLE_EXCEPTION_CATCHING=0")
    add_link_flag("-sDISABLE_EXCEPTION_CATCHING=0")
  endif()
  if(EMSCRIPTEN_ENABLE_PTHREADS)
    add_compile_flag("-pthread")
    add_link_flag("-pthread")
    # Use mimalloc to avoid a 5x slowdown:
    # https://github.com/emscripten-core/emscripten/issues/15727#issuecomment-1960295018
    add_link_flag("-sMALLOC=mimalloc")
    # Disable the warning on pthreads+memory growth (we are not much affected by
    # it as there is little wasm-JS transfer of data, almost all work is inside
    # the wasm).
    add_link_flag("-Wno-pthreads-mem-growth")
  endif()
  # In the browser, there is no natural place to provide commandline arguments
  # for a commandline tool, so let the user run the main entry point themselves
  # and pass in the arguments there.
  if(BUILD_FOR_BROWSER)
    add_link_flag("-sENVIRONMENT=web,worker")
    add_link_flag("-sINVOKE_RUN=0")
    add_link_flag("-sEXPORTED_RUNTIME_METHODS=run,callMain,FS")
    add_link_flag("-sEXPORT_ES6")
    add_link_flag("-sFILESYSTEM")
    add_link_flag("-sFORCE_FILESYSTEM")
  else()
    # On Node.js, make the tools immediately usable.
    add_link_flag("-sNODERAWFS")
  endif()
  if(EMSCRIPTEN_ENABLE_WASM64)
    add_compile_flag("-sMEMORY64")
    add_link_flag("-sMEMORY64")
  endif()
endif()

# clang doesn't print colored diagnostics when invoked from Ninja
if(UNIX AND CMAKE_GENERATOR STREQUAL "Ninja")
  if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    add_compile_flag("-fdiagnostics-color=always")
  elseif(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
    add_compile_flag("-fcolor-diagnostics")
  endif()
endif()

# Add targets and sources for 3P code.

add_subdirectory(third_party)

# Additionally configure compiler for 1P code.

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

  if(BUILD_FUZZTEST)
    add_compile_flag("-DFUZZTEST")
    fuzztest_setup_fuzzing_flags()

    # Enabling fuzzing mode turns on sanitizers, which turn on additional
    # warnings. To keep the build working, do not treat these warnings as
    # errors.
    add_compile_flag("-Wno-error=maybe-uninitialized")
    add_compile_flag("-Wno-error=uninitialized")
    add_compile_flag("-Wno-error=array-bounds")
    add_compile_flag("-Wno-error=stringop-overread")
    add_compile_flag("-Wno-error=missing-field-initializers")
  endif()

  if(NOT APPLE AND NOT "${CMAKE_CXX_FLAGS}" MATCHES "-fsanitize")
    # This flag only applies to shared libraries so don't use add_link_flag
    set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -Wl,--no-undefined")
  endif()

endif()

# Declare libbinaryen

if(BUILD_STATIC_LIB)
  message(STATUS "Building libbinaryen as statically linked library.")
  add_library(binaryen STATIC)
  add_definitions(-DBUILD_STATIC_LIBRARY)
else()
  message(STATUS "Building libbinaryen as shared library.")
  add_library(binaryen SHARED)
  if(LINUX)
    # Disable interposition and resolve Binaryen symbols locally.
    add_link_flag("-Bsymbolic")
  endif()
endif()
target_link_libraries(binaryen Threads::Threads)
if(BUILD_LLVM_DWARF)
  target_link_libraries(binaryen llvm_dwarf)
endif()

if(BUILD_MIMALLOC)
  if(NOT(CMAKE_SYSTEM_NAME STREQUAL "Linux") OR EMSCRIPTEN)
    message(FATAL_ERROR "Linking mimalloc is only supported on Linux.")
  endif()
  message(STATUS "Building with mimalloc allocator.")
  if(BUILD_STATIC_LIB)
    target_link_libraries(binaryen mimalloc-static)
  else()
    target_link_libraries(binaryen mimalloc)
  endif()
endif()

add_subdirectory(src/ir)
add_subdirectory(src/asmjs)
add_subdirectory(src/cfg)
add_subdirectory(src/emscripten-optimizer)
add_subdirectory(src/interpreter)
add_subdirectory(src/passes)
add_subdirectory(src/parser)
add_subdirectory(src/support)
add_subdirectory(src/wasm)
add_subdirectory(src/analysis)

if(BUILD_TOOLS)
  # Build binaryen tools
  add_subdirectory(src/tools)
endif()

# Configure lit tests
add_subdirectory(test/lit)

if(BUILD_TESTS)
  # Configure GTest unit tests
  add_subdirectory(test/gtest)
endif()

# Sources.

file(GLOB binaryen_HEADERS src/*.h)
set(binaryen_SOURCES
  src/binaryen-c.cpp
  ${binaryen_HEADERS}
)
target_sources(binaryen PRIVATE ${binaryen_SOURCES})

if(INSTALL_LIBS OR NOT BUILD_STATIC_LIB)
  install(TARGETS binaryen
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR})
endif()
if(INSTALL_LIBS)
  install(FILES src/binaryen-c.h src/wasm-delegations.def DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})
endif()

# binaryen.js
#
# Note that we can't emit binaryen.js directly, as there is libbinaryen already
# declared earlier, so we create binaryen_wasm/js.js, which must then be copied.
if(EMSCRIPTEN)
  # binaryen.js WebAssembly variant
  add_executable(binaryen_wasm ${binaryen_HEADERS})
  # For the emscripten build we link against libbinaryen wih `--whole-archive`.
  # Without this, the EMSCRIPTEN_KEEPALIVE symbols within the library would
  # be ignored.
  target_link_libraries(binaryen_wasm PRIVATE binaryen)
  target_link_libraries(binaryen_wasm PRIVATE "-sFILESYSTEM")
  target_link_libraries(binaryen_wasm PRIVATE "-sEXPORT_NAME=Binaryen")
  target_link_libraries(binaryen_wasm PRIVATE "-sNODERAWFS=0")
  # Do not error on the repeated NODERAWFS argument
  target_link_libraries(binaryen_wasm PRIVATE "-Wno-unused-command-line-argument")
  # Emit a single file for convenience of people using binaryen.js as a library,
  # so they only need to distribute a single file.
  if(EMSCRIPTEN_ENABLE_SINGLE_FILE)
    target_link_libraries(binaryen_wasm PRIVATE "-sSINGLE_FILE")
  endif()
  target_link_libraries(binaryen_wasm PRIVATE "-sEXPORT_ES6")
  target_link_libraries(binaryen_wasm PRIVATE "-sEXPORTED_RUNTIME_METHODS=stringToUTF8OnStack,stringToAscii")
  # Explictly export _i32_load to ensure the binaryen-c.cpp is linked in.
  # This is the file that contains all the EMSCRIPTEN_KEEPALIVE symbols which
  # we want to exports, but enless we explictly reference a symbol from it
  # the linker will ignore the whole library.
  # TODO(sbc): Replace with `LINK_LIBRARY:WHOLE_ARCHIVE` once we bump the min
  # cmake version 3.24.
  target_link_libraries(binaryen_wasm PRIVATE "-sEXPORTED_FUNCTIONS=_malloc,_free,__i32_load")
  target_link_libraries(binaryen_wasm PRIVATE "--post-js=${CMAKE_CURRENT_SOURCE_DIR}/src/js/binaryen.js-post.js")
  target_link_libraries(binaryen_wasm PRIVATE optimized "--closure=1")
  # TODO: Fix closure warnings! (#5062)
  target_link_libraries(binaryen_wasm PRIVATE optimized "-Wno-error=closure")
  target_link_libraries(binaryen_wasm PRIVATE debug "--profiling")
  # Avoid catching exit as that can confuse error reporting in Node,
  # see https://github.com/emscripten-core/emscripten/issues/17228
  target_link_libraries(binaryen_wasm PRIVATE "-sNODEJS_CATCH_EXIT=0")
  install(TARGETS binaryen_wasm DESTINATION ${CMAKE_INSTALL_BINDIR})

  # binaryen.js JavaScript variant
  add_executable(binaryen_js ${binaryen_HEADERS})
  target_link_libraries(binaryen_js PRIVATE binaryen)
  target_link_libraries(binaryen_js PRIVATE "-sWASM=0")
  target_link_libraries(binaryen_js PRIVATE "-sWASM_ASYNC_COMPILATION=0")

  if(${CMAKE_CXX_COMPILER_VERSION} STREQUAL "6.0.1")
    # only valid with fastcomp and WASM=0
    target_link_libraries(binaryen_js PRIVATE "-sELIMINATE_DUPLICATE_FUNCTIONS")
  endif()
  # Disabling filesystem and setting web environment for js_of_ocaml
  # so it doesn't try to detect the "node" environment
  if(JS_OF_OCAML)
    target_link_libraries(binaryen_js PRIVATE "-sFILESYSTEM=0")
    target_link_libraries(binaryen_js PRIVATE "-sENVIRONMENT=web,worker")
  else()
    target_link_libraries(binaryen_js PRIVATE "-sFILESYSTEM=1")
  endif()
  target_link_libraries(binaryen_js PRIVATE "-sNODERAWFS=0")
  # Do not error on the repeated NODERAWFS argument
  target_link_libraries(binaryen_js PRIVATE "-Wno-unused-command-line-argument")
  if(EMSCRIPTEN_ENABLE_SINGLE_FILE)
    target_link_libraries(binaryen_js PRIVATE "-sSINGLE_FILE")
  endif()
  target_link_libraries(binaryen_js PRIVATE "-sEXPORT_NAME=Binaryen")
  # Currently, js_of_ocaml can only process ES5 code
  if(JS_OF_OCAML)
    target_link_libraries(binaryen_js PRIVATE "-sEXPORT_ES6=0")
  else()
    target_link_libraries(binaryen_js PRIVATE "-sEXPORT_ES6=1")
  endif()
  target_link_libraries(binaryen_js PRIVATE "-sEXPORTED_RUNTIME_METHODS=stringToUTF8OnStack,stringToAscii")
  target_link_libraries(binaryen_js PRIVATE "-sEXPORTED_FUNCTIONS=_malloc,_free,__i32_load")
  target_link_libraries(binaryen_js PRIVATE "--post-js=${CMAKE_CURRENT_SOURCE_DIR}/src/js/binaryen.js-post.js")
  # js_of_ocaml needs a specified variable with special comment to provide the library to consumers
  if(JS_OF_OCAML)
    target_link_libraries(binaryen_js PRIVATE "--extern-pre-js=${CMAKE_CURRENT_SOURCE_DIR}/src/js/binaryen.jsoo-extern-pre.js")
  endif()
  target_link_libraries(binaryen_js PRIVATE optimized "--closure=1")
  # Currently, js_of_ocaml can only process ES5 code
  if(JS_OF_OCAML)
    target_link_libraries(binaryen_js PRIVATE optimized "--closure-args=\"--language_out=ECMASCRIPT5\"")
  endif()
  # TODO: Fix closure warnings! (#5062)
  target_link_libraries(binaryen_js PRIVATE optimized "-Wno-error=closure")
  target_link_libraries(binaryen_js PRIVATE debug "--profiling")
  target_link_libraries(binaryen_js PRIVATE debug "-sASSERTIONS")
  # Avoid catching exit as that can confuse error reporting in Node,
  # see https://github.com/emscripten-core/emscripten/issues/17228
  target_link_libraries(binaryen_js PRIVATE "-sNODEJS_CATCH_EXIT=0")
  install(TARGETS binaryen_js DESTINATION ${CMAKE_INSTALL_BINDIR})
endif()

configure_file(scripts/binaryen-lit.in ${CMAKE_BINARY_DIR}/bin/binaryen-lit @ONLY)
