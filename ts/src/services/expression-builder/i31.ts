import type {
	Module,
} from "../../classes/module/Module.ts";



/** Placeholder. */
const STUB = (..._args: readonly number[]): number => 0;



/** @see https://webassembly.github.io/spec/core/syntax/instructions.html#aggregate-instructions */
export function i31(_mod: Module) {
	return {
		get_s: STUB,
		get_u: STUB,
	} as const;
}
