PROJECT(binaryen CXX)
CMAKE_MINIMUM_REQUIRED(VERSION 2.8.12.2)

INCLUDE_DIRECTORIES(${CMAKE_CURRENT_SOURCE_DIR}/src)

SET(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${PROJECT_BINARY_DIR}/bin")

SET(CMAKE_CXX_FLAGS "-std=c++11 ${CMAKE_CXX_FLAGS}")
SET(CMAKE_CXX_FLAGS "-msse2 -mfpmath=sse ${CMAKE_CXX_FLAGS}")

# clang doesn't print colored diagnostics when invoked from Ninja
IF (UNIX AND
    CMAKE_CXX_COMPILER_ID STREQUAL "Clang" AND
    CMAKE_GENERATOR STREQUAL "Ninja")
  SET(CMAKE_CXX_FLAGS "-fcolor-diagnostics ${CMAKE_CXX_FLAGS}")
ENDIF()

SET(binaryen-shell_SOURCES
  src/binaryen-shell.cpp
  src/pass.cpp
  src/passes/LowerIfElse.cpp
  src/passes/NameManager.cpp
  src/passes/RemoveImports.cpp
)
ADD_EXECUTABLE(binaryen-shell
               ${binaryen-shell_SOURCES})
SET_PROPERTY(TARGET binaryen-shell PROPERTY CXX_STANDARD 11)
SET_PROPERTY(TARGET binaryen-shell PROPERTY CXX_STANDARD_REQUIRED ON)
INSTALL(TARGETS binaryen-shell DESTINATION bin)

SET(asm2wasm_SOURCES
  src/asm2wasm-main.cpp
  src/emscripten-optimizer/parser.cpp
  src/emscripten-optimizer/simple_ast.cpp
  src/emscripten-optimizer/optimizer-shared.cpp
)
ADD_EXECUTABLE(asm2wasm
               ${asm2wasm_SOURCES})
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
SET_PROPERTY(TARGET wasm2asm PROPERTY CXX_STANDARD 11)
SET_PROPERTY(TARGET wasm2asm PROPERTY CXX_STANDARD_REQUIRED ON)
INSTALL(TARGETS wasm2asm DESTINATION bin)

SET(s2wasm_SOURCES
  src/s2wasm-main.cpp
)
ADD_EXECUTABLE(s2wasm
               ${s2wasm_SOURCES})
SET_PROPERTY(TARGET s2wasm PROPERTY CXX_STANDARD 11)
SET_PROPERTY(TARGET s2wasm PROPERTY CXX_STANDARD_REQUIRED ON)
INSTALL(TARGETS s2wasm DESTINATION bin)
