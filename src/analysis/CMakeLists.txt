file(GLOB analysis_HEADERS *.h lattices/*.h)
set(analysis_SOURCES
  cfg.cpp
  ${analysis_HEADERS}
)
target_sources(binaryen PRIVATE ${analysis_SOURCES})
