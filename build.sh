echo "building binaryen shell"
g++ -O2 -std=c++11 src/binaryen-shell.cpp src/pass.cpp src/passes/*.cpp -o bin/binaryen-shell -Isrc/ -msse2 -mfpmath=sse # use sse for math, avoid x87, necessarily for proper float rounding on 32-bit
echo "building asm2wasm"
g++ -O2 -std=c++11 src/asm2wasm-main.cpp src/emscripten-optimizer/parser.cpp src/emscripten-optimizer/simple_ast.cpp src/emscripten-optimizer/optimizer-shared.cpp -o bin/asm2wasm
echo "building interpreter/js"
em++ -std=c++11 src/wasm-js.cpp src/emscripten-optimizer/parser.cpp src/emscripten-optimizer/simple_ast.cpp src/emscripten-optimizer/optimizer-shared.cpp -o bin/wasm.js -s MODULARIZE=1 -s 'EXPORT_NAME="WasmJS"' --memory-init-file 0 -O3 -s ALLOW_MEMORY_GROWTH=1 -profiling -s DEMANGLE_SUPPORT=1 #-DWASM_JS_DEBUG #-DWASM_INTERPRETER_DEBUG
cat src/js/post.js >> bin/wasm.js

