import {
	BinaryenObj,
	UTF8ToString,
} from "../../-pre.ts";
import {
	getAllNested,
	preserveStack,
	setAllNested,
	strToStack,
} from "../../-utils.ts";
import {
	ExpressionId,
	type ExpressionRef,
	type Operation,
	type Type,
} from "../../constants.ts";
import {
	Expression,
} from "./Expression.ts";



export class Break extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.Break, expr);
	}

	get name(): string | null {
		const name = BinaryenObj["_BinaryenBreakGetName"](this._ptr);
		return name ? UTF8ToString(name) : null;
	}

	set name(name: string) {
		preserveStack(() => BinaryenObj["_BinaryenBreakSetName"](this._ptr, strToStack(name)));
	}

	get condition(): ExpressionRef { return BinaryenObj["_BinaryenBreakGetCondition"](this._ptr); }
	set condition(condExpr: ExpressionRef) { BinaryenObj["_BinaryenBreakSetCondition"](this._ptr, condExpr); }

	get value(): ExpressionRef { return BinaryenObj["_BinaryenBreakGetValue"](this._ptr); }
	set value(valueExpr: ExpressionRef) { BinaryenObj["_BinaryenBreakSetValue"](this._ptr, valueExpr); }
}



export class Switch extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.Switch, expr);
	}

	get condition(): ExpressionRef { return BinaryenObj["_BinaryenSwitchGetCondition"](this._ptr); }
	set condition(condExpr: ExpressionRef) { BinaryenObj["_BinaryenSwitchSetCondition"](condExpr); }

	get value(): ExpressionRef { return BinaryenObj["_BinaryenSwitchGetValue"](this._ptr); }
	set value(valueExpr: ExpressionRef) { BinaryenObj["_BinaryenSwitchSetValue"](valueExpr); }

	get numNames(): number { return BinaryenObj["_BinaryenSwitchGetNumNames"](this._ptr); }

	get names(): string[] {
		return getAllNested(
			this._ptr,
			BinaryenObj["_BinaryenSwitchGetNumNames"],
			BinaryenObj["_BinaryenSwitchGetNameAt"],
		).map((p) => UTF8ToString(p));
	}

	set names(names: readonly string[]) {
		preserveStack(() => setAllNested(
			this._ptr,
			names.map(strToStack),
			BinaryenObj["_BinaryenSwitchGetNumNames"],
			BinaryenObj["_BinaryenSwitchSetNameAt"],
			BinaryenObj["_BinaryenSwitchAppendName"],
			BinaryenObj["_BinaryenSwitchRemoveNameAt"],
		));
	}

	get defaultName(): string | null {
		const name = BinaryenObj["_BinaryenSwitchGetDefaultName"](this._ptr);
		return name ? UTF8ToString(name) : null;
	}

	set defaultName(defaultName: string) {
		preserveStack(() => BinaryenObj["_BinaryenSwitchSetDefaultName"](this._ptr, strToStack(defaultName)));
	}

	getNameAt(index: number): string {
		return UTF8ToString(BinaryenObj["_BinaryenSwitchGetNameAt"](this._ptr, index));
	}

	setNameAt(index: number, name: string): void {
		preserveStack(() => BinaryenObj["_BinaryenSwitchSetNameAt"](this._ptr, index, strToStack(name)));
	}

	appendName(name: string): void {
		preserveStack(() => BinaryenObj["_BinaryenSwitchAppendName"](this._ptr, strToStack(name)));
	}

	insertNameAt(index: number, name: string): void {
		preserveStack(() => BinaryenObj["_BinaryenSwitchInsertNameAt"](this._ptr, index, strToStack(name)));
	}

	removeNameAt(index: number): string {
		return UTF8ToString(BinaryenObj["_BinaryenSwitchRemoveNameAt"](this._ptr, index));
	}
}



export class BrOn extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.BrOn, expr);
	}

	get op(): Operation { return BinaryenObj["_BinaryenBrOnGetOp"](this._ptr); }
	set op(op: Operation) { BinaryenObj["_BinaryenBrOnSetOp"](this._ptr, op); }

	get name(): string { return UTF8ToString(BinaryenObj["_BinaryenBrOnGetName"](this._ptr)); }
	set name(name: string) { preserveStack(() => BinaryenObj["_BinaryenBrOnSetName"](this._ptr, strToStack(name))); }

	get ref(): ExpressionRef { return BinaryenObj["_BinaryenBrOnGetRef"](this._ptr); }
	set ref(ref: ExpressionRef) { BinaryenObj["_BinaryenBrOnSetRef"](this._ptr, ref); }

	get castType(): Type { return BinaryenObj["_BinaryenBrOnGetCastType"](this._ptr); }
	set castType(castType: Type) { BinaryenObj["_BinaryenBrOnSetCastType"](this._ptr, castType); }
}
