cmake_minimum_required(VERSION 3.1.3)
project(binaryen LANGUAGES C CXX VERSION 98)
include(GNUInstallDirs)

# The C++ standard whose features are required to build Binaryen.
# Keep in sync with scripts/test/shared.py cxx_standard
set(CXX_STANDARD 17)

if(NOT CMAKE_BUILD_TYPE)
  message(STATUS "No build type selected, default to Release")
  set(CMAKE_BUILD_TYPE "Release")
endif()

# We default to assertions enabled, even in release builds so that we get
# more useful error reports from users.
option(BYN_ENABLE_ASSERTIONS "Enable assertions" ON)

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

# Support functionality.

function(ADD_COMPILE_FLAG value)
  message(STATUS "Building with ${value}")
  FOREACH(variable CMAKE_C_FLAGS CMAKE_CXX_FLAGS)
    set(${variable} "${${variable}} ${value}" PARENT_SCOPE)
  ENDFOREACH(variable)
endfunction()

function(ADD_CXX_FLAG value)
  message(STATUS "Building with ${value}")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${value}" PARENT_SCOPE)
endfunction()

function(ADD_DEBUG_COMPILE_FLAG value)
  if("${CMAKE_BUILD_TYPE}" MATCHES "Debug")
    message(STATUS "Building with ${value}")
  endif()
  FOREACH(variable CMAKE_C_FLAGS_DEBUG CMAKE_CXX_FLAGS_DEBUG)
    set(${variable} "${${variable}} ${value}" PARENT_SCOPE)
  ENDFOREACH(variable)
endfunction()

function(ADD_NONDEBUG_COMPILE_FLAG value)
  if(NOT "${CMAKE_BUILD_TYPE}" MATCHES "Debug")
    message(STATUS "Building with ${value}")
  endif()
  FOREACH(variable CMAKE_C_FLAGS_RELEASE CMAKE_CXX_FLAGS_RELEASE CMAKE_C_FLAGS_RELWITHDEBINFO CMAKE_CXX_FLAGS_RELWITHDEBINFO CMAKE_C_FLAGS_MINSIZEREL CMAKE_CXX_FLAGS_MINSIZEREL)
    set(${variable} "${${variable}} ${value}" PARENT_SCOPE)
  ENDFOREACH(variable)
endfunction()

function(ADD_LINK_FLAG value)
  message(STATUS "Linking with ${value}")
  FOREACH(variable CMAKE_EXE_LINKER_FLAGS)
    set(${variable} "${${variable}} ${value}" PARENT_SCOPE)
  ENDFOREACH(variable)
endfunction()

function(binaryen_setup_rpath name)
  if(CMAKE_INSTALL_RPATH)
    return()
  endif()

  if (APPLE)
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

# Options

option(BUILD_STATIC_LIB "Build as a static library" OFF)
if (MSVC)
  # We don't have dllexport declarations set up for windows yet.
  set(BUILD_STATIC_LIB ON)
endif()

# For now, don't include full DWARF support in JS builds, for size.
if (NOT EMSCRIPTEN)
  option(BUILD_LLVM_DWARF "Enable full DWARF support" ON)

  if(BUILD_LLVM_DWARF)
    if(MSVC)
      ADD_COMPILE_FLAG("/DBUILD_LLVM_DWARF")
    else()
      ADD_COMPILE_FLAG("-DBUILD_LLVM_DWARF")
    endif()
  endif()
endif()

# Compiler setup.

include_directories(${CMAKE_CURRENT_SOURCE_DIR}/src)
if(BUILD_LLVM_DWARF)
  include_directories(${CMAKE_CURRENT_SOURCE_DIR}/third_party/llvm-project/include)
endif()

# Add output directory to include path so config.h can be found
include_directories(${CMAKE_CURRENT_BINARY_DIR})

# Force output to bin/ and lib/. This is to suppress CMake multigenerator output paths and avoid bin/Debug, bin/Release/ and so on, which is CMake default.
FOREACH(SUFFIX "_DEBUG" "_RELEASE" "_RELWITHDEBINFO" "_MINSIZEREL" "")
  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY${SUFFIX} "${PROJECT_BINARY_DIR}/bin")
  set(CMAKE_LIBRARY_OUTPUT_DIRECTORY${SUFFIX} "${PROJECT_BINARY_DIR}/lib")
  set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY${SUFFIX} "${PROJECT_BINARY_DIR}/lib")
ENDFOREACH()

if(MSVC)
  if(CMAKE_CXX_COMPILER_VERSION VERSION_LESS "19.0") # VS2013 and older explicitly need /arch:sse2 set, VS2015 no longer has that option, but always enabled.
    add_compile_flag("/arch:sse2")
  endif()
  add_compile_flag("/std:c++${CXX_STANDARD}")
  add_compile_flag("/wd4146") # Ignore warning "warning C4146: unary minus operator applied to unsigned type, result still unsigned", this pattern is used somewhat commonly in the code.
  # 4267 and 4244 are conversion/truncation warnings. We might want to fix these but they are currently pervasive.
  add_compile_flag("/wd4267")
  add_compile_flag("/wd4244")
  # 4722 warns that destructors never return, even with WASM_NORETURN.
  add_compile_flag("/wd4722")
  # "destructor was implicitly defined as deleted" caused by LLVM headers.
  add_compile_flag("/wd4624")
  add_compile_flag("/WX-")
  add_debug_compile_flag("/Od")
  add_nondebug_compile_flag("/O2")
  add_compile_flag("/D_CRT_SECURE_NO_WARNINGS")
  add_compile_flag("/D_SCL_SECURE_NO_WARNINGS")
  # Visual Studio 2018 15.8 implemented conformant support for std::aligned_storage, but the conformant support is only enabled when the following flag is passed, to avoid
  # breaking backwards compatibility with code that relied on the non-conformant behavior (the old nonconformant behavior is not used with Binaryen)
  add_compile_flag("/D_ENABLE_EXTENDED_ALIGNED_STORAGE")
  # Don't warn about using "strdup" as a reserved name.
  add_compile_flag("/D_CRT_NONSTDC_NO_DEPRECATE")

  # multi-core build.
  add_compile_flag("/MP")

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

      # Compile with `/MT` to link against `libcmt.lib`, removing a dependency
      # on `msvcrt.dll`. May result in slightly larger binaries but they should
      # be more portable across systems.
      string(REPLACE "/MD" "/MT" ${flags_var_to_scrub} "${${flags_var_to_scrub}}")
    endforeach()
  endif()

  add_link_flag("/STACK:8388608")

  if(RUN_STATIC_ANALYZER)
    add_definitions(/analyze)
  endif()
else()

  option(ENABLE_WERROR "Enable -Werror" ON)

  set(THREADS_PREFER_PTHREAD_FLAG ON)
  set(CMAKE_THREAD_PREFER_PTHREAD ON)
  find_package(Threads REQUIRED)
  add_cxx_flag("-std=c++${CXX_STANDARD}")
  if(NOT EMSCRIPTEN)
    if(CMAKE_SYSTEM_PROCESSOR MATCHES "^i.86$")
      # wasm doesn't allow for x87 floating point math
      add_compile_flag("-msse2")
      add_compile_flag("-mfpmath=sse")
    elseif(CMAKE_SYSTEM_PROCESSOR MATCHES "^armv[2-6]" AND NOT CMAKE_CXX_FLAGS MATCHES "-mfpu=")
      add_compile_flag("-mfpu=vfpv3")
    endif()
  endif()
  add_compile_flag("-Wall")
  if(ENABLE_WERROR)
    add_compile_flag("-Werror")
  endif()
  add_compile_flag("-Wextra")
  add_compile_flag("-Wno-unused-parameter")
  add_compile_flag("-Wno-unused-variable")
  add_compile_flag("-fno-omit-frame-pointer")
  add_compile_flag("-fno-rtti")
  # TODO(https://github.com/WebAssembly/binaryen/pull/2314): Remove these two
  # flags once we resolve the issue.
  add_compile_flag("-Wno-implicit-int-float-conversion")
  add_compile_flag("-Wno-unknown-warning-option")
  add_compile_flag("-Wswitch") # we explicitly expect this in the code
  if(WIN32)
    add_compile_flag("-D_GNU_SOURCE")
    add_compile_flag("-D__STDC_FORMAT_MACROS")
    add_link_flag("-Wl,--stack,8388608")
  elseif(NOT EMSCRIPTEN)
    add_compile_flag("-fPIC")
  endif()
  add_debug_compile_flag("-O0")
  add_debug_compile_flag("-g3")
  if(EMSCRIPTEN)
    # really focus on minimizing output size when compiling sources
    add_nondebug_compile_flag("-Oz")
  else()
    add_nondebug_compile_flag("-O2")
  endif()
  if(BYN_ENABLE_ASSERTIONS)
    # On non-Debug builds cmake automatically defines NDEBUG, so we
    # explicitly undefine it:
    add_nondebug_compile_flag("-UNDEBUG")
  endif()
endif()

if(EMSCRIPTEN)
  # link with -O3 for metadce and other powerful optimizations. note that we
  # must use add_link_options so that this appears after CMake's default -O2
  add_link_options("-O3")
  add_link_flag("-s SINGLE_FILE")
  add_link_flag("-s ALLOW_MEMORY_GROWTH=1")
  add_compile_flag("-s DISABLE_EXCEPTION_CATCHING=0")
  add_link_flag("-s DISABLE_EXCEPTION_CATCHING=0")
  # make the tools immediately usable on Node.js
  add_link_flag("-s NODERAWFS")
  # in opt builds, LTO helps so much (>20%) it's worth slow compile times
  add_nondebug_compile_flag("-flto")
endif()

# clang doesn't print colored diagnostics when invoked from Ninja
if(UNIX AND CMAKE_GENERATOR STREQUAL "Ninja")
  if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    add_compile_flag("-fdiagnostics-color=always")
  elseif(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
    add_compile_flag("-fcolor-diagnostics")
  endif()
endif()

# Static libraries
# Current (partial) dependency structure is as follows:
# passes -> wasm -> asmjs -> support
# TODO: It's odd that wasm should depend on asmjs, maybe we should fix that.
add_subdirectory(src/ir)
add_subdirectory(src/asmjs)
add_subdirectory(src/cfg)
add_subdirectory(src/emscripten-optimizer)
add_subdirectory(src/passes)
add_subdirectory(src/support)
add_subdirectory(src/wasm)
add_subdirectory(third_party)

# Object files
set(binaryen_objs
    $<TARGET_OBJECTS:passes>
    $<TARGET_OBJECTS:wasm>
    $<TARGET_OBJECTS:asmjs>
    $<TARGET_OBJECTS:emscripten-optimizer>
    $<TARGET_OBJECTS:ir>
    $<TARGET_OBJECTS:cfg>
    $<TARGET_OBJECTS:support>)

IF(BUILD_LLVM_DWARF)
  SET(binaryen_objs ${binaryen_objs} $<TARGET_OBJECTS:llvm_dwarf>)
ENDIF()

# Sources.

file(GLOB binaryen_HEADERS src/*.h)
set(binaryen_SOURCES
  src/binaryen-c.cpp
  ${binaryen_HEADERS}
)
if(BUILD_STATIC_LIB)
  message(STATUS "Building libbinaryen as statically linked library.")
  add_library(binaryen STATIC ${binaryen_SOURCES} ${binaryen_objs})
  add_definitions(-DBUILD_STATIC_LIBRARY)
else()
  message(STATUS "Building libbinaryen as shared library.")
  add_library(binaryen SHARED ${binaryen_SOURCES} ${binaryen_objs})
endif()
install(TARGETS binaryen
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR})

install(FILES src/binaryen-c.h DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

function(binaryen_add_executable name sources)
  add_executable(${name} ${sources})
  target_link_libraries(${name} ${CMAKE_THREAD_LIBS_INIT})
  target_link_libraries(${name} binaryen)
  set_property(TARGET ${name} PROPERTY CXX_STANDARD ${CXX_STANDARD})
  set_property(TARGET ${name} PROPERTY CXX_STANDARD_REQUIRED ON)
  binaryen_setup_rpath(${name})
  install(TARGETS ${name} DESTINATION ${CMAKE_INSTALL_BINDIR})
endfunction()

binaryen_add_executable(wasm-opt src/tools/wasm-opt.cpp)
binaryen_add_executable(wasm-shell src/tools/wasm-shell.cpp)
binaryen_add_executable(wasm-metadce src/tools/wasm-metadce.cpp)
binaryen_add_executable(wasm2js src/tools/wasm2js.cpp)
binaryen_add_executable(wasm-emscripten-finalize src/tools/wasm-emscripten-finalize.cpp)
binaryen_add_executable(wasm-as src/tools/wasm-as.cpp)
binaryen_add_executable(wasm-dis src/tools/wasm-dis.cpp)
binaryen_add_executable(wasm-ctor-eval src/tools/wasm-ctor-eval.cpp)
binaryen_add_executable(wasm-reduce src/tools/wasm-reduce.cpp)


# binaryen.js
#
# Note that we can't emit binaryen.js directly, as there is libbinaryen already
# declared earlier, so we create binaryen_wasm/js.js, which must then be copied.
# Note that SHELL: is needed as otherwise cmake will coalesce -s link flags
# in an incorrect way for emscripten.
if(EMSCRIPTEN)
  set(binaryen_emscripten_SOURCES
    src/binaryen-c.cpp
    ${binaryen_HEADERS}
  )

  # binaryen.js WebAssembly variant
  add_executable(binaryen_wasm
                 ${binaryen_emscripten_SOURCES})
  target_link_libraries(binaryen_wasm wasm asmjs emscripten-optimizer passes ir cfg support wasm)
  target_link_libraries(binaryen_wasm "-s NO_FILESYSTEM=0")
  target_link_libraries(binaryen_wasm "-s NODERAWFS=0")
  target_link_libraries(binaryen_wasm "-s EXPORT_NAME=binaryen")
  target_link_libraries(binaryen_wasm "--post-js ${CMAKE_CURRENT_SOURCE_DIR}/src/js/binaryen.js-post.js")
  target_link_libraries(binaryen_wasm "--extern-pre-js ${CMAKE_CURRENT_SOURCE_DIR}/src/js/binaryen.js-extern-pre.js")
  target_link_libraries(binaryen_wasm "--extern-post-js ${CMAKE_CURRENT_SOURCE_DIR}/src/js/binaryen.js-extern-post.js")
  target_link_libraries(binaryen_wasm optimized "--closure 1")
  target_link_libraries(binaryen_wasm optimized "--closure-args \"--language_in=ECMASCRIPT6 --language_out=ECMASCRIPT6\"")
  target_link_libraries(binaryen_wasm optimized "-flto")
  target_link_libraries(binaryen_wasm debug "--profiling")
  set_property(TARGET binaryen_wasm PROPERTY CXX_STANDARD ${CXX_STANDARD})
  set_property(TARGET binaryen_wasm PROPERTY CXX_STANDARD_REQUIRED ON)
  install(TARGETS binaryen_wasm DESTINATION ${CMAKE_INSTALL_BINDIR})

  # binaryen.js JavaScript variant
  add_executable(binaryen_js
                 ${binaryen_emscripten_SOURCES})
  target_link_libraries(binaryen_js wasm asmjs emscripten-optimizer passes ir cfg support wasm)
  target_link_libraries(binaryen_js "-s WASM=0")
  target_link_libraries(binaryen_js "-s WASM_ASYNC_COMPILATION=0")
  if(${CMAKE_CXX_COMPILER_VERSION} STREQUAL "6.0.1")
    # only valid with fastcomp and WASM=0
    target_link_libraries(binaryen_js "-s ELIMINATE_DUPLICATE_FUNCTIONS=1")
  endif()
  target_link_libraries(binaryen_js "-s NO_FILESYSTEM=0")
  target_link_libraries(binaryen_js "-s NODERAWFS=0")
  target_link_libraries(binaryen_js "-s EXPORT_NAME=binaryen")
  target_link_libraries(binaryen_js "--post-js ${CMAKE_CURRENT_SOURCE_DIR}/src/js/binaryen.js-post.js")
  target_link_libraries(binaryen_js "--extern-pre-js ${CMAKE_CURRENT_SOURCE_DIR}/src/js/binaryen.js-extern-pre.js")
  target_link_libraries(binaryen_js "--extern-post-js ${CMAKE_CURRENT_SOURCE_DIR}/src/js/binaryen.js-extern-post.js")
  target_link_libraries(binaryen_js optimized "--closure 1")
  target_link_libraries(binaryen_js optimized "--closure-args \"--language_in=ECMASCRIPT6 --language_out=ECMASCRIPT6\"")
  target_link_libraries(binaryen_js optimized "-flto")
  target_link_libraries(binaryen_js debug "--profiling")
  target_link_libraries(binaryen_js debug "-s ASSERTIONS")
  set_property(TARGET binaryen_js PROPERTY CXX_STANDARD ${CXX_STANDARD})
  set_property(TARGET binaryen_js PROPERTY CXX_STANDARD_REQUIRED ON)
  install(TARGETS binaryen_js DESTINATION ${CMAKE_INSTALL_BINDIR})
endif()
