import {
	_free,
	_malloc,
	BinaryenObj,
	UTF8ToString,
} from "../../-pre.ts";
import type {
	DataSegmentRef,
} from "../../constants.ts";
import {
	HEAP8,
	preserveStack,
	strToStack,
} from "../../utils.ts";
import type {
	Module,
} from "./Module.ts";



export class DataSegment {
	readonly name: string;
	readonly offset?: number;
	readonly data: ArrayBuffer;
	readonly passive: boolean;


	constructor(mod: Module, segment: DataSegmentRef) {
		this.name = UTF8ToString(BinaryenObj["_BinaryenDataSegmentGetName"](segment));
		this.passive = Boolean(BinaryenObj["_BinaryenGetDataSegmentPassive"](segment));
		if (!this.passive) {
			this.offset = BinaryenObj["_BinaryenGetDataSegmentByteOffset"](mod.ptr, segment);
		}

		const size = BinaryenObj["_BinaryenGetDataSegmentByteLength"](segment);
		const ptr = _malloc(size);
		BinaryenObj["_BinaryenCopyDataSegmentData"](segment, ptr);
		const res = new Uint8Array(size);
		res.set(HEAP8.subarray(ptr, ptr + size));
		_free(ptr);

		this.data = res.buffer;
	}
}



export class ModuleDataSegments {
	constructor(private readonly mod: Module) {}

	get(name: string): DataSegmentRef {
		return preserveStack(() => BinaryenObj["_BinaryenGetDataSegment"](this.mod.ptr, strToStack(name)));
	}

	getByIndex(index: number): DataSegmentRef {
		return BinaryenObj["_BinaryenGetDataSegmentByIndex"](this.mod.ptr, index);
	}

	count(): number {
		return BinaryenObj["_BinaryenGetNumDataSegments"](this.mod.ptr);
	}
}
