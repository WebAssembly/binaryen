import {BinaryenObj} from "./pre.ts";



export class TypeBuilder {
	readonly ptr: number;

	constructor(size: number) {
		this.ptr = BinaryenObj["_TypeBuilderCreate"](size);
	}

	grow() {}

	getSize() {}

	setSignatureType() {}

	setStructType() {}

	setArrayType() {}

	getTempHeapType() {}

	getTempTupleType() {}

	getTempRefType() {}

	setSubType() {}

	setOpen() {}

	createRecGroup() {}

	buildAndDispose() {}
}
