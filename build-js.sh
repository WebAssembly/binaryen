#
# This file builds the js components using emscripten. You normally don't need
# to run this, as the builds are bundled in the repo in bin/. Running this is
# useful if you are a developer and want to update those builds.
#
# Usage: build-js.sh
# Usage: EMSCRIPTEN=path/to/emscripten build-js.sh  # explicit emscripten dir
#
# Emscripten's em++ and tools/webidl_binder.py will be accessed through the
# env var EMSCRIPTEN, e.g. ${EMSCRIPTEN}/em++
#
# You can get emscripten from
# http://kripken.github.io/emscripten-site/docs/getting_started/downloads.html
#
set -e

if [ "$1" == "-h" ] || [ "$1" == "--help" ] || [ "$1" == "-help" ]; then
  echo "usage: $0 [-g]" >&2
  echo "  -g  produce debug build" >&2
  echo ""
  echo "If EMSCRIPTEN is set in the envionment, emscripten will be loaded"
  echo "from that directory. Otherwise the location of emscripten is resolved"
  echo "through PATH."
  exit 1
fi

if [ -z $EMSCRIPTEN ]; then
  if (which emcc >/dev/null); then
    # Found emcc in PATH -- set EMSCRIPTEN (we need this to access webidl_binder.py)
    EMSCRIPTEN=$(dirname "$(which emcc)")
  else
    echo "$0: EMSCRIPTEN environment variable is not set and emcc was not found in PATH" >&2
    exit 1
  fi
elif [ ! -d "$EMSCRIPTEN" ]; then
  echo "$0: \"$EMSCRIPTEN\" (\$EMSCRIPTEN) is not a directory" >&2
  exit 1
fi

EMCC_ARGS="-std=c++11 --memory-init-file 0"
EMCC_ARGS="$EMCC_ARGS -s ALLOW_MEMORY_GROWTH=1"
EMCC_ARGS="$EMCC_ARGS -s DEMANGLE_SUPPORT=1"
EMCC_ARGS="$EMCC_ARGS -s DISABLE_EXCEPTION_CATCHING=0" # Exceptions are thrown and caught when optimizing endless loops
OUT_FILE_SUFFIX=

if [ "$1" == "-g" ]; then
  EMCC_ARGS="$EMCC_ARGS -O2" # need emcc js opts to be decently fast
  EMCC_ARGS="$EMCC_ARGS --llvm-opts 0 --llvm-lto 0"
  EMCC_ARGS="$EMCC_ARGS -profiling"
  OUT_FILE_SUFFIX=-g
else
  EMCC_ARGS="$EMCC_ARGS -Oz"
  EMCC_ARGS="$EMCC_ARGS --llvm-lto 1"
  EMCC_ARGS="$EMCC_ARGS -s ELIMINATE_DUPLICATE_FUNCTIONS=1"
  # Why these settings?
  # See https://gist.github.com/rsms/e33c61a25a31c08260161a087be03169
fi

echo "building wasm.js"

"$EMSCRIPTEN/em++" \
  $EMCC_ARGS \
  src/wasm-js.cpp \
  src/ast/ExpressionAnalyzer.cpp \
  src/ast/ExpressionManipulator.cpp \
  src/passes/pass.cpp \
  src/passes/CoalesceLocals.cpp \
  src/passes/CodePushing.cpp \
  src/passes/DeadCodeElimination.cpp \
  src/passes/DuplicateFunctionElimination.cpp \
  src/passes/ExtractFunction.cpp \
  src/passes/FlattenControlFlow.cpp \
  src/passes/Inlining.cpp \
  src/passes/InstrumentMemory.cpp \
  src/passes/LegalizeJSInterface.cpp \
  src/passes/LocalCSE.cpp \
  src/passes/LogExecution.cpp \
  src/passes/MemoryPacking.cpp \
  src/passes/MergeBlocks.cpp \
  src/passes/Metrics.cpp \
  src/passes/NameList.cpp \
  src/passes/NameManager.cpp \
  src/passes/OptimizeInstructions.cpp \
  src/passes/PickLoadSigns.cpp \
  src/passes/PostEmscripten.cpp \
  src/passes/Precompute.cpp \
  src/passes/PrintCallGraph.cpp \
  src/passes/Print.cpp \
  src/passes/RelooperJumpThreading.cpp \
  src/passes/RemoveImports.cpp \
  src/passes/RemoveMemory.cpp \
  src/passes/RemoveUnusedBrs.cpp \
  src/passes/RemoveUnusedModuleElements.cpp \
  src/passes/RemoveUnusedNames.cpp \
  src/passes/ReorderFunctions.cpp \
  src/passes/ReorderLocals.cpp \
  src/passes/ReReloop.cpp \
  src/passes/SimplifyLocals.cpp \
  src/passes/Vacuum.cpp \
  src/emscripten-optimizer/parser.cpp \
  src/emscripten-optimizer/simple_ast.cpp \
  src/emscripten-optimizer/optimizer-shared.cpp \
  src/wasm-emscripten.cpp \
  src/support/colors.cpp \
  src/support/safe_integer.cpp \
  src/support/bits.cpp \
  src/support/threads.cpp \
  src/asmjs/asm_v_wasm.cpp \
  src/asmjs/shared-constants.cpp \
  src/wasm/wasm.cpp \
  src/wasm/wasm-type.cpp \
  src/wasm/wasm-s-parser.cpp \
  src/wasm/wasm-binary.cpp \
  src/wasm/literal.cpp \
  src/cfg/Relooper.cpp \
  -Isrc/ \
  -o bin/wasm${OUT_FILE_SUFFIX}.js \
  -s MODULARIZE=1 \
  -s 'EXPORT_NAME="WasmJS"'
  #-DWASM_JS_DEBUG
  #-DWASM_INTERPRETER_DEBUG=2

echo "building binaryen.js to bitcode"

if [ "$1" != "-g" ]; then
  EMCC_ARGS="$EMCC_ARGS --closure 1"
fi

"$EMSCRIPTEN/em++" \
  $EMCC_ARGS \
  -std=c++11 \
  src/ast/ExpressionAnalyzer.cpp \
  src/ast/ExpressionManipulator.cpp \
  src/passes/pass.cpp \
  src/passes/CoalesceLocals.cpp \
  src/passes/CodePushing.cpp \
  src/passes/DeadCodeElimination.cpp \
  src/passes/DuplicateFunctionElimination.cpp \
  src/passes/ExtractFunction.cpp \
  src/passes/FlattenControlFlow.cpp \
  src/passes/Inlining.cpp \
  src/passes/InstrumentMemory.cpp \
  src/passes/LegalizeJSInterface.cpp \
  src/passes/LocalCSE.cpp \
  src/passes/LogExecution.cpp \
  src/passes/MemoryPacking.cpp \
  src/passes/MergeBlocks.cpp \
  src/passes/Metrics.cpp \
  src/passes/NameList.cpp \
  src/passes/NameManager.cpp \
  src/passes/OptimizeInstructions.cpp \
  src/passes/PickLoadSigns.cpp \
  src/passes/PostEmscripten.cpp \
  src/passes/Precompute.cpp \
  src/passes/PrintCallGraph.cpp \
  src/passes/Print.cpp \
  src/passes/RelooperJumpThreading.cpp \
  src/passes/RemoveImports.cpp \
  src/passes/RemoveMemory.cpp \
  src/passes/RemoveUnusedBrs.cpp \
  src/passes/RemoveUnusedModuleElements.cpp \
  src/passes/RemoveUnusedNames.cpp \
  src/passes/ReorderFunctions.cpp \
  src/passes/ReorderLocals.cpp \
  src/passes/ReReloop.cpp \
  src/passes/SimplifyLocals.cpp \
  src/passes/Vacuum.cpp \
  src/wasm-emscripten.cpp \
  src/support/colors.cpp \
  src/support/safe_integer.cpp \
  src/support/bits.cpp \
  src/support/threads.cpp \
  src/asmjs/asm_v_wasm.cpp \
  src/asmjs/shared-constants.cpp \
  src/wasm/wasm.cpp \
  src/wasm/wasm-type.cpp \
  src/wasm/wasm-binary.cpp \
  src/wasm/wasm-s-parser.cpp \
  src/wasm/literal.cpp \
  src/binaryen-c.cpp \
  src/cfg/Relooper.cpp \
  -o binaryen.bc \
  -Isrc/

echo "building binaryen.js to js"

"$EMSCRIPTEN/em++" \
  $EMCC_ARGS \
  binaryen.bc \
  -s 'EXPORTED_FUNCTIONS=["_BinaryenNone", "_BinaryenInt32", "_BinaryenInt64", "_BinaryenFloat32", "_BinaryenFloat64", "_BinaryenUndefined", "_BinaryenModuleCreate", "_BinaryenModuleDispose", "_BinaryenAddFunctionType", "_BinaryenGetFunctionTypeBySignature", "_BinaryenLiteralInt32", "_BinaryenLiteralInt64", "_BinaryenLiteralFloat32", "_BinaryenLiteralFloat64", "_BinaryenLiteralFloat32Bits", "_BinaryenLiteralFloat64Bits", "_BinaryenClzInt32", "_BinaryenCtzInt32", "_BinaryenPopcntInt32", "_BinaryenNegFloat32", "_BinaryenAbsFloat32", "_BinaryenCeilFloat32", "_BinaryenFloorFloat32", "_BinaryenTruncFloat32", "_BinaryenNearestFloat32", "_BinaryenSqrtFloat32", "_BinaryenEqZInt32", "_BinaryenClzInt64", "_BinaryenCtzInt64", "_BinaryenPopcntInt64", "_BinaryenNegFloat64", "_BinaryenAbsFloat64", "_BinaryenCeilFloat64", "_BinaryenFloorFloat64", "_BinaryenTruncFloat64", "_BinaryenNearestFloat64", "_BinaryenSqrtFloat64", "_BinaryenEqZInt64", "_BinaryenExtendSInt32", "_BinaryenExtendUInt32", "_BinaryenWrapInt64", "_BinaryenTruncSFloat32ToInt32", "_BinaryenTruncSFloat32ToInt64", "_BinaryenTruncUFloat32ToInt32", "_BinaryenTruncUFloat32ToInt64", "_BinaryenTruncSFloat64ToInt32", "_BinaryenTruncSFloat64ToInt64", "_BinaryenTruncUFloat64ToInt32", "_BinaryenTruncUFloat64ToInt64", "_BinaryenReinterpretFloat32", "_BinaryenReinterpretFloat64", "_BinaryenConvertSInt32ToFloat32", "_BinaryenConvertSInt32ToFloat64", "_BinaryenConvertUInt32ToFloat32", "_BinaryenConvertUInt32ToFloat64", "_BinaryenConvertSInt64ToFloat32", "_BinaryenConvertSInt64ToFloat64", "_BinaryenConvertUInt64ToFloat32", "_BinaryenConvertUInt64ToFloat64", "_BinaryenPromoteFloat32", "_BinaryenDemoteFloat64", "_BinaryenReinterpretInt32", "_BinaryenReinterpretInt64", "_BinaryenAddInt32", "_BinaryenSubInt32", "_BinaryenMulInt32", "_BinaryenDivSInt32", "_BinaryenDivUInt32", "_BinaryenRemSInt32", "_BinaryenRemUInt32", "_BinaryenAndInt32", "_BinaryenOrInt32", "_BinaryenXorInt32", "_BinaryenShlInt32", "_BinaryenShrUInt32", "_BinaryenShrSInt32", "_BinaryenRotLInt32", "_BinaryenRotRInt32", "_BinaryenEqInt32", "_BinaryenNeInt32", "_BinaryenLtSInt32", "_BinaryenLtUInt32", "_BinaryenLeSInt32", "_BinaryenLeUInt32", "_BinaryenGtSInt32", "_BinaryenGtUInt32", "_BinaryenGeSInt32", "_BinaryenGeUInt32", "_BinaryenAddInt64", "_BinaryenSubInt64", "_BinaryenMulInt64", "_BinaryenDivSInt64", "_BinaryenDivUInt64", "_BinaryenRemSInt64", "_BinaryenRemUInt64", "_BinaryenAndInt64", "_BinaryenOrInt64", "_BinaryenXorInt64", "_BinaryenShlInt64", "_BinaryenShrUInt64", "_BinaryenShrSInt64", "_BinaryenRotLInt64", "_BinaryenRotRInt64", "_BinaryenEqInt64", "_BinaryenNeInt64", "_BinaryenLtSInt64", "_BinaryenLtUInt64", "_BinaryenLeSInt64", "_BinaryenLeUInt64", "_BinaryenGtSInt64", "_BinaryenGtUInt64", "_BinaryenGeSInt64", "_BinaryenGeUInt64", "_BinaryenAddFloat32", "_BinaryenSubFloat32", "_BinaryenMulFloat32", "_BinaryenDivFloat32", "_BinaryenCopySignFloat32", "_BinaryenMinFloat32", "_BinaryenMaxFloat32", "_BinaryenEqFloat32", "_BinaryenNeFloat32", "_BinaryenLtFloat32", "_BinaryenLeFloat32", "_BinaryenGtFloat32", "_BinaryenGeFloat32", "_BinaryenAddFloat64", "_BinaryenSubFloat64", "_BinaryenMulFloat64", "_BinaryenDivFloat64", "_BinaryenCopySignFloat64", "_BinaryenMinFloat64", "_BinaryenMaxFloat64", "_BinaryenEqFloat64", "_BinaryenNeFloat64", "_BinaryenLtFloat64", "_BinaryenLeFloat64", "_BinaryenGtFloat64", "_BinaryenGeFloat64", "_BinaryenPageSize", "_BinaryenCurrentMemory", "_BinaryenGrowMemory", "_BinaryenHasFeature", "_BinaryenBlock", "_BinaryenIf", "_BinaryenLoop", "_BinaryenBreak", "_BinaryenSwitch", "_BinaryenCall", "_BinaryenCallImport", "_BinaryenCallIndirect", "_BinaryenGetLocal", "_BinaryenSetLocal", "_BinaryenTeeLocal", "_BinaryenGetGlobal", "_BinaryenSetGlobal", "_BinaryenLoad", "_BinaryenStore", "_BinaryenConst", "_BinaryenUnary", "_BinaryenBinary", "_BinaryenSelect", "_BinaryenDrop", "_BinaryenReturn", "_BinaryenHost", "_BinaryenNop", "_BinaryenUnreachable", "_BinaryenExpressionPrint", "_BinaryenAddFunction", "_BinaryenAddGlobal", "_BinaryenAddImport", "_BinaryenRemoveImport", "_BinaryenAddExport", "_BinaryenRemoveExport", "_BinaryenSetFunctionTable", "_BinaryenSetMemory", "_BinaryenSetStart", "_BinaryenModuleParse", "_BinaryenModulePrint", "_BinaryenModuleValidate", "_BinaryenModuleOptimize", "_BinaryenModuleAutoDrop", "_BinaryenModuleWrite", "_BinaryenModuleRead", "_BinaryenModuleInterpret", "_RelooperCreate", "_RelooperAddBlock", "_RelooperAddBranch", "_RelooperAddBlockWithSwitch", "_RelooperAddBranchForSwitch", "_RelooperRenderAndDispose", "_BinaryenSetAPITracing"]' \
  -o bin/binaryen${OUT_FILE_SUFFIX}.js \
  --memory-init-file 0 \
  --pre-js src/js/binaryen.js-pre.js \
  --post-js src/js/binaryen.js-post.js
