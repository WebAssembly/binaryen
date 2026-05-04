import type {
	Module,
} from "../../classes/module/Module.ts";



/** Placeholder. */
const STUB = (..._args: readonly number[]): number => 0;



function memoryAtomic(_mod: Module) {
	return {
		notify: STUB,
		wait32: STUB,
		wait64: STUB,
	} as const;
}



/** @see https://webassembly.github.io/spec/core/syntax/instructions.html#memory-instructions */
export function memory(mod: Module) {
	return {
		size: STUB,
		grow: STUB,
		fill: STUB,
		copy: STUB,
		init: STUB,
		/** @experimental */
		atomic: memoryAtomic(mod),
	} as const;
}
