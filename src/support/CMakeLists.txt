FILE(GLOB support_HEADERS *.h)
set(support_SOURCES
  archive.cpp
  bits.cpp
  colors.cpp
  command-line.cpp
  debug.cpp
  file.cpp
  path.cpp
  safe_integer.cpp
  threads.cpp
  utilities.cpp
  ${support_HEADERS}
)
add_library(support OBJECT ${support_SOURCES})
add_dependencies(support gen_exprs)
