import {
	BinaryenObj,
	UTF8ToString,
} from "../../-pre.ts";
import type {
	ExpressionRef,
	GlobalRef,
	Type,
} from "../../constants.ts";



export class Global {
	readonly name: string;
	readonly module: string;
	readonly base: string;
	readonly type: Type;
	readonly mutable: boolean;
	readonly init: ExpressionRef;


	constructor(global: GlobalRef) {
		this.name = UTF8ToString(BinaryenObj["_BinaryenGlobalGetName"](global));
		this.module = UTF8ToString(BinaryenObj["_BinaryenGlobalImportGetModule"](global));
		this.base = UTF8ToString(BinaryenObj["_BinaryenGlobalImportGetBase"](global));
		this.type = BinaryenObj["_BinaryenGlobalGetType"](global);
		this.mutable = Boolean(BinaryenObj["_BinaryenGlobalIsMutable"](global));
		this.init = BinaryenObj["_BinaryenGlobalGetInitExpr"](global);
	}
}
