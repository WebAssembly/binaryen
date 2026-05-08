import {
	BinaryenObj,
} from "../-pre.ts";
import {
	PTR,
	i32sToStack,
	preserveStack,
} from "../-utils.ts";
import type {
	ExpressionRef,
} from "../constants.ts";
import type {
	Module,
} from "./module/Module.ts";



export type RelooperBlockRef = number;



export class Relooper {
	readonly #ptr: number;

	/**
	 * Constructs a relooper instance.
	 * This lets you provide an arbitrary CFG, and the relooper will structure it for WebAssembly.
	 * @param mod the binaryen Module
	 */
	constructor(mod: Module) {
		this.#ptr = BinaryenObj["_RelooperCreate"](mod[PTR]);
	}

	/**
	 * Adds a new block to the CFG, containing the provided code as its body.
	 * @param code the block expression
	 * @returns a reference to the block
	 */
	addBlock(code: ExpressionRef): RelooperBlockRef {
		return BinaryenObj["_RelooperAddBlock"](this.#ptr, code);
	}

	/**
	 * Adds a branch from a block to another block, with a condition
	 * (or nothing, if this is the default branch to take from the origin —
	 * each block must have one such branch), and optional code to execute
	 * on the branch (useful for phis).
	 * @param from source block
	 * @param to destination block
	 * @param condition contition to evaluate: if true, jumps to the given block; else does nothing
	 * @param code code to evaluate in between block jumps
	 */
	addBranch(from: RelooperBlockRef, to: RelooperBlockRef, condition: ExpressionRef, code: ExpressionRef): void {
		BinaryenObj["_RelooperAddBranch"](from, to, condition, code);
	}

	/**
	 * Adds a new block, which ends with a switch/br_table, with provided code and condition
	 * (that determines where we go in the switch).
	 * @param code the block expression
	 * @param condition contition to determine the jump destination
	 */
	addBlockWithSwitch(code: ExpressionRef, condition: ExpressionRef): RelooperBlockRef {
		return BinaryenObj["_RelooperAddBlockWithSwitch"](this.#ptr, code, condition);
	}

	/**
	 * Adds a branch from a block ending in a switch, to another block,
	 * using an array of indexes that determine where to go, and optional code to execute on the branch.
	 * @param from source block
	 * @param to destination block
	 * @param indexes array containing corresponding indices for destination blocks
	 * @param code code to evaluate in between block jumps
	 */
	addBranchForSwitch(from: RelooperBlockRef, to: RelooperBlockRef, indexes: readonly number[], code: ExpressionRef): void {
		preserveStack(() => BinaryenObj["_RelooperAddBranchForSwitch"](from, to, i32sToStack(indexes), indexes.length, code));
	}

	/**
	 * Renders and cleans up the Relooper instance.
	 * Call this after you have created all the blocks and branches, giving it the entry block (where control flow begins),
	 * a label helper variable (an index of a local we can use, necessary for irreducible control flow), and the module.
	 * This returns an expression — normal WebAssembly code — that you can use normally anywhere.
	 */
	renderAndDispose(entry: RelooperBlockRef, labelHelper: number): ExpressionRef {
		return BinaryenObj["_RelooperRenderAndDispose"](this.#ptr, entry, labelHelper);
	}
}
