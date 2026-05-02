import {
	BinaryenObj,
} from "../-pre.ts";
import type {
	ExpressionRef,
} from "../constants.ts";
import {
	preserveStack,
	strToStack,
} from "../utils.ts";
import type {
	Module,
} from "./module/Module.ts";



export enum ExpressionRunnerFlag {
	Default = BinaryenObj["_ExpressionRunnerFlagsDefault"](),
	PreserveSideeffects = BinaryenObj["_ExpressionRunnerFlagsPreserveSideeffects"](),
}



export class ExpressionRunner {
	/** @deprecated Static field `ExpressionRunner.Flags` is now a standalone enum `ExpressionRunnerFlag`. */
	static Flags = ExpressionRunnerFlag;


	readonly #ptr: number;

	constructor(mod: Module, flags: ExpressionRunnerFlag, maxDepth: number, maxLoopIterations: number) {
		this.#ptr = BinaryenObj["_ExpressionRunnerCreate"](mod.ptr, flags, maxDepth, maxLoopIterations);
	}

	setLocalValue(index: number, valueExpr: ExpressionRef): boolean {
		return Boolean(BinaryenObj["_ExpressionRunnerSetLocalValue"](this.#ptr, index, valueExpr));
	}

	setGlobalValue(name: string, valueExpr: ExpressionRef): boolean {
		return preserveStack(() => Boolean(BinaryenObj["_ExpressionRunnerSetGlobalValue"](this.#ptr, strToStack(name), valueExpr)));
	}

	runAndDispose(expr: ExpressionRef): ExpressionRef {
		return BinaryenObj["_ExpressionRunnerRunAndDispose"](this.#ptr, expr);
	}
}
