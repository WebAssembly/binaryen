/** @module binaryen.ts */
export * from "./constants.ts";
export * from "./globals.ts";
export {type SettingsService, settings} from "./services/SettingsService.ts";
export * as EXPR from "./classes/expression/index.ts";
export type {ExpressionBuilder} from "./services/expression-builder/expressionBuilder.ts";
export {
	Feature,
	Module,
} from "./classes/module/Module.ts";
export type {Tag, ModuleTags} from "./classes/module/Tag.ts";
export type {Global, ModuleGlobals} from "./classes/module/Global.ts";
export type {Memory, ModuleMemories} from "./classes/module/Memory.ts";
export type {Table, ModuleTables} from "./classes/module/Table.ts";
export type {Function as BinaryenFunction, ModuleFunctions} from "./classes/module/Function.ts";
export type {DataSegment, ModuleDataSegments} from "./classes/module/DataSegment.ts";
export type {ElementSegment, ModuleElementSegments} from "./classes/module/ElementSegment.ts";
export type {Import, ModuleImports} from "./classes/module/Import.ts";
export type {Export, ModuleExports} from "./classes/module/Export.ts";
export {TypeBuilder} from "./classes/TypeBuilder.ts";
export {
	ExpressionRunner,
	ExpressionRunnerFlag,
} from "./classes/ExpressionRunner.ts";
export {Relooper} from "./classes/Relooper.ts";
export * from "./-deprecations.ts";
