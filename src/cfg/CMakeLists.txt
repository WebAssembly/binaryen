FILE(GLOB cfg_HEADERS *.h)
set(cfg_SOURCES
  DomTree.cpp
  Relooper.cpp
  ${cfg_HEADERS}
)
add_library(cfg OBJECT ${cfg_SOURCES})
