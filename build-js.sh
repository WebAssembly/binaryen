#!/bin/bash
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

EMCC_ARGS="-std=gnu++17 --memory-init-file 0"
EMCC_ARGS="$EMCC_ARGS -s ALLOW_MEMORY_GROWTH=1"
EMCC_ARGS="$EMCC_ARGS -s DEMANGLE_SUPPORT=1"
EMCC_ARGS="$EMCC_ARGS -s NO_FILESYSTEM=0"
EMCC_ARGS="$EMCC_ARGS -s WASM=0"
EMCC_ARGS="$EMCC_ARGS -s BINARYEN_ASYNC_COMPILATION=0"
EMCC_ARGS="$EMCC_ARGS -s DISABLE_EXCEPTION_CATCHING=0" # Exceptions are thrown and caught when optimizing endless loops

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

python3 $BINARYEN_SCRIPTS/embedwast.py $BINARYEN_SRC/passes/wasm-intrinsics.wast $BINARYEN_SRC/passes/WasmIntrinsics.cpp

echo "compiling source files"

# internal source files or directories to exclude
EXCLUDE=(
  "$BINARYEN_SRC/support/archive.cpp"
  "$BINARYEN_SRC/support/command-line.cpp"
  "$BINARYEN_SRC/support/path.cpp"
  "$BINARYEN_SRC/tools/"
)

# external source files to include
INCLUDE=()

mapfile -t SOURCES < <(find $BINARYEN_SRC -name "*.cpp")
for i in ${!SOURCES[@]}; do
  for j in ${!EXCLUDE[@]}; do
    if [[ "${SOURCES[$i]}" == "${EXCLUDE[$j]}"* ]]; then
      continue 2
    fi
  done
  INCLUDE+=("${SOURCES[$i]}")
  echo "  ${SOURCES[$i]}"
done

mkdir -p "${OUT}"
"$EMSCRIPTEN/em++" \
  $EMCC_ARGS \
  ${INCLUDE[@]} \
  -I"$BINARYEN_SRC" \
  -o "${OUT}/shared.o"

echo "building binaryen.js"

"$EMSCRIPTEN/em++" \
  $EMCC_ARGS \
  "$BINARYEN_SRC/binaryen-c.cpp" \
  "$OUT/shared.o" \
  -I"$BINARYEN_SRC" \
  -o "$OUT/binaryen.js" \
  -s MODULARIZE_INSTANCE=1 \
  -s 'EXPORT_NAME="Binaryen"' \
  --post-js "$BINARYEN_SRC/js/binaryen.js-post.js"

echo "done: $OUT/binaryen.js"
