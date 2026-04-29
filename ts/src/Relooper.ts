import {BinaryenObj} from "./pre.ts";
import type {Module} from "./Module.ts";



export class Relooper {
	readonly ptr: number;

	constructor(module: Module) {
		this.ptr = BinaryenObj["_RelooperCreate"](module.ptr)
	}

	addBlock() {}

	addBranch() {}

	addBlockWithSwitch() {}

	addBranchForSwitch() {}

	renderAndDispose() {}
}
