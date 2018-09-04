PROJECT(binaryen C CXX)
CMAKE_MINIMUM_REQUIRED(VERSION 2.8.7)
INCLUDE(GNUInstallDirs)

IF(NOT CMAKE_BUILD_TYPE)
  MESSAGE(STATUS "No build type selected, default to Release")
  SET(CMAKE_BUILD_TYPE "Release")
ENDIF()

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
  ADD_CXX_FLAG("-std=c++11")
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
  IF(WIN32)
    ADD_COMPILE_FLAG("-D_GNU_SOURCE")
    ADD_LINK_FLAG("-Wl,--stack,8388608")
  ELSE()
    ADD_COMPILE_FLAG("-fPIC")
  ENDIF()
  ADD_DEBUG_COMPILE_FLAG("-O0")
  ADD_DEBUG_COMPILE_FLAG("-g3")
  ADD_NONDEBUG_COMPILE_FLAG("-O2")
  ADD_NONDEBUG_COMPILE_FLAG("-UNDEBUG") # Keep asserts.
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

# Sources.


SET(binaryen_SOURCES
  src/binaryen-c.cpp
)
IF(BUILD_STATIC_LIB)
  ADD_LIBRARY(binaryen STATIC ${binaryen_SOURCES})
ELSE()
  ADD_LIBRARY(binaryen SHARED ${binaryen_SOURCES})
ENDIF()
TARGET_LINK_LIBRARIES(binaryen passes wasm asmjs emscripten-optimizer ir cfg support)
INSTALL(TARGETS binaryen DESTINATION ${CMAKE_INSTALL_LIBDIR})

INSTALL(FILES src/binaryen-c.h DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

# if binaryen.js and wasm.js were built (using "./build-js.sh", currently
# optional), install them
IF(EXISTS "${PROJECT_SOURCE_DIR}/bin/binaryen.js")
  INSTALL(FILES bin/binaryen.js DESTINATION ${CMAKE_INSTALL_DATADIR}/${PROJECT_NAME})
ENDIF()
IF(EXISTS "${PROJECT_SOURCE_DIR}/bin/wasm.js")
  INSTALL(FILES bin/wasm.js DESTINATION ${CMAKE_INSTALL_DATADIR}/${PROJECT_NAME})
ENDIF()

SET(wasm-shell_SOURCES
  src/tools/wasm-shell.cpp
)
ADD_EXECUTABLE(wasm-shell
               ${wasm-shell_SOURCES})
TARGET_LINK_LIBRARIES(wasm-shell wasm asmjs emscripten-optimizer passes ir cfg support wasm)
SET_PROPERTY(TARGET wasm-shell PROPERTY CXX_STANDARD 11)
SET_PROPERTY(TARGET wasm-shell PROPERTY CXX_STANDARD_REQUIRED ON)
INSTALL(TARGETS wasm-shell DESTINATION ${CMAKE_INSTALL_BINDIR})

SET(wasm-opt_SOURCES
  src/tools/wasm-opt.cpp
)
ADD_EXECUTABLE(wasm-opt
               ${wasm-opt_SOURCES})
TARGET_LINK_LIBRARIES(wasm-opt wasm asmjs emscripten-optimizer passes ir cfg support wasm)
SET_PROPERTY(TARGET wasm-opt PROPERTY CXX_STANDARD 11)
SET_PROPERTY(TARGET wasm-opt PROPERTY CXX_STANDARD_REQUIRED ON)
INSTALL(TARGETS wasm-opt DESTINATION ${CMAKE_INSTALL_BINDIR})

SET(wasm-merge_SOURCES
  src/tools/wasm-merge.cpp
)
ADD_EXECUTABLE(wasm-merge
               ${wasm-merge_SOURCES})
TARGET_LINK_LIBRARIES(wasm-merge wasm asmjs emscripten-optimizer passes ir cfg support wasm)
SET_PROPERTY(TARGET wasm-merge PROPERTY CXX_STANDARD 11)
SET_PROPERTY(TARGET wasm-merge PROPERTY CXX_STANDARD_REQUIRED ON)
INSTALL(TARGETS wasm-merge DESTINATION bin)

SET(wasm-metadce_SOURCES
  src/tools/wasm-metadce.cpp
)
ADD_EXECUTABLE(wasm-metadce
               ${wasm-metadce_SOURCES})
TARGET_LINK_LIBRARIES(wasm-metadce wasm asmjs emscripten-optimizer passes ir cfg support wasm)
SET_PROPERTY(TARGET wasm-metadce PROPERTY CXX_STANDARD 11)
SET_PROPERTY(TARGET wasm-metadce PROPERTY CXX_STANDARD_REQUIRED ON)
INSTALL(TARGETS wasm-metadce DESTINATION bin)

SET(asm2wasm_SOURCES
  src/tools/asm2wasm.cpp
)
ADD_EXECUTABLE(asm2wasm
               ${asm2wasm_SOURCES})
TARGET_LINK_LIBRARIES(asm2wasm emscripten-optimizer passes wasm asmjs ir cfg support)
SET_PROPERTY(TARGET asm2wasm PROPERTY CXX_STANDARD 11)
SET_PROPERTY(TARGET asm2wasm PROPERTY CXX_STANDARD_REQUIRED ON)
INSTALL(TARGETS asm2wasm DESTINATION ${CMAKE_INSTALL_BINDIR})

SET(wasm2js_SOURCES
  src/tools/wasm2js.cpp
)
ADD_EXECUTABLE(wasm2js
               ${wasm2js_SOURCES})
TARGET_LINK_LIBRARIES(wasm2js passes wasm asmjs emscripten-optimizer ir cfg support)
SET_PROPERTY(TARGET wasm2js PROPERTY CXX_STANDARD 11)
SET_PROPERTY(TARGET wasm2js PROPERTY CXX_STANDARD_REQUIRED ON)
INSTALL(TARGETS wasm2js DESTINATION ${CMAKE_INSTALL_BINDIR})

SET(wasm-emscripten-finalize_SOURCES
  src/tools/wasm-emscripten-finalize.cpp
)
ADD_EXECUTABLE(wasm-emscripten-finalize
               ${wasm-emscripten-finalize_SOURCES})
TARGET_LINK_LIBRARIES(wasm-emscripten-finalize passes wasm asmjs ir cfg support)
SET_PROPERTY(TARGET wasm-emscripten-finalize PROPERTY CXX_STANDARD 11)
SET_PROPERTY(TARGET wasm-emscripten-finalize PROPERTY CXX_STANDARD_REQUIRED ON)
INSTALL(TARGETS wasm-emscripten-finalize DESTINATION ${CMAKE_INSTALL_BINDIR})

SET(wasm_as_SOURCES
  src/tools/wasm-as.cpp
)
ADD_EXECUTABLE(wasm-as
               ${wasm_as_SOURCES})
TARGET_LINK_LIBRARIES(wasm-as wasm asmjs passes ir cfg support wasm)
SET_PROPERTY(TARGET wasm-as PROPERTY CXX_STANDARD 11)
SET_PROPERTY(TARGET wasm-as PROPERTY CXX_STANDARD_REQUIRED ON)
INSTALL(TARGETS wasm-as DESTINATION ${CMAKE_INSTALL_BINDIR})

SET(wasm_dis_SOURCES
  src/tools/wasm-dis.cpp
)
ADD_EXECUTABLE(wasm-dis
               ${wasm_dis_SOURCES})
TARGET_LINK_LIBRARIES(wasm-dis passes wasm asmjs ir cfg support)
SET_PROPERTY(TARGET wasm-dis PROPERTY CXX_STANDARD 11)
SET_PROPERTY(TARGET wasm-dis PROPERTY CXX_STANDARD_REQUIRED ON)
INSTALL(TARGETS wasm-dis DESTINATION ${CMAKE_INSTALL_BINDIR})

SET(wasm-ctor-eval_SOURCES
  src/tools/wasm-ctor-eval.cpp
)
ADD_EXECUTABLE(wasm-ctor-eval
               ${wasm-ctor-eval_SOURCES})
TARGET_LINK_LIBRARIES(wasm-ctor-eval emscripten-optimizer passes wasm asmjs ir cfg support)
SET_PROPERTY(TARGET wasm-ctor-eval PROPERTY CXX_STANDARD 11)
SET_PROPERTY(TARGET wasm-ctor-eval PROPERTY CXX_STANDARD_REQUIRED ON)
INSTALL(TARGETS wasm-ctor-eval DESTINATION bin)

SET(wasm-reduce_SOURCES
  src/tools/wasm-reduce.cpp
)
ADD_EXECUTABLE(wasm-reduce
                ${wasm-reduce_SOURCES})
TARGET_LINK_LIBRARIES(wasm-reduce wasm asmjs passes wasm ir cfg support)
SET_PROPERTY(TARGET wasm-reduce PROPERTY CXX_STANDARD 11)
SET_PROPERTY(TARGET wasm-reduce PROPERTY CXX_STANDARD_REQUIRED ON)
INSTALL(TARGETS wasm-reduce DESTINATION ${CMAKE_INSTALL_BINDIR})
