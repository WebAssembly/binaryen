import type {
	Module,
} from "../../classes/module/Module.ts";



/** Placeholder. */
const STUB = (..._args: readonly number[]): number => 0;



export function struct(_mod: Module) {
	return {
		new: STUB,
		new_default: STUB,
		/**
		 * **Warning:** `.get()` no longer takes the boolean `isSigned` argument, and assumes an unpacked type.
		 * For packed types, use `.get_s()` for signed and `.get_u()` for unsigned.
		 */
		get: (_index: number, _ref: number, _type: number, deprecated_isSigned?: boolean) => deprecated_isSigned === undefined
			? STUB
			: deprecated_isSigned ? /* get_s */ STUB : /* get_u */ STUB,
		get_s: STUB,
		get_u: STUB,
		set: STUB,
	} as const;
}
