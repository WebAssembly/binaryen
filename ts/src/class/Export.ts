import {
	BinaryenObj,
	UTF8ToString,
} from "../-pre.ts";
import type {
	ExportRef,
	ExternalKind,
} from "../constants.ts";



export class Export {
	readonly kind: ExternalKind;
	readonly name: string;
	readonly value: string;


	constructor(xport: ExportRef) {
		this.kind = BinaryenObj["_BinaryenExportGetKind"](xport);
		this.name = UTF8ToString(BinaryenObj["_BinaryenExportGetName"](xport));
		this.value = UTF8ToString(BinaryenObj["_BinaryenExportGetValue"](xport));
	}
}
