include_directories(.)

FILE(GLOB fuzzing_HEADERS *h)
set(fuzzing_SOURCES
  fuzzing.cpp
  ${fuzzing_HEADERS}
)
add_library(fuzzing STATIC ${fuzzing_SOURCES})
