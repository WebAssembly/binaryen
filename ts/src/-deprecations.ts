// # Deprecations # //



import {
	type ElementSegmentRef,
	type ExportRef,
	ExpressionId,
	ExternalKind,
	type FunctionRef,
	type GlobalRef,
	SideEffect,
	type TableRef,
	type TagRef,
} from "./constants.ts";
import {
	Operation,
} from "./classes/expression/Operation.ts";
import {
	Feature,
	Module,
} from "./classes/module/Module.ts";
import {
	consoleWarn,
} from "./lib.ts";
import {
	settings,
} from "./services/SettingsService.ts";



/** @deprecated The `ExpressionIds` enum has been renamed to `ExpressionId`. */
export const ExpressionIds = ExpressionId;
/** @deprecated The `SideEffects` enum has been renamed to `SideEffect`. */
export const SideEffects = SideEffect;
/** @deprecated The `ExternalKinds` enum has been renamed to `ExternalKind`. */
export const ExternalKinds = ExternalKind;
/** @deprecated The `Features` enum has been renamed to `Feature`. */
export const Features = Feature;
/** @deprecated The `Operations` enum has been renamed to `Operation`. */
export const Operations = Operation;



/** @deprecated The `TagInfo` object type is now called `Module.Tag`. */
export type TagInfo = Module.Tag;
/** @deprecated The `GlobalInfo` object type is now called `Module.Global`. */
export type GlobalInfo = Module.Global;
/** @deprecated The `MemoryInfo` object type is now called `Module.Memory`*/
export type MemoryInfo = Module.Memory;
/** @deprecated The `TableInfo` object type is now called `Module.Table`. */
export type TableInfo = Module.Table;
/** @deprecated The `FunctionInfo` object type is now called `Module.Function`. */
export type FunctionInfo = Module.Function;
// type `DataSegmentInfo` never existed
/** @deprecated The `ElementSegmentInfo` object type is now called `Module.ElementSegment`. */
export type ElementSegmentInfo = Module.ElementSegment;
// type `ImportInfo` never existed
/** @deprecated The `ExportInfo` object type is now called `Module.Export`. */
export type ExportInfo = Module.Export;


/** @deprecated The `Function` class now lives under the `Module` namespace. Use `Module.Function`. */
export const Function = Module.Function;
/** @deprecated The `Table` class now lives under the `Module` namespace. Use `Module.Table`. */
export const Table = Module.Table;



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
// function `getMemoryInfo` always existed in `Module`
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
// function `getDataSegmentInfo` always existed in `Module`
/** @deprecated Use `new Module.ElementSegment(segmentref)` instead. */
export function getElementSegmentInfo(segment: ElementSegmentRef) {
	consoleWarn("Global function `getElementSegmentInfo` is deprecated; use `new Module.ElementSegment(segmentref)` instead.");
	return new Module.ElementSegment(segment);
}
// no function `getImportInfo` ever existed
/** @deprecated Use `new Module.Export(exportref)` instead. */
export function getExportInfo(xport: ExportRef) {
	consoleWarn("Global function `getExportInfo` is deprecated; use `new Module.Export(exportref)` instead.");
	return new Module.Export(xport);
}



/** @deprecated Use `settings.optimizeLevel` instead. */
export function getOptimizeLevel() {
	consoleWarn("Global function `getOptimizeLevel` is deprecated; use `settings.optimizeLevel` instead.");
	return settings.optimizeLevel;
}
/** @deprecated Use `settings.optimizeLevel = level` instead. */
export function setOptimizeLevel(level: number) {
	consoleWarn("Global function `setOptimizeLevel` is deprecated; use `settings.optimizeLevel = level` instead.");
	settings.optimizeLevel = level;
}
/** @deprecated Use `settings.shrinkLevel` instead. */
export function getShrinkLevel() {
	consoleWarn("Global function `getShrinkLevel` is deprecated; use `settings.shrinkLevel` instead.");
	return settings.shrinkLevel;
}
/** @deprecated Use `settings.shrinkLevel = level` instead. */
export function setShrinkLevel(level: number) {
	consoleWarn("Global function `setShrinkLevel` is deprecated; use `settings.shrinkLevel = level` instead.");
	settings.shrinkLevel = level;
}
/** @deprecated Use `settings.debugInfo` instead. */
export function getDebugInfo(): boolean {
	consoleWarn("Global function `getDebugInfo` is deprecated; use `settings.debugInfo` instead.");
	return settings.debugInfo;
}
/** @deprecated Use `settings.debugInfo = enabled` instead. */
export function setDebugInfo(enabled: boolean) {
	consoleWarn("Global function `setDebugInfo` is deprecated; use `settings.debugInfo = enabled` instead.");
	settings.debugInfo = enabled;
}
/** @deprecated Use `settings.trapsNeverHappen` instead. */
export function getTrapsNeverHappen(): boolean {
	consoleWarn("Global function `getTrapsNeverHappen` is deprecated; use `settings.trapsNeverHappen` instead.");
	return settings.trapsNeverHappen;
}
/** @deprecated Use `settings.trapsNeverHappen = enabled` instead. */
export function setTrapsNeverHappen(enabled: boolean) {
	consoleWarn("Global function `setTrapsNeverHappen` is deprecated; use `settings.trapsNeverHappen = enabled` instead.");
	settings.trapsNeverHappen = enabled;
}
/** @deprecated Use `settings.closedWorld` instead. */
export function getClosedWorld() {
	consoleWarn("Global function `getClosedWorld` is deprecated; use `settings.closedWorld` instead.");
	return settings.closedWorld;
}
/** @deprecated Use `settings.closedWorld = enabled` instead. */
export function setClosedWorld(enabled: boolean) {
	consoleWarn("Global function `setClosedWorld` is deprecated; use `settings.closedWorld = enabled` instead.");
	settings.closedWorld = enabled;
}
/** @deprecated Use `settings.lowMemoryUnused` instead. */
export function getLowMemoryUnused() {
	consoleWarn("Global function `getLowMemoryUnused` is deprecated; use `settings.lowMemoryUnused` instead.");
	return settings.lowMemoryUnused;
}
/** @deprecated Use `settings.lowMemoryUnused = enabled` instead. */
export function setLowMemoryUnused(enabled: boolean) {
	consoleWarn("Global function `setLowMemoryUnused` is deprecated; use `settings.lowMemoryUnused = enabled` instead.");
	settings.lowMemoryUnused = enabled;
}
/** @deprecated Use `settings.zeroFilledMemory` instead. */
export function getZeroFilledMemory() {
	consoleWarn("Global function `getZeroFilledMemory` is deprecated; use `settings.zeroFilledMemory` instead.");
	return settings.zeroFilledMemory;
}
/** @deprecated Use `settings.zeroFilledMemory = enabled` instead. */
export function setZeroFilledMemory(enabled: boolean) {
	consoleWarn("Global function `setZeroFilledMemory` is deprecated; use `settings.zeroFilledMemory = enabled` instead.");
	settings.zeroFilledMemory = enabled;
}
/** @deprecated Use `settings.fastMath` instead. */
export function getFastMath() {
	consoleWarn("Global function `getFastMath` is deprecated; use `settings.fastMath` instead.");
	return settings.fastMath;
}
/** @deprecated Use `settings.fastMath = enabled` instead. */
export function setFastMath(enabled: boolean) {
	consoleWarn("Global function `setFastMath` is deprecated; use `settings.fastMath = enabled` instead.");
	settings.fastMath = enabled;
}
/** @deprecated Use `settings.generateStackIR` instead. */
export function getGenerateStackIR() {
	consoleWarn("Global function `getGenerateStackIR` is deprecated; use `settings.generateStackIR` instead.");
	return settings.generateStackIR;
}
/** @deprecated Use `settings.generateStackIR = enabled` instead. */
export function setGenerateStackIR(enabled: boolean) {
	consoleWarn("Global function `setGenerateStackIR` is deprecated; use `settings.generateStackIR = enabled` instead.");
	settings.generateStackIR = enabled;
}
/** @deprecated Use `settings.optimizeStackIR` instead. */
export function getOptimizeStackIR() {
	consoleWarn("Global function `getOptimizeStackIR` is deprecated; use `settings.optimizeStackIR` instead.");
	return settings.optimizeStackIR;
}
/** @deprecated Use `settings.optimizeStackIR = enabled` instead. */
export function setOptimizeStackIR(enabled: boolean) {
	consoleWarn("Global function `setOptimizeStackIR` is deprecated; use `settings.optimizeStackIR = enabled` instead.");
	settings.optimizeStackIR = enabled;
}
/** @deprecated Use `settings.alwaysInlineMaxSize` instead. */
export function getAlwaysInlineMaxSize() {
	consoleWarn("Global function `getAlwaysInlineMaxSize` is deprecated; use `settings.alwaysInlineMaxSize` instead.");
	return settings.alwaysInlineMaxSize;
}
/** @deprecated Use `settings.alwaysInlineMaxSize = size` instead. */
export function setAlwaysInlineMaxSize(size: number) {
	consoleWarn("Global function `setAlwaysInlineMaxSize` is deprecated; use `settings.alwaysInlineMaxSize = size` instead.");
	settings.alwaysInlineMaxSize = size;
}
/** @deprecated Use `settings.flexibleInlineMaxSize` instead. */
export function getFlexibleInlineMaxSize() {
	consoleWarn("Global function `getFlexibleInlineMaxSize` is deprecated; use `settings.flexibleInlineMaxSize` instead.");
	return settings.flexibleInlineMaxSize;
}
/** @deprecated Use `settings.flexibleInlineMaxSize = size` instead. */
export function setFlexibleInlineMaxSize(size: number) {
	consoleWarn("Global function `setFlexibleInlineMaxSize` is deprecated; use `settings.flexibleInlineMaxSize = size` instead.");
	settings.flexibleInlineMaxSize = size;
}
/** @deprecated Use `settings.oneCallerInlineMaxSize` instead. */
export function getOneCallerInlineMaxSize() {
	consoleWarn("Global function `getOneCallerInlineMaxSize` is deprecated; use `settings.oneCallerInlineMaxSize` instead.");
	return settings.oneCallerInlineMaxSize;
}
/** @deprecated Use `settings.oneCallerInlineMaxSize = size` instead. */
export function setOneCallerInlineMaxSize(size: number) {
	consoleWarn("Global function `setOneCallerInlineMaxSize` is deprecated; use `settings.oneCallerInlineMaxSize = size` instead.");
	settings.oneCallerInlineMaxSize = size;
}
/** @deprecated Use `settings.allowInliningFunctionsWithLoops` instead. */
export function getAllowInliningFunctionsWithLoops() {
	consoleWarn("Global function `getAllowInliningFunctionsWithLoops` is deprecated; use `settings.allowInliningFunctionsWithLoops` instead.");
	return settings.allowInliningFunctionsWithLoops;
}
/** @deprecated Use `settings.allowInliningFunctionsWithLoops = enabled` instead. */
export function setAllowInliningFunctionsWithLoops(enabled: boolean) {
	consoleWarn("Global function `setAllowInliningFunctionsWithLoops` is deprecated; use `settings.allowInliningFunctionsWithLoops = enabled` instead.");
	settings.allowInliningFunctionsWithLoops = enabled;
}



/** @deprecated Use `settings.getPassArgument(key)` instead. */
export function getPassArgument(key: string) {
	consoleWarn("Global function `getPassArgument` is deprecated; use `settings.getPassArgument(key)` instead.");
	return settings.getPassArgument(key);
}
/** @deprecated Use `settings.setPassArgument(key, value)` instead. */
export function setPassArgument(key: string, value?: string) {
	consoleWarn("Global function `setPassArgument` is deprecated; use `settings.setPassArgument(key, value)` instead.");
	return settings.setPassArgument(key, value);
}
/** @deprecated Use `settings.clearPassArguments()` instead. */
export function clearPassArguments() {
	consoleWarn("Global function `clearPassArguments` is deprecated; use `settings.clearPassArguments()` instead.");
	return settings.clearPassArguments();
}
/** @deprecated Use `settings.hasPassToSkip(pass)` instead. */
export function hasPassToSkip(pass: string) {
	consoleWarn("Global function `hasPassToSkip` is deprecated; use `settings.hasPassToSkip(pass)` instead.");
	return settings.hasPassToSkip(pass);
}
/** @deprecated Use `settings.addPassToSkip(pass)` instead. */
export function addPassToSkip(pass: string) {
	consoleWarn("Global function `addPassToSkip` is deprecated; use `settings.addPassToSkip(pass)` instead.");
	return settings.addPassToSkip(pass);
}
/** @deprecated Use `settings.clearPassesToSkip()` instead. */
export function clearPassesToSkip() {
	consoleWarn("Global function `clearPassesToSkip` is deprecated; use `settings.clearPassesToSkip()` instead.");
	return settings.clearPassesToSkip();
}
