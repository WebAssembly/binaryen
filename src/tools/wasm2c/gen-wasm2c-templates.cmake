# https://stackoverflow.com/a/47801116
file(READ ${in} content)
string(REGEX REPLACE "(.[^\n]*\n)" "R\"w2c_template(\\1)w2c_template\"\n" content "${content}")
set(content "const char* ${symbol} = ${content};\n")
file(WRITE ${out} "${content}")
