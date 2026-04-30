// # Deprecations # //



import {
	ExpressionId,
	ExternalKind,
	Operation,
	SideEffect,
} from "./constants.ts";
import {
	Function as BinaryenFunction,
} from "./class/Function.ts";
import {
	Table as BinaryenTable,
} from "./class/Table.ts";



/** @deprecated `ExpressionIds` has been renamed to `ExpressionId`. */
export const ExpressionIds = ExpressionId;

/** @deprecated `Operations` has been renamed to `Operation`. */
export const Operations = Operation;

/** @deprecated `ExternalKinds` has been renamed to `ExternalKind`. */
export const ExternalKinds = ExternalKind;

/** @deprecated `SideEffects` has been renamed to `SideEffect`. */
export const SideEffects = SideEffect;



/** @deprecated The `Function` class now lives as a static member of the `Module` class. Use `Module.Function`. */
export const Function = BinaryenFunction;

/** @deprecated The `Table` class now lives as a static member of the `Module` class. Use `Module.Table`. */
export const Table = BinaryenTable;
