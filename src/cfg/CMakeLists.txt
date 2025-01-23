FILE(GLOB cfg_HEADERS *.h)
set(cfg_SOURCES
  Relooper.cpp
  ${cfg_HEADERS}
)
target_sources(binaryen PRIVATE ${cfg_SOURCES})
