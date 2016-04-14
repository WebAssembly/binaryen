SET(support_SOURCES
  bits.cpp
  colors.cpp
  command-line.cpp
  file.cpp
  safe_integer.cpp
)
ADD_LIBRARY(support STATIC ${support_SOURCES})
