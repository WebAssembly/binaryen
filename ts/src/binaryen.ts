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
export {Tag} from "./classes/module/Tag.ts";
export {Global} from "./classes/module/Global.ts";
export {Memory} from "./classes/module/Memory.ts";
export {Table} from "./classes/module/Table.ts";
export {Function} from "./classes/module/Function.ts";
export {DataSegment} from "./classes/module/DataSegment.ts";
export {ElementSegment} from "./classes/module/ElementSegment.ts";
export {Import} from "./classes/module/Import.ts";
export {Export} from "./classes/module/Export.ts";
export {TypeBuilder} from "./classes/TypeBuilder.ts";
export {
	ExpressionRunner,
	ExpressionRunnerFlag,
} from "./classes/ExpressionRunner.ts";
export {Relooper} from "./classes/Relooper.ts";
export * from "./-deprecations.ts";
