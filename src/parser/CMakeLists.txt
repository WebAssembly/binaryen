FILE(GLOB parser_HEADERS *.h)
set(parser_SOURCES
 context-decls.cpp
 context-defs.cpp
 lexer.cpp
 wast-parser.cpp
 wat-parser.cpp
 ${parser_HEADERS}
)
add_library(parser OBJECT ${parser_SOURCES})
