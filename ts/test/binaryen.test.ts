import * as assert from "node:assert";
import {
	suite,
	test,
} from "node:test";
import * as binaryen from "../src/binaryen.ts";



suite("binaryen", () => {
	test("[internal] Emscripten artifacts exist.", async () => {
		const __pre = await import("../src/-pre.ts");
		assert.ok(__pre.BinaryenObj);
		assert.ok(__pre._malloc);
		assert.ok(__pre._free);
		assert.ok(__pre.HEAP8);
		assert.ok(__pre.HEAPU8);
		assert.ok(__pre.HEAP32);
		assert.ok(__pre.HEAPU32);
		assert.ok(__pre.stackSave);
		assert.ok(__pre.stackRestore);
		assert.ok(__pre.stackAlloc);
		assert.ok(__pre.UTF8ToString);
		assert.ok(__pre.stringToAscii);
		assert.ok(__pre.stringToUTF8OnStack);
		assert.ok(__pre.getExceptionMessage);
	});


	test("namespace exists and has all the right top-level exports.", () => {
		assert.ok(binaryen);

		// constants
		assert.ok(binaryen.unreachable);
		assert.ok("none" in binaryen);
		assert.ok(binaryen.auto);
		assert.ok(binaryen.i32);
		assert.ok(binaryen.i64);
		assert.ok(binaryen.f32);
		assert.ok(binaryen.f64);
		assert.ok(binaryen.v128);
		assert.ok(binaryen.anyref);
		assert.ok(binaryen.eqref);
		assert.ok(binaryen.i31ref);
		assert.ok(binaryen.structref);
		assert.ok(binaryen.arrayref);
		assert.ok(binaryen.funcref);
		// @ts-expect-error
		assert.ok(!binaryen.exnref);
		assert.ok(binaryen.externref);
		assert.ok(binaryen.nullref);
		assert.ok(binaryen.nullfuncref);
		// @ts-expect-error
		assert.ok(!binaryen.nullexnref);
		assert.ok(binaryen.nullexternref);
		assert.strictEqual(binaryen.notPacked, 0);
		assert.ok(binaryen.i8);
		assert.ok(binaryen.i16);
		assert.ok(binaryen.stringref);

		// enums
		assert.strictEqual(typeof binaryen.ExpressionId, "object");
		assert.strictEqual(typeof binaryen.SideEffect, "object");
		assert.strictEqual(typeof binaryen.ExternalKind, "object");
		assert.strictEqual(typeof binaryen.Operation, "object");
		assert.strictEqual(typeof binaryen.MemoryOrder, "object");
		assert.strictEqual(typeof binaryen.Feature, "object");
		assert.strictEqual(typeof binaryen.ExpressionRunnerFlag, "object");

		// functions
		assert.strictEqual(typeof binaryen.emitText, "function");
		assert.strictEqual(typeof binaryen.readBinary, "function");
		assert.strictEqual(typeof binaryen.readBinaryWithFeatures, "function");
		assert.strictEqual(typeof binaryen.parseText, "function");
		assert.strictEqual(typeof binaryen.exit, "function");
		assert.strictEqual(typeof binaryen.createType, "function");
		assert.strictEqual(typeof binaryen.expandType, "function");
		assert.strictEqual(typeof binaryen.getTypeFromHeapType, "function");
		assert.strictEqual(typeof binaryen.getHeapType, "function");
		assert.strictEqual(typeof binaryen.getExpressionId, "function");
		assert.strictEqual(typeof binaryen.getExpressionType, "function");
		assert.strictEqual(typeof binaryen.getExpressionInfo, "function");
		assert.ok(binaryen.emitText.toString().startsWith("function"));
		assert.ok(binaryen.readBinary.toString().startsWith("function"));
		assert.ok(binaryen.readBinaryWithFeatures.toString().startsWith("function"));
		assert.ok(binaryen.parseText.toString().startsWith("function"));
		assert.ok(binaryen.exit.toString().startsWith("function"));
		assert.ok(binaryen.createType.toString().startsWith("function"));
		assert.ok(binaryen.expandType.toString().startsWith("function"));
		assert.ok(binaryen.getTypeFromHeapType.toString().startsWith("function"));
		assert.ok(binaryen.getHeapType.toString().startsWith("function"));
		assert.ok(binaryen.getExpressionId.toString().startsWith("function"));
		assert.ok(binaryen.getExpressionType.toString().startsWith("function"));
		assert.ok(binaryen.getExpressionInfo.toString().startsWith("function"));

		// classes
		assert.strictEqual(typeof binaryen.Module, "function");
		assert.strictEqual(typeof binaryen.TypeBuilder, "function");
		assert.strictEqual(typeof binaryen.ExpressionRunner, "function");
		assert.strictEqual(typeof binaryen.Relooper, "function");
		assert.ok(binaryen.Module.toString().startsWith("class"));
		assert.ok(binaryen.TypeBuilder.toString().startsWith("class"));
		assert.ok(binaryen.ExpressionRunner.toString().startsWith("class"));
		assert.ok(binaryen.Relooper.toString().startsWith("class"));

		// other
		assert.ok(binaryen.settings);
		assert.ok(binaryen.expressions);
	});


	test("types.", () => {
		assert.strictEqual(binaryen.auto, -1);
		assert.strictEqual(binaryen.none, 0);
		assert.strictEqual(binaryen.unreachable, 1);
		assert.strictEqual(binaryen.i32, 2);
		assert.strictEqual(binaryen.i64, 3);
		assert.strictEqual(binaryen.f32, 4);
		assert.strictEqual(binaryen.f64, 5);
		assert.strictEqual(binaryen.v128, 6);
		assert.strictEqual(binaryen.anyref, 0x22);
		assert.strictEqual(binaryen.eqref, 0x2a);
		assert.strictEqual(binaryen.i31ref, 0x32);
		assert.strictEqual(binaryen.structref, 0x3a);
		assert.strictEqual(binaryen.arrayref, 0x42);
		assert.strictEqual(binaryen.funcref, 0x12);
		// @ts-expect-error
		assert.strictEqual(binaryen.exnref, undefined);
		assert.strictEqual(binaryen.externref, 0x0a);
		assert.strictEqual(binaryen.nullref, 0x5a);
		assert.strictEqual(binaryen.nullfuncref, 0x6a);
		// @ts-expect-error
		assert.strictEqual(binaryen.nullexnref, undefined);
		assert.strictEqual(binaryen.nullexternref, 0x62);
		assert.strictEqual(binaryen.notPacked, 0);
		assert.strictEqual(binaryen.i8, 1);
		assert.strictEqual(binaryen.i16, 2);
		assert.strictEqual(binaryen.stringref, 0x52);

		const i32_pair = binaryen.createType([binaryen.i32, binaryen.i32]);
		const duplicate_pair = binaryen.createType([binaryen.i32, binaryen.i32]);
		assert.strictEqual(binaryen.expandType(i32_pair).toString(), "2,2");
		assert.strictEqual(binaryen.expandType(duplicate_pair).toString(), "2,2");
		assert.strictEqual(i32_pair, duplicate_pair);

		assert.strictEqual(binaryen.expandType(binaryen.createType([binaryen.f32, binaryen.f32])).toString(), "4,4");
	});


	test(".Feature", () => {
		// NOTE: the length is twice the number of members due to how TypeScript emits enums.
		assert.strictEqual(Object.entries(binaryen.Feature).length, 52);

		assert.strictEqual(binaryen.Feature.MVP, 0);
		assert.strictEqual(binaryen.Feature.Atomics, 1 << 0);
		assert.strictEqual(binaryen.Feature.MutableGlobals, 1 << 1);
		assert.strictEqual(binaryen.Feature.NontrappingFPToInt, 1 << 2);
		assert.strictEqual(binaryen.Feature.SIMD128, 1 << 3);
		assert.strictEqual(binaryen.Feature.BulkMemory, 1 << 4);
		assert.strictEqual(binaryen.Feature.SignExt, 1 << 5);
		assert.strictEqual(binaryen.Feature.ExceptionHandling, 1 << 6);
		assert.strictEqual(binaryen.Feature.TailCall, 1 << 7);
		assert.strictEqual(binaryen.Feature.ReferenceTypes, 1 << 8);
		assert.strictEqual(binaryen.Feature.Multivalue, 1 << 9);
		assert.strictEqual(binaryen.Feature.GC, 1 << 10);
		assert.strictEqual(binaryen.Feature.Memory64, 1 << 11);
		assert.strictEqual(binaryen.Feature.RelaxedSIMD, 1 << 12);
		assert.strictEqual(binaryen.Feature.ExtendedConst, 1 << 13);
		assert.strictEqual(binaryen.Feature.Strings, 1 << 14);
		assert.strictEqual(binaryen.Feature.MultiMemory, 1 << 15);
		assert.strictEqual(binaryen.Feature.StackSwitching, 1 << 16);
		assert.strictEqual(binaryen.Feature.SharedEverything, 1 << 17);
		assert.strictEqual(binaryen.Feature.FP16, 1 << 18);
		assert.strictEqual(binaryen.Feature.BulkMemoryOpt, 1 << 19);
		assert.strictEqual(binaryen.Feature.CallIndirectOverlong, 1 << 20);
		// @ts-expect-error
		assert.strictEqual(binaryen.Feature.CustomDescriptors, undefined); assert.notStrictEqual(binaryen.Feature.CustomDescriptors, 1 << 21);
		assert.strictEqual(binaryen.Feature.RelaxedAtomics, 1 << 22);
		assert.strictEqual(binaryen.Feature.CustomPageSizes, 1 << 23);
		// @ts-expect-error
		assert.strictEqual(binaryen.Feature.Multibyte, undefined); assert.notStrictEqual(binaryen.Feature.Multibyte, 1 << 24);
		assert.strictEqual(binaryen.Feature.WideArithmetic, 1 << 25);
		assert.strictEqual(binaryen.Feature.All, (1 << 26) - 1);
	});


	test(".ExpressionId", () => {
		// NOTE: the length is twice the number of members due to how TypeScript emits enums.
		assert.strictEqual(Object.entries(binaryen.ExpressionId).length, 170);

		assert.strictEqual(binaryen.ExpressionId.Invalid, 0);
		assert.strictEqual(binaryen.ExpressionId.Block, 1);
		assert.strictEqual(binaryen.ExpressionId.If, 2);
		assert.strictEqual(binaryen.ExpressionId.Loop, 3);
		assert.strictEqual(binaryen.ExpressionId.Break, 4);
		assert.strictEqual(binaryen.ExpressionId.Switch, 5);
		assert.strictEqual(binaryen.ExpressionId.Call, 6);
		assert.strictEqual(binaryen.ExpressionId.CallIndirect, 7);
		assert.strictEqual(binaryen.ExpressionId.LocalGet, 8);
		assert.strictEqual(binaryen.ExpressionId.LocalSet, 9);
		assert.strictEqual(binaryen.ExpressionId.GlobalGet, 10);
		assert.strictEqual(binaryen.ExpressionId.GlobalSet, 11);
		assert.strictEqual(binaryen.ExpressionId.Load, 12);
		assert.strictEqual(binaryen.ExpressionId.Store, 13);
		assert.strictEqual(binaryen.ExpressionId.Const, 14);
		assert.strictEqual(binaryen.ExpressionId.Unary, 15);
		assert.strictEqual(binaryen.ExpressionId.Binary, 16);
		assert.strictEqual(binaryen.ExpressionId.Select, 17);
		assert.strictEqual(binaryen.ExpressionId.Drop, 18);
		assert.strictEqual(binaryen.ExpressionId.Return, 19);
		assert.strictEqual(binaryen.ExpressionId.MemorySize, 20);
		assert.strictEqual(binaryen.ExpressionId.MemoryGrow, 21);
		assert.strictEqual(binaryen.ExpressionId.Nop, 22);
		assert.strictEqual(binaryen.ExpressionId.Unreachable, 23);
		assert.strictEqual(binaryen.ExpressionId.AtomicRMW, 24);
		assert.strictEqual(binaryen.ExpressionId.AtomicCmpxchg, 25);
		assert.strictEqual(binaryen.ExpressionId.AtomicWait, 26);
		assert.strictEqual(binaryen.ExpressionId.AtomicNotify, 27);
		assert.strictEqual(binaryen.ExpressionId.AtomicFence, 28);
		// @ts-expect-error
		assert.strictEqual(binaryen.ExpressionId.Pause, undefined); assert.notStrictEqual(binaryen.ExpressionId.Pause, 29);
		assert.strictEqual(binaryen.ExpressionId.SIMDExtract, 30);
		assert.strictEqual(binaryen.ExpressionId.SIMDReplace, 31);
		assert.strictEqual(binaryen.ExpressionId.SIMDShuffle, 32);
		assert.strictEqual(binaryen.ExpressionId.SIMDTernary, 33);
		assert.strictEqual(binaryen.ExpressionId.SIMDShift, 34);
		assert.strictEqual(binaryen.ExpressionId.SIMDLoad, 35);
		assert.strictEqual(binaryen.ExpressionId.SIMDLoadStoreLane, 36);
		assert.strictEqual(binaryen.ExpressionId.MemoryInit, 37);
		assert.strictEqual(binaryen.ExpressionId.DataDrop, 38);
		assert.strictEqual(binaryen.ExpressionId.MemoryCopy, 39);
		assert.strictEqual(binaryen.ExpressionId.MemoryFill, 40);
		assert.strictEqual(binaryen.ExpressionId.Pop, 41);
		assert.strictEqual(binaryen.ExpressionId.RefNull, 42);
		assert.strictEqual(binaryen.ExpressionId.RefIsNull, 43);
		assert.strictEqual(binaryen.ExpressionId.RefFunc, 44);
		assert.strictEqual(binaryen.ExpressionId.RefEq, 45);
		assert.strictEqual(binaryen.ExpressionId.TableGet, 46);
		assert.strictEqual(binaryen.ExpressionId.TableSet, 47);
		assert.strictEqual(binaryen.ExpressionId.TableSize, 48);
		assert.strictEqual(binaryen.ExpressionId.TableGrow, 49);
		// @ts-expect-error
		assert.strictEqual(binaryen.ExpressionId.TableFill, undefined); assert.notStrictEqual(binaryen.ExpressionId.TableFill, 50);
		// @ts-expect-error
		assert.strictEqual(binaryen.ExpressionId.TableCopy, undefined); assert.notStrictEqual(binaryen.ExpressionId.TableCopy, 51);
		// @ts-expect-error
		assert.strictEqual(binaryen.ExpressionId.TableInit, undefined); assert.notStrictEqual(binaryen.ExpressionId.TableInit, 52);
		// @ts-expect-error
		assert.strictEqual(binaryen.ExpressionId.ElemDrop, undefined); assert.notStrictEqual(binaryen.ExpressionId.ElemDrop, 53);
		assert.strictEqual(binaryen.ExpressionId.Try, 54);
		// @ts-expect-error
		assert.strictEqual(binaryen.ExpressionId.TryTable, undefined); assert.notStrictEqual(binaryen.ExpressionId.TryTable, 55);
		assert.strictEqual(binaryen.ExpressionId.Throw, 56);
		assert.strictEqual(binaryen.ExpressionId.Rethrow, 57);
		// @ts-expect-error
		assert.strictEqual(binaryen.ExpressionId.ThrowRef, undefined); assert.notStrictEqual(binaryen.ExpressionId.ThrowRef, 58);
		assert.strictEqual(binaryen.ExpressionId.TupleMake, 59);
		assert.strictEqual(binaryen.ExpressionId.TupleExtract, 60);
		assert.strictEqual(binaryen.ExpressionId.RefI31, 61);
		assert.strictEqual(binaryen.ExpressionId.I31Get, 62);
		assert.strictEqual(binaryen.ExpressionId.CallRef, 63);
		assert.strictEqual(binaryen.ExpressionId.RefTest, 64);
		assert.strictEqual(binaryen.ExpressionId.RefCast, 65);
		// @ts-expect-error
		assert.strictEqual(binaryen.ExpressionId.RefGetDesc, undefined); assert.notStrictEqual(binaryen.ExpressionId.RefGetDesc, 66);
		assert.strictEqual(binaryen.ExpressionId.BrOn, 67);
		assert.strictEqual(binaryen.ExpressionId.StructNew, 68);
		assert.strictEqual(binaryen.ExpressionId.StructGet, 69);
		assert.strictEqual(binaryen.ExpressionId.StructSet, 70);
		// @ts-expect-error
		assert.strictEqual(binaryen.ExpressionId.StructRMW, undefined); assert.notStrictEqual(binaryen.ExpressionId.StructRMW, 71);
		// @ts-expect-error
		assert.strictEqual(binaryen.ExpressionId.StructCmpxchg, undefined); assert.notStrictEqual(binaryen.ExpressionId.StructCmpxchg, 72);
		assert.strictEqual(binaryen.ExpressionId.ArrayNew, 73);
		assert.strictEqual(binaryen.ExpressionId.ArrayNewData, 74);
		assert.strictEqual(binaryen.ExpressionId.ArrayNewElem, 75);
		assert.strictEqual(binaryen.ExpressionId.ArrayNewFixed, 76);
		assert.strictEqual(binaryen.ExpressionId.ArrayGet, 77);
		assert.strictEqual(binaryen.ExpressionId.ArraySet, 78);
		// @ts-expect-error
		assert.strictEqual(binaryen.ExpressionId.ArrayLoadId, undefined); assert.notStrictEqual(binaryen.ExpressionId.ArrayLoadId, 79);
		// @ts-expect-error
		assert.strictEqual(binaryen.ExpressionId.ArrayStoreId, undefined); assert.notStrictEqual(binaryen.ExpressionId.ArrayStoreId, 80);
		assert.strictEqual(binaryen.ExpressionId.ArrayLen, 81);
		assert.strictEqual(binaryen.ExpressionId.ArrayCopy, 82);
		assert.strictEqual(binaryen.ExpressionId.ArrayFill, 83);
		assert.strictEqual(binaryen.ExpressionId.ArrayInitData, 84);
		assert.strictEqual(binaryen.ExpressionId.ArrayInitElem, 85);
		// @ts-expect-error
		assert.strictEqual(binaryen.ExpressionId.ArrayRMWId, undefined); assert.notStrictEqual(binaryen.ExpressionId.ArrayRMWId, 86);
		// @ts-expect-error
		assert.strictEqual(binaryen.ExpressionId.ArrayCmpxchgId, undefined); assert.notStrictEqual(binaryen.ExpressionId.ArrayCmpxchgId, 87);
		assert.strictEqual(binaryen.ExpressionId.RefAs, 88);
		assert.strictEqual(binaryen.ExpressionId.StringNew, 89);
		assert.strictEqual(binaryen.ExpressionId.StringConst, 90);
		assert.strictEqual(binaryen.ExpressionId.StringMeasure, 91);
		assert.strictEqual(binaryen.ExpressionId.StringEncode, 92);
		assert.strictEqual(binaryen.ExpressionId.StringConcat, 93);
		assert.strictEqual(binaryen.ExpressionId.StringEq, 94);
		// @ts-expect-error
		assert.strictEqual(binaryen.ExpressionId.StringTest, undefined); assert.notStrictEqual(binaryen.ExpressionId.StringTest, 95);
		assert.strictEqual(binaryen.ExpressionId.StringWTF16Get, 96);
		assert.strictEqual(binaryen.ExpressionId.StringSliceWTF, 97);

		assert.strictEqual(binaryen.ExpressionId.WideIntAddSub, 106);
		assert.strictEqual(binaryen.ExpressionId.WideIntMul, 107);
	});


	test(".ExternalKind", () => {
		// NOTE: the length is twice the number of members due to how TypeScript emits enums.
		assert.strictEqual(Object.entries(binaryen.ExternalKind).length, 10);

		assert.strictEqual(binaryen.ExternalKind.ExternalFunction, 0);
		assert.strictEqual(binaryen.ExternalKind.ExternalTable, 1);
		assert.strictEqual(binaryen.ExternalKind.ExternalMemory, 2);
		assert.strictEqual(binaryen.ExternalKind.ExternalGlobal, 3);
		assert.strictEqual(binaryen.ExternalKind.ExternalTag, 4);
	});
});
