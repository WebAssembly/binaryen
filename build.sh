echo "building asm2wasm"
g++ -O2 -std=c++11 src/asm2wasm-main.cpp src/emscripten-optimizer/parser.cpp src/emscripten-optimizer/simple_ast.cpp src/emscripten-optimizer/optimizer-shared.cpp -g -o bin/asm2wasm -Isrc/emscripten-optimizer
echo "building interpreter/js"
em++ -std=c++11 src/wasm-js.cpp src/emscripten-optimizer/parser.cpp src/emscripten-optimizer/simple_ast.cpp src/emscripten-optimizer/optimizer-shared.cpp -o bin/wasm.js -s MODULARIZE=1 -s 'EXPORT_NAME="WasmJS"' --memory-init-file 0 -s DEMANGLE_SUPPORT=1 -O3 -profiling -s TOTAL_MEMORY=67108864 -s SAFE_HEAP=1 -s ASSERTIONS=1  -Isrc/emscripten-optimizer #-DWASM_JS_DEBUG #-DWASM_INTERPRETER_DEBUG
cat src/js/post.js >> bin/wasm.js
echo "building wasm shell"
g++ -O2 -std=c++11 src/wasm-shell.cpp -g -o bin/wasm-shell -Isrc/emscripten-optimizer

