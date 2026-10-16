import {
	_free,
	_malloc,
	BinaryenObj,
	UTF8ToString,
} from "../../-pre.ts";
import {
	PTR,
	preserveStack,
	strToStack,
} from "../../-utils.ts";
import type {
	DataSegmentRef,
} from "../../constants.ts";
import type {
	Module,
} from "./Module.ts";



/**
 * Information about a data segment in a WASM module.
 */
export class DataSegment {
	readonly name: string;
	readonly offset?: number;
	readonly data: ArrayBuffer;
	readonly passive: boolean;


	constructor(mod: Module, segment: DataSegmentRef) {
		this.name = UTF8ToString(BinaryenObj["_BinaryenDataSegmentGetName"](segment));
		this.passive = Boolean(BinaryenObj["_BinaryenGetDataSegmentPassive"](segment));
		if (!this.passive) {
			this.offset = BinaryenObj["_BinaryenGetDataSegmentByteOffset"](mod[PTR], segment);
		}

		const size = BinaryenObj["_BinaryenGetDataSegmentByteLength"](segment);
		const ptr = _malloc(size);
		BinaryenObj["_BinaryenCopyDataSegmentData"](segment, ptr);
		const res = new Uint8Array(size);
		res.set(BinaryenObj.HEAP8.subarray(ptr, ptr + size));
		_free(ptr);

		this.data = res.buffer;
	}
}



/**
 * Methods for manipulating data segments in a WASM module.
 * @inline
 */
export class ModuleDataSegments {
	constructor(private readonly mod: Module) {}

	/** Gets a data segment by name. */
	get(name: string): DataSegmentRef {
		return preserveStack(() => BinaryenObj["_BinaryenGetDataSegment"](this.mod[PTR], strToStack(name)));
	}

	/** Gets a data segment by index. */
	getByIndex(index: number): DataSegmentRef {
		return BinaryenObj["_BinaryenGetDataSegmentByIndex"](this.mod[PTR], index);
	}

	/** Gets the number of data segments within the module. */
	count(): number {
		return BinaryenObj["_BinaryenGetNumDataSegments"](this.mod[PTR]);
	}
}
