import {
	BinaryenObj,
	UTF8ToString,
} from "../../-pre.ts";
import {
	type ElementSegmentRef,
	type ExpressionRef,
	type TableRef,
	type Type,
	funcref,
} from "../../constants.ts";
import {
	THIS_PTR,
	preserveStack,
	strToStack,
} from "../../utils.ts";
import type {
	Module,
} from "./Module.ts";



/** Information about a table in a WASM module. */
export class Table {
	private readonly [THIS_PTR]: TableRef;

	readonly module: string;
	readonly base: string;


	constructor(table: TableRef) {
		this[THIS_PTR] = table;
		this.module = UTF8ToString(BinaryenObj["_BinaryenTableImportGetModule"](this[THIS_PTR]));
		this.base = UTF8ToString(BinaryenObj["_BinaryenTableImportGetBase"](this[THIS_PTR]));
	}


	valueOf(): TableRef {
		return this[THIS_PTR];
	}

	// FIXME: post.js has converted all methods starting with `get` to getters and `set` to setters
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



/** Methods for manipulating tables in a WASM module. */
export class ModuleTables {
	constructor(private readonly mod: Module) {}

	add(name: string, initial: number, maximum: number, type: Type = funcref, init?: ExpressionRef): TableRef {
		return preserveStack(() => BinaryenObj["_BinaryenAddTable"](this.mod.ptr, strToStack(name), initial, maximum, type, init ?? 0));
	}

	get(name: string): TableRef {
		return preserveStack(() => BinaryenObj["_BinaryenGetTable"](this.mod.ptr, strToStack(name)));
	}

	getByIndex(index: number): TableRef {
		return BinaryenObj["_BinaryenGetTableByIndex"](this.mod.ptr, index);
	}

	getSegments(table: TableRef): ElementSegmentRef[] {
		const numElementSegments = BinaryenObj["_BinaryenGetNumElementSegments"](this.mod.ptr);
		const tableName = UTF8ToString(BinaryenObj["_BinaryenTableGetName"](table));
		const ret = [];
		for (let i = 0; i < numElementSegments; i++) {
			const segment = BinaryenObj["_BinaryenGetElementSegmentByIndex"](this.mod.ptr, i);
			const elemTableName = UTF8ToString(BinaryenObj["_BinaryenElementSegmentGetTable"](segment));
			if (tableName === elemTableName) {
				ret.push(segment);
			}
		}
		return ret;
	}

	count(): number {
		return BinaryenObj["_BinaryenGetNumTables"](this.mod.ptr);
	}

	remove(name: string): void {
		return preserveStack(() => {
			BinaryenObj["_BinaryenRemoveTable"](this.mod.ptr, strToStack(name));
		});
	}
}
