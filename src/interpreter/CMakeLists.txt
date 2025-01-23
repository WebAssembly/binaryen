FILE(GLOB interpreter_HEADERS *.h)
set(interpreter_SOURCES
 expression-iterator.cpp
 interpreter.cpp
 ${interpreter_HEADERS}
)
target_sources(binaryen PRIVATE ${interpreter_SOURCES})
