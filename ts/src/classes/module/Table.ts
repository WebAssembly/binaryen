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



/**
 * Information about a table in a WASM module.
 * @see {@link ModuleTables}
 */
export class Table {
	private readonly [THIS_PTR]: TableRef;

	readonly module: string;
	readonly base: string;


	constructor(table: TableRef) {
		this[THIS_PTR] = table;
		this.module = UTF8ToString(BinaryenObj["_BinaryenTableImportGetModule"](this[THIS_PTR]));
		this.base = UTF8ToString(BinaryenObj["_BinaryenTableImportGetBase"](this[THIS_PTR]));
	}


	/** The name of this table */
	get name(): string { return UTF8ToString(BinaryenObj["_BinaryenTableGetName"](this[THIS_PTR])); }
	set name(name: string) { preserveStack(() => { BinaryenObj["_BinaryenTableSetName"](this[THIS_PTR], strToStack(name)); }); }

	/** The initial number of pages of this table. */
	get initial(): number { return BinaryenObj["_BinaryenTableGetInitial"](this[THIS_PTR]); }
	set initial(initial: number) { BinaryenObj["_BinaryenTableSetInitial"](this[THIS_PTR], initial); }

	/** The maximum number of pages of this table. */
	get max(): number { return BinaryenObj["_BinaryenTableGetMax"](this[THIS_PTR]); }
	set max(max: number) { BinaryenObj["_BinaryenTableSetMax"](this[THIS_PTR], max); }

	/** The type of this table. */
	get type(): Type { return BinaryenObj["_BinaryenTableGetType"](this[THIS_PTR]); }
	set type(tableType: Type) { BinaryenObj["_BinaryenTableSetType"](this[THIS_PTR], tableType); }

	valueOf(): TableRef {
		return this[THIS_PTR];
	}

	/**
	 * @returns does this table have a maximum number of pages?
	 */
	hasMax(): boolean {
		return Boolean(BinaryenObj["_BinaryenTableHasMax"](this[THIS_PTR]));
	}
}



/**
 * Methods for manipulating {@link Table | tables} in a WASM module.
 */
export class ModuleTables {
	constructor(private readonly mod: Module) {}

	/** Adds a table. */
	add(name: string, initial: number, maximum: number, type: Type = funcref, init?: ExpressionRef): TableRef {
		return preserveStack(() => BinaryenObj["_BinaryenAddTable"](this.mod.ptr, strToStack(name), initial, maximum, type, init ?? 0));
	}

	/** Gets a table by name. */
	get(name: string): TableRef {
		return preserveStack(() => BinaryenObj["_BinaryenGetTable"](this.mod.ptr, strToStack(name)));
	}

	/** Gets a table by index. */
	getByIndex(index: number): TableRef {
		return BinaryenObj["_BinaryenGetTableByIndex"](this.mod.ptr, index);
	}

	/** Gets the number of table segments within the module. */
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

	/** Gets the number of tables within the module. */
	count(): number {
		return BinaryenObj["_BinaryenGetNumTables"](this.mod.ptr);
	}

	/** Removes a table by name. */
	remove(name: string): void {
		return preserveStack(() => {
			BinaryenObj["_BinaryenRemoveTable"](this.mod.ptr, strToStack(name));
		});
	}
}
