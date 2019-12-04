SET(debugging_SOURCES
  Debugging.cpp
  DWARFContext.cpp
)
ADD_LIBRARY(debugging OBJECT ${debugging_SOURCES})
