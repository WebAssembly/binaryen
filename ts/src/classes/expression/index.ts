/**
 * A collection of classes related to WASM expression manipulation.
 *
 * The {@link Expression} class is the root class in the hierarchy;
 * all other classes in this module extend it and describe specific kinds of expressions.
 * Each expression type corresponds to an {@link ExpressionId}.
 * @module expressions
 */



export {Expression} from "./Expression.ts";

// ## Parametric ## //
export {Drop} from "./Drop.ts";
export {Select} from "./Select.ts";

// ## Control ## //
export {Block} from "./Block.ts";
export {Loop} from "./Loop.ts";
export {If} from "./If.ts";
export {Break} from "./Break.ts";
export {Switch} from "./Switch.ts";
export {BrOn} from "./BrOn.ts";
export {Call} from "./Call.ts";
export {CallRef} from "./CallRef.ts";
export {CallIndirect} from "./CallIndirect.ts";
export {Return} from "./Return.ts";
export {Throw} from "./Throw.ts";
export {Rethrow} from "./Rethrow.ts";
export {Try} from "./Try.ts";

// ## Variable ## //
export {LocalGet} from "./LocalGet.ts";
export {LocalSet} from "./LocalSet.ts";

// ## Numeric & Vector ## //
export {Const} from "./Const.ts";
