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
export {Tag, type ModuleTags} from "./classes/module/Tag.ts";
export {Global, type ModuleGlobals} from "./classes/module/Global.ts";
export {Memory, type ModuleMemories} from "./classes/module/Memory.ts";
export {Table, type ModuleTables} from "./classes/module/Table.ts";
export {Function, type ModuleFunctions} from "./classes/module/Function.ts";
export {DataSegment, type ModuleDataSegments} from "./classes/module/DataSegment.ts";
export {ElementSegment, type ModuleElementSegments} from "./classes/module/ElementSegment.ts";
export {Import, type ModuleImports} from "./classes/module/Import.ts";
export {Export, type ModuleExports} from "./classes/module/Export.ts";
export {TypeBuilder} from "./classes/TypeBuilder.ts";
export {
	ExpressionRunner,
	ExpressionRunnerFlag,
} from "./classes/ExpressionRunner.ts";
export {Relooper} from "./classes/Relooper.ts";
export * from "./-deprecations.ts";
