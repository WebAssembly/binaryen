import type {
	TableRef,
} from "../constants.ts";
import {
	THIS_PTR,
} from "../utils.ts";



export class Table {
	// TODO: static methods are deprecated; convert to instance and log warnings
	static getName() {}
	static setName() {}
	static getInitial() {}
	static setInitial() {}
	static hasMax() {}
	static getMax() {}
	static setMax() {}
	static getType() {}
	static setType() {}


	private readonly [THIS_PTR]: TableRef;

	constructor(table: TableRef) {
		this[THIS_PTR] = table;
	}

	valueOf() {
		return this[THIS_PTR];
	}
}
