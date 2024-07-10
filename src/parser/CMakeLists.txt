FILE(GLOB parser_HEADERS *.h)
set(parser_SOURCES
 context-decls.cpp
 context-defs.cpp
 lexer.cpp
 parse-1-decls.cpp
 parse-2-typedefs.cpp
 parse-3-implicit-types.cpp
 parse-4-module-types.cpp
 parse-5-defs.cpp
 wast-parser.cpp
 wat-parser.cpp
 ${parser_HEADERS}
)
add_library(parser OBJECT ${parser_SOURCES})
