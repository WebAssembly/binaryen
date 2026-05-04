import type {
	Module,
} from "../module/Module.ts";



/** Placeholder. */
const STUB = (..._args: readonly number[]): number => 0;



export function tuple(_mod: Module) {
	return {
		make: STUB,
		extract: STUB,
	} as const;
}
