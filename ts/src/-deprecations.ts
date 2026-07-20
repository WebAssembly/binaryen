// # Deprecations # //



import {
	BinaryenObj,
} from "./-pre.ts";
import {
	Feature,
	type Module,
} from "./classes/module/Module.ts";
import {
	ExpressionId,
	type ExpressionRef,
	ExternalKind,
	SideEffect,
} from "./constants.ts";



/** @deprecated The `ExpressionIds` enum has been renamed to {@link ExpressionId}. */
export const ExpressionIds = ExpressionId;
/** @deprecated The `SideEffects` enum has been renamed to {@link SideEffect}. */
export const SideEffects = SideEffect;
/** @deprecated The `ExternalKinds` enum has been renamed to {@link ExternalKind}. */
export const ExternalKinds = ExternalKind;
/** @deprecated The `Features` enum has been renamed to {@link Feature}. */
export const Features = Feature;



/** @deprecated Use {@link Module#getSideEffects} instead. */
export function getSideEffects(expr: ExpressionRef, mod: Module) {
	BinaryenObj.printWarn("Global function `getSideEffects(expr, mod)` is deprecated; use `mod.getSideEffects(expr)` instead.");
	return mod.getSideEffects(expr);
}
