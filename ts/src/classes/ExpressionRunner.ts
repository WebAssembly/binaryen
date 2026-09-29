import {
	BinaryenObj,
} from "../-pre.ts";



export enum ExpressionRunnerFlag {
	Default = BinaryenObj["_ExpressionRunnerFlagsDefault"](),
	PreserveSideeffects = BinaryenObj["_ExpressionRunnerFlagsPreserveSideeffects"](),
}
