import type {
	Module,
} from "../module/Module.ts";



/** Placeholder. */
const STUB = (..._args: readonly number[]): number => 0;



export function global(_mod: Module) {
	return {
		get: STUB,
		set: STUB,
	} as const;
}



/** @useDeclaredType */
export type ExpressionBuilderGlobal = ReturnType<typeof global>;
