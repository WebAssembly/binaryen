import {
	BinaryenObj,
} from "../-pre.ts";



class SettingsService {
	/* eslint-disable @stylistic/brace-style */
	/** The currently set optimize level. 0, 1, 2 correspond to -O0, -O1, -O2, etc. */
	get optimizeLevel(): number { return BinaryenObj["_BinaryenGetOptimizeLevel"](); }
	set optimizeLevel(level: number) { BinaryenObj["_BinaryenSetOptimizeLevel"](level); }

	/** The currently set shrink level. 0, 1, 2 correspond to -O0, -Os, -Oz. */
	get shrinkLevel(): number { return BinaryenObj["_BinaryenGetShrinkLevel"](); }
	set shrinkLevel(level: number) { BinaryenObj["_BinaryenSetShrinkLevel"](level); }

	/** Is generating debug information currently enabled? */
	get debugInfo(): boolean { return Boolean(BinaryenObj["_BinaryenGetDebugInfo"]()); }
	set debugInfo(enabled: boolean) { BinaryenObj["_BinaryenSetDebugInfo"](enabled); }

	/** Whether no traps can be considered reached at runtime when optimizing. */
	get trapsNeverHappen(): boolean { return Boolean(BinaryenObj["_BinaryenGetTrapsNeverHappen"]()); }
	set trapsNeverHappen(enabled: boolean) { BinaryenObj["_BinaryenSetTrapsNeverHappen"](enabled); }

	/** Whether considering that the code outside of the module does not inspect or interact with GC and function references. */
	get closedWorld(): boolean { return Boolean(BinaryenObj["_BinaryenGetClosedWorld"]()); }
	set closedWorld(enabled: boolean) { BinaryenObj["_BinaryenSetClosedWorld"](enabled); }

	/** Can the low 1K of memory be considered unused when optimizing? */
	get lowMemoryUnused(): boolean { return Boolean(BinaryenObj["_BinaryenGetLowMemoryUnused"]()); }
	set lowMemoryUnused(enabled: boolean) { BinaryenObj["_BinaryenSetLowMemoryUnused"](enabled); }

	/** Will an imported memory be zero-initialized speculation? */
	get zeroFilledMemory(): boolean { return Boolean(BinaryenObj["_BinaryenGetZeroFilledMemory"]()); }
	set zeroFilledMemory(enabled: boolean) { BinaryenObj["_BinaryenSetZeroFilledMemory"](enabled); }

	/** Whether fast math optimizations are enabled, ignoring for example corner cases of floating-point math like NaN changes. */
	get fastMath(): boolean { return Boolean(BinaryenObj["_BinaryenGetFastMath"]()); }
	set fastMath(enabled: boolean) { BinaryenObj["_BinaryenSetFastMath"](enabled); }

	/** Generate StackIR during binary writing? */
	get generateStackIR(): boolean { return Boolean(BinaryenObj["_BinaryenGetGenerateStackIR"]()); }
	set generateStackIR(enabled: boolean) { BinaryenObj["_BinaryenSetGenerateStackIR"](enabled); }

	/** Optimize StackIR during binary writing? */
	get optimizeStackIR(): boolean { return Boolean(BinaryenObj["_BinaryenGetOptimizeStackIR"]()); }
	set optimizeStackIR(enabled: boolean) { BinaryenObj["_BinaryenSetOptimizeStackIR"](enabled); }

	/** The function size at which we always inline. */
	get alwaysInlineMaxSize(): number { return BinaryenObj["_BinaryenGetAlwaysInlineMaxSize"](); }
	set alwaysInlineMaxSize(size: number) { BinaryenObj["_BinaryenSetAlwaysInlineMaxSize"](size); }

	/** The function size which we inline when functions are lightweight. */
	get flexibleInlineMaxSize(): number { return BinaryenObj["_BinaryenGetFlexibleInlineMaxSize"](); }
	set flexibleInlineMaxSize(size: number) { BinaryenObj["_BinaryenSetFlexibleInlineMaxSize"](size); }

	/** The function size which we inline when there is only one caller. */
	get oneCallerInlineMaxSize(): number { return BinaryenObj["_BinaryenGetOneCallerInlineMaxSize"](); }
	set oneCallerInlineMaxSize(size: number) { BinaryenObj["_BinaryenSetOneCallerInlineMaxSize"](size); }

	/** Are functions with loops allowed to be inlined? */
	get allowInliningFunctionsWithLoops(): boolean { return Boolean(BinaryenObj["_BinaryenGetAllowInliningFunctionsWithLoops"]()); }
	set allowInliningFunctionsWithLoops(enabled: boolean) { BinaryenObj["_BinaryenSetAllowInliningFunctionsWithLoops"](enabled); }
	/* eslint-enable @stylistic/brace-style */
}



/** The global settings control. */
export const settings = new SettingsService();
