import {
	BinaryenObj,
	UTF8ToString,
} from "../../-pre.ts";
import type {
	TagRef,
	Type,
} from "../../constants.ts";
import {
	preserveStack,
	strToStack,
} from "../../utils.ts";
import type {
	Module,
} from "./Module.ts";



/**
 * Information about a tag in a WASM module.
 */
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



/**
 * Methods for manipulating tags in a WASM module.
 * @inline
 */
export class ModuleTags {
	constructor(private readonly mod: Module) {}

	/** Adds a tag. */
	add(name: string, params: Type, results: Type): TagRef {
		return preserveStack(() => BinaryenObj["_BinaryenAddTag"](this.mod.ptr, strToStack(name), params, results));
	}

	/** Gets a tag by name. */
	get(name: string): TagRef {
		return preserveStack(() => BinaryenObj["_BinaryenGetTag"](this.mod.ptr, strToStack(name)));
	}

	/** Removes a tag by name. */
	remove(name: string): void {
		return preserveStack(() => {
			BinaryenObj["_BinaryenRemoveTag"](this.mod.ptr, strToStack(name));
		});
	}
}
