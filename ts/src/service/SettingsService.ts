import {
	BinaryenObj,
} from "../-pre.ts";



interface Settings {
	/** The currently set optimize level. 0, 1, 2 correspond to -O0, -O1, -O2, etc. */
	optimizeLevel: number;

	/** The currently set shrink level. 0, 1, 2 correspond to -O0, -Os, -Oz. */
	shrinkLevel: number;

	/** Is generating debug information currently enabled? */
	debugInfo: boolean;

	/** Whether no traps can be considered reached at runtime when optimizing. */
	trapsNeverHappen: boolean;

	/** Whether considering that the code outside of the module does not inspect or interact with GC and function references. */
	closedWorld: boolean;

	/** Whether the low 1K of memory can be considered unused when optimizing. */
	lowMemoryUnused: boolean;

	/** Whether that an imported memory will be zero-initialized speculation. */
	zeroFilledMemory: boolean;

	/** Whether fast math optimizations are enabled, ignoring for example corner cases of floating-point math like NaN changes. */
	fastMath: boolean;

	/** Whether to generate StackIR during binary writing. */
	generateStackIR: boolean;

	/** Whether to optimize StackIR during binary writing. */
	optimizeStackIR: boolean;

	/** The function size at which we always inline. */
	alwaysInlineMaxSize: number;

	/** The function size which we inline when functions are lightweight. */
	flexibleInlineMaxSize: number;

	/** The function size which we inline when there is only one caller. */
	oneCallerInlineMaxSize: number;

	/** Whether functions with loops are allowed to be inlined. */
	allowInliningFunctionsWithLoops: boolean;
}



class SettingsService implements Settings {
	/* eslint-disable @stylistic/brace-style */
	get optimizeLevel(): number { return BinaryenObj["_BinaryenGetOptimizeLevel"](); }
	set optimizeLevel(level: number) { BinaryenObj["_BinaryenSetOptimizeLevel"](level); }

	get shrinkLevel(): number { return BinaryenObj["_BinaryenGetShrinkLevel"](); }
	set shrinkLevel(level: number) { BinaryenObj["_BinaryenSetShrinkLevel"](level); }

	get debugInfo(): boolean { return Boolean(BinaryenObj["_BinaryenGetDebugInfo"]()); }
	set debugInfo(enabled: boolean) { BinaryenObj["_BinaryenSetDebugInfo"](enabled); }

	get trapsNeverHappen(): boolean { return Boolean(BinaryenObj["_BinaryenGetTrapsNeverHappen"]()); }
	set trapsNeverHappen(enabled: boolean) { BinaryenObj["_BinaryenSetTrapsNeverHappen"](enabled); }

	get closedWorld(): boolean { return Boolean(BinaryenObj["_BinaryenGetClosedWorld"]()); }
	set closedWorld(enabled: boolean) { BinaryenObj["_BinaryenSetClosedWorld"](enabled); }

	get lowMemoryUnused(): boolean { return Boolean(BinaryenObj["_BinaryenGetLowMemoryUnused"]()); }
	set lowMemoryUnused(enabled: boolean) { BinaryenObj["_BinaryenSetLowMemoryUnused"](enabled); }

	get zeroFilledMemory(): boolean { return Boolean(BinaryenObj["_BinaryenGetZeroFilledMemory"]()); }
	set zeroFilledMemory(enabled: boolean) { BinaryenObj["_BinaryenSetZeroFilledMemory"](enabled); }

	get fastMath(): boolean { return Boolean(BinaryenObj["_BinaryenGetFastMath"]()); }
	set fastMath(enabled: boolean) { BinaryenObj["_BinaryenSetFastMath"](enabled); }

	get generateStackIR(): boolean { return Boolean(BinaryenObj["_BinaryenGetGenerateStackIR"]()); }
	set generateStackIR(enabled: boolean) { BinaryenObj["_BinaryenSetGenerateStackIR"](enabled); }

	get optimizeStackIR(): boolean { return Boolean(BinaryenObj["_BinaryenGetOptimizeStackIR"]()); }
	set optimizeStackIR(enabled: boolean) { BinaryenObj["_BinaryenSetOptimizeStackIR"](enabled); }

	get alwaysInlineMaxSize(): number { return BinaryenObj["_BinaryenGetAlwaysInlineMaxSize"](); }
	set alwaysInlineMaxSize(size: number) { BinaryenObj["_BinaryenSetAlwaysInlineMaxSize"](size); }

	get flexibleInlineMaxSize(): number { return BinaryenObj["_BinaryenGetFlexibleInlineMaxSize"](); }
	set flexibleInlineMaxSize(size: number) { BinaryenObj["_BinaryenSetFlexibleInlineMaxSize"](size); }

	get oneCallerInlineMaxSize(): number { return BinaryenObj["_BinaryenGetOneCallerInlineMaxSize"](); }
	set oneCallerInlineMaxSize(size: number) { BinaryenObj["_BinaryenSetOneCallerInlineMaxSize"](size); }

	get allowInliningFunctionsWithLoops(): boolean { return Boolean(BinaryenObj["_BinaryenGetAllowInliningFunctionsWithLoops"]()); }
	set allowInliningFunctionsWithLoops(enabled: boolean) { BinaryenObj["_BinaryenSetAllowInliningFunctionsWithLoops"](enabled); }
	/* eslint-enable @stylistic/brace-style */
}



/** The global settings control. */
export const settings: Settings = new SettingsService();
