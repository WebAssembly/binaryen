import {
	BinaryenObj,
	stackAlloc,
} from "../-pre.ts";
import {
	i8sToStack,
	i32sToStack,
	preserveStack,
} from "../-utils.ts";
import type {
	HeapType,
	PackedType,
	Type,
} from "../constants.ts";



/**
 * A field in a struct/array.
 * @inline
 */
type Field = {
	/** The type of the struct field. */
	readonly type: Type,
	/** The field’s packed type. */
	readonly packedType: PackedType,
	/** Is the field mutable? */
	readonly mutable: boolean,
};



export class TypeBuilder {
	readonly #ptr: number;

	constructor(size: number = 0) {
		this.#ptr = BinaryenObj["_TypeBuilderCreate"](size);
	}

	/**
	 * Grow the builder by the given number of types.
	 * @param count the number of slots to add
	 */
	grow(count: number): void {
		BinaryenObj["_TypeBuilderGrow"](this.#ptr, count);
	}

	/**
	 * @returns the number of types in the builder
	 */
	getSize(): number {
		return BinaryenObj["_TypeBuilderGetSize"](this.#ptr);
	}

	/**
	 * Add a function signature type
	 * @param index index of the type to add
	 * @param paramTypes function’s parameter types, as a multi-value type
	 * @param resultTypes function’s result types, as a multi-value type
	 */
	setSignatureType(index: number, paramTypes: Type, resultTypes: Type): void {
		BinaryenObj["_TypeBuilderSetSignatureType"](this.#ptr, index, paramTypes, resultTypes);
	}

	/**
	 * Add a struct type.
	 * @param index index of the type to add
	 * @param fields array of fields in the struct
	 */
	setStructType(index: number, fields: readonly Field[]): void {
		preserveStack(() => {
			const types = [];
			const packedTypes = [];
			const mutables = [];
			for (let i = 0; i < fields.length; i++) {
				const {type: typ, packedType, mutable} = fields[i];
				types[i] = typ;
				packedTypes[i] = packedType;
				mutables[i] = +mutable;
			}
			BinaryenObj["_TypeBuilderSetStructType"](
				this.#ptr,
				index,
				i32sToStack(types),
				i32sToStack(packedTypes),
				i8sToStack(mutables),
				fields.length,
			);
		});
	}

	/**
	 * Add an array type.
	 * @param index index of the type to add
	 * @param elementType type of element in the array
	 * @param elementPackedType packed type of elements
	 * @param elementMutable are array entries mutable?
	 */
	setArrayType(index: number, elementType: Type, elementPackedType: Type, elementMutable: boolean): void {
		BinaryenObj["_TypeBuilderSetArrayType"](this.#ptr, index, elementType, elementPackedType, elementMutable);
	}

	/**
	 * Retrieve a heap type from the builder, before disposal.
	 * @param index index of the type to get
	 * @returns the heap type at the given index
	 */
	getTempHeapType(index: number): HeapType {
		return BinaryenObj["_TypeBuilderGetTempHeapType"](this.#ptr, index);
	}

	/**
	 * Retrieve a tuple type.
	 * @param types types in the tuple
	 * @returns the tuple type
	 */
	getTempTupleType(types: readonly Type[]): Type {
		return preserveStack(() => BinaryenObj["_TypeBuilderGetTempTupleType"](this.#ptr, i32sToStack(types), types.length));
	}

	/**
	 * Generate a refence type from the given temporary heap type.
	 * @param heapType the heap type in the type builder to use
	 * @param nullable is the reference type nullable?
	 * @returns the reference type
	 */
	getTempRefType(heapType: HeapType, nullable: boolean): Type {
		return BinaryenObj["_TypeBuilderGetTempRefType"](this.#ptr, heapType, nullable);
	}

	/**
	 * Declare a type as a subtype of another.
	 * @param index the index of the type to set
	 * @param superType the supertype
	 */
	setSubType(index: number, superType: Type): void {
		BinaryenObj["_TypeBuilderSetSubType"](this.#ptr, index, superType);
	}

	/**
	 * Declare a type as “open”, i.e., not “final” (it may be extended/subtyped).
	 * @param index the index of the type to set
	 */
	setOpen(index: number): void {
		BinaryenObj["_TypeBuilderSetOpen"](this.#ptr, index);
	}

	/**
	 * Create a recursive group.
	 * @param index index in the builder to create the group
	 * @param length number of types in the group
	 */
	createRecGroup(index: number, length: number): void {
		BinaryenObj["_TypeBuilderCreateRecGroup"](this.#ptr, index, length);
	}

	/**
	 * Resolve any and all recursive types in the TypeBuilder and return their finalized forms.
	 * @returns list of finalized heap types in the builder
	 */
	buildAndDispose(): HeapType[] {
		return preserveStack(() => {
			const numTypes = this.getSize();
			const array = stackAlloc(numTypes << 2);
			if (!BinaryenObj["_TypeBuilderBuildAndDispose"](this.#ptr, array, 0, 0)) {
				throw new TypeError("TypeBuilder.buildAndDispose failed");
			}
			const types = new Array(numTypes);
			for (let i = 0; i < numTypes; i++) {
				types[i] = BinaryenObj.HEAPU32[(array >>> 2) + i];
			}
			return types;
		});
	}
}
