// # Deprecations # //



import {
	BinaryenObj,
} from "./-pre.ts";
import type * as expressions from "./classes/expression/index.ts";
import {
	Feature,
	Module,
} from "./classes/module/Module.ts";
import {
	type ElementSegmentRef,
	type ExportRef,
	ExpressionId,
	type ExpressionRef,
	ExternalKind,
	type FunctionRef,
	type GlobalRef,
	SideEffect,
	type TableRef,
	type TagRef,
} from "./constants.ts";
import {
	settings,
} from "./services/SettingsService.ts";



/** @deprecated The `ExpressionIds` enum has been renamed to {@link ExpressionId}. */
export const ExpressionIds = ExpressionId;
/** @deprecated The `SideEffects` enum has been renamed to {@link SideEffect}. */
export const SideEffects = SideEffect;
/** @deprecated The `ExternalKinds` enum has been renamed to {@link ExternalKind}. */
export const ExternalKinds = ExternalKind;
/** @deprecated The `Features` enum has been renamed to {@link Feature}. */
export const Features = Feature;



/** @deprecated The `TagInfo` object type is now called {@link Module.Tag}. */
export type TagInfo = Module.Tag;
/** @deprecated The `GlobalInfo` object type is now called {@link Module.Global}. */
export type GlobalInfo = Module.Global;
/** @deprecated The `MemoryInfo` object type is now called {@link Module.Memory}*/
export type MemoryInfo = Module.Memory;
/** @deprecated The `TableInfo` object type is now called {@link Module.Table}. */
export type TableInfo = Module.Table;
/** @deprecated The `FunctionInfo` object type is now called {@link Module.Function}. */
export type FunctionInfo = Module.Function;
// type `DataSegmentInfo` never existed
/** @deprecated The `ElementSegmentInfo` object type is now called {@link Module.ElementSegment}. */
export type ElementSegmentInfo = Module.ElementSegment;
// type `ImportInfo` never existed
/** @deprecated The `ExportInfo` object type is now called {@link Module.Export}. */
export type ExportInfo = Module.Export;



/** @deprecated The `ExpressionInfo` object type is now called {@link expressions.Expression}. */
export type ExpressionInfo = expressions.Expression;
/** @deprecated The `DropInfo` object type is now called {@link expressions.Drop}. */
export type DropInfo = expressions.Drop;
/** @deprecated The `SelectInfo` object type is now called {@link expressions.Select}. */
export type SelectInfo = expressions.Select;
/** @deprecated The `BlockInfo` object type is now called {@link expressions.Block}. */
export type BlockInfo = expressions.Block;
/** @deprecated The `LoopInfo` object type is now called {@link expressions.Loop}. */
export type LoopInfo = expressions.Loop;
/** @deprecated The `BreakInfo` object type is now called {@link expressions.Break}. */
export type BreakInfo = expressions.Break;
/** @deprecated The `LocalGetInfo` object type is now called {@link expressions.LocalGet}. */
export type LocalGetInfo = expressions.LocalGet;
/** @deprecated The `LocalSetInfo` object type is now called {@link expressions.LocalSet}. */
export type LocalSetInfo = expressions.LocalSet;
/** @deprecated The `ConstInfo` object type is now called {@link expressions.Const}. */
export type ConstInfo = expressions.Const;

/** @deprecated The `Function` class now lives under the `Module` namespace. Use {@link Module.Function}. */
export const Function = Module.Function;
/** @deprecated The `Table` class now lives under the `Module` namespace. Use {@link Module.Table}. */
export const Table = Module.Table;



/** @deprecated Use {@link Module#getSideEffects} instead. */
export function getSideEffects(expr: ExpressionRef, mod: Module) {
	BinaryenObj.printWarn("Global function `getSideEffects(expr, mod)` is deprecated; use `mod.getSideEffects(expr)` instead.");
	return mod.getSideEffects(expr);
}



/** @deprecated Use {@link Module.Tag | `new Module.Tag(tagref)`} instead. */
export function getTagInfo(tag: TagRef) {
	BinaryenObj.printWarn("Global function `getTagInfo` is deprecated; use `new Module.Tag(tagref)` instead.");
	return new Module.Tag(tag);
}
/** @deprecated Use {@link Module.Global | `new Module.Global(globalref)`} instead. */
export function getGlobalInfo(global: GlobalRef) {
	BinaryenObj.printWarn("Global function `getGlobalInfo` is deprecated; use `new Module.Global(globalref)` instead.");
	return new Module.Global(global);
}
// function `getMemoryInfo` always existed in `Module`
/** @deprecated Use {@link Module.Table | `new Module.Table(tableref)`} instead. */
export function getTableInfo(table: TableRef) {
	BinaryenObj.printWarn("Global function `getTableInfo` is deprecated; use `new Module.Table(tableref)` instead.");
	return new Module.Table(table);
}
/** @deprecated Use {@link Module.Function | `new Module.Function(funcref)`} instead. */
export function getFunctionInfo(func: FunctionRef) {
	BinaryenObj.printWarn("Global function `getFunctionInfo` is deprecated; use `new Module.Function(funcref)` instead.");
	return new Module.Function(func);
}
// function `getDataSegmentInfo` always existed in `Module`
/** @deprecated Use {@link Module.ElementSegment | `new Module.ElementSegment(segmentref)`} instead. */
export function getElementSegmentInfo(segment: ElementSegmentRef) {
	BinaryenObj.printWarn("Global function `getElementSegmentInfo` is deprecated; use `new Module.ElementSegment(segmentref)` instead.");
	return new Module.ElementSegment(segment);
}
// no function `getImportInfo` ever existed
/** @deprecated Use {@link Module.Export | `new Module.Export(exportref)`} instead. */
export function getExportInfo(xport: ExportRef) {
	BinaryenObj.printWarn("Global function `getExportInfo` is deprecated; use `new Module.Export(exportref)` instead.");
	return new Module.Export(xport);
}



/** @deprecated Use {@link settings.optimizeLevel} instead. */
export function getOptimizeLevel() {
	BinaryenObj.printWarn("Global function `getOptimizeLevel` is deprecated; use `settings.optimizeLevel` instead.");
	return settings.optimizeLevel;
}
/** @deprecated Use {@link settings.optimizeLevel} instead. */
export function setOptimizeLevel(level: number) {
	BinaryenObj.printWarn("Global function `setOptimizeLevel` is deprecated; use `settings.optimizeLevel = level` instead.");
	settings.optimizeLevel = level;
}
/** @deprecated Use {@link settings.shrinkLevel} instead. */
export function getShrinkLevel() {
	BinaryenObj.printWarn("Global function `getShrinkLevel` is deprecated; use `settings.shrinkLevel` instead.");
	return settings.shrinkLevel;
}
/** @deprecated Use {@link settings.shrinkLevel} instead. */
export function setShrinkLevel(level: number) {
	BinaryenObj.printWarn("Global function `setShrinkLevel` is deprecated; use `settings.shrinkLevel = level` instead.");
	settings.shrinkLevel = level;
}
/** @deprecated Use {@link settings.debugInfo} instead. */
export function getDebugInfo(): boolean {
	BinaryenObj.printWarn("Global function `getDebugInfo` is deprecated; use `settings.debugInfo` instead.");
	return settings.debugInfo;
}
/** @deprecated Use {@link settings.debugInfo} instead. */
export function setDebugInfo(enabled: boolean) {
	BinaryenObj.printWarn("Global function `setDebugInfo` is deprecated; use `settings.debugInfo = enabled` instead.");
	settings.debugInfo = enabled;
}
/** @deprecated Use {@link settings.trapsNeverHappen} instead. */
export function getTrapsNeverHappen(): boolean {
	BinaryenObj.printWarn("Global function `getTrapsNeverHappen` is deprecated; use `settings.trapsNeverHappen` instead.");
	return settings.trapsNeverHappen;
}
/** @deprecated Use {@link settings.trapsNeverHappen} instead. */
export function setTrapsNeverHappen(enabled: boolean) {
	BinaryenObj.printWarn("Global function `setTrapsNeverHappen` is deprecated; use `settings.trapsNeverHappen = enabled` instead.");
	settings.trapsNeverHappen = enabled;
}
/** @deprecated Use {@link settings.closedWorld} instead. */
export function getClosedWorld() {
	BinaryenObj.printWarn("Global function `getClosedWorld` is deprecated; use `settings.closedWorld` instead.");
	return settings.closedWorld;
}
/** @deprecated Use {@link settings.closedWorld} instead. */
export function setClosedWorld(enabled: boolean) {
	BinaryenObj.printWarn("Global function `setClosedWorld` is deprecated; use `settings.closedWorld = enabled` instead.");
	settings.closedWorld = enabled;
}
/** @deprecated Use {@link settings.lowMemoryUnused} instead. */
export function getLowMemoryUnused() {
	BinaryenObj.printWarn("Global function `getLowMemoryUnused` is deprecated; use `settings.lowMemoryUnused` instead.");
	return settings.lowMemoryUnused;
}
/** @deprecated Use {@link settings.lowMemoryUnused} instead. */
export function setLowMemoryUnused(enabled: boolean) {
	BinaryenObj.printWarn("Global function `setLowMemoryUnused` is deprecated; use `settings.lowMemoryUnused = enabled` instead.");
	settings.lowMemoryUnused = enabled;
}
/** @deprecated Use {@link settings.zeroFilledMemory} instead. */
export function getZeroFilledMemory() {
	BinaryenObj.printWarn("Global function `getZeroFilledMemory` is deprecated; use `settings.zeroFilledMemory` instead.");
	return settings.zeroFilledMemory;
}
/** @deprecated Use {@link settings.zeroFilledMemory} instead. */
export function setZeroFilledMemory(enabled: boolean) {
	BinaryenObj.printWarn("Global function `setZeroFilledMemory` is deprecated; use `settings.zeroFilledMemory = enabled` instead.");
	settings.zeroFilledMemory = enabled;
}
/** @deprecated Use {@link settings.fastMath} instead. */
export function getFastMath() {
	BinaryenObj.printWarn("Global function `getFastMath` is deprecated; use `settings.fastMath` instead.");
	return settings.fastMath;
}
/** @deprecated Use {@link settings.fastMath} instead. */
export function setFastMath(enabled: boolean) {
	BinaryenObj.printWarn("Global function `setFastMath` is deprecated; use `settings.fastMath = enabled` instead.");
	settings.fastMath = enabled;
}
/** @deprecated Use {@link settings.generateStackIR} instead. */
export function getGenerateStackIR() {
	BinaryenObj.printWarn("Global function `getGenerateStackIR` is deprecated; use `settings.generateStackIR` instead.");
	return settings.generateStackIR;
}
/** @deprecated Use {@link settings.generateStackIR} instead. */
export function setGenerateStackIR(enabled: boolean) {
	BinaryenObj.printWarn("Global function `setGenerateStackIR` is deprecated; use `settings.generateStackIR = enabled` instead.");
	settings.generateStackIR = enabled;
}
/** @deprecated Use {@link settings.optimizeStackIR} instead. */
export function getOptimizeStackIR() {
	BinaryenObj.printWarn("Global function `getOptimizeStackIR` is deprecated; use `settings.optimizeStackIR` instead.");
	return settings.optimizeStackIR;
}
/** @deprecated Use {@link settings.optimizeStackIR} instead. */
export function setOptimizeStackIR(enabled: boolean) {
	BinaryenObj.printWarn("Global function `setOptimizeStackIR` is deprecated; use `settings.optimizeStackIR = enabled` instead.");
	settings.optimizeStackIR = enabled;
}
/** @deprecated Use {@link settings.alwaysInlineMaxSize} instead. */
export function getAlwaysInlineMaxSize() {
	BinaryenObj.printWarn("Global function `getAlwaysInlineMaxSize` is deprecated; use `settings.alwaysInlineMaxSize` instead.");
	return settings.alwaysInlineMaxSize;
}
/** @deprecated Use {@link settings.alwaysInlineMaxSize} instead. */
export function setAlwaysInlineMaxSize(size: number) {
	BinaryenObj.printWarn("Global function `setAlwaysInlineMaxSize` is deprecated; use `settings.alwaysInlineMaxSize = size` instead.");
	settings.alwaysInlineMaxSize = size;
}
/** @deprecated Use {@link settings.flexibleInlineMaxSize} instead. */
export function getFlexibleInlineMaxSize() {
	BinaryenObj.printWarn("Global function `getFlexibleInlineMaxSize` is deprecated; use `settings.flexibleInlineMaxSize` instead.");
	return settings.flexibleInlineMaxSize;
}
/** @deprecated Use {@link settings.flexibleInlineMaxSize} instead. */
export function setFlexibleInlineMaxSize(size: number) {
	BinaryenObj.printWarn("Global function `setFlexibleInlineMaxSize` is deprecated; use `settings.flexibleInlineMaxSize = size` instead.");
	settings.flexibleInlineMaxSize = size;
}
/** @deprecated Use {@link settings.oneCallerInlineMaxSize} instead. */
export function getOneCallerInlineMaxSize() {
	BinaryenObj.printWarn("Global function `getOneCallerInlineMaxSize` is deprecated; use `settings.oneCallerInlineMaxSize` instead.");
	return settings.oneCallerInlineMaxSize;
}
/** @deprecated Use {@link settings.oneCallerInlineMaxSize} instead. */
export function setOneCallerInlineMaxSize(size: number) {
	BinaryenObj.printWarn("Global function `setOneCallerInlineMaxSize` is deprecated; use `settings.oneCallerInlineMaxSize = size` instead.");
	settings.oneCallerInlineMaxSize = size;
}
/** @deprecated Use {@link settings.allowInliningFunctionsWithLoops} instead. */
export function getAllowInliningFunctionsWithLoops() {
	BinaryenObj.printWarn("Global function `getAllowInliningFunctionsWithLoops` is deprecated; use `settings.allowInliningFunctionsWithLoops` instead.");
	return settings.allowInliningFunctionsWithLoops;
}
/** @deprecated Use {@link settings.allowInliningFunctionsWithLoops} instead. */
export function setAllowInliningFunctionsWithLoops(enabled: boolean) {
	BinaryenObj.printWarn("Global function `setAllowInliningFunctionsWithLoops` is deprecated; use `settings.allowInliningFunctionsWithLoops = enabled` instead.");
	settings.allowInliningFunctionsWithLoops = enabled;
}



/** @deprecated Use {@link settings.getPassArgument} instead. */
export function getPassArgument(key: string) {
	BinaryenObj.printWarn("Global function `getPassArgument` is deprecated; use `settings.getPassArgument(key)` instead.");
	return settings.getPassArgument(key);
}
/** @deprecated Use {@link settings.setPassArgument} instead. */
export function setPassArgument(key: string, value?: string) {
	BinaryenObj.printWarn("Global function `setPassArgument` is deprecated; use `settings.setPassArgument(key, value)` instead.");
	return settings.setPassArgument(key, value);
}
/** @deprecated Use {@link settings.clearPassArguments} instead. */
export function clearPassArguments() {
	BinaryenObj.printWarn("Global function `clearPassArguments` is deprecated; use `settings.clearPassArguments()` instead.");
	return settings.clearPassArguments();
}
/** @deprecated Use {@link settings.hasPassToSkip} instead. */
export function hasPassToSkip(pass: string) {
	BinaryenObj.printWarn("Global function `hasPassToSkip` is deprecated; use `settings.hasPassToSkip(pass)` instead.");
	return settings.hasPassToSkip(pass);
}
/** @deprecated Use {@link settings.addPassToSkip} instead. */
export function addPassToSkip(pass: string) {
	BinaryenObj.printWarn("Global function `addPassToSkip` is deprecated; use `settings.addPassToSkip(pass)` instead.");
	return settings.addPassToSkip(pass);
}
/** @deprecated Use {@link settings.clearPassesToSkip} instead. */
export function clearPassesToSkip() {
	BinaryenObj.printWarn("Global function `clearPassesToSkip` is deprecated; use `settings.clearPassesToSkip()` instead.");
	return settings.clearPassesToSkip();
}
