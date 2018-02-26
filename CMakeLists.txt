PROJECT(binaryen C CXX)
CMAKE_MINIMUM_REQUIRED(VERSION 2.8.7)
INCLUDE(GNUInstallDirs)

set(BUILD_STATIC_LIB ON)

# Support functionality.

FUNCTION(ADD_COMPILE_FLAG value)
  MESSAGE(STATUS "binaryen building with ${value}")
  FOREACH(variable CMAKE_C_FLAGS CMAKE_CXX_FLAGS)
    SET(${variable} "${${variable}} ${value}" PARENT_SCOPE)
  ENDFOREACH(variable)
ENDFUNCTION()

FUNCTION(ADD_CXX_FLAG value)
  MESSAGE(STATUS "binaryen building with ${value}")
  SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${value}" PARENT_SCOPE)
ENDFUNCTION()

FUNCTION(ADD_DEBUG_COMPILE_FLAG value)
  IF("${CMAKE_BUILD_TYPE}" MATCHES "Debug")
    MESSAGE(STATUS "binaryen building with ${value}")
  ENDIF()
  FOREACH(variable CMAKE_C_FLAGS_DEBUG CMAKE_CXX_FLAGS_DEBUG)
    SET(${variable} "${${variable}} ${value}" PARENT_SCOPE)
  ENDFOREACH(variable)
ENDFUNCTION()

FUNCTION(ADD_NONDEBUG_COMPILE_FLAG value)
  IF(NOT "${CMAKE_BUILD_TYPE}" MATCHES "Debug")
    MESSAGE(STATUS "binaryen building with ${value}")
  ENDIF()
  FOREACH(variable CMAKE_C_FLAGS_RELEASE CMAKE_CXX_FLAGS_RELEASE CMAKE_C_FLAGS_RELWITHDEBINFO CMAKE_CXX_FLAGS_RELWITHDEBINFO CMAKE_C_FLAGS_MINSIZEREL CMAKE_CXX_FLAGS_MINSIZEREL)
    SET(${variable} "${${variable}} ${value}" PARENT_SCOPE)
  ENDFOREACH(variable)
ENDFUNCTION()

FUNCTION(ADD_LINK_FLAG value)
  MESSAGE(STATUS "binaryen linking with ${value}")
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

SET(all_passes passes)

IF(MSVC)
  IF(CMAKE_CXX_COMPILER_VERSION VERSION_LESS "19.0") # VS2013 and older explicitly need /arch:sse2 set, VS2015 no longer has that option, but always enabled. 
    ADD_COMPILE_FLAG("/arch:sse2")
  ENDIF()
  ADD_COMPILE_FLAG("/wd4146") # Ignore warning "warning C4146: unary minus operator applied to unsigned type, result still unsigned", this pattern is used somewhat commonly in the code.
  # 4267 and 4244 are conversion/truncation warnings. We might want to fix these but they are currently pervasive.
  ADD_COMPILE_FLAG("/wd4267")
  ADD_COMPILE_FLAG("/wd4244")
  ADD_COMPILE_FLAG("/WX-")
  ADD_DEBUG_COMPILE_FLAG("/Od")
  ADD_NONDEBUG_COMPILE_FLAG("/O2")
  ADD_COMPILE_FLAG("/D_CRT_SECURE_NO_WARNINGS")
  ADD_COMPILE_FLAG("/D_SCL_SECURE_NO_WARNINGS")

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
  SET(THREADS_PREFER_PTHREAD_FLAG ON)
  SET(CMAKE_THREAD_PREFER_PTHREAD ON)
  FIND_PACKAGE(Threads REQUIRED)
  ADD_CXX_FLAG("-std=c++11")
  if (NOT EMSCRIPTEN)
    # try to get the target architecture by compiling a dummy.c file and
    # checking the architecture using the file command.
    file(WRITE ${PROJECT_BINARY_DIR}/dummy.c "main(){}")
    try_compile(
      COMPILE_OK
      ${PROJECT_BINARY_DIR}
      ${PROJECT_BINARY_DIR}/dummy.c
      OUTPUT_VARIABLE COMPILE_OUTPUT
      COPY_FILE ${PROJECT_BINARY_DIR}/dummy
    )
    if (COMPILE_OK)
      execute_process(
        COMMAND file ${PROJECT_BINARY_DIR}/dummy
        RESULT_VARIABLE FILE_RESULT
        OUTPUT_VARIABLE FILE_OUTPUT
        ERROR_QUIET
      )

      if (FILE_RESULT EQUAL 0)
        if (${FILE_OUTPUT} MATCHES "x86[-_]64")
          set(TARGET_ARCH "x86-64")
        elseif (${FILE_OUTPUT} MATCHES "Intel 80386")
          set(TARGET_ARCH "i386")
        elseif (${FILE_OUTPUT} MATCHES "ARM")
          set(TARGET_ARCH "ARM")
        else ()
          message(WARNING "Unknown target architecture!")
        endif ()
        if(TARGET_ARCH)
          MESSAGE(STATUS "binaryen building for platform ${TARGET_ARCH}")
        endif ()
      else ()
        message(WARNING "Error running file on dummy executable")
      endif ()
    else ()
      message(WARNING "Error compiling dummy.c file: ${COMPILE_OUTPUT}")
    endif ()

    if (TARGET_ARCH STREQUAL "i386")
      # wasm doesn't allow for x87 floating point math
      ADD_COMPILE_FLAG("-msse2")
      ADD_COMPILE_FLAG("-mfpmath=sse")
    elseif(TARGET_ARCH STREQUAL "ARM")
      # stub for ARM-specific instructions. GCC6 adds NEON with the below flags
      ADD_COMPILE_FLAG("-march=native")
    endif ()
  endif ()
  ADD_COMPILE_FLAG("-Wall")
  ADD_COMPILE_FLAG("-Werror")
  ADD_COMPILE_FLAG("-Wextra")
  ADD_COMPILE_FLAG("-Wno-unused-parameter")
  ADD_COMPILE_FLAG("-fno-omit-frame-pointer")
  IF(WIN32)
    ADD_COMPILE_FLAG("-D_GNU_SOURCE")
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
ADD_SUBDIRECTORY(src/ast)
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

SET(s2wasm_SOURCES
  src/tools/s2wasm.cpp
  src/wasm-emscripten.cpp
  src/wasm-linker.cpp
)
ADD_EXECUTABLE(eosio-s2wasm
               ${s2wasm_SOURCES})
TARGET_LINK_LIBRARIES(eosio-s2wasm passes wasm asmjs ast cfg support)
SET_PROPERTY(TARGET eosio-s2wasm PROPERTY CXX_STANDARD 11)
SET_PROPERTY(TARGET eosio-s2wasm PROPERTY CXX_STANDARD_REQUIRED ON)
INSTALL(TARGETS eosio-s2wasm DESTINATION ${CMAKE_INSTALL_BINDIR})
