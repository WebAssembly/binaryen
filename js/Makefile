#
# This file builds the js components using emscripten. You normally don't need
# to run this, as the builds are bundled in the repo in bin/. Running this is
# useful if you are a developer and want to update those builds.
#
# Usage: Enter this directory and run
#
#   emmake make
#
# Emscripten's em++ etc. will be accessed through the
# env var EMSCRIPTEN, e.g. ${EMSCRIPTEN}/em++
#
# To build a debug build, build binaryen.debug.js. The default target is
# release.
#
# You can get emscripten from
# http://kripken.github.io/emscripten-site/docs/getting_started/downloads.html
#

# input sources relative to this script
BINARYEN_SCRIPTS="$(PWD)/../scripts"

OUT="$(PWD)/../out"

OUT = "$(PWD)/../out"

BINARYEN_SRC = $(PWD)/../src

CFLAGS = -O2 \
         -std=gnu++14 \
         -s ALLOW_MEMORY_GROWTH=1 \
         -s BINARYEN_ASYNC_COMPILATION=0 \
         -s DISABLE_EXCEPTION_CATCHING=0 \

LINKFLAGS = -s MODULARIZE_INSTANCE=1 \
            -s 'EXPORT_NAME="Binaryen"' \
            --post-js "$(BINARYEN_SRC)/js/binaryen.js-post.js"

LINKFLAGS_DEBUG = -O2 --profiling -s -s DEMANGLE_SUPPORT=1

LINKFLAGS_RELEASE = -Os --closure 1

OBJECTS = \
  $(BINARYEN_SRC)/asmjs/asm_v_wasm.o \
  $(BINARYEN_SRC)/asmjs/asmangle.o \
  $(BINARYEN_SRC)/asmjs/shared-constants.o \
  $(BINARYEN_SRC)/cfg/Relooper.o \
  $(BINARYEN_SRC)/emscripten-optimizer/optimizer-shared.o \
  $(BINARYEN_SRC)/emscripten-optimizer/parser.o \
  $(BINARYEN_SRC)/emscripten-optimizer/simple_ast.o \
  $(BINARYEN_SRC)/ir/ExpressionAnalyzer.o \
  $(BINARYEN_SRC)/ir/ExpressionManipulator.o \
  $(BINARYEN_SRC)/ir/LocalGraph.o \
  $(BINARYEN_SRC)/ir/ReFinalize.o \
  $(BINARYEN_SRC)/passes/pass.o \
  $(BINARYEN_SRC)/passes/AlignmentLowering.o \
  $(BINARYEN_SRC)/passes/Asyncify.o \
  $(BINARYEN_SRC)/passes/AvoidReinterprets.o \
  $(BINARYEN_SRC)/passes/CoalesceLocals.o \
  $(BINARYEN_SRC)/passes/DeadArgumentElimination.o \
  $(BINARYEN_SRC)/passes/CodeFolding.o \
  $(BINARYEN_SRC)/passes/CodePushing.o \
  $(BINARYEN_SRC)/passes/ConstHoisting.o \
  $(BINARYEN_SRC)/passes/DataFlowOpts.o \
  $(BINARYEN_SRC)/passes/DeadCodeElimination.o \
  $(BINARYEN_SRC)/passes/Directize.o \
  $(BINARYEN_SRC)/passes/DuplicateImportElimination.o \
  $(BINARYEN_SRC)/passes/DuplicateFunctionElimination.o \
  $(BINARYEN_SRC)/passes/ExtractFunction.o \
  $(BINARYEN_SRC)/passes/Flatten.o \
  $(BINARYEN_SRC)/passes/FuncCastEmulation.o \
  $(BINARYEN_SRC)/passes/I64ToI32Lowering.o \
  $(BINARYEN_SRC)/passes/Inlining.o \
  $(BINARYEN_SRC)/passes/InstrumentLocals.o \
  $(BINARYEN_SRC)/passes/InstrumentMemory.o \
  $(BINARYEN_SRC)/passes/LegalizeJSInterface.o \
  $(BINARYEN_SRC)/passes/LimitSegments.o \
  $(BINARYEN_SRC)/passes/LocalCSE.o \
  $(BINARYEN_SRC)/passes/LogExecution.o \
  $(BINARYEN_SRC)/passes/LoopInvariantCodeMotion.o \
  $(BINARYEN_SRC)/passes/MemoryPacking.o \
  $(BINARYEN_SRC)/passes/MergeBlocks.o \
  $(BINARYEN_SRC)/passes/MergeLocals.o \
  $(BINARYEN_SRC)/passes/Metrics.o \
  $(BINARYEN_SRC)/passes/MinifyImportsAndExports.o \
  $(BINARYEN_SRC)/passes/NameList.o \
  $(BINARYEN_SRC)/passes/NoExitRuntime.o \
  $(BINARYEN_SRC)/passes/OptimizeAddedConstants.o \
  $(BINARYEN_SRC)/passes/OptimizeInstructions.o \
  $(BINARYEN_SRC)/passes/PickLoadSigns.o \
  $(BINARYEN_SRC)/passes/PostEmscripten.o \
  $(BINARYEN_SRC)/passes/Precompute.o \
  $(BINARYEN_SRC)/passes/Print.o \
  $(BINARYEN_SRC)/passes/PrintFeatures.o \
  $(BINARYEN_SRC)/passes/PrintFunctionMap.o \
  $(BINARYEN_SRC)/passes/PrintCallGraph.o \
  $(BINARYEN_SRC)/passes/RedundantSetElimination.o \
  $(BINARYEN_SRC)/passes/RelooperJumpThreading.o \
  $(BINARYEN_SRC)/passes/RemoveNonJSOps.o \
  $(BINARYEN_SRC)/passes/RemoveImports.o \
  $(BINARYEN_SRC)/passes/RemoveMemory.o \
  $(BINARYEN_SRC)/passes/RemoveUnusedBrs.o \
  $(BINARYEN_SRC)/passes/RemoveUnusedModuleElements.o \
  $(BINARYEN_SRC)/passes/RemoveUnusedNames.o \
  $(BINARYEN_SRC)/passes/ReorderFunctions.o \
  $(BINARYEN_SRC)/passes/ReorderLocals.o \
  $(BINARYEN_SRC)/passes/ReReloop.o \
  $(BINARYEN_SRC)/passes/SafeHeap.o \
  $(BINARYEN_SRC)/passes/SimplifyGlobals.o \
  $(BINARYEN_SRC)/passes/SimplifyLocals.o \
  $(BINARYEN_SRC)/passes/Souperify.o \
  $(BINARYEN_SRC)/passes/SpillPointers.o \
  $(BINARYEN_SRC)/passes/SSAify.o \
  $(BINARYEN_SRC)/passes/StackIR.o \
  $(BINARYEN_SRC)/passes/Strip.o \
  $(BINARYEN_SRC)/passes/StripTargetFeatures.o \
  $(BINARYEN_SRC)/passes/TrapMode.o \
  $(BINARYEN_SRC)/passes/Untee.o \
  $(BINARYEN_SRC)/passes/Vacuum.o \
  $(BINARYEN_SRC)/passes/WasmIntrinsics.o \
  $(BINARYEN_SRC)/support/bits.o \
  $(BINARYEN_SRC)/support/colors.o \
  $(BINARYEN_SRC)/support/file.o \
  $(BINARYEN_SRC)/support/safe_integer.o \
  $(BINARYEN_SRC)/support/threads.o \
  $(BINARYEN_SRC)/wasm/literal.o \
  $(BINARYEN_SRC)/wasm/wasm-binary.o \
  $(BINARYEN_SRC)/wasm/wasm-emscripten.o \
  $(BINARYEN_SRC)/wasm/wasm-interpreter.o \
  $(BINARYEN_SRC)/wasm/wasm-io.o \
  $(BINARYEN_SRC)/wasm/wasm-s-parser.o \
  $(BINARYEN_SRC)/wasm/wasm-stack.o \
  $(BINARYEN_SRC)/wasm/wasm-type.o \
  $(BINARYEN_SRC)/wasm/wasm-validator.o \
  $(BINARYEN_SRC)/wasm/wasm.o \
  $(BINARYEN_SRC)/binaryen-c.o

all: binaryen.js

%.o: %.cpp WasmIntrinsics.cpp
	$(CXX) $(CFLAGS) -I$(BINARYEN_SRC) $< -o $@ -c

binaryen.js: $(OBJECTS)
	$(CXX) $(CFLAGS) $(LINKFLAGS) $(LINKFLAGS_RELEASE) $(OBJECTS) -o $(OUT)/binaryen.js

binaryen.debug.js: $(OBJECTS)
	$(CXX) $(CFLAGS) $(LINKFLAGS) $(LINKFLAGS_DEBUG) $(OBJECTS) -o $(OUT)/binaryen.js

WasmIntrinsics.cpp:
	python3 "$(BINARYEN_SCRIPTS)/embedwast.py" "$(BINARYEN_SRC)/passes/wasm-intrinsics.wast" "WasmIntrinsics.cpp"
	cp "WasmIntrinsics.cpp" "$(BINARYEN_SRC)/WasmIntrinsics.cpp"
  
clean:
	rm $(OBJECTS) $(OUT)/binaryen.js $(OUT)/binaryen.debug.js "WasmIntrinsics.cpp"
