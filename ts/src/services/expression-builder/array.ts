import type {
	Module,
} from "../../classes/module/Module.ts";



/** Placeholder. */
const STUB = (..._args: readonly number[]): number => 0;



export function array(_mod: Module) {
	return {
		new: STUB,
		new_default: STUB,
		new_fixed: STUB,
		new_data: STUB,
		new_elem: STUB,
		/**
		 * **Warning:** `.get()` no longer takes the boolean `isSigned` argument, and assumes an unpacked type.
		 * For packed types, use `.get_s()` for signed and `.get_u()` for unsigned.
		 */
		get: (_ref: number, _index: number, _type: number, deprecated_isSigned?: boolean) => deprecated_isSigned === undefined
			? STUB
			: deprecated_isSigned ? /* get_s */ STUB : /* get_u */ STUB,
		get_s: STUB,
		get_u: STUB,
		set: STUB,
		len: STUB,
		fill: STUB,
		copy: STUB,
		init_data: STUB,
		init_elem: STUB,
	} as const;
}
