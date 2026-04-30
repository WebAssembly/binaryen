import {
	BinaryenObj,
	UTF8ToString,
} from "../../-pre.ts";
import type {
	TableRef,
	Type,
} from "../../constants.ts";
import {
	replacedBy,
} from "../../lib.ts";
import {
	THIS_PTR,
	preserveStack,
	strToStack,
} from "../../utils.ts";



export class Table {
	/* eslint-disable @stylistic/brace-style */
	/** @deprecated */ @replacedBy("`instance.getName`") static getName(table: TableRef) { return Table.prototype.getName.call({[THIS_PTR]: table}); }
	/** @deprecated */ @replacedBy("`instance.setName`") static setName(table: TableRef, name: string) { return Table.prototype.setName.call({[THIS_PTR]: table}, name); }
	/** @deprecated */ @replacedBy("`instance.getInitial`") static getInitial(table: TableRef) { return Table.prototype.getInitial.call({[THIS_PTR]: table}); }
	/** @deprecated */ @replacedBy("`instance.setInitial`") static setInitial(table: TableRef, initial: number) { return Table.prototype.setInitial.call({[THIS_PTR]: table}, initial); }
	/** @deprecated */ @replacedBy("`instance.hasMax`") static hasMax(table: TableRef) { return Table.prototype.hasMax.call({[THIS_PTR]: table}); }
	/** @deprecated */ @replacedBy("`instance.getMax`") static getMax(table: TableRef) { return Table.prototype.getMax.call({[THIS_PTR]: table}); }
	/** @deprecated */ @replacedBy("`instance.setMax`") static setMax(table: TableRef, max: number) { return Table.prototype.setMax.call({[THIS_PTR]: table}, max); }
	/** @deprecated */ @replacedBy("`instance.getType`") static getType(table: TableRef) { return Table.prototype.getType.call({[THIS_PTR]: table}); }
	/** @deprecated */ @replacedBy("`instance.setType`") static setType(table: TableRef, tableType: Type) { return Table.prototype.setType.call({[THIS_PTR]: table}, tableType); }
	/* eslint-enable @stylistic/brace-style */


	private readonly [THIS_PTR]: TableRef;

	readonly module: string;
	readonly base: string;


	constructor(table: TableRef) {
		this[THIS_PTR] = table;
		this.module = UTF8ToString(BinaryenObj["_BinaryenTableImportGetModule"](this[THIS_PTR]));
		this.base = UTF8ToString(BinaryenObj["_BinaryenTableImportGetBase"](this[THIS_PTR]));
	}


	valueOf() {
		return this[THIS_PTR];
	}

	// TODO: post.js has converted all methods starting with `get` to getters and `set` to setters
	/**
	 * @return the name of this table
	 */
	getName(): string {
		return UTF8ToString(BinaryenObj["_BinaryenTableGetName"](this[THIS_PTR]));
	}

	/**
	 * @param name the new name for the this table
	 */
	setName(name: string): void {
		preserveStack(() => {
			BinaryenObj["_BinaryenTableSetName"](this[THIS_PTR], strToStack(name));
		});
	}

	/**
	 * @return the initial number of pages of the `Table`
	 */
	getInitial(): number {
		return BinaryenObj["_BinaryenTableGetInitial"](this[THIS_PTR]);
	}

	/**
	 * @param initial the new initial number of pages for this table
	 */
	setInitial(initial: number): void {
		BinaryenObj["_BinaryenTableSetInitial"](this[THIS_PTR], initial);
	}

	/**
	 * @return does this table have a maximum number of pages?
	 */
	hasMax(): boolean {
		return Boolean(BinaryenObj["_BinaryenTableHasMax"](this[THIS_PTR]));
	}

	/**
	 * @return the maximum number of pages of this table
	 */
	getMax(): number {
		return BinaryenObj["_BinaryenTableGetMax"](this[THIS_PTR]);
	}

	/**
	 * @param max the maximum number of pages of this table
	 */
	setMax(max: number): void {
		BinaryenObj["_BinaryenTableSetMax"](this[THIS_PTR], max);
	}

	/**
	 * @return the type of this table
	 */
	getType(): Type {
		return BinaryenObj["_BinaryenTableGetType"](this[THIS_PTR]);
	}

	/**
	 * @param tableType the new type for this table
	 */
	setType(tableType: Type): void {
		BinaryenObj["_BinaryenTableSetType"](this[THIS_PTR], tableType);
	}
}
