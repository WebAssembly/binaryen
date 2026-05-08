/**
 * A collection of classes related to WASM expression manipulation.
 *
 * The {@link Expression} class is the root class in the hierarchy;
 * all other classes in this module extend it and describe specific kinds of expressions.
 * Each expression type corresponds to an {@link ExpressionId}.
 * @module expressions
 */



export {Expression} from "./Expression.ts";

export {
	Drop,
	Select,
} from "./parametrics.ts";
export {
	Block,
	Loop,
	If,
} from "./blocks.ts";
export {
	Break,
	Switch,
	BrOn,
} from "./breaks.ts";
export {
	Call,
	CallRef,
	CallIndirect,
	Return,
} from "./calls.ts";
export {
	Throw,
	Rethrow,
	Try,
} from "./throws.ts";
export {
	LocalGet,
	LocalSet,
	GlobalGet,
	GlobalSet,
} from "./variables.ts";
export {
	TableGet,
	TableSet,
	TableSize,
	TableGrow,
} from "./tables.ts";

export {Const} from "./Const.ts";
