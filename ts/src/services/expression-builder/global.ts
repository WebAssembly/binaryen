import type {
	Module,
} from "../../classes/module/Module.ts";



/** Placeholder. */
const STUB = (..._args: readonly number[]): number => 0;



/** @see https://webassembly.github.io/spec/core/syntax/instructions.html#variable-instructions */
export function global(_mod: Module) {
	return {
		get: STUB,
		set: STUB,
	} as const;
}
