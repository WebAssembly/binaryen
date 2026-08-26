/**
 * A collection of classes related to WASM expression manipulation.
 *
 * The {@link Expression} class is the root class in the hierarchy;
 * all other classes in this module extend it and describe specific kinds of expressions.
 * Each expression type corresponds to an {@link ExpressionId}.
 * @module expressions
 */



export * from "./Expression.ts";

export * from "./parametrics.ts";
export * from "./blocks.ts";
export * from "./breaks.ts";
export * from "./calls.ts";
export * from "./throws.ts";
export * from "./variables.ts";
export * from "./tables.ts";
export * from "./memories.ts";
export * from "./references.ts";
export * from "./aggregates.ts";
export * from "./numerics.ts";
export * from "./vectors.ts";
export * from "./atomics.ts";
export * from "./strings.ts";
