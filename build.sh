echo "updating"
./update.py
echo "building (run   cmake .  if necessary)"
make -j
#echo "building binaryen shell"
#g++ -O2 -std=c++11 src/binaryen-shell.cpp src/pass.cpp src/passes/LowerIfElse.cpp src/passes/MergeBlocks.cpp src/passes/NameManager.cpp src/passes/RemoveImports.cpp src/passes/RemoveUnusedBrs.cpp src/passes/RemoveUnusedNames.cpp src/support/colors.cpp -o bin/binaryen-shell -Isrc/ -msse2 -mfpmath=sse # use sse for math, avoid x87, necessarily for proper float rounding on 32-bit
#echo "building asm2wasm"
#g++ -O2 -std=c++11 src/asm2wasm-main.cpp src/passes/MergeBlocks.cpp src/passes/RemoveUnusedBrs.cpp src/pass.cpp src/passes/RemoveUnusedNames.cpp src/emscripten-optimizer/parser.cpp src/emscripten-optimizer/simple_ast.cpp src/emscripten-optimizer/optimizer-shared.cpp src/support/colors.cpp -Isrc/ -o bin/asm2wasm
#echo "building wasm2asm"
#g++ -O2 -std=c++11 src/wasm2asm-main.cpp src/emscripten-optimizer/parser.cpp src/emscripten-optimizer/simple_ast.cpp src/emscripten-optimizer/optimizer-shared.cpp src/support/colors.cpp -Isrc/ -o bin/wasm2asm
#echo "building s2wasm"
#g++ -O2 -std=c++11 src/s2wasm-main.cpp src/support/command-line.cpp src/support/file.cpp src/support/colors.cpp -Isrc/ -o bin/s2wasm
echo "building wasm.js"
em++ -std=c++11 src/wasm-js.cpp src/pass.cpp src/passes/MergeBlocks.cpp src/passes/Print.cpp src/passes/OptimizeInstructions.cpp src/passes/RemoveUnusedBrs.cpp src/passes/RemoveUnusedNames.cpp src/passes/PostEmscripten.cpp src/passes/SimplifyLocals.cpp src/passes/ReorderLocals.cpp src/emscripten-optimizer/parser.cpp src/emscripten-optimizer/simple_ast.cpp src/emscripten-optimizer/optimizer-shared.cpp src/support/colors.cpp src/support/safe_integer.cpp src/support/bits.cpp -Isrc/ -o bin/wasm.js -s MODULARIZE=1 -s 'EXPORT_NAME="WasmJS"' --memory-init-file 0 -Oz -s ALLOW_MEMORY_GROWTH=1 -profiling -s DEMANGLE_SUPPORT=1 #-DWASM_JS_DEBUG -DWASM_INTERPRETER_DEBUG=2
echo "building binaryen.js"
python ~/Dev/emscripten/tools/webidl_binder.py src/js/binaryen.idl glue
em++ -std=c++11 src/binaryen-js.cpp src/pass.cpp src/passes/MergeBlocks.cpp src/passes/Print.cpp src/passes/RemoveUnusedBrs.cpp src/passes/RemoveUnusedNames.cpp src/passes/PostEmscripten.cpp src/passes/SimplifyLocals.cpp src/passes/ReorderLocals.cpp src/emscripten-optimizer/parser.cpp src/emscripten-optimizer/simple_ast.cpp src/emscripten-optimizer/optimizer-shared.cpp src/support/colors.cpp src/support/safe_integer.cpp src/support/bits.cpp -Isrc/ -o bin/binaryen.js -s MODULARIZE=1 -s 'EXPORT_NAME="Binaryen"' --memory-init-file 0 -Oz -s ALLOW_MEMORY_GROWTH=1 -profiling -s DEMANGLE_SUPPORT=1 -s INVOKE_RUN=0 --post-js glue.js
