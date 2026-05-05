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
export {TypeBuilder} from "./classes/TypeBuilder.ts";
export {
	ExpressionRunner,
	ExpressionRunnerFlag,
} from "./classes/ExpressionRunner.ts";
export {Relooper} from "./classes/Relooper.ts";
export * from "./-deprecations.ts";
