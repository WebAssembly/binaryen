echo "building asm2wasm"
g++ -std=c++11 src/asm2wasm-main.cpp src/parser.cpp src/simple_ast.cpp src/optimizer-shared.cpp -g -o bin/asm2wasm
echo "building interpreter/js"
em++ -std=c++11 src/wasm-js.cpp -o bin/wasm.js

