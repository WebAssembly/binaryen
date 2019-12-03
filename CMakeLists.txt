PROJECT(binaryen C CXX)
CMAKE_MINIMUM_REQUIRED(VERSION 3.1.3)
INCLUDE(GNUInstallDirs)

IF(NOT CMAKE_BUILD_TYPE)
  MESSAGE(STATUS "No build type selected, default to Release")
  SET(CMAKE_BUILD_TYPE "Release")
ENDIF()

FIND_PACKAGE(Git QUIET REQUIRED)
EXECUTE_PROCESS(COMMAND
             "${GIT_EXECUTABLE}" --git-dir=${CMAKE_CURRENT_SOURCE_DIR}/.git describe --tags
         RESULT_VARIABLE
             GIT_HASH_RESULT
         OUTPUT_VARIABLE
             GIT_HASH
         OUTPUT_STRIP_TRAILING_WHITESPACE)
IF(${GIT_HASH_RESULT})
  MESSAGE(WARNING "Error running git describe to determine version")
  SET(BINARYEN_VERSION_INFO "(unable to determine version)")
ELSE()
  SET(BINARYEN_VERSION_INFO "${GIT_HASH}")
ENDIF()
CONFIGURE_FILE(config.h.in config.h)

OPTION(BUILD_STATIC_LIB "Build as a static library" OFF)

# Support functionality.

FUNCTION(ADD_COMPILE_FLAG value)
  MESSAGE(STATUS "Building with ${value}")
  FOREACH(variable CMAKE_C_FLAGS CMAKE_CXX_FLAGS)
    SET(${variable} "${${variable}} ${value}" PARENT_SCOPE)
  ENDFOREACH(variable)
ENDFUNCTION()

FUNCTION(ADD_CXX_FLAG value)
  MESSAGE(STATUS "Building with ${value}")
  SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${value}" PARENT_SCOPE)
ENDFUNCTION()

FUNCTION(ADD_DEBUG_COMPILE_FLAG value)
  IF("${CMAKE_BUILD_TYPE}" MATCHES "Debug")
    MESSAGE(STATUS "Building with ${value}")
  ENDIF()
  FOREACH(variable CMAKE_C_FLAGS_DEBUG CMAKE_CXX_FLAGS_DEBUG)
    SET(${variable} "${${variable}} ${value}" PARENT_SCOPE)
  ENDFOREACH(variable)
ENDFUNCTION()

FUNCTION(ADD_NONDEBUG_COMPILE_FLAG value)
  IF(NOT "${CMAKE_BUILD_TYPE}" MATCHES "Debug")
    MESSAGE(STATUS "Building with ${value}")
  ENDIF()
  FOREACH(variable CMAKE_C_FLAGS_RELEASE CMAKE_CXX_FLAGS_RELEASE CMAKE_C_FLAGS_RELWITHDEBINFO CMAKE_CXX_FLAGS_RELWITHDEBINFO CMAKE_C_FLAGS_MINSIZEREL CMAKE_CXX_FLAGS_MINSIZEREL)
    SET(${variable} "${${variable}} ${value}" PARENT_SCOPE)
  ENDFOREACH(variable)
ENDFUNCTION()

FUNCTION(ADD_LINK_FLAG value)
  MESSAGE(STATUS "Linking with ${value}")
  FOREACH(variable CMAKE_EXE_LINKER_FLAGS)
    SET(${variable} "${${variable}} ${value}" PARENT_SCOPE)
  ENDFOREACH(variable)
ENDFUNCTION()

# Compiler setup.

INCLUDE_DIRECTORIES(${CMAKE_CURRENT_SOURCE_DIR}/src)

# Add output directory to include path so config.h can be found
INCLUDE_DIRECTORIES(${CMAKE_CURRENT_BINARY_DIR})

# Force output to bin/ and lib/. This is to suppress CMake multigenerator output paths and avoid bin/Debug, bin/Release/ and so on, which is CMake default.
FOREACH(SUFFIX "_DEBUG" "_RELEASE" "_RELWITHDEBINFO" "_MINSIZEREL" "")
  SET(CMAKE_RUNTIME_OUTPUT_DIRECTORY${SUFFIX} "${PROJECT_BINARY_DIR}/bin")
  SET(CMAKE_LIBRARY_OUTPUT_DIRECTORY${SUFFIX} "${PROJECT_BINARY_DIR}/lib")
  SET(CMAKE_ARCHIVE_OUTPUT_DIRECTORY${SUFFIX} "${PROJECT_BINARY_DIR}/lib")
ENDFOREACH()

IF(MSVC)
  IF(CMAKE_CXX_COMPILER_VERSION VERSION_LESS "19.0") # VS2013 and older explicitly need /arch:sse2 set, VS2015 no longer has that option, but always enabled.
    ADD_COMPILE_FLAG("/arch:sse2")
  ENDIF()
  ADD_COMPILE_FLAG("/wd4146") # Ignore warning "warning C4146: unary minus operator applied to unsigned type, result still unsigned", this pattern is used somewhat commonly in the code.
  # 4267 and 4244 are conversion/truncation warnings. We might want to fix these but they are currently pervasive.
  ADD_COMPILE_FLAG("/wd4267")
  ADD_COMPILE_FLAG("/wd4244")
  # 4722 warns that destructors never return, even with WASM_NORETURN.
  ADD_COMPILE_FLAG("/wd4722")
  ADD_COMPILE_FLAG("/WX-")
  ADD_DEBUG_COMPILE_FLAG("/Od")
  ADD_NONDEBUG_COMPILE_FLAG("/O2")
  ADD_COMPILE_FLAG("/D_CRT_SECURE_NO_WARNINGS")
  ADD_COMPILE_FLAG("/D_SCL_SECURE_NO_WARNINGS")
  # Visual Studio 2018 15.8 implemented conformant support for std::aligned_storage, but the conformant support is only enabled when the following flag is passed, to avoid
  # breaking backwards compatibility with code that relied on the non-conformant behavior (the old nonconformant behavior is not used with Binaryen)
  ADD_COMPILE_FLAG("/D_ENABLE_EXTENDED_ALIGNED_STORAGE")
  # Don't warn about using "strdup" as a reserved name.
  ADD_COMPILE_FLAG("/D_CRT_NONSTDC_NO_DEPRECATE")

  ADD_NONDEBUG_COMPILE_FLAG("/UNDEBUG") # Keep asserts.
  # Also remove /D NDEBUG to avoid MSVC warnings about conflicting defines.
  if( NOT CMAKE_BUILD_TYPE MATCHES "Debug" )
    foreach (flags_var_to_scrub
        CMAKE_CXX_FLAGS_RELEASE
        CMAKE_CXX_FLAGS_RELWITHDEBINFO
        CMAKE_CXX_FLAGS_MINSIZEREL
        CMAKE_C_FLAGS_RELEASE
        CMAKE_C_FLAGS_RELWITHDEBINFO
        CMAKE_C_FLAGS_MINSIZEREL)
      string (REGEX REPLACE "(^| )[/-]D *NDEBUG($| )" " "
        "${flags_var_to_scrub}" "${${flags_var_to_scrub}}")

      # Compile with `/MT` to link against `libcmt.lib`, removing a dependency
      # on `msvcrt.dll`. May result in slightly larger binaries but they should
      # be more portable across systems.
      string(REPLACE "/MD" "/MT" ${flags_var_to_scrub} "${${flags_var_to_scrub}}")
    endforeach()
  endif()

  ADD_LINK_FLAG("/STACK:8388608")

  IF(RUN_STATIC_ANALYZER)
    ADD_DEFINITIONS(/analyze)
  ENDIF()
ELSE()

  OPTION(ENABLE_WERROR "Enable -Werror" ON)

  SET(THREADS_PREFER_PTHREAD_FLAG ON)
  SET(CMAKE_THREAD_PREFER_PTHREAD ON)
  FIND_PACKAGE(Threads REQUIRED)
  ADD_CXX_FLAG("-std=c++14")
  if (NOT EMSCRIPTEN)
    if (CMAKE_SYSTEM_PROCESSOR MATCHES "^i.86$")
      # wasm doesn't allow for x87 floating point math
      ADD_COMPILE_FLAG("-msse2")
      ADD_COMPILE_FLAG("-mfpmath=sse")
    elseif (CMAKE_SYSTEM_PROCESSOR MATCHES "^armv[2-6]" AND NOT CMAKE_CXX_FLAGS MATCHES "-mfpu=")
      ADD_COMPILE_FLAG("-mfpu=vfpv3")
    endif ()
  endif ()
  ADD_COMPILE_FLAG("-Wall")
  if(ENABLE_WERROR)
    ADD_COMPILE_FLAG("-Werror")
  endif()
  ADD_COMPILE_FLAG("-Wextra")
  ADD_COMPILE_FLAG("-Wno-unused-parameter")
  ADD_COMPILE_FLAG("-fno-omit-frame-pointer")
  # TODO(https://github.com/WebAssembly/binaryen/pull/2314): Remove these two
  # flags once we resolve the issue.
  ADD_COMPILE_FLAG("-Wno-implicit-int-float-conversion")
  ADD_COMPILE_FLAG("-Wno-unknown-warning-option")
  ADD_COMPILE_FLAG("-Wswitch") # we explicitly expect this in the code
  IF(WIN32)
    ADD_COMPILE_FLAG("-D_GNU_SOURCE")
    ADD_LINK_FLAG("-Wl,--stack,8388608")
  ELSE()
    ADD_COMPILE_FLAG("-fPIC")
  ENDIF()
  ADD_DEBUG_COMPILE_FLAG("-O0")
  ADD_DEBUG_COMPILE_FLAG("-g3")
  IF (EMSCRIPTEN)
    # really focus on minimizing output size when compiling sources
    ADD_NONDEBUG_COMPILE_FLAG("-Oz")
  ELSE()
    ADD_NONDEBUG_COMPILE_FLAG("-O2")
  ENDIF()
  ADD_NONDEBUG_COMPILE_FLAG("-UNDEBUG") # Keep asserts.
ENDIF()

IF (EMSCRIPTEN)
  # link with -O3 for metadce and other powerful optimizations. note that we
  # must use add_link_options so that this appears after CMake's default -O2
  add_link_options("-O3")
  ADD_LINK_FLAG("-s SINGLE_FILE")
  ADD_LINK_FLAG("-s ALLOW_MEMORY_GROWTH=1")
  ADD_COMPILE_FLAG("-s DISABLE_EXCEPTION_CATCHING=0")
  ADD_LINK_FLAG("-s DISABLE_EXCEPTION_CATCHING=0")
  # make the tools immediately usable on Node.js
  ADD_LINK_FLAG("-s NODERAWFS")
  # this can be moved into the fastcomp section once upstream ignores this flag,
  # https://github.com/emscripten-core/emscripten/pull/9897
  ADD_COMPILE_FLAG("-Wno-almost-asm")
  # check for fastcomp by the clang version, which is stuck in fastcomp way
  # back in the past
  IF (${CMAKE_CXX_COMPILER_VERSION} STREQUAL "6.0.1")
    ADD_LINK_FLAG("-s ELIMINATE_DUPLICATE_FUNCTIONS=1")
  ELSE()
    # in opt builds, LTO helps so much (>20%) it's worth slow compile times
    ADD_NONDEBUG_COMPILE_FLAG("-s WASM_OBJECT_FILES=0")
  ENDIF()
ENDIF()

# clang doesn't print colored diagnostics when invoked from Ninja
IF (UNIX AND
    CMAKE_CXX_COMPILER_ID STREQUAL "Clang" AND
    CMAKE_GENERATOR STREQUAL "Ninja")
  ADD_COMPILE_FLAG("-fcolor-diagnostics")
ENDIF()

# Static libraries
# Current (partial) dependency structure is as follows:
# passes -> wasm -> asmjs -> support
# TODO: It's odd that wasm should depend on asmjs, maybe we should fix that.
ADD_SUBDIRECTORY(src/ir)
ADD_SUBDIRECTORY(src/asmjs)
ADD_SUBDIRECTORY(src/cfg)
ADD_SUBDIRECTORY(src/emscripten-optimizer)
ADD_SUBDIRECTORY(src/passes)
ADD_SUBDIRECTORY(src/support)
ADD_SUBDIRECTORY(src/wasm)
ADD_SUBDIRECTORY(src/debugging)

# Object files
SET(binaryen_objs
    $<TARGET_OBJECTS:passes>
    $<TARGET_OBJECTS:wasm>
    $<TARGET_OBJECTS:asmjs>
    $<TARGET_OBJECTS:emscripten-optimizer>
    $<TARGET_OBJECTS:ir>
    $<TARGET_OBJECTS:debugging>
    $<TARGET_OBJECTS:cfg>
    $<TARGET_OBJECTS:support>)

# Sources.

SET(binaryen_SOURCES
  src/binaryen-c.cpp
)
IF(BUILD_STATIC_LIB)
  MESSAGE(STATUS "Building libbinaryen as statically linked library.")
  ADD_LIBRARY(binaryen STATIC ${binaryen_SOURCES} ${binaryen_objs})
  ADD_DEFINITIONS(-DBUILD_STATIC_LIBRARY)
ELSE()
  MESSAGE(STATUS "Building libbinaryen as shared library.")
  ADD_LIBRARY(binaryen SHARED ${binaryen_SOURCES} ${binaryen_objs})
ENDIF()
INSTALL(TARGETS binaryen DESTINATION ${CMAKE_INSTALL_LIBDIR})

INSTALL(FILES src/binaryen-c.h DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

SET(wasm-shell_SOURCES
  src/tools/wasm-shell.cpp
)
ADD_EXECUTABLE(wasm-shell ${wasm-shell_SOURCES} ${binaryen_objs})
TARGET_LINK_LIBRARIES(wasm-shell ${CMAKE_THREAD_LIBS_INIT})
SET_PROPERTY(TARGET wasm-shell PROPERTY CXX_STANDARD 14)
SET_PROPERTY(TARGET wasm-shell PROPERTY CXX_STANDARD_REQUIRED ON)
INSTALL(TARGETS wasm-shell DESTINATION ${CMAKE_INSTALL_BINDIR})

SET(wasm-opt_SOURCES
  src/tools/wasm-opt.cpp
)
ADD_EXECUTABLE(wasm-opt ${wasm-opt_SOURCES} ${binaryen_objs})
TARGET_LINK_LIBRARIES(wasm-opt ${CMAKE_THREAD_LIBS_INIT})
SET_PROPERTY(TARGET wasm-opt PROPERTY CXX_STANDARD 14)
SET_PROPERTY(TARGET wasm-opt PROPERTY CXX_STANDARD_REQUIRED ON)
INSTALL(TARGETS wasm-opt DESTINATION ${CMAKE_INSTALL_BINDIR})

SET(wasm-metadce_SOURCES
  src/tools/wasm-metadce.cpp
)
ADD_EXECUTABLE(wasm-metadce ${wasm-metadce_SOURCES} ${binaryen_objs})
TARGET_LINK_LIBRARIES(wasm-metadce ${CMAKE_THREAD_LIBS_INIT})
SET_PROPERTY(TARGET wasm-metadce PROPERTY CXX_STANDARD 14)
SET_PROPERTY(TARGET wasm-metadce PROPERTY CXX_STANDARD_REQUIRED ON)
INSTALL(TARGETS wasm-metadce DESTINATION bin)

SET(asm2wasm_SOURCES
  src/tools/asm2wasm.cpp
)
ADD_EXECUTABLE(asm2wasm ${asm2wasm_SOURCES} ${binaryen_objs})
TARGET_LINK_LIBRARIES(asm2wasm ${CMAKE_THREAD_LIBS_INIT})
SET_PROPERTY(TARGET asm2wasm PROPERTY CXX_STANDARD 14)
SET_PROPERTY(TARGET asm2wasm PROPERTY CXX_STANDARD_REQUIRED ON)
INSTALL(TARGETS asm2wasm DESTINATION ${CMAKE_INSTALL_BINDIR})

SET(wasm2js_SOURCES
  src/tools/wasm2js.cpp
)
ADD_EXECUTABLE(wasm2js ${wasm2js_SOURCES} ${binaryen_objs})
TARGET_LINK_LIBRARIES(wasm2js ${CMAKE_THREAD_LIBS_INIT})
SET_PROPERTY(TARGET wasm2js PROPERTY CXX_STANDARD 14)
SET_PROPERTY(TARGET wasm2js PROPERTY CXX_STANDARD_REQUIRED ON)
INSTALL(TARGETS wasm2js DESTINATION ${CMAKE_INSTALL_BINDIR})

SET(wasm-emscripten-finalize_SOURCES
  src/tools/wasm-emscripten-finalize.cpp
)
ADD_EXECUTABLE(wasm-emscripten-finalize ${wasm-emscripten-finalize_SOURCES} ${binaryen_objs})
TARGET_LINK_LIBRARIES(wasm-emscripten-finalize ${CMAKE_THREAD_LIBS_INIT})
SET_PROPERTY(TARGET wasm-emscripten-finalize PROPERTY CXX_STANDARD 14)
SET_PROPERTY(TARGET wasm-emscripten-finalize PROPERTY CXX_STANDARD_REQUIRED ON)
INSTALL(TARGETS wasm-emscripten-finalize DESTINATION ${CMAKE_INSTALL_BINDIR})

SET(wasm_as_SOURCES
  src/tools/wasm-as.cpp
)
ADD_EXECUTABLE(wasm-as ${wasm_as_SOURCES} ${binaryen_objs})
TARGET_LINK_LIBRARIES(wasm-as ${CMAKE_THREAD_LIBS_INIT})
SET_PROPERTY(TARGET wasm-as PROPERTY CXX_STANDARD 14)
SET_PROPERTY(TARGET wasm-as PROPERTY CXX_STANDARD_REQUIRED ON)
INSTALL(TARGETS wasm-as DESTINATION ${CMAKE_INSTALL_BINDIR})

SET(wasm_dis_SOURCES
  src/tools/wasm-dis.cpp
)
ADD_EXECUTABLE(wasm-dis ${wasm_dis_SOURCES} ${binaryen_objs})
TARGET_LINK_LIBRARIES(wasm-dis ${CMAKE_THREAD_LIBS_INIT})
SET_PROPERTY(TARGET wasm-dis PROPERTY CXX_STANDARD 14)
SET_PROPERTY(TARGET wasm-dis PROPERTY CXX_STANDARD_REQUIRED ON)
INSTALL(TARGETS wasm-dis DESTINATION ${CMAKE_INSTALL_BINDIR})

SET(wasm-ctor-eval_SOURCES
  src/tools/wasm-ctor-eval.cpp
)
ADD_EXECUTABLE(wasm-ctor-eval ${wasm-ctor-eval_SOURCES} ${binaryen_objs})
TARGET_LINK_LIBRARIES(wasm-ctor-eval ${CMAKE_THREAD_LIBS_INIT})
SET_PROPERTY(TARGET wasm-ctor-eval PROPERTY CXX_STANDARD 14)
SET_PROPERTY(TARGET wasm-ctor-eval PROPERTY CXX_STANDARD_REQUIRED ON)
INSTALL(TARGETS wasm-ctor-eval DESTINATION bin)

SET(wasm-reduce_SOURCES
  src/tools/wasm-reduce.cpp
)
ADD_EXECUTABLE(wasm-reduce ${wasm-reduce_SOURCES} ${binaryen_objs})
TARGET_LINK_LIBRARIES(wasm-reduce ${CMAKE_THREAD_LIBS_INIT})
SET_PROPERTY(TARGET wasm-reduce PROPERTY CXX_STANDARD 14)
SET_PROPERTY(TARGET wasm-reduce PROPERTY CXX_STANDARD_REQUIRED ON)
INSTALL(TARGETS wasm-reduce DESTINATION ${CMAKE_INSTALL_BINDIR})

# binaryen.js
#
# Note that we can't emit binaryen.js directly, as there is libbinaryen already
# declared earlier, so we create binaryen_js.js, which must then be copied.
IF (EMSCRIPTEN)
  SET(binaryen_js_SOURCES
    src/binaryen-c.cpp
  )
  ADD_EXECUTABLE(binaryen_js
                 ${binaryen_js_SOURCES})
  TARGET_LINK_LIBRARIES(binaryen_js wasm asmjs emscripten-optimizer passes ir cfg support wasm)
  # note that SHELL: is needed as otherwise cmake will coalesce -s link flags
  # in an incorrect way for emscripten
  TARGET_LINK_LIBRARIES(binaryen_js "-s WASM=0")
  TARGET_LINK_LIBRARIES(binaryen_js "-s WASM_ASYNC_COMPILATION=0")
  TARGET_LINK_LIBRARIES(binaryen_js "-s MODULARIZE_INSTANCE=1")
  TARGET_LINK_LIBRARIES(binaryen_js "-s NO_FILESYSTEM=0")
  TARGET_LINK_LIBRARIES(binaryen_js "-s NODERAWFS=0")
  TARGET_LINK_LIBRARIES(binaryen_js "-s EXPORT_NAME=Binaryen")
  TARGET_LINK_LIBRARIES(binaryen_js "--post-js ${CMAKE_CURRENT_SOURCE_DIR}/src/js/binaryen.js-post.js")
  TARGET_LINK_LIBRARIES(binaryen_js optimized "--closure 1")
  TARGET_LINK_LIBRARIES(binaryen_js optimized "--llvm-lto 1")
  TARGET_LINK_LIBRARIES(binaryen_js debug "--profiling")
  SET_PROPERTY(TARGET binaryen_js PROPERTY CXX_STANDARD 14)
  SET_PROPERTY(TARGET binaryen_js PROPERTY CXX_STANDARD_REQUIRED ON)
  INSTALL(TARGETS binaryen_js DESTINATION ${CMAKE_INSTALL_BINDIR})
ENDIF()

# Testing
#
# Currently just some very simple smoke tests.

ENABLE_TESTING()

ADD_TEST(NAME opt-unit
         COMMAND bin/wasm-opt test/unit.wast --flatten --ssa --metrics -O4 -Os --metrics)
ADD_TEST(NAME metrics-emcc
         COMMAND bin/wasm-opt test/emcc_hello_world.fromasm --metrics)
ADD_TEST(NAME exec-unit
         COMMAND bin/wasm-opt test/unit.wast --fuzz-exec)
ADD_TEST(NAME exec-hello
         COMMAND bin/wasm-opt test/hello_world.wast --fuzz-exec)
