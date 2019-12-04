SET(debugging_SOURCES
  Debugging.cpp
  DWARFContext.cpp
  raw_ostream.cpp
)
ADD_LIBRARY(debugging OBJECT ${debugging_SOURCES})
