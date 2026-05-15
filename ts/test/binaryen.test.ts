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
});
