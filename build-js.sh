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
  echo "If EMSCRIPTEN is set in the environment, emscripten will be loaded"
  echo "from that directory. Otherwise the location of emscripten is resolved"
  echo "through PATH."
  exit 1
fi

if [ -z "$EMSCRIPTEN" ]; then
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

EMCC_ARGS="-std=gnu++14 --memory-init-file 0"
EMCC_ARGS="$EMCC_ARGS -s ALLOW_MEMORY_GROWTH=1"
EMCC_ARGS="$EMCC_ARGS -s DEMANGLE_SUPPORT=1"
EMCC_ARGS="$EMCC_ARGS -s NO_FILESYSTEM=0"
EMCC_ARGS="$EMCC_ARGS -s WASM=0"
EMCC_ARGS="$EMCC_ARGS -s BINARYEN_ASYNC_COMPILATION=0"
EMCC_ARGS="$EMCC_ARGS -s DISABLE_EXCEPTION_CATCHING=0" # Exceptions are thrown and caught when optimizing endless loops
OUT_FILE_SUFFIX=

if [ "$1" == "-g" ]; then
  EMCC_ARGS="$EMCC_ARGS -O2" # need emcc js opts to be decently fast
  EMCC_ARGS="$EMCC_ARGS --llvm-opts 0 --llvm-lto 0"
  EMCC_ARGS="$EMCC_ARGS -profiling"
  EMCC_ARGS="$EMCC_ARGS -s ASSERTIONS=0" # 0 as a temporary workaround for https://github.com/emscripten-core/emscripten/pull/9360
else
  EMCC_ARGS="$EMCC_ARGS -Oz"
  EMCC_ARGS="$EMCC_ARGS --llvm-lto 1"
  EMCC_ARGS="$EMCC_ARGS -s ELIMINATE_DUPLICATE_FUNCTIONS=1"
  EMCC_ARGS="$EMCC_ARGS --closure 1"
  # Why these settings?
  # See https://gist.github.com/rsms/e33c61a25a31c08260161a087be03169
fi

# input sources relative to this script
BINARYEN_SRC="$(dirname $0)/src"

# input sources relative to this script
BINARYEN_SCRIPTS="$(dirname $0)/scripts"

# output binaries relative to current working directory
OUT="$PWD/out"

echo "generate embedded intrinsics module"

python3 "$BINARYEN_SCRIPTS/embedwast.py" "$BINARYEN_SRC/passes/wasm-intrinsics.wast" "$BINARYEN_SRC/passes/WasmIntrinsics.cpp"

echo "compiling source files"

mkdir -p $OUT
"$EMSCRIPTEN/em++" \
  $EMCC_ARGS \
  "$BINARYEN_SRC/asmjs/asm_v_wasm.cpp" \
  "$BINARYEN_SRC/asmjs/asmangle.cpp" \
  "$BINARYEN_SRC/asmjs/shared-constants.cpp" \
  "$BINARYEN_SRC/cfg/Relooper.cpp" \
  "$BINARYEN_SRC/emscripten-optimizer/optimizer-shared.cpp" \
  "$BINARYEN_SRC/emscripten-optimizer/parser.cpp" \
  "$BINARYEN_SRC/emscripten-optimizer/simple_ast.cpp" \
  "$BINARYEN_SRC/ir/ExpressionAnalyzer.cpp" \
  "$BINARYEN_SRC/ir/ExpressionManipulator.cpp" \
  "$BINARYEN_SRC/ir/LocalGraph.cpp" \
  "$BINARYEN_SRC/ir/ReFinalize.cpp" \
  "$BINARYEN_SRC/passes/pass.cpp" \
  "$BINARYEN_SRC/passes/AlignmentLowering.cpp" \
  "$BINARYEN_SRC/passes/Asyncify.cpp" \
  "$BINARYEN_SRC/passes/AvoidReinterprets.cpp" \
  "$BINARYEN_SRC/passes/CoalesceLocals.cpp" \
  "$BINARYEN_SRC/passes/DeadArgumentElimination.cpp" \
  "$BINARYEN_SRC/passes/CodeFolding.cpp" \
  "$BINARYEN_SRC/passes/CodePushing.cpp" \
  "$BINARYEN_SRC/passes/ConstHoisting.cpp" \
  "$BINARYEN_SRC/passes/DataFlowOpts.cpp" \
  "$BINARYEN_SRC/passes/DeadCodeElimination.cpp" \
  "$BINARYEN_SRC/passes/Directize.cpp" \
  "$BINARYEN_SRC/passes/DuplicateImportElimination.cpp" \
  "$BINARYEN_SRC/passes/DuplicateFunctionElimination.cpp" \
  "$BINARYEN_SRC/passes/ExtractFunction.cpp" \
  "$BINARYEN_SRC/passes/Flatten.cpp" \
  "$BINARYEN_SRC/passes/FuncCastEmulation.cpp" \
  "$BINARYEN_SRC/passes/I64ToI32Lowering.cpp" \
  "$BINARYEN_SRC/passes/Inlining.cpp" \
  "$BINARYEN_SRC/passes/InstrumentLocals.cpp" \
  "$BINARYEN_SRC/passes/InstrumentMemory.cpp" \
  "$BINARYEN_SRC/passes/LegalizeJSInterface.cpp" \
  "$BINARYEN_SRC/passes/LimitSegments.cpp" \
  "$BINARYEN_SRC/passes/LocalCSE.cpp" \
  "$BINARYEN_SRC/passes/LogExecution.cpp" \
  "$BINARYEN_SRC/passes/LoopInvariantCodeMotion.cpp" \
  "$BINARYEN_SRC/passes/MemoryPacking.cpp" \
  "$BINARYEN_SRC/passes/MergeBlocks.cpp" \
  "$BINARYEN_SRC/passes/MergeLocals.cpp" \
  "$BINARYEN_SRC/passes/Metrics.cpp" \
  "$BINARYEN_SRC/passes/MinifyImportsAndExports.cpp" \
  "$BINARYEN_SRC/passes/NameList.cpp" \
  "$BINARYEN_SRC/passes/NoExitRuntime.cpp" \
  "$BINARYEN_SRC/passes/OptimizeAddedConstants.cpp" \
  "$BINARYEN_SRC/passes/OptimizeInstructions.cpp" \
  "$BINARYEN_SRC/passes/PickLoadSigns.cpp" \
  "$BINARYEN_SRC/passes/PostEmscripten.cpp" \
  "$BINARYEN_SRC/passes/Precompute.cpp" \
  "$BINARYEN_SRC/passes/Print.cpp" \
  "$BINARYEN_SRC/passes/PrintFeatures.cpp" \
  "$BINARYEN_SRC/passes/PrintFunctionMap.cpp" \
  "$BINARYEN_SRC/passes/PrintCallGraph.cpp" \
  "$BINARYEN_SRC/passes/RedundantSetElimination.cpp" \
  "$BINARYEN_SRC/passes/RelooperJumpThreading.cpp" \
  "$BINARYEN_SRC/passes/RemoveNonJSOps.cpp" \
  "$BINARYEN_SRC/passes/RemoveImports.cpp" \
  "$BINARYEN_SRC/passes/RemoveMemory.cpp" \
  "$BINARYEN_SRC/passes/RemoveUnusedBrs.cpp" \
  "$BINARYEN_SRC/passes/RemoveUnusedModuleElements.cpp" \
  "$BINARYEN_SRC/passes/RemoveUnusedNames.cpp" \
  "$BINARYEN_SRC/passes/ReorderFunctions.cpp" \
  "$BINARYEN_SRC/passes/ReorderLocals.cpp" \
  "$BINARYEN_SRC/passes/ReReloop.cpp" \
  "$BINARYEN_SRC/passes/SafeHeap.cpp" \
  "$BINARYEN_SRC/passes/SimplifyGlobals.cpp" \
  "$BINARYEN_SRC/passes/SimplifyLocals.cpp" \
  "$BINARYEN_SRC/passes/Souperify.cpp" \
  "$BINARYEN_SRC/passes/SpillPointers.cpp" \
  "$BINARYEN_SRC/passes/SSAify.cpp" \
  "$BINARYEN_SRC/passes/StackIR.cpp" \
  "$BINARYEN_SRC/passes/Strip.cpp" \
  "$BINARYEN_SRC/passes/StripTargetFeatures.cpp" \
  "$BINARYEN_SRC/passes/TrapMode.cpp" \
  "$BINARYEN_SRC/passes/Untee.cpp" \
  "$BINARYEN_SRC/passes/Vacuum.cpp" \
  "$BINARYEN_SRC/passes/WasmIntrinsics.cpp" \
  "$BINARYEN_SRC/support/bits.cpp" \
  "$BINARYEN_SRC/support/colors.cpp" \
  "$BINARYEN_SRC/support/file.cpp" \
  "$BINARYEN_SRC/support/safe_integer.cpp" \
  "$BINARYEN_SRC/support/threads.cpp" \
  "$BINARYEN_SRC/wasm/literal.cpp" \
  "$BINARYEN_SRC/wasm/wasm-binary.cpp" \
  "$BINARYEN_SRC/wasm/wasm-emscripten.cpp" \
  "$BINARYEN_SRC/wasm/wasm-interpreter.cpp" \
  "$BINARYEN_SRC/wasm/wasm-io.cpp" \
  "$BINARYEN_SRC/wasm/wasm-s-parser.cpp" \
  "$BINARYEN_SRC/wasm/wasm-stack.cpp" \
  "$BINARYEN_SRC/wasm/wasm-type.cpp" \
  "$BINARYEN_SRC/wasm/wasm-validator.cpp" \
  "$BINARYEN_SRC/wasm/wasm.cpp" \
  -I"$BINARYEN_SRC" \
  -o "$OUT/shared.o"

echo "building binaryen.js"

"$EMSCRIPTEN/em++" \
  $EMCC_ARGS \
  "$BINARYEN_SRC/binaryen-c.cpp" \
  "$OUT/shared.o" \
  -I"$BINARYEN_SRC/" \
  -o "$OUT/binaryen$OUT_FILE_SUFFIX.js" \
  -s MODULARIZE_INSTANCE=1 \
  -s 'EXPORT_NAME="Binaryen"' \
  --post-js "$BINARYEN_SRC/js/binaryen.js-post.js"
