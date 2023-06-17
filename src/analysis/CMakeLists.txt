file(GLOB analysis_HEADERS *.h)
set(analysis_SOURCES
  cfg.cpp
  sign-lattice.cpp
  monotone-analyzer.cpp
  powerset-lattice.cpp
  ${analysis_HEADERS}
)
add_library(analysis OBJECT ${analysis_SOURCES})
