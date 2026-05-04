import type {
	Module,
} from "../../classes/module/Module.ts";



/** Placeholder. */
const STUB = (..._args: readonly number[]): number => 0;



/** @see https://webassembly.github.io/spec/core/syntax/instructions.html#table-instructions */
export function table(_mod: Module) {
	return {
		get: STUB,
		set: STUB,
		size: STUB,
		grow: STUB,
		// TODO: fill
		// TODO: copy
		// TODO: init
	} as const;
}
