import {
	BinaryenObj,
} from "../-pre.ts";



export class TypeBuilder {
	// eslint-disable-next-line no-unused-private-class-members
	readonly #ptr: number;

	constructor(size: number) {
		this.#ptr = BinaryenObj["_TypeBuilderCreate"](size);
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
