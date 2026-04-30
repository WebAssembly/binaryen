import {
	BinaryenObj,
	UTF8ToString,
} from "../../-pre.ts";
import type {
	ElementSegmentRef,
} from "../../constants.ts";



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
