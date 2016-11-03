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
  EMCC_ARGS="$EMCC_ARGS -s ELIMINATE_DUPLICATE_FUNCTIONS=1"
  # Why these settings?
  # See https://gist.github.com/rsms/e33c61a25a31c08260161a087be03169
fi


echo "building wasm.js"

"$EMSCRIPTEN/em++" \
  $EMCC_ARGS \
  src/wasm-js.cpp \
  src/passes/pass.cpp \
  src/passes/Print.cpp \
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

echo "building binaryen.js"

if [ "$1" != "-g" ]; then
  EMCC_ARGS="$EMCC_ARGS --closure 1"
fi

python "$EMSCRIPTEN/tools/webidl_binder.py" src/js/binaryen.idl glue

"$EMSCRIPTEN/em++" \
  $EMCC_ARGS \
  -std=c++11 \
  src/binaryen-js.cpp \
  src/passes/pass.cpp \
  src/passes/MergeBlocks.cpp \
  src/passes/Print.cpp \
  src/passes/RemoveUnusedBrs.cpp \
  src/passes/RemoveUnusedNames.cpp \
  src/passes/PostEmscripten.cpp \
  src/passes/SimplifyLocals.cpp \
  src/passes/ReorderLocals.cpp \
  src/passes/Vacuum.cpp \
  src/passes/DuplicateFunctionElimination.cpp \
  src/passes/CoalesceLocals.cpp \
  src/emscripten-optimizer/parser.cpp \
  src/emscripten-optimizer/simple_ast.cpp \
  src/emscripten-optimizer/optimizer-shared.cpp \
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
  -o bin/binaryen${OUT_FILE_SUFFIX}.js \
  -s 'EXPORT_NAME="Binaryen"' \
  --memory-init-file 0 \
  -s INVOKE_RUN=0 \
  --pre-js src/js/binaryen.js-pre.js \
  --post-js glue.js \
  --post-js src/js/binaryen.js-extended.js \
  --post-js src/js/binaryen.js-post.js
