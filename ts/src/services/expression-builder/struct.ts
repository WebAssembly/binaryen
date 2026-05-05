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
		get: function (index: number, ref: number, type: number, deprecated_isSigned?: boolean) {
			return deprecated_isSigned === undefined
				? STUB(index, ref, type)
				: deprecated_isSigned
					? this.get_s(index, ref, type)
					: this.get_u(index, ref, type);
		},
		get_s: STUB,
		get_u: STUB,
		set: STUB,
	} as const;
}
