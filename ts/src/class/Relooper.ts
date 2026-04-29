import {BinaryenObj} from "../-pre.ts";
import type {Module} from "./Module.ts";



export class Relooper {
	readonly ptr: number;

	constructor(mod: Module) {
		this.ptr = BinaryenObj["_RelooperCreate"](mod.ptr)
	}

	addBlock() {}

	addBranch() {}

	addBlockWithSwitch() {}

	addBranchForSwitch() {}

	renderAndDispose() {}
}
