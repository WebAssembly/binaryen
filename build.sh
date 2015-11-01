echo "building asm2wasm"
g++ -O2 -std=c++11 src/asm2wasm-main.cpp src/parser.cpp src/simple_ast.cpp src/optimizer-shared.cpp -g -o bin/asm2wasm
echo "building interpreter/js"
em++ -std=c++11 src/wasm-js.cpp src/parser.cpp src/simple_ast.cpp src/optimizer-shared.cpp -o bin/wasm.js -s MODULARIZE=1 -s 'EXPORT_NAME="WasmJS"' --memory-init-file 0 -s DEMANGLE_SUPPORT=1 -O3 -profiling -s TOTAL_MEMORY=67108864 #-DWASM_INTERPRETER_DEBUG
cat src/js/post.js >> bin/wasm.js

