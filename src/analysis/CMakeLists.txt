file(GLOB analysis_HEADERS *.h lattices/*.h)
set(analysis_SOURCES
  cfg.cpp
  ${analysis_HEADERS}
)
add_library(analysis OBJECT ${analysis_SOURCES})
