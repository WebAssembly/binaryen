#g++ -std=c++11 src/wasm-interpreter.cpp -g -o bin/wasm
g++ -std=c++11 src/asm2wasm.cpp src/parser.cpp src/simple_ast.cpp -g -o bin/asm2wasm

