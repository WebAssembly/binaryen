PROJECT(binaryen CXX)
CMAKE_MINIMUM_REQUIRED(VERSION 2.8.7)

IF(NOT CMAKE_BUILD_TYPE)
  MESSAGE(STATUS "No build type selected, default to Release")
  SET(CMAKE_BUILD_TYPE "Release")
ENDIF()
STRING(TOUPPER "${CMAKE_BUILD_TYPE}" uppercase_CMAKE_BUILD_TYPE)
IF(CMAKE_BUILD_TYPE AND
    NOT uppercase_CMAKE_BUILD_TYPE MATCHES "^(DEBUG|RELEASE)$")
  MESSAGE(FATAL_ERROR "Invalid value for CMAKE_BUILD_TYPE: ${CMAKE_BUILD_TYPE}")
ENDIF()

# Support functionality.

FUNCTION(ADD_COMPILE_FLAG value)
  MESSAGE(STATUS "Building with ${value}")
  FOREACH(variable CMAKE_C_FLAGS CMAKE_CXX_FLAGS)
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
  ADD_COMPILE_FLAG("/WX-")
  IF(uppercase_CMAKE_BUILD_TYPE STREQUAL "DEBUG")
    ADD_COMPILE_FLAG("/O0")
  ELSE()
    ADD_COMPILE_FLAG("/O2")
  ENDIF()
ELSE()
  ADD_COMPILE_FLAG("-std=c++11")
  ADD_COMPILE_FLAG("-msse2")
  ADD_COMPILE_FLAG("-mfpmath=sse")
  ADD_COMPILE_FLAG("-Wall")
  ADD_COMPILE_FLAG("-Werror")
  ADD_COMPILE_FLAG("-Wextra")
  ADD_COMPILE_FLAG("-Wno-unused-parameter")
  ADD_COMPILE_FLAG("-fno-omit-frame-pointer")
  ADD_LINK_FLAG("-pthread")
  IF(uppercase_CMAKE_BUILD_TYPE STREQUAL "DEBUG")
    ADD_COMPILE_FLAG("-O0")
    ADD_COMPILE_FLAG("-g3")
  ELSE()
    ADD_COMPILE_FLAG("-O2")
    ADD_DEFINITIONS("-UNDEBUG")  # Keep asserts.
  ENDIF()
ENDIF()

# clang doesn't print colored diagnostics when invoked from Ninja
IF (UNIX AND
    CMAKE_CXX_COMPILER_ID STREQUAL "Clang" AND
    CMAKE_GENERATOR STREQUAL "Ninja")
  ADD_COMPILE_FLAG("-fcolor-diagnostics")
ENDIF()

# Sources.

SET(support_SOURCES
  src/support/bits.cpp
  src/support/colors.cpp
  src/support/command-line.cpp
  src/support/file.cpp
  src/support/safe_integer.cpp
  src/support/threads.cpp
)
ADD_LIBRARY(support STATIC ${support_SOURCES})

SET(binaryen-shell_SOURCES
  src/binaryen-shell.cpp
  src/pass.cpp
  src/passes/LowerIfElse.cpp
  src/passes/MergeBlocks.cpp
  src/passes/NameManager.cpp
  src/passes/OptimizeInstructions.cpp
  src/passes/PostEmscripten.cpp
  src/passes/Print.cpp
  src/passes/RemoveImports.cpp
  src/passes/RemoveUnusedBrs.cpp
  src/passes/RemoveUnusedNames.cpp
  src/passes/SimplifyLocals.cpp
  src/passes/ReorderLocals.cpp
  src/passes/Vacuum.cpp
  src/passes/Metrics.cpp
)
ADD_EXECUTABLE(binaryen-shell
               ${binaryen-shell_SOURCES})
TARGET_LINK_LIBRARIES(binaryen-shell support)
SET_PROPERTY(TARGET binaryen-shell PROPERTY CXX_STANDARD 11)
SET_PROPERTY(TARGET binaryen-shell PROPERTY CXX_STANDARD_REQUIRED ON)
INSTALL(TARGETS binaryen-shell DESTINATION bin)

SET(asm2wasm_SOURCES
  src/asm2wasm-main.cpp
  src/pass.cpp
  src/passes/MergeBlocks.cpp
  src/passes/OptimizeInstructions.cpp
  src/passes/PostEmscripten.cpp
  src/passes/Print.cpp
  src/passes/RemoveUnusedBrs.cpp
  src/passes/RemoveUnusedNames.cpp
  src/passes/SimplifyLocals.cpp
  src/passes/ReorderLocals.cpp
  src/passes/Vacuum.cpp
  src/emscripten-optimizer/parser.cpp
  src/emscripten-optimizer/simple_ast.cpp
  src/emscripten-optimizer/optimizer-shared.cpp
)
ADD_EXECUTABLE(asm2wasm
               ${asm2wasm_SOURCES})
TARGET_LINK_LIBRARIES(asm2wasm support)
SET_PROPERTY(TARGET asm2wasm PROPERTY CXX_STANDARD 11)
SET_PROPERTY(TARGET asm2wasm PROPERTY CXX_STANDARD_REQUIRED ON)
INSTALL(TARGETS asm2wasm DESTINATION bin)

SET(wasm2asm_SOURCES
  src/wasm2asm-main.cpp
  src/emscripten-optimizer/parser.cpp
  src/emscripten-optimizer/simple_ast.cpp
  src/emscripten-optimizer/optimizer-shared.cpp
)
ADD_EXECUTABLE(wasm2asm
               ${wasm2asm_SOURCES})
TARGET_LINK_LIBRARIES(wasm2asm support)
SET_PROPERTY(TARGET wasm2asm PROPERTY CXX_STANDARD 11)
SET_PROPERTY(TARGET wasm2asm PROPERTY CXX_STANDARD_REQUIRED ON)
INSTALL(TARGETS wasm2asm DESTINATION bin)

SET(s2wasm_SOURCES
  src/pass.cpp
  src/passes/Print.cpp
  src/s2wasm-main.cpp
)
ADD_EXECUTABLE(s2wasm
               ${s2wasm_SOURCES})
TARGET_LINK_LIBRARIES(s2wasm support)
SET_PROPERTY(TARGET s2wasm PROPERTY CXX_STANDARD 11)
SET_PROPERTY(TARGET s2wasm PROPERTY CXX_STANDARD_REQUIRED ON)
INSTALL(TARGETS s2wasm DESTINATION bin)

SET(wasm_as_SOURCES
  src/wasm-as.cpp
)
ADD_EXECUTABLE(wasm-as
               ${wasm_as_SOURCES})
TARGET_LINK_LIBRARIES(wasm-as support)
SET_PROPERTY(TARGET wasm-as PROPERTY CXX_STANDARD 11)
SET_PROPERTY(TARGET wasm-as PROPERTY CXX_STANDARD_REQUIRED ON)
INSTALL(TARGETS wasm-as DESTINATION bin)

SET(wasm_dis_SOURCES
  src/pass.cpp
  src/passes/Print.cpp
  src/wasm-dis.cpp
)
ADD_EXECUTABLE(wasm-dis
               ${wasm_dis_SOURCES})
TARGET_LINK_LIBRARIES(wasm-dis support)
SET_PROPERTY(TARGET wasm-dis PROPERTY CXX_STANDARD 11)
SET_PROPERTY(TARGET wasm-dis PROPERTY CXX_STANDARD_REQUIRED ON)
INSTALL(TARGETS wasm-dis DESTINATION bin)
