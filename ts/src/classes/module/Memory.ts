import {
	_free,
	_malloc,
	BinaryenObj,
	UTF8ToString,
} from "../../-pre.ts";
import type {
	ExpressionRef,
} from "../../constants.ts";
import {
	HEAP8,
	i32sToStack,
	preserveStack,
	strToStack,
} from "../../utils.ts";
import type {
	Module,
} from "./Module.ts";



/** Similar to a `DataSegment` but with some minor differences. */
interface MemorySegment {
	name?: string;
	offset: ExpressionRef;
	data: Uint8Array;
	passive: boolean;
}



/** Information about a memory in a WASM module. */
export class Memory {
	readonly module: string;
	readonly base: string;
	readonly initial: number;
	readonly shared: boolean;
	readonly is64: boolean;
	readonly max?: number;


	constructor(mod: Module, name: string) {
		this.module = UTF8ToString(BinaryenObj["_BinaryenMemoryImportGetModule"](mod.ptr, strToStack(name)));
		this.base = UTF8ToString(BinaryenObj["_BinaryenMemoryImportGetBase"](mod.ptr, strToStack(name)));
		this.initial = BinaryenObj["_BinaryenMemoryGetInitial"](mod.ptr, strToStack(name));
		this.shared = Boolean(BinaryenObj["_BinaryenMemoryIsShared"](mod.ptr, strToStack(name)));
		this.is64 = Boolean(BinaryenObj["_BinaryenMemoryIs64"](mod.ptr, strToStack(name)));
		if (BinaryenObj["_BinaryenMemoryHasMax"](mod.ptr, strToStack(name))) {
			this.max = BinaryenObj["_BinaryenMemoryGetMax"](mod.ptr, strToStack(name));
		}
	}
}



/** Methods for manipulating memories in a WASM module. */
export class ModuleMemories {
	constructor(private readonly mod: Module) {}

	/** Sets the memory. There’s just one memory for now, using name "0". Providing `exportName` also creates a memory export. */
	set(
		initial: number,
		maximum: number,
		exportName: string,
		segments: readonly MemorySegment[] = [],
		shared: boolean = false,
		memory64: boolean = false,
		internalName?: string,
	): void {
		return preserveStack(() => {
			const names: number[] = [];
			const datas: number[] = [];
			const passives: number[] = [];
			const offsets: number[] = [];
			const lengths: number[] = [];
			for (let i = 0; i < segments.length; i++) {
				const {name, data, passive, offset} = segments[i];
				names[i] = strToStack(name);
				datas[i] = _malloc(data.length);
				passives[i] = Number(passive);
				offsets[i] = offset;
				HEAP8.set(data, datas[i]);
				lengths[i] = data.length;
			}
			BinaryenObj["_BinaryenSetMemory"](
				this.mod.ptr,
				initial,
				maximum,
				strToStack(exportName),
				i32sToStack(names),
				i32sToStack(datas),
				i32sToStack(passives),
				i32sToStack(offsets),
				i32sToStack(lengths),
				segments.length,
				shared,
				memory64,
				strToStack(internalName),
			);
			for (const dataptr of datas) {
				_free(dataptr);
			}
		});
	}

	/** Returns whether the module has a memory. */
	has(): boolean {
		return Boolean(BinaryenObj["_BinaryenHasMemory"](this.mod.ptr));
	}
}
