import type {Module} from "./Module.ts";
import type {
	ExpressionRef,
	ExpressionRunnerRef,
} from "./constants.ts";
import {BinaryenObj} from "./pre.ts";
import {
	preserveStack,
	strToStack,
} from "./utils.ts";



export enum ExpressionRunnerFlag {
	Default = BinaryenObj["_ExpressionRunnerFlagsDefault"](),
	PreserveSideeffects = BinaryenObj["_ExpressionRunnerFlagsPreserveSideeffects"](),
}



export class ExpressionRunner {
	readonly ptr: ExpressionRunnerRef;

	constructor(module: Module, flags: ExpressionRunnerFlag, maxDepth: number, maxLoopIterations: number) {
		this.ptr = BinaryenObj["_ExpressionRunnerCreate"](module.ptr, flags, maxDepth, maxLoopIterations);
	}

	setLocalValue(index: number, valueExpr: ExpressionRef): boolean {
		return Boolean(BinaryenObj["_ExpressionRunnerSetLocalValue"](this.ptr, index, valueExpr));
	}

	setGlobalValue(name: string, valueExpr: ExpressionRef): boolean {
		return preserveStack(() => Boolean(BinaryenObj["_ExpressionRunnerSetGlobalValue"](this.ptr, strToStack(name), valueExpr)));
	}

	runAndDispose(expr: ExpressionRef): ExpressionRef {
		return BinaryenObj["_ExpressionRunnerRunAndDispose"](this.ptr, expr);
	}
}
