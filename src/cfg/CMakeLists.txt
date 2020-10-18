FILE(GLOB cfg_HEADERS *.h)
set(cfg_SOURCES
  Relooper.cpp
  ${cfg_HEADERS}
)
add_library(cfg OBJECT ${cfg_SOURCES})
