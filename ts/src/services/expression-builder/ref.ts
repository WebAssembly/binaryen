import type {
	Module,
} from "../../classes/module/Module.ts";



/** Placeholder. */
const STUB = (..._args: readonly number[]): number => 0;



export function ref(_mod: Module) {
	return {
		func: STUB,
		null: STUB,
		is_null: STUB,
		as_non_null: STUB,
		eq: STUB,
		test: STUB,
		cast: STUB,
		i31: STUB,
	} as const;
}
