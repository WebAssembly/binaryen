#
# This file builds the js components using emscripten. You normally don't need
# to run this, as the builds are bundled in the repo in bin/. Running this is
# useful if you are a developer and want to update those builds.
#

echo "building wasm.js"

em++ -std=c++11 src/wasm-js.cpp src/passes/pass.cpp src/passes/Print.cpp src/emscripten-optimizer/parser.cpp src/emscripten-optimizer/simple_ast.cpp src/emscripten-optimizer/optimizer-shared.cpp src/support/colors.cpp src/support/safe_integer.cpp src/support/bits.cpp src/support/threads.cpp src/asmjs/asm_v_wasm.cpp src/asmjs/shared-constants.cpp  src/wasm.cpp -Isrc/ -o bin/wasm.js -s MODULARIZE=1 -s 'EXPORT_NAME="WasmJS"' --memory-init-file 0 -Oz -s ALLOW_MEMORY_GROWTH=1 -profiling -s DEMANGLE_SUPPORT=1 #-DWASM_JS_DEBUG -DWASM_INTERPRETER_DEBUG=2

echo "building binaryen.js"

python ~/Dev/emscripten/tools/webidl_binder.py src/js/binaryen.idl glue
em++ -std=c++11 src/binaryen-js.cpp src/passes/pass.cpp src/passes/MergeBlocks.cpp src/passes/Print.cpp src/passes/RemoveUnusedBrs.cpp src/passes/RemoveUnusedNames.cpp src/passes/PostEmscripten.cpp src/passes/SimplifyLocals.cpp src/passes/ReorderLocals.cpp src/passes/Vacuum.cpp src/passes/DuplicateFunctionElimination.cpp src/passes/CoalesceLocals.cpp src/emscripten-optimizer/parser.cpp src/emscripten-optimizer/simple_ast.cpp src/emscripten-optimizer/optimizer-shared.cpp src/support/colors.cpp src/support/safe_integer.cpp src/support/bits.cpp src/support/threads.cpp src/asmjs/asm_v_wasm.cpp src/asmjs/shared-constants.cpp src/wasm.cpp -Isrc/ -o bin/binaryen.js -s MODULARIZE=1 -s 'EXPORT_NAME="Binaryen"' --memory-init-file 0 -Oz -s ALLOW_MEMORY_GROWTH=1 -profiling -s DEMANGLE_SUPPORT=1 -s INVOKE_RUN=0 --post-js glue.js
