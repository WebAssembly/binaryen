import {
	BinaryenObj,
	UTF8ToString,
} from "../../-pre.ts";
import {
	PTR,
	preserveStack,
	strToStack,
} from "../../-utils.ts";
import {
	type ElementSegmentRef,
	type ExpressionRef,
	type TableRef,
	type Type,
	funcref,
} from "../../constants.ts";
import type {
	Module,
} from "./Module.ts";



/**
 * Information about a table in a WASM module.
 */
export class Table {
	/** The underlying C-API pointer of the wrapped table. */
	readonly #ptr: TableRef;

	readonly module: string;
	readonly base: string;


	constructor(table: TableRef) {
		this.#ptr = table;
		this.module = UTF8ToString(BinaryenObj["_BinaryenTableImportGetModule"](this.#ptr));
		this.base = UTF8ToString(BinaryenObj["_BinaryenTableImportGetBase"](this.#ptr));
	}


	/** The name of this table */
	get name(): string { return UTF8ToString(BinaryenObj["_BinaryenTableGetName"](this.#ptr)); }
	set name(name: string) { preserveStack(() => BinaryenObj["_BinaryenTableSetName"](this.#ptr, strToStack(name))); }

	/** The initial number of pages of this table. */
	get initial(): number { return BinaryenObj["_BinaryenTableGetInitial"](this.#ptr); }
	set initial(initial: number) { BinaryenObj["_BinaryenTableSetInitial"](this.#ptr, initial); }

	/** The maximum number of pages of this table. */
	get max(): number { return BinaryenObj["_BinaryenTableGetMax"](this.#ptr); }
	set max(max: number) { BinaryenObj["_BinaryenTableSetMax"](this.#ptr, max); }

	/** The type of this table. */
	get type(): Type { return BinaryenObj["_BinaryenTableGetType"](this.#ptr); }
	set type(tableType: Type) { BinaryenObj["_BinaryenTableSetType"](this.#ptr, tableType); }

	valueOf(): TableRef {
		return this.#ptr;
	}

	/**
	 * @returns does this table have a maximum number of pages?
	 */
	hasMax(): boolean {
		return Boolean(BinaryenObj["_BinaryenTableHasMax"](this.#ptr));
	}
}



/**
 * Methods for manipulating tables in a WASM module.
 * @inline
 */
export class ModuleTables {
	constructor(private readonly mod: Module) {}

	/** Adds a table. */
	add(name: string, initial: number, maximum: number, type: Type = funcref, init?: ExpressionRef): TableRef {
		return preserveStack(() => BinaryenObj["_BinaryenAddTable"](this.mod[PTR], strToStack(name), initial, maximum, type, init ?? 0));
	}

	/** Gets a table by name. */
	get(name: string): TableRef {
		return preserveStack(() => BinaryenObj["_BinaryenGetTable"](this.mod[PTR], strToStack(name)));
	}

	/** Gets a table by index. */
	getByIndex(index: number): TableRef {
		return BinaryenObj["_BinaryenGetTableByIndex"](this.mod[PTR], index);
	}

	/** Gets the number of table segments within the module. */
	getSegments(table: TableRef): ElementSegmentRef[] {
		const numElementSegments = BinaryenObj["_BinaryenGetNumElementSegments"](this.mod[PTR]);
		const tableName = UTF8ToString(BinaryenObj["_BinaryenTableGetName"](table));
		const ret = [];
		for (let i = 0; i < numElementSegments; i++) {
			const segment = BinaryenObj["_BinaryenGetElementSegmentByIndex"](this.mod[PTR], i);
			const elemTableName = UTF8ToString(BinaryenObj["_BinaryenElementSegmentGetTable"](segment));
			if (tableName === elemTableName) {
				ret.push(segment);
			}
		}
		return ret;
	}

	/** Gets the number of tables within the module. */
	count(): number {
		return BinaryenObj["_BinaryenGetNumTables"](this.mod[PTR]);
	}

	/** Removes a table by name. */
	remove(name: string): void {
		preserveStack(() => BinaryenObj["_BinaryenRemoveTable"](this.mod[PTR], strToStack(name)));
	}
}
