SET(support_SOURCES
  archive.cpp
  bits.cpp
  colors.cpp
  command-line.cpp
  file.cpp
  path.cpp
  safe_integer.cpp
  threads.cpp
)
ADD_LIBRARY(support STATIC ${support_SOURCES})
TARGET_LINK_LIBRARIES(support ${CMAKE_THREAD_LIBS_INIT})
