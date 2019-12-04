SET(support_SOURCES
  archive.cpp
  bits.cpp
  colors.cpp
  command-line.cpp
  debug.cpp
  file.cpp
  path.cpp
  safe_integer.cpp
  threads.cpp
)
ADD_LIBRARY(support OBJECT ${support_SOURCES})
