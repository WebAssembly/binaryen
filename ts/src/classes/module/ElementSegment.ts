import {
	BinaryenObj,
	UTF8ToString,
} from "../../-pre.ts";
import type {
	ExpressionRef,
	ElementSegmentRef,
} from "../../constants.ts";
import {
	i32sToStack,
	preserveStack,
	strToStack,
} from "../../utils.ts";
import type {
	Module,
} from "./Module.ts";



export class ElementSegment {
	readonly name: string;
	readonly table: string;
	readonly offset: number;
	readonly data: readonly string[];


	constructor(segment: ElementSegmentRef) {
		const segmentLength = BinaryenObj["_BinaryenElementSegmentGetLength"](segment);
		const names: string[] = [];
		for (let j = 0; j !== segmentLength; ++j) {
			const ptr = BinaryenObj["_BinaryenElementSegmentGetData"](segment, j);
			names[j] = UTF8ToString(ptr);
		}

		this.name = UTF8ToString(BinaryenObj["_BinaryenElementSegmentGetName"](segment));
		this.table = UTF8ToString(BinaryenObj["_BinaryenElementSegmentGetTable"](segment));
		this.offset = BinaryenObj["_BinaryenElementSegmentGetOffset"](segment);
		this.data = names;
	}
}



export class ModuleElementSegments {
	constructor(private readonly mod: Module) {}

	addActive(table: string, name: string, funcNames: readonly string[], offset: ExpressionRef): ElementSegmentRef {
		return preserveStack(() => BinaryenObj["_BinaryenAddActiveElementSegment"](
			this.mod.ptr,
			strToStack(table),
			strToStack(name),
			i32sToStack(funcNames.map(strToStack)),
			funcNames.length,
			offset,
		));
	}

	addPassive(name: string, funcNames: readonly string[]): ElementSegmentRef {
		return preserveStack(() => BinaryenObj["_BinaryenAddPassiveElementSegment"](
			this.mod.ptr,
			strToStack(name),
			i32sToStack(funcNames.map(strToStack)),
			funcNames.length,
		));
	}

	get(name: string): ElementSegmentRef {
		return preserveStack(() => BinaryenObj["_BinaryenGetElementSegment"](this.mod.ptr, strToStack(name)));
	}

	getByIndex(index: number): ElementSegmentRef {
		return BinaryenObj["_BinaryenGetElementSegmentByIndex"](this.mod.ptr, index);
	}

	count(): number {
		return BinaryenObj["_BinaryenGetNumElementSegments"](this.mod.ptr);
	}

	remove(name: string): void {
		return preserveStack(() => {
			BinaryenObj["_BinaryenRemoveElementSegment"](this.mod.ptr, strToStack(name));
		});
	}
}
