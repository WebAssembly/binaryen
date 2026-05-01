import {
	_free,
	_malloc,
	BinaryenObj,
	UTF8ToString,
} from "../../-pre.ts";
import {
	type DataSegmentRef,
	type ExpressionRef,
	type FunctionRef,
	type TableRef,
	type Type,
	funcref,
} from "../../constants.ts";
import {
	replacedBy,
} from "../../lib.ts";
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
	ModuleDataSegments,
} from "./DataSegment.ts";
import {
	ElementSegment,
	ModuleElementSegments,
} from "./ElementSegment.ts";
import {
	Export,
	ModuleExports,
} from "./Export.ts";
import {
	Function as BinaryenFunction,
	ModuleFunctions,
} from "./Function.ts";
import {
	Global,
	ModuleGlobals,
} from "./Global.ts";
import {
	ModuleImports,
} from "./Import.ts";
import {
	Memory,
} from "./Memory.ts";
import {
	Table,
	ModuleTables,
} from "./Table.ts";
import {
	Tag,
	ModuleTags,
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

	// ## Module Component Operations ## //
	// see https://webassembly.github.io/spec/core/syntax/modules.html
	tags = new ModuleTags(this);
	globals = new ModuleGlobals(this);
	tables = new ModuleTables(this);
	functions = new ModuleFunctions(this);
	dataSegments = new ModuleDataSegments(this);
	elementSegments = new ModuleElementSegments(this);
	imports = new ModuleImports(this);
	exports = new ModuleExports(this);

	/* eslint-disable @stylistic/brace-style */
	/** @deprecated Use `this.tags.add` instead. */ @replacedBy("`this.tags.add`") addTag(name: string, params: Type, results: Type) { return this.tags.add(name, params, results); }
	/** @deprecated Use `this.tags.get` instead. */ @replacedBy("`this.tags.get`") getTag(name: string) { return this.tags.get(name); }
	/** @deprecated Use `this.tags.remove` instead. */ @replacedBy("`this.tags.remove`") removeTag(name: string) { return this.tags.remove(name); }

	/** @deprecated Use `this.globals.add` instead. */ @replacedBy("`this.globals.add`") addGlobal(name: string, type: Type, mutable: boolean, init: ExpressionRef) { return this.globals.add(name, type, mutable, init); }
	/** @deprecated Use `this.globals.get` instead. */ @replacedBy("`this.globals.get`") getGlobal(name: string) { return this.globals.get(name); }
	/** @deprecated Use `this.globals.getByIndex` instead. */ @replacedBy("`this.globals.getByIndex`") getGlobalByIndex(index: number) { return this.globals.getByIndex(index); }
	/** @deprecated Use `this.globals.count` instead. */ @replacedBy("`this.globals.count`") getNumGlobals() { return this.globals.count(); }
	/** @deprecated Use `this.globals.remove` instead. */ @replacedBy("`this.globals.remove`") removeGlobal(name: string) { return this.globals.remove(name); }

	/** @deprecated Use `this.tables.add` instead. */ @replacedBy("`this.tables.add`") addTable(name: string, initial: number, maximum: number, type: Type = funcref, init?: ExpressionRef) { return this.tables.add(name, initial, maximum, type, init); }
	/** @deprecated Use `this.tables.get` instead. */ @replacedBy("`this.tables.get`") getTable(name: string) { return this.tables.get(name); }
	/** @deprecated Use `this.tables.getByIndex` instead. */ @replacedBy("`this.tables.getByIndex`") getTableByIndex(index: number) { return this.tables.getByIndex(index); }
	/** @deprecated Use `this.tables.getSegments` instead. */ @replacedBy("`this.tables.getSegments`") getTableSegments(table: TableRef) { return this.tables.getSegments(table); }
	/** @deprecated Use `this.tables.count` instead. */ @replacedBy("`this.tables.count`") getNumTables() { return this.tables.count(); }
	/** @deprecated Use `this.tables.remove` instead. */ @replacedBy("`this.tables.remove`") removeTable(name: string) { return this.tables.remove(name); }

	/** @deprecated Use `this.functions.add` instead. */ @replacedBy("`this.functions.add`") addFunction(name: string, params: Type, results: Type, varTypes: readonly Type[], body: ExpressionRef) { return this.functions.add(name, params, results, varTypes, body); }
	/** @deprecated Use `this.functions.get` instead. */ @replacedBy("`this.functions.get`") getFunction(name: string) { return this.functions.get(name); }
	/** @deprecated Use `this.functions.getByIndex` instead. */ @replacedBy("`this.functions.getByIndex`") getFunctionByIndex(index: number) { return this.functions.getByIndex(index); }
	/** @deprecated Use `this.functions.count` instead. */ @replacedBy("`this.functions.count`") getNumFunctions() { return this.functions.count(); }
	/** @deprecated Use `this.functions.remove` instead. */ @replacedBy("`this.functions.remove`") removeFunction(name: string) { return this.functions.remove(name); }

	/** @deprecated Use `this.dataSegments.get` instead. */ @replacedBy("`this.dataSegments.get`") getDataSegment(name: string) { return this.dataSegments.get(name); }
	/** @deprecated Use `this.dataSegments.getByIndex` instead. */ @replacedBy("`this.dataSegments.getByIndex`") getDataSegmentByIndex(index: number) { return this.dataSegments.getByIndex(index); }
	/** @deprecated Use `this.dataSegments.count` instead. */ @replacedBy("`this.dataSegments.count`") getNumDataSegments() { return this.dataSegments.count(); }

	/** @deprecated Use `this.elementSegments.addActive` instead. */ @replacedBy("`this.elementSegments.addActive`") addActiveElementSegment(table: string, name: string, funcNames: readonly string[], offset: ExpressionRef) { return this.elementSegments.addActive(table, name, funcNames, offset); }
	/** @deprecated Use `this.elementSegments.addPassive` instead. */ @replacedBy("`this.elementSegments.addPassive`") addPassiveElementSegment(name: string, funcNames: readonly string[]) { return this.elementSegments.addPassive(name, funcNames); }
	/** @deprecated Use `this.elementSegments.get` instead. */ @replacedBy("`this.elementSegments.get`") getElementSegment(name: string) { return this.elementSegments.get(name); }
	/** @deprecated Use `this.elementSegments.getByIndex` instead. */ @replacedBy("`this.elementSegments.getByIndex`") getElementSegmentByIndex(index: number) { return this.elementSegments.getByIndex(index); }
	/** @deprecated Use `this.elementSegments.count` instead. */ @replacedBy("`this.elementSegments.count`") getNumElementSegments() { return this.elementSegments.count(); }
	/** @deprecated Use `this.elementSegments.remove` instead. */ @replacedBy("`this.elementSegments.remove`") removeElementSegment(name: string) { return this.elementSegments.remove(name); }

	/** @deprecated Use `this.imports.addTag` instead. */ @replacedBy("`this.imports.addTag`") addTagImport(internalName: string, externalModuleName: string, externalBaseName: string, params: Type, results: Type) { return this.imports.addTag(internalName, externalModuleName, externalBaseName, params, results); }
	/** @deprecated Use `this.imports.addGlobal` instead. */ @replacedBy("`this.imports.addGlobal`") addGlobalImport(internalName: string, externalModuleName: string, externalBaseName: string, globalType: Type, mutable: boolean) { return this.imports.addGlobal(internalName, externalModuleName, externalBaseName, globalType, mutable); }
	/** @deprecated Use `this.imports.addMemory` instead. */ @replacedBy("`this.imports.addMemory`") addMemoryImport(internalName: string, externalModuleName: string, externalBaseName: string, shared: boolean) { return this.imports.addMemory(internalName, externalModuleName, externalBaseName, shared); }
	/** @deprecated Use `this.imports.addTable` instead. */ @replacedBy("`this.imports.addTable`") addTableImport(internalName: string, externalModuleName: string, externalBaseName: string) { return this.imports.addTable(internalName, externalModuleName, externalBaseName); }
	/** @deprecated Use `this.imports.addFunction` instead. */ @replacedBy("`this.imports.addFunction`") addFunctionImport(internalName: string, externalModuleName: string, externalBaseName: string, params: Type, results: Type) { return this.imports.addFunction(internalName, externalModuleName, externalBaseName, params, results); }

	/** @deprecated Use `this.exports.addTag` instead. */ @replacedBy("`this.exports.addTag`") addTagExport(internalName: string, externalName: string) { return this.exports.addTag(internalName, externalName); }
	/** @deprecated Use `this.exports.addGlobal` instead. */ @replacedBy("`this.exports.addGlobal`") addGlobalExport(internalName: string, externalName: string) { return this.exports.addGlobal(internalName, externalName); }
	/** @deprecated Use `this.exports.addMemory` instead. */ @replacedBy("`this.exports.addMemory`") addMemoryExport(internalName: string, externalName: string) { return this.exports.addMemory(internalName, externalName); }
	/** @deprecated Use `this.exports.addTable` instead. */ @replacedBy("`this.exports.addTable`") addTableExport(internalName: string, externalName: string) { return this.exports.addTable(internalName, externalName); }
	/** @deprecated Use `this.exports.addFunction` instead. */ @replacedBy("`this.exports.addFunction`") addFunctionExport(internalName: string, externalName: string) { return this.exports.addFunction(internalName, externalName); }
	/** @deprecated Use `this.exports.get` instead. */ @replacedBy("`this.exports.get`") getExport(externalName: string) { return this.exports.get(externalName); }
	/** @deprecated Use `this.exports.getByIndex` instead. */ @replacedBy("`this.exports.getByIndex`") getExportByIndex(index: number) { return this.exports.getByIndex(index); }
	/** @deprecated Use `this.exports.count` instead. */ @replacedBy("`this.exports.count`") getNumExports() { return this.exports.count(); }
	/** @deprecated Use `this.exports.remove` instead. */ @replacedBy("`this.exports.remove`") removeExport(externalName: string) { return this.exports.remove(externalName); }
	/* eslint-enable @stylistic/brace-style */

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

	getDataSegmentInfo(segment: DataSegmentRef): DataSegment {
		return new DataSegment(this, segment);
	}

	getStart(): FunctionRef {
		return BinaryenObj["_BinaryenGetStart"](this.ptr);
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
