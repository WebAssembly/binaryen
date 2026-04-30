import {
	BinaryenObj,
	UTF8ToString,
} from "../-pre.ts";
import type {
	TagRef,
	Type,
} from "../constants.ts";



export class Tag {
	readonly name: string;
	readonly module: string;
	readonly base: string;
	readonly params: Type;
	readonly results: Type;


	constructor(tag: TagRef) {
		this.name = UTF8ToString(BinaryenObj["_BinaryenTagGetName"](tag));
		this.module = UTF8ToString(BinaryenObj["_BinaryenTagImportGetModule"](tag));
		this.base = UTF8ToString(BinaryenObj["_BinaryenTagImportGetBase"](tag));
		this.params = BinaryenObj["_BinaryenTagGetParams"](tag);
		this.results = BinaryenObj["_BinaryenTagGetResults"](tag);
	}
}
