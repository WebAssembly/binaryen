import {
	_free,
	_malloc,
	BinaryenObj,
	UTF8ToString,
} from "../../-pre.ts";
import {
	type DataSegmentRef,
	type ElementSegmentRef,
	type ExportRef,
	type ExpressionRef,
	type FunctionRef,
	type GlobalRef,
	type TableRef,
	type TagRef,
	type Type,
	funcref,
} from "../../constants.ts";
import {
	HEAP8,
	i32sToStack,
	preserveStack,
	strToStack,
} from "../../utils.ts";
import {
	block,
} from "../expression/Block.ts";
import {
	localGet,
} from "../expression/LocalGet.ts";
import {
	localSet,
	localTee,
} from "../expression/LocalSet.ts";
import {
	DataSegment,
} from "./DataSegment.ts";
import {
	ElementSegment,
} from "./ElementSegment.ts";
import {
	Export,
} from "./Export.ts";
import {
	Function as BinaryenFunction,
} from "./Function.ts";
import {
	Global,
} from "./Global.ts";
import {
	Memory,
} from "./Memory.ts";
import {
	Table,
} from "./Table.ts";
import {
	Tag,
} from "./Tag.ts";



/** Similar to a `DataSegment` but with some minor differences. */
interface MemorySegment {
	name?: string;
	offset: ExpressionRef;
	data: Uint8Array;
	passive: boolean;
}



/**
 * The size of a single literal in memory as used in Const creation,
 * which is a little different: we don’t want users to need to make
 * their own Literals, as the C API handles them by value, which means
 * we would leak them. Instead, Const creation is fused together with
 * an intermediate stack allocation of this size to pass the value.
 */
// eslint-disable-next-line @typescript-eslint/no-unused-vars
const SIZE_OF_LITERAL = BinaryenObj["_BinaryenSizeofLiteral"]();



export enum Feature {
	MVP = BinaryenObj["_BinaryenFeatureMVP"](),
	Atomics = BinaryenObj["_BinaryenFeatureAtomics"](),
	MutableGlobals = BinaryenObj["_BinaryenFeatureMutableGlobals"](),
	NontrappingFPToInt = BinaryenObj["_BinaryenFeatureNontrappingFPToInt"](),
	SIMD128 = BinaryenObj["_BinaryenFeatureSIMD128"](),
	BulkMemory = BinaryenObj["_BinaryenFeatureBulkMemory"](),
	SignExt = BinaryenObj["_BinaryenFeatureSignExt"](),
	ExceptionHandling = BinaryenObj["_BinaryenFeatureExceptionHandling"](),
	TailCall = BinaryenObj["_BinaryenFeatureTailCall"](),
	ReferenceTypes = BinaryenObj["_BinaryenFeatureReferenceTypes"](),
	Multivalue = BinaryenObj["_BinaryenFeatureMultivalue"](),
	GC = BinaryenObj["_BinaryenFeatureGC"](),
	Memory64 = BinaryenObj["_BinaryenFeatureMemory64"](),
	RelaxedSIMD = BinaryenObj["_BinaryenFeatureRelaxedSIMD"](),
	ExtendedConst = BinaryenObj["_BinaryenFeatureExtendedConst"](),
	Strings = BinaryenObj["_BinaryenFeatureStrings"](),
	MultiMemory = BinaryenObj["_BinaryenFeatureMultiMemory"](),
	StackSwitching = BinaryenObj["_BinaryenFeatureStackSwitching"](),
	SharedEverything = BinaryenObj["_BinaryenFeatureSharedEverything"](),
	FP16 = BinaryenObj["_BinaryenFeatureFP16"](),
	BulkMemoryOpt = BinaryenObj["_BinaryenFeatureBulkMemoryOpt"](),
	CallIndirectOverlong = BinaryenObj["_BinaryenFeatureCallIndirectOverlong"](),
	RelaxedAtomics = BinaryenObj["_BinaryenFeatureRelaxedAtomics"](),
	CustomPageSizes = BinaryenObj["_BinaryenFeatureCustomPageSizes"](),
	WideArithmetic = BinaryenObj["_BinaryenFeatureWideArithmetic"](),
	All = BinaryenObj["_BinaryenFeatureAll"](),
}
/** @deprecated Enum name is now singular. */
export const Features = Feature;



export class Module {
	static Tag = Tag;
	static Global = Global;
	static Memory = Memory;
	static Table = Table;
	static Function = BinaryenFunction;
	static DataSegment = DataSegment;
	static ElementSegment = ElementSegment;
	static Export = Export;


	readonly ptr: number = BinaryenObj["_BinaryenModuleCreate"]();

	// ## Expression Creation ## //
	// ### Control Instructions ### //
	block = block;

	// ### Variable Instructions ### //
	get local() {
		return {
			get: localGet.bind(this),
			set: localSet.bind(this),
			tee: localTee.bind(this),
		};
	}

	// ## Module Operations ## //
	// see https://webassembly.github.io/spec/core/syntax/modules.html

	// ### Tags ### //
	// TODO: move these to the Tag class
	addTag(name: string, params: Type, results: Type): TagRef {
		return preserveStack(() => BinaryenObj["_BinaryenAddTag"](this.ptr, strToStack(name), params, results));
	}

	getTag(name: string): TagRef {
		return preserveStack(() => BinaryenObj["_BinaryenGetTag"](this.ptr, strToStack(name)));
	}

	removeTag(name: string): void {
		return preserveStack(() => {
			BinaryenObj["_BinaryenRemoveTag"](this.ptr, strToStack(name));
		});
	}

	// ### Globals ### //
	// TODO: move these to the Global class
	addGlobal(name: string, type: Type, mutable: boolean, init: ExpressionRef): GlobalRef {
		return preserveStack(() => BinaryenObj["_BinaryenAddGlobal"](this.ptr, strToStack(name), type, mutable, init));
	}

	getGlobal(name: string): GlobalRef {
		return preserveStack(() => BinaryenObj["_BinaryenGetGlobal"](this.ptr, strToStack(name)));
	}

	getGlobalByIndex(index: number): GlobalRef {
		return BinaryenObj["_BinaryenGetGlobalByIndex"](this.ptr, index);
	}

	getNumGlobals(): number {
		return BinaryenObj["_BinaryenGetNumGlobals"](this.ptr);
	}

	removeGlobal(name: string): void {
		return preserveStack(() => {
			BinaryenObj["_BinaryenRemoveGlobal"](this.ptr, strToStack(name));
		});
	}

	// ### Memories ### //
	setMemory(
		initial: number,
		maximum: number,
		exportName: string,
		segments: readonly MemorySegment[] = [],
		shared: boolean = false,
		memory64: boolean = false,
		internalName?: string,
	): void {
		return preserveStack(() => {
			const names: number[] = [];
			const datas: number[] = [];
			const passives: number[] = [];
			const offsets: number[] = [];
			const lengths: number[] = [];
			for (let i = 0; i < segments.length; i++) {
				const {name, data, passive, offset} = segments[i];
				names[i] = strToStack(name);
				datas[i] = _malloc(data.length);
				passives[i] = Number(passive);
				offsets[i] = offset;
				HEAP8.set(data, datas[i]);
				lengths[i] = data.length;
			}
			BinaryenObj["_BinaryenSetMemory"](
				this.ptr,
				initial,
				maximum,
				strToStack(exportName),
				i32sToStack(names),
				i32sToStack(datas),
				i32sToStack(passives),
				i32sToStack(offsets),
				i32sToStack(lengths),
				segments.length,
				shared,
				memory64,
				strToStack(internalName),
			);
			for (const dataptr of datas) {
				_free(dataptr);
			}
		});
	}

	hasMemory(): boolean {
		return Boolean(BinaryenObj["_BinaryenHasMemory"](this.ptr));
	}

	getMemoryInfo(name: string): Memory {
		return new Memory(this, name);
	}

	// ### Tables ### //
	// TODO: move these to the Table class
	addTable(name: string, initial: number, maximum: number, type: Type = funcref, init?: ExpressionRef): TableRef {
		return preserveStack(() => BinaryenObj["_BinaryenAddTable"](this.ptr, strToStack(name), initial, maximum, type, init ?? 0));
	}

	getTable(name: string): TableRef {
		return preserveStack(() => BinaryenObj["_BinaryenGetTable"](this.ptr, strToStack(name)));
	}

	getTableByIndex(index: number): TableRef {
		return BinaryenObj["_BinaryenGetTableByIndex"](this.ptr, index);
	}

	getNumTables(): number {
		return BinaryenObj["_BinaryenGetNumTables"](this.ptr);
	}

	getTableSegments(table: TableRef): ElementSegmentRef[] {
		const numElementSegments = BinaryenObj["_BinaryenGetNumElementSegments"](this.ptr);
		const tableName = UTF8ToString(BinaryenObj["_BinaryenTableGetName"](table));
		const ret = [];
		for (let i = 0; i < numElementSegments; i++) {
			const segment = BinaryenObj["_BinaryenGetElementSegmentByIndex"](this.ptr, i);
			const elemTableName = UTF8ToString(BinaryenObj["_BinaryenElementSegmentGetTable"](segment));
			if (tableName === elemTableName) {
				ret.push(segment);
			}
		}
		return ret;
	}

	removeTable(name: string): void {
		return preserveStack(() => {
			BinaryenObj["_BinaryenRemoveTable"](this.ptr, strToStack(name));
		});
	}

	// ### Functions ### //
	// TODO: move these to the Function class
	addFunction(name: string, params: Type, results: Type, varTypes: readonly Type[], body: ExpressionRef): FunctionRef {
		return preserveStack(() => BinaryenObj["_BinaryenAddFunction"](
			this.ptr,
			strToStack(name),
			params,
			results,
			i32sToStack(varTypes),
			varTypes.length,
			body,
		));
	}

	getFunction(name: string): FunctionRef {
		return preserveStack(() => BinaryenObj["_BinaryenGetFunction"](this.ptr, strToStack(name)));
	}

	removeFunction(name: string): void {
		return preserveStack(() => {
			BinaryenObj["_BinaryenRemoveFunction"](this.ptr, strToStack(name));
		});
	}

	getNumFunctions(): number {
		return BinaryenObj["_BinaryenGetNumFunctions"](this.ptr);
	}

	getFunctionByIndex(index: number): FunctionRef {
		return BinaryenObj["_BinaryenGetFunctionByIndex"](this.ptr, index);
	}

	// ### Data Segments ### //
	getDataSegment(name: string): DataSegmentRef {
		return preserveStack(() => BinaryenObj["_BinaryenGetDataSegment"](this.ptr, strToStack(name)));
	}

	getDataSegmentByIndex(index: number): DataSegmentRef {
		return BinaryenObj["_BinaryenGetDataSegmentByIndex"](this.ptr, index);
	}

	getNumDataSegments(): number {
		return BinaryenObj["_BinaryenGetNumDataSegments"](this.ptr);
	}

	getDataSegmentInfo(segment: DataSegmentRef): DataSegment {
		return new DataSegment(this, segment);
	}

	// ### Element Segments ### //
	// TODO: move these to the ElementSegment class
	addActiveElementSegment(table: string, name: string, funcNames: readonly string[], offset: ExpressionRef): ElementSegmentRef {
		return preserveStack(() => BinaryenObj["_BinaryenAddActiveElementSegment"](
			this.ptr,
			strToStack(table),
			strToStack(name),
			i32sToStack(funcNames.map(strToStack)),
			funcNames.length,
			offset,
		));
	}

	addPassiveElementSegment(name: string, funcNames: readonly string[]): ElementSegmentRef {
		return preserveStack(() => BinaryenObj["_BinaryenAddPassiveElementSegment"](
			this.ptr,
			strToStack(name),
			i32sToStack(funcNames.map(strToStack)),
			funcNames.length,
		));
	}

	getElementSegment(name: string): ElementSegmentRef {
		return preserveStack(() => BinaryenObj["_BinaryenGetElementSegment"](this.ptr, strToStack(name)));
	}

	getElementSegmentByIndex(index: number): ElementSegmentRef {
		return BinaryenObj["_BinaryenGetElementSegmentByIndex"](this.ptr, index);
	}

	getNumElementSegments(): number {
		return BinaryenObj["_BinaryenGetNumElementSegments"](this.ptr);
	}

	removeElementSegment(name: string): void {
		return preserveStack(() => {
			BinaryenObj["_BinaryenRemoveElementSegment"](this.ptr, strToStack(name));
		});
	}

	// ### Start Function ### //
	getStart(): FunctionRef {
		return BinaryenObj["_BinaryenGetStart"](this.ptr);
	}

	// ### Imports ### //
	addTagImport(internalName: string, externalModuleName: string, externalBaseName: string, params: Type, results: Type): void {
		return preserveStack(() => {
			BinaryenObj["_BinaryenAddTagImport"](
				this.ptr,
				strToStack(internalName),
				strToStack(externalModuleName),
				strToStack(externalBaseName),
				params,
				results,
			);
		});
	}

	addGlobalImport(internalName: string, externalModuleName: string, externalBaseName: string, globalType: Type, mutable: boolean): void {
		return preserveStack(() => {
			BinaryenObj["_BinaryenAddGlobalImport"](
				this.ptr,
				strToStack(internalName),
				strToStack(externalModuleName),
				strToStack(externalBaseName),
				globalType,
				mutable,
			);
		});
	}

	addMemoryImport(internalName: string, externalModuleName: string, externalBaseName: string, shared: boolean): void {
		return preserveStack(() => {
			BinaryenObj["_BinaryenAddMemoryImport"](
				this.ptr,
				strToStack(internalName),
				strToStack(externalModuleName),
				strToStack(externalBaseName),
				shared,
			);
		});
	}

	addTableImport(internalName: string, externalModuleName: string, externalBaseName: string): void {
		return preserveStack(() => {
			BinaryenObj["_BinaryenAddTableImport"](
				this.ptr,
				strToStack(internalName),
				strToStack(externalModuleName),
				strToStack(externalBaseName),
			);
		});
	}

	addFunctionImport(internalName: string, externalModuleName: string, externalBaseName: string, params: Type, results: Type): void {
		return preserveStack(() => {
			BinaryenObj["_BinaryenAddFunctionImport"](
				this.ptr,
				strToStack(internalName),
				strToStack(externalModuleName),
				strToStack(externalBaseName),
				params,
				results,
			);
		});
	}

	// ### Exports ### //
	addTagExport(internalName: string, externalName: string): ExportRef {
		return preserveStack(() => BinaryenObj["_BinaryenAddTagExport"](this.ptr, strToStack(internalName), strToStack(externalName)));
	}

	addGlobalExport(internalName: string, externalName: string): ExportRef {
		return preserveStack(() => BinaryenObj["_BinaryenAddGlobalExport"](this.ptr, strToStack(internalName), strToStack(externalName)));
	}

	addMemoryExport(internalName: string, externalName: string): ExportRef {
		return preserveStack(() => BinaryenObj["_BinaryenAddMemoryExport"](this.ptr, strToStack(internalName), strToStack(externalName)));
	}

	addTableExport(internalName: string, externalName: string): ExportRef {
		return preserveStack(() => BinaryenObj["_BinaryenAddTableExport"](this.ptr, strToStack(internalName), strToStack(externalName)));
	}

	addFunctionExport(internalName: string, externalName: string): ExportRef {
		return preserveStack(() => BinaryenObj["_BinaryenAddFunctionExport"](this.ptr, strToStack(internalName), strToStack(externalName)));
	}

	getExport(externalName: string): ExportRef {
		return preserveStack(() => BinaryenObj["_BinaryenGetExport"](this.ptr, strToStack(externalName)));
	}

	getNumExports(): number {
		return BinaryenObj["_BinaryenGetNumExports"](this.ptr);
	}

	getExportByIndex(index: number): ExportRef {
		return BinaryenObj["_BinaryenGetExportByIndex"](this.ptr, index);
	}

	removeExport(externalName: string): void {
		return preserveStack(() => {
			BinaryenObj["_BinaryenRemoveExport"](this.ptr, strToStack(externalName));
		});
	}

	// ## Binaryen Operations ## //
	emitText(): string {
		const textPtr = BinaryenObj["_BinaryenModuleAllocateAndWriteText"](this.ptr);
		const text = UTF8ToString(textPtr);
		if (textPtr) {
			_free(textPtr);
		}
		return text;
	}

	emitStackIR() {}

	emitAsmjs() {}

	emitBinary() {}

	getFeatures() {}

	setFeatures() {}

	setTypeName() {}

	setFieldName() {}

	addCustomSection() {}

	interpret() {}

	validate() {}

	optimize() {}

	optimizeFunction() {}

	updateMaps() {}

	runPasses() {}

	runPassesOnFunction() {}

	dispose() {}

	addDebugInfoFileName() {}

	getDebugInfoFileName() {}

	setDebugLocation() {}

	copyExpression() {}
}
