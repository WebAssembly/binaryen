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
OUT_FILE_SUFFIX=

if [ "$1" == "-g" ]; then
  EMCC_ARGS="$EMCC_ARGS -O2" # need emcc js opts to be decently fast
  EMCC_ARGS="$EMCC_ARGS --llvm-opts 0 --llvm-lto 0"
  EMCC_ARGS="$EMCC_ARGS -profiling"
  OUT_FILE_SUFFIX=-g
else
  EMCC_ARGS="$EMCC_ARGS -Oz"
  EMCC_ARGS="$EMCC_ARGS --llvm-lto 1"
  #EMCC_ARGS="$EMCC_ARGS -s ELIMINATE_DUPLICATE_FUNCTIONS=1"
  # Why these settings?
  # See https://gist.github.com/rsms/e33c61a25a31c08260161a087be03169
fi


echo "building wasm.js"

0 && "$EMSCRIPTEN/em++" \
  $EMCC_ARGS \
  src/wasm-js.cpp \
  src/ast/ExpressionAnalyzer.cpp \
  src/ast/ExpressionManipulator.cpp \
  src/passes/pass.cpp \
  src/passes/DeadCodeElimination.cpp \
  src/passes/Print.cpp \
  src/passes/LegalizeJSInterface.cpp \
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
  src/wasm/wasm-s-parser.cpp \
  src/wasm/wasm-binary.cpp \
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

0 && "$EMSCRIPTEN/em++" \
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
  src/passes/Inlining.cpp \
  src/passes/LegalizeJSInterface.cpp \
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
  src/wasm/wasm-binary.cpp \
  -o binaryen.bc \
  -Isrc/

echo "building binaryen.js to js"

"$EMSCRIPTEN/em++" \
  $EMCC_ARGS \
  binaryen.bc \
  -s 'EXPORTED_FUNCTIONS=["BinaryenNone", "BinaryenInt32", "BinaryenInt64", "BinaryenFloat32", "BinaryenFloat64", "BinaryenModuleCreate", "BinaryenModuleDispose", "BinaryenAddFunctionType", "BinaryenLiteralInt32", "BinaryenLiteralInt64", "BinaryenLiteralFloat32", "BinaryenLiteralFloat64", "BinaryenLiteralFloat32Bits", "BinaryenLiteralFloat64Bits", "BinaryenClzInt32", "BinaryenCtzInt32", "BinaryenPopcntInt32", "BinaryenNegFloat32", "BinaryenAbsFloat32", "BinaryenCeilFloat32", "BinaryenFloorFloat32", "BinaryenTruncFloat32", "BinaryenNearestFloat32", "BinaryenSqrtFloat32", "BinaryenEqZInt32", "BinaryenClzInt64", "BinaryenCtzInt64", "BinaryenPopcntInt64", "BinaryenNegFloat64", "BinaryenAbsFloat64", "BinaryenCeilFloat64", "BinaryenFloorFloat64", "BinaryenTruncFloat64", "BinaryenNearestFloat64", "BinaryenSqrtFloat64", "BinaryenEqZInt64", "BinaryenExtendSInt32", "BinaryenExtentUInt32", "BinaryenWrapInt64", "BinaryenTruncSFloat32ToInt32", "BinaryenTruncSFloat32ToInt64", "BinaryenTruncUFloat32ToInt32", "BinaryenTruncUFloat32ToInt64", "BinaryenTruncSFloat64ToInt32", "BinaryenTruncSFloat64ToInt64", "BinaryenTruncUFloat64ToInt32", "BinaryenTruncUFloat64ToInt64", "BinaryenReinterpretFloat32", "BinaryenReinterpretFloat64", "BinaryenConvertSInt32ToFloat32", "BinaryenConvertSInt32ToFloat64", "BinaryenConvertUInt32ToFloat32", "BinaryenConvertUInt32ToFloat64", "BinaryenConvertSInt64ToFloat32", "BinaryenConvertSInt64ToFloat64", "BinaryenConvertUInt64ToFloat32", "BinaryenConvertUInt64ToFloat64", "BinaryenPromoteFloat32", "BinaryenDemoteFloat64", "BinaryenReinterpretInt32", "BinaryenReinterpretInt64", "BinaryenAddInt32", "BinaryenSubInt32", "BinaryenMulInt32", "BinaryenDivSInt32", "BinaryenDivUInt32", "BinaryenRemSInt32", "BinaryenRemUInt32", "BinaryenAndInt32", "BinaryenOrInt32", "BinaryenXorInt32", "BinaryenShlInt32", "BinaryenShrUInt32", "BinaryenShrSInt32", "BinaryenRotLInt32", "BinaryenRotRInt32", "BinaryenEqInt32", "BinaryenNeInt32", "BinaryenLtSInt32", "BinaryenLtUInt32", "BinaryenLeSInt32", "BinaryenLeUInt32", "BinaryenGtSInt32", "BinaryenGtUInt32", "BinaryenGeSInt32", "BinaryenGeUInt32", "BinaryenAddInt64", "BinaryenSubInt64", "BinaryenMulInt64", "BinaryenDivSInt64", "BinaryenDivUInt64", "BinaryenRemSInt64", "BinaryenRemUInt64", "BinaryenAndInt64", "BinaryenOrInt64", "BinaryenXorInt64", "BinaryenShlInt64", "BinaryenShrUInt64", "BinaryenShrSInt64", "BinaryenRotLInt64", "BinaryenRotRInt64", "BinaryenEqInt64", "BinaryenNeInt64", "BinaryenLtSInt64", "BinaryenLtUInt64", "BinaryenLeSInt64", "BinaryenLeUInt64", "BinaryenGtSInt64", "BinaryenGtUInt64", "BinaryenGeSInt64", "BinaryenGeUInt64", "BinaryenAddFloat32", "BinaryenSubFloat32", "BinaryenMulFloat32", "BinaryenDivFloat32", "BinaryenCopySignFloat32", "BinaryenMinFloat32", "BinaryenMaxFloat32", "BinaryenEqFloat32", "BinaryenNeFloat32", "BinaryenLtFloat32", "BinaryenLeFloat32", "BinaryenGtFloat32", "BinaryenGeFloat32", "BinaryenAddFloat64", "BinaryenSubFloat64", "BinaryenMulFloat64", "BinaryenDivFloat64", "BinaryenCopySignFloat64", "BinaryenMinFloat64", "BinaryenMaxFloat64", "BinaryenEqFloat64", "BinaryenNeFloat64", "BinaryenLtFloat64", "BinaryenLeFloat64", "BinaryenGtFloat64", "BinaryenGeFloat64", "BinaryenPageSize", "BinaryenCurrentMemory", "BinaryenGrowMemory", "BinaryenHasFeature", "BinaryenBlock", "BinaryenIf", "BinaryenLoop", "BinaryenBreak", "BinaryenSwitch", "BinaryenCall", "BinaryenCallImport", "BinaryenCallIndirect", "BinaryenGetLocal", "BinaryenSetLocal", "BinaryenTeeLocal", "BinaryenLoad", "BinaryenStore", "BinaryenConst", "BinaryenUnary", "BinaryenBinary", "BinaryenSelect", "BinaryenDrop", "BinaryenReturn", "BinaryenHost", "BinaryenNop", "BinaryenUnreachable", "BinaryenExpressionPrint", "BinaryenAddFunction", "BinaryenAddImport", "BinaryenAddExport", "BinaryenSetFunctionTable", "BinaryenSetMemory", "BinaryenSetStart", "BinaryenModulePrint", "BinaryenModuleValidate", "BinaryenModuleOptimize", "BinaryenModuleAutoDrop", "BinaryenModuleWrite", "BinaryenModuleRead", "BinaryenModuleInterpret", "RelooperCreate", "RelooperAddBlock", "RelooperAddBranch", "RelooperAddBlockWithSwitch", "RelooperAddBranchForSwitch", "RelooperRenderAndDispose", "BinaryenSetAPITracing"]' \
  -o bin/binaryen${OUT_FILE_SUFFIX}.js \
  --memory-init-file 0 \
  --pre-js src/js/binaryen.js-pre.js \
  --post-js src/js/binaryen.js-post.js
