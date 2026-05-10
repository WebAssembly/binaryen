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
export {
	Load,
	Store,
	SIMDLoad,
	SIMDLoadStoreLane,
	MemorySize,
	MemoryGrow,
	MemoryFill,
	MemoryCopy,
	MemoryInit,
	DataDrop,
} from "./memories.ts";
export {
	RefFunc,
	// TODO: RefNull,
	RefIsNull,
	RefAs,
	RefEq,
	RefTest,
	RefCast,
	RefI31,
	I31Get,
} from "./references.ts";
export {
	TupleMake,
	TupleExtract,
	StructNew,
	StructGet,
	StructSet,
	ArrayNew,
	ArrayNewFixed,
	ArrayNewData,
	ArrayNewElem,
	ArrayGet,
	ArraySet,
	ArrayLen,
	ArrayFill,
	ArrayCopy,
	ArrayInitData,
	ArrayInitElem,
} from "./aggregates.ts";
export {
	Const,
	Unary,
	Binary,
	WideIntAddSub,
	WideIntMul,
} from "./numerics.ts";
