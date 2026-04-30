// # Deprecations # //



import {
	ExpressionId,
	ExternalKind,
	Operation,
	SideEffect,
	type TagRef,
	type GlobalRef,
	type TableRef,
	type FunctionRef,
	type ElementSegmentRef,
	type ExportRef,
} from "./constants.ts";
import {
	Function as BinaryenFunction,
} from "./class/module/Function.ts";
import {
	Module,
} from "./class/module/Module.ts";
import {
	Table as BinaryenTable,
} from "./class/module/Table.ts";
import {
	consoleWarn,
} from "./lib.ts";



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



/** @deprecated Use `new Module.Tag(tagref)` instead. */
export function getTagInfo(tag: TagRef) {
	consoleWarn("Global function `getTagInfo` is deprecated; use `new Module.Tag(tagref)` instead.");
	return new Module.Tag(tag);
}

/** @deprecated Use `new Module.Global(globalref)` instead. */
export function getGlobalInfo(global: GlobalRef) {
	consoleWarn("Global function `getGlobalInfo` is deprecated; use `new Module.Global(globalref)` instead.");
	return new Module.Global(global);
}

/** @deprecated Use `new Module.Table(tableref)` instead. */
export function getTableInfo(table: TableRef) {
	consoleWarn("Global function `getTableInfo` is deprecated; use `new Module.Table(tableref)` instead.");
	return new Module.Table(table);
}

/** @deprecated Use `new Module.Function(funcref)` instead. */
export function getFunctionInfo(func: FunctionRef) {
	consoleWarn("Global function `getFunctionInfo` is deprecated; use `new Module.Function(funcref)` instead.");
	return new Module.Function(func);
}

/** @deprecated Use `new Module.ElementSegment(segmentref)` instead. */
export function getElementSegmentInfo(segment: ElementSegmentRef) {
	consoleWarn("Global function `getElementSegmentInfo` is deprecated; use `new Module.ElementSegment(segmentref)` instead.");
	return new Module.ElementSegment(segment);
}

/** @deprecated Use `new Module.Export(exportref)` instead. */
export function getExportInfo(xport: ExportRef) {
	consoleWarn("Global function `getExportInfo` is deprecated; use `new Module.Export(exportref)` instead.");
	return new Module.Export(xport);
}
