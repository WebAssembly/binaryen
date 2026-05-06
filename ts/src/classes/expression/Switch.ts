import {
	BinaryenObj,
	UTF8ToString,
} from "../../-pre.ts";
import {
	ExpressionId,
	type ExpressionRef,
} from "../../constants.ts";
import {
	THIS_PTR,
	getAllNested,
	preserveStack,
	setAllNested,
	strToStack,
} from "../../utils.ts";
import {
	Expression,
} from "./Expression.ts";



export class Switch extends Expression {
	constructor(expr: ExpressionRef) {
		super(ExpressionId.Switch, expr);
	}


	get condition(): ExpressionRef { return BinaryenObj["_BinaryenSwitchGetCondition"](this[THIS_PTR]); }
	set condition(condExpr: ExpressionRef) { BinaryenObj["_BinaryenSwitchSetCondition"](condExpr); }

	get value(): ExpressionRef { return BinaryenObj["_BinaryenSwitchGetValue"](this[THIS_PTR]); }
	set value(valueExpr: ExpressionRef) { BinaryenObj["_BinaryenSwitchSetValue"](valueExpr); }

	get numNames(): number { return BinaryenObj["_BinaryenSwitchGetNumNames"](this[THIS_PTR]); }

	get names(): string[] {
		return getAllNested(
			this[THIS_PTR],
			BinaryenObj["_BinaryenSwitchGetNumNames"],
			BinaryenObj["_BinaryenSwitchGetNameAt"],
		).map((p) => UTF8ToString(p));
	}

	set names(names: readonly string[]) {
		preserveStack(() => setAllNested(
			this[THIS_PTR],
			names.map(strToStack),
			BinaryenObj["_BinaryenSwitchGetNumNames"],
			BinaryenObj["_BinaryenSwitchSetNameAt"],
			BinaryenObj["_BinaryenSwitchAppendName"],
			BinaryenObj["_BinaryenSwitchRemoveNameAt"],
		));
	}

	get defaultName(): string | null {
		const name = BinaryenObj["_BinaryenSwitchGetDefaultName"](this[THIS_PTR]);
		return name ? UTF8ToString(name) : null;
	}

	set defaultName(defaultName: string) {
		preserveStack(() => BinaryenObj["_BinaryenSwitchSetDefaultName"](this[THIS_PTR], strToStack(defaultName)));
	}


	getNameAt(index: number): string {
		return UTF8ToString(BinaryenObj["_BinaryenSwitchGetNameAt"](this[THIS_PTR], index));
	}

	setNameAt(index: number, name: string): void {
		preserveStack(() => BinaryenObj["_BinaryenSwitchSetNameAt"](this[THIS_PTR], index, strToStack(name)));
	}

	appendName(name: string): void {
		preserveStack(() => BinaryenObj["_BinaryenSwitchAppendName"](this[THIS_PTR], strToStack(name)));
	}

	insertNameAt(index: number, name: string): void {
		preserveStack(() => BinaryenObj["_BinaryenSwitchInsertNameAt"](this[THIS_PTR], index, strToStack(name)));
	}

	removeNameAt(index: number): string {
		return UTF8ToString(BinaryenObj["_BinaryenSwitchRemoveNameAt"](this[THIS_PTR], index));
	}
}
