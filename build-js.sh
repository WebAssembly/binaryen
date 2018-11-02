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

EMCC_ARGS="-std=c++11 --memory-init-file 0"
EMCC_ARGS="$EMCC_ARGS -s ALLOW_MEMORY_GROWTH=1"
EMCC_ARGS="$EMCC_ARGS -s DEMANGLE_SUPPORT=1"
EMCC_ARGS="$EMCC_ARGS -s NO_FILESYSTEM=1"
EMCC_ARGS="$EMCC_ARGS -s WASM=0"
EMCC_ARGS="$EMCC_ARGS -s ERROR_ON_UNDEFINED_SYMBOLS=1"
# TODO: enable this (need nearbyint in emscripten tag) EMCC_ARGS="$EMCC_ARGS -s ERROR_ON_UNDEFINED_SYMBOLS=1"
EMCC_ARGS="$EMCC_ARGS -s DISABLE_EXCEPTION_CATCHING=0" # Exceptions are thrown and caught when optimizing endless loops
OUT_FILE_SUFFIX=

if [ "$1" == "-g" ]; then
  EMCC_ARGS="$EMCC_ARGS -O2" # need emcc js opts to be decently fast
  EMCC_ARGS="$EMCC_ARGS --llvm-opts 0 --llvm-lto 0"
  EMCC_ARGS="$EMCC_ARGS -profiling"
  EMCC_ARGS="$EMCC_ARGS -s ASSERTIONS=1"
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
BINARYEN_BIN="$PWD/bin"

echo "generate embedded intrinsics module"

python $BINARYEN_SCRIPTS/embedwast.py $BINARYEN_SRC/passes/wasm-intrinsics.wast $BINARYEN_SRC/passes/WasmIntrinsics.cpp

echo "building shared bitcode"

"$EMSCRIPTEN/em++" \
  $EMCC_ARGS \
  $BINARYEN_SRC/asmjs/asm_v_wasm.cpp \
  $BINARYEN_SRC/asmjs/asmangle.cpp \
  $BINARYEN_SRC/asmjs/shared-constants.cpp \
  $BINARYEN_SRC/cfg/Relooper.cpp \
  $BINARYEN_SRC/emscripten-optimizer/optimizer-shared.cpp \
  $BINARYEN_SRC/emscripten-optimizer/parser.cpp \
  $BINARYEN_SRC/emscripten-optimizer/simple_ast.cpp \
  $BINARYEN_SRC/ir/ExpressionAnalyzer.cpp \
  $BINARYEN_SRC/ir/ExpressionManipulator.cpp \
  $BINARYEN_SRC/ir/LocalGraph.cpp \
  $BINARYEN_SRC/passes/pass.cpp \
  $BINARYEN_SRC/passes/CoalesceLocals.cpp \
  $BINARYEN_SRC/passes/DeadArgumentElimination.cpp \
  $BINARYEN_SRC/passes/CodeFolding.cpp \
  $BINARYEN_SRC/passes/CodePushing.cpp \
  $BINARYEN_SRC/passes/ConstHoisting.cpp \
  $BINARYEN_SRC/passes/DataFlowOpts.cpp \
  $BINARYEN_SRC/passes/DeadCodeElimination.cpp \
  $BINARYEN_SRC/passes/DuplicateFunctionElimination.cpp \
  $BINARYEN_SRC/passes/ExtractFunction.cpp \
  $BINARYEN_SRC/passes/Flatten.cpp \
  $BINARYEN_SRC/passes/FuncCastEmulation.cpp \
  $BINARYEN_SRC/passes/I64ToI32Lowering.cpp \
  $BINARYEN_SRC/passes/Inlining.cpp \
  $BINARYEN_SRC/passes/InstrumentLocals.cpp \
  $BINARYEN_SRC/passes/InstrumentMemory.cpp \
  $BINARYEN_SRC/passes/LegalizeJSInterface.cpp \
  $BINARYEN_SRC/passes/LocalCSE.cpp \
  $BINARYEN_SRC/passes/LogExecution.cpp \
  $BINARYEN_SRC/passes/LoopInvariantCodeMotion.cpp \
  $BINARYEN_SRC/passes/MemoryPacking.cpp \
  $BINARYEN_SRC/passes/MergeBlocks.cpp \
  $BINARYEN_SRC/passes/MergeLocals.cpp \
  $BINARYEN_SRC/passes/Metrics.cpp \
  $BINARYEN_SRC/passes/MinifyImportsAndExports.cpp \
  $BINARYEN_SRC/passes/NameList.cpp \
  $BINARYEN_SRC/passes/OptimizeInstructions.cpp \
  $BINARYEN_SRC/passes/PickLoadSigns.cpp \
  $BINARYEN_SRC/passes/PostEmscripten.cpp \
  $BINARYEN_SRC/passes/Precompute.cpp \
  $BINARYEN_SRC/passes/Print.cpp \
  $BINARYEN_SRC/passes/PrintCallGraph.cpp \
  $BINARYEN_SRC/passes/RedundantSetElimination.cpp \
  $BINARYEN_SRC/passes/RelooperJumpThreading.cpp \
  $BINARYEN_SRC/passes/RemoveNonJSOps.cpp \
  $BINARYEN_SRC/passes/RemoveImports.cpp \
  $BINARYEN_SRC/passes/RemoveMemory.cpp \
  $BINARYEN_SRC/passes/RemoveUnusedBrs.cpp \
  $BINARYEN_SRC/passes/RemoveUnusedModuleElements.cpp \
  $BINARYEN_SRC/passes/RemoveUnusedNames.cpp \
  $BINARYEN_SRC/passes/ReorderFunctions.cpp \
  $BINARYEN_SRC/passes/ReorderLocals.cpp \
  $BINARYEN_SRC/passes/ReReloop.cpp \
  $BINARYEN_SRC/passes/SafeHeap.cpp \
  $BINARYEN_SRC/passes/SimplifyLocals.cpp \
  $BINARYEN_SRC/passes/Souperify.cpp \
  $BINARYEN_SRC/passes/SpillPointers.cpp \
  $BINARYEN_SRC/passes/SSAify.cpp \
  $BINARYEN_SRC/passes/StackIR.cpp \
  $BINARYEN_SRC/passes/TrapMode.cpp \
  $BINARYEN_SRC/passes/Untee.cpp \
  $BINARYEN_SRC/passes/Vacuum.cpp \
  $BINARYEN_SRC/passes/WasmIntrinsics.cpp \
  $BINARYEN_SRC/support/bits.cpp \
  $BINARYEN_SRC/support/colors.cpp \
  $BINARYEN_SRC/support/file.cpp \
  $BINARYEN_SRC/support/safe_integer.cpp \
  $BINARYEN_SRC/support/threads.cpp \
  $BINARYEN_SRC/wasm/literal.cpp \
  $BINARYEN_SRC/wasm/wasm-binary.cpp \
  $BINARYEN_SRC/wasm/wasm-emscripten.cpp \
  $BINARYEN_SRC/wasm/wasm-interpreter.cpp \
  $BINARYEN_SRC/wasm/wasm-io.cpp \
  $BINARYEN_SRC/wasm/wasm-s-parser.cpp \
  $BINARYEN_SRC/wasm/wasm-type.cpp \
  $BINARYEN_SRC/wasm/wasm-validator.cpp \
  $BINARYEN_SRC/wasm/wasm.cpp \
  -I$BINARYEN_SRC \
  -o shared.bc

echo "building wasm.js"

"$EMSCRIPTEN/em++" \
  $EMCC_ARGS \
  $BINARYEN_SRC/wasm-js.cpp \
  shared.bc \
  -I$BINARYEN_SRC/ \
  -o $BINARYEN_BIN/wasm${OUT_FILE_SUFFIX}.js \
  -s MODULARIZE=1 \
  -s 'EXTRA_EXPORTED_RUNTIME_METHODS=["writeAsciiToMemory"]' \
  -s 'EXPORT_NAME="WasmJS"'

echo "building binaryen.js"

function export_function { if [ -z ${EXPORTED_FUNCTIONS} ]; then EXPORTED_FUNCTIONS='"'$1'"'; else EXPORTED_FUNCTIONS=${EXPORTED_FUNCTIONS}',"'$1'"'; fi }

# Types
export_function "_BinaryenTypeNone"
export_function "_BinaryenTypeInt32"
export_function "_BinaryenTypeInt64"
export_function "_BinaryenTypeFloat32"
export_function "_BinaryenTypeFloat64"
export_function "_BinaryenTypeUnreachable"
export_function "_BinaryenTypeAuto"

# Expression ids
export_function "_BinaryenInvalidId"
export_function "_BinaryenBlockId"
export_function "_BinaryenIfId"
export_function "_BinaryenLoopId"
export_function "_BinaryenBreakId"
export_function "_BinaryenSwitchId"
export_function "_BinaryenCallId"
export_function "_BinaryenCallIndirectId"
export_function "_BinaryenGetLocalId"
export_function "_BinaryenSetLocalId"
export_function "_BinaryenGetGlobalId"
export_function "_BinaryenSetGlobalId"
export_function "_BinaryenLoadId"
export_function "_BinaryenStoreId"
export_function "_BinaryenConstId"
export_function "_BinaryenUnaryId"
export_function "_BinaryenBinaryId"
export_function "_BinaryenSelectId"
export_function "_BinaryenDropId"
export_function "_BinaryenReturnId"
export_function "_BinaryenHostId"
export_function "_BinaryenNopId"
export_function "_BinaryenUnreachableId"
export_function "_BinaryenAtomicCmpxchgId"
export_function "_BinaryenAtomicRMWId"
export_function "_BinaryenAtomicWaitId"
export_function "_BinaryenAtomicWakeId"

# External kinds
export_function "_BinaryenExternalFunction"
export_function "_BinaryenExternalTable"
export_function "_BinaryenExternalMemory"
export_function "_BinaryenExternalGlobal"

# Literals
export_function "_BinaryenLiteralInt32"
export_function "_BinaryenLiteralInt64"
export_function "_BinaryenLiteralFloat32"
export_function "_BinaryenLiteralFloat64"
export_function "_BinaryenLiteralFloat32Bits"
export_function "_BinaryenLiteralFloat64Bits"

# Operations
export_function "_BinaryenClzInt32"
export_function "_BinaryenCtzInt32"
export_function "_BinaryenPopcntInt32"
export_function "_BinaryenNegFloat32"
export_function "_BinaryenAbsFloat32"
export_function "_BinaryenCeilFloat32"
export_function "_BinaryenFloorFloat32"
export_function "_BinaryenTruncFloat32"
export_function "_BinaryenNearestFloat32"
export_function "_BinaryenSqrtFloat32"
export_function "_BinaryenEqZInt32"
export_function "_BinaryenClzInt64"
export_function "_BinaryenCtzInt64"
export_function "_BinaryenPopcntInt64"
export_function "_BinaryenNegFloat64"
export_function "_BinaryenAbsFloat64"
export_function "_BinaryenCeilFloat64"
export_function "_BinaryenFloorFloat64"
export_function "_BinaryenTruncFloat64"
export_function "_BinaryenNearestFloat64"
export_function "_BinaryenSqrtFloat64"
export_function "_BinaryenEqZInt64"
export_function "_BinaryenExtendSInt32"
export_function "_BinaryenExtendUInt32"
export_function "_BinaryenWrapInt64"
export_function "_BinaryenTruncSFloat32ToInt32"
export_function "_BinaryenTruncSFloat32ToInt64"
export_function "_BinaryenTruncUFloat32ToInt32"
export_function "_BinaryenTruncUFloat32ToInt64"
export_function "_BinaryenTruncSFloat64ToInt32"
export_function "_BinaryenTruncSFloat64ToInt64"
export_function "_BinaryenTruncUFloat64ToInt32"
export_function "_BinaryenTruncUFloat64ToInt64"
export_function "_BinaryenReinterpretFloat32"
export_function "_BinaryenReinterpretFloat64"
export_function "_BinaryenConvertSInt32ToFloat32"
export_function "_BinaryenConvertSInt32ToFloat64"
export_function "_BinaryenConvertUInt32ToFloat32"
export_function "_BinaryenConvertUInt32ToFloat64"
export_function "_BinaryenConvertSInt64ToFloat32"
export_function "_BinaryenConvertSInt64ToFloat64"
export_function "_BinaryenConvertUInt64ToFloat32"
export_function "_BinaryenConvertUInt64ToFloat64"
export_function "_BinaryenPromoteFloat32"
export_function "_BinaryenDemoteFloat64"
export_function "_BinaryenReinterpretInt32"
export_function "_BinaryenReinterpretInt64"
export_function "_BinaryenExtendS8Int32"
export_function "_BinaryenExtendS16Int32"
export_function "_BinaryenExtendS8Int64"
export_function "_BinaryenExtendS16Int64"
export_function "_BinaryenExtendS32Int64"
export_function "_BinaryenAddInt32"
export_function "_BinaryenSubInt32"
export_function "_BinaryenMulInt32"
export_function "_BinaryenDivSInt32"
export_function "_BinaryenDivUInt32"
export_function "_BinaryenRemSInt32"
export_function "_BinaryenRemUInt32"
export_function "_BinaryenAndInt32"
export_function "_BinaryenOrInt32"
export_function "_BinaryenXorInt32"
export_function "_BinaryenShlInt32"
export_function "_BinaryenShrUInt32"
export_function "_BinaryenShrSInt32"
export_function "_BinaryenRotLInt32"
export_function "_BinaryenRotRInt32"
export_function "_BinaryenEqInt32"
export_function "_BinaryenNeInt32"
export_function "_BinaryenLtSInt32"
export_function "_BinaryenLtUInt32"
export_function "_BinaryenLeSInt32"
export_function "_BinaryenLeUInt32"
export_function "_BinaryenGtSInt32"
export_function "_BinaryenGtUInt32"
export_function "_BinaryenGeSInt32"
export_function "_BinaryenGeUInt32"
export_function "_BinaryenAddInt64"
export_function "_BinaryenSubInt64"
export_function "_BinaryenMulInt64"
export_function "_BinaryenDivSInt64"
export_function "_BinaryenDivUInt64"
export_function "_BinaryenRemSInt64"
export_function "_BinaryenRemUInt64"
export_function "_BinaryenAndInt64"
export_function "_BinaryenOrInt64"
export_function "_BinaryenXorInt64"
export_function "_BinaryenShlInt64"
export_function "_BinaryenShrUInt64"
export_function "_BinaryenShrSInt64"
export_function "_BinaryenRotLInt64"
export_function "_BinaryenRotRInt64"
export_function "_BinaryenEqInt64"
export_function "_BinaryenNeInt64"
export_function "_BinaryenLtSInt64"
export_function "_BinaryenLtUInt64"
export_function "_BinaryenLeSInt64"
export_function "_BinaryenLeUInt64"
export_function "_BinaryenGtSInt64"
export_function "_BinaryenGtUInt64"
export_function "_BinaryenGeSInt64"
export_function "_BinaryenGeUInt64"
export_function "_BinaryenAddFloat32"
export_function "_BinaryenSubFloat32"
export_function "_BinaryenMulFloat32"
export_function "_BinaryenDivFloat32"
export_function "_BinaryenCopySignFloat32"
export_function "_BinaryenMinFloat32"
export_function "_BinaryenMaxFloat32"
export_function "_BinaryenEqFloat32"
export_function "_BinaryenNeFloat32"
export_function "_BinaryenLtFloat32"
export_function "_BinaryenLeFloat32"
export_function "_BinaryenGtFloat32"
export_function "_BinaryenGeFloat32"
export_function "_BinaryenAddFloat64"
export_function "_BinaryenSubFloat64"
export_function "_BinaryenMulFloat64"
export_function "_BinaryenDivFloat64"
export_function "_BinaryenCopySignFloat64"
export_function "_BinaryenMinFloat64"
export_function "_BinaryenMaxFloat64"
export_function "_BinaryenEqFloat64"
export_function "_BinaryenNeFloat64"
export_function "_BinaryenLtFloat64"
export_function "_BinaryenLeFloat64"
export_function "_BinaryenGtFloat64"
export_function "_BinaryenGeFloat64"
export_function "_BinaryenCurrentMemory"
export_function "_BinaryenGrowMemory"
export_function "_BinaryenAtomicRMWAdd"
export_function "_BinaryenAtomicRMWSub"
export_function "_BinaryenAtomicRMWAnd"
export_function "_BinaryenAtomicRMWOr"
export_function "_BinaryenAtomicRMWXor"
export_function "_BinaryenAtomicRMWXchg"

# Expression creation
export_function "_BinaryenBlock"
export_function "_BinaryenIf"
export_function "_BinaryenLoop"
export_function "_BinaryenBreak"
export_function "_BinaryenSwitch"
export_function "_BinaryenCall"
export_function "_BinaryenCallIndirect"
export_function "_BinaryenGetLocal"
export_function "_BinaryenSetLocal"
export_function "_BinaryenTeeLocal"
export_function "_BinaryenGetGlobal"
export_function "_BinaryenSetGlobal"
export_function "_BinaryenLoad"
export_function "_BinaryenStore"
export_function "_BinaryenConst"
export_function "_BinaryenUnary"
export_function "_BinaryenBinary"
export_function "_BinaryenSelect"
export_function "_BinaryenDrop"
export_function "_BinaryenReturn"
export_function "_BinaryenHost"
export_function "_BinaryenNop"
export_function "_BinaryenUnreachable"
export_function "_BinaryenAtomicLoad"
export_function "_BinaryenAtomicStore"
export_function "_BinaryenAtomicRMW"
export_function "_BinaryenAtomicCmpxchg"
export_function "_BinaryenAtomicWait"
export_function "_BinaryenAtomicWake"

# 'Expression' operations
export_function "_BinaryenExpressionGetId"
export_function "_BinaryenExpressionGetType"
export_function "_BinaryenExpressionPrint"

# 'Block' expression operations
export_function "_BinaryenBlockGetName"
export_function "_BinaryenBlockGetNumChildren"
export_function "_BinaryenBlockGetChild"

# 'If' expression operations
export_function "_BinaryenIfGetCondition"
export_function "_BinaryenIfGetIfTrue"
export_function "_BinaryenIfGetIfFalse"

# 'Loop' expression operations
export_function "_BinaryenLoopGetName"
export_function "_BinaryenLoopGetBody"

# 'Break' expression operations
export_function "_BinaryenBreakGetName"
export_function "_BinaryenBreakGetCondition"
export_function "_BinaryenBreakGetValue"

# 'Switch' expression operations
export_function "_BinaryenSwitchGetNumNames"
export_function "_BinaryenSwitchGetName"
export_function "_BinaryenSwitchGetDefaultName"
export_function "_BinaryenSwitchGetCondition"
export_function "_BinaryenSwitchGetValue"

# 'Call' expression operations
export_function "_BinaryenCallGetTarget"
export_function "_BinaryenCallGetNumOperands"
export_function "_BinaryenCallGetOperand"

# 'CallIndirect' expression operations
export_function "_BinaryenCallIndirectGetTarget"
export_function "_BinaryenCallIndirectGetNumOperands"
export_function "_BinaryenCallIndirectGetOperand"

# 'GetLocal' expression operations
export_function "_BinaryenGetLocalGetIndex"

# 'SetLocal' expression operations
export_function "_BinaryenSetLocalIsTee"
export_function "_BinaryenSetLocalGetIndex"
export_function "_BinaryenSetLocalGetValue"

# 'GetGlobal' expression operations
export_function "_BinaryenGetGlobalGetName"

# 'SetGlobal' expression operations
export_function "_BinaryenSetGlobalGetName"
export_function "_BinaryenSetGlobalGetValue"

# 'Host' expression operations
export_function "_BinaryenHostGetOp"
export_function "_BinaryenHostGetNameOperand"
export_function "_BinaryenHostGetNumOperands"
export_function "_BinaryenHostGetOperand"

# 'Load' expression operations
export_function "_BinaryenLoadIsAtomic"
export_function "_BinaryenLoadIsSigned"
export_function "_BinaryenLoadGetBytes"
export_function "_BinaryenLoadGetOffset"
export_function "_BinaryenLoadGetAlign"
export_function "_BinaryenLoadGetPtr"

# 'Store' expression operations
export_function "_BinaryenStoreIsAtomic"
export_function "_BinaryenStoreGetBytes"
export_function "_BinaryenStoreGetOffset"
export_function "_BinaryenStoreGetAlign"
export_function "_BinaryenStoreGetPtr"
export_function "_BinaryenStoreGetValue"

# 'Const' expression operations
export_function "_BinaryenConstGetValueI32"
export_function "_BinaryenConstGetValueI64Low"
export_function "_BinaryenConstGetValueI64High"
export_function "_BinaryenConstGetValueF32"
export_function "_BinaryenConstGetValueF64"

# 'Unary' expression operations
export_function "_BinaryenUnaryGetOp"
export_function "_BinaryenUnaryGetValue"

# 'Binary' expression operations
export_function "_BinaryenBinaryGetOp"
export_function "_BinaryenBinaryGetLeft"
export_function "_BinaryenBinaryGetRight"

# 'Select' expression operations
export_function "_BinaryenSelectGetIfTrue"
export_function "_BinaryenSelectGetIfFalse"
export_function "_BinaryenSelectGetCondition"

# 'Drop' expression operations
export_function "_BinaryenDropGetValue"

# 'Return' expression operations
export_function "_BinaryenReturnGetValue"

# 'AtomicRMW' expression operations
export_function "_BinaryenAtomicRMWGetOp"
export_function "_BinaryenAtomicRMWGetBytes"
export_function "_BinaryenAtomicRMWGetOffset"
export_function "_BinaryenAtomicRMWGetPtr"
export_function "_BinaryenAtomicRMWGetValue"

# 'AtomicCmpxchg' expression operations
export_function "_BinaryenAtomicCmpxchgGetBytes"
export_function "_BinaryenAtomicCmpxchgGetOffset"
export_function "_BinaryenAtomicCmpxchgGetPtr"
export_function "_BinaryenAtomicCmpxchgGetExpected"
export_function "_BinaryenAtomicCmpxchgGetReplacement"

# 'AtomicWait' expression operations
export_function "_BinaryenAtomicWaitGetPtr"
export_function "_BinaryenAtomicWaitGetExpected"
export_function "_BinaryenAtomicWaitGetTimeout"
export_function "_BinaryenAtomicWaitGetExpectedType"

# 'AtomicWake' expression operations
export_function "_BinaryenAtomicWakeGetPtr"
export_function "_BinaryenAtomicWakeGetWakeCount"

# 'Module' operations
export_function "_BinaryenModuleCreate"
export_function "_BinaryenModuleDispose"
export_function "_BinaryenAddFunctionType"
export_function "_BinaryenRemoveFunctionType"
export_function "_BinaryenGetFunctionTypeBySignature"
export_function "_BinaryenAddFunction"
export_function "_BinaryenGetFunction"
export_function "_BinaryenRemoveFunction"
export_function "_BinaryenAddGlobal"
export_function "_BinaryenRemoveGlobal"
export_function "_BinaryenAddFunctionImport"
export_function "_BinaryenAddTableImport"
export_function "_BinaryenAddMemoryImport"
export_function "_BinaryenAddGlobalImport"
export_function "_BinaryenAddFunctionExport"
export_function "_BinaryenAddTableExport"
export_function "_BinaryenAddMemoryExport"
export_function "_BinaryenAddGlobalExport"
export_function "_BinaryenRemoveExport"
export_function "_BinaryenSetFunctionTable"
export_function "_BinaryenSetMemory"
export_function "_BinaryenSetStart"
export_function "_BinaryenModuleParse"
export_function "_BinaryenModulePrint"
export_function "_BinaryenModulePrintAsmjs"
export_function "_BinaryenModuleValidate"
export_function "_BinaryenModuleOptimize"
export_function "_BinaryenGetOptimizeLevel"
export_function "_BinaryenSetOptimizeLevel"
export_function "_BinaryenGetShrinkLevel"
export_function "_BinaryenSetShrinkLevel"
export_function "_BinaryenGetDebugInfo"
export_function "_BinaryenSetDebugInfo"
export_function "_BinaryenModuleRunPasses"
export_function "_BinaryenModuleAutoDrop"
export_function "_BinaryenModuleAllocateAndWrite"
export_function "_BinaryenModuleRead"
export_function "_BinaryenModuleInterpret"
export_function "_BinaryenModuleAddDebugInfoFileName"
export_function "_BinaryenModuleGetDebugInfoFileName"

# 'FunctionType' operations
export_function "_BinaryenFunctionTypeGetName"
export_function "_BinaryenFunctionTypeGetNumParams"
export_function "_BinaryenFunctionTypeGetParam"
export_function "_BinaryenFunctionTypeGetResult"

# 'Function' operations
export_function "_BinaryenFunctionGetName"
export_function "_BinaryenFunctionGetType"
export_function "_BinaryenFunctionGetNumParams"
export_function "_BinaryenFunctionGetParam"
export_function "_BinaryenFunctionGetResult"
export_function "_BinaryenFunctionGetNumVars"
export_function "_BinaryenFunctionGetVar"
export_function "_BinaryenFunctionGetBody"
export_function "_BinaryenFunctionOptimize"
export_function "_BinaryenFunctionRunPasses"
export_function "_BinaryenFunctionSetDebugLocation"

# 'Import' operations
export_function "_BinaryenGlobalImportGetModule"
export_function "_BinaryenGlobalImportGetBase"
export_function "_BinaryenFunctionImportGetModule"
export_function "_BinaryenFunctionImportGetBase"

# 'Export' operations
export_function "_BinaryenExportGetKind"
export_function "_BinaryenExportGetName"
export_function "_BinaryenExportGetValue"

# 'Relooper' operations
export_function "_RelooperCreate"
export_function "_RelooperAddBlock"
export_function "_RelooperAddBranch"
export_function "_RelooperAddBlockWithSwitch"
export_function "_RelooperAddBranchForSwitch"
export_function "_RelooperRenderAndDispose"

# Tracing
export_function "_BinaryenSetAPITracing"

"$EMSCRIPTEN/em++" \
  $EMCC_ARGS \
  $BINARYEN_SRC/binaryen-c.cpp \
  shared.bc \
  -I$BINARYEN_SRC/ \
  -s EXPORTED_FUNCTIONS=[${EXPORTED_FUNCTIONS}] \
  -o $BINARYEN_BIN/binaryen${OUT_FILE_SUFFIX}.js \
  -s MODULARIZE_INSTANCE=1 \
  -s 'EXPORT_NAME="Binaryen"' \
  --post-js $BINARYEN_SRC/js/binaryen.js-post.js
