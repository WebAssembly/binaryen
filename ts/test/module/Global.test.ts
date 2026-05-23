import * as assert from "node:assert";
import {
	beforeEach,
	suite,
	test,
} from "node:test";
import * as binaryen from "../../src/binaryen.ts";



suite("Global", () => {
	let mod: binaryen.Module;
	let globalRef: binaryen.GlobalRef;
	let globalInfo: binaryen.Module.Global;

	beforeEach(() => {
		mod = new binaryen.Module();
		mod.features = (
			binaryen.Feature.MVP |
			binaryen.Feature.MutableGlobals
		);
		globalRef = mod.globals.add("a-global", binaryen.i32, false, mod.wasm.i32.const(1));
		assert.strictEqual(mod.globals.count(), 1);
		globalInfo = new binaryen.Module.Global(globalRef);
	});

	test(".constructor", () => {
		assert.partialDeepStrictEqual(globalInfo, {
			name: "a-global",
			module: "",
			base: "",
			type: binaryen.i32,
			mutable: false,
		});
	});

	test("`Module#globals.get` returns the ref returned by `Module#globals.add`.", () => {
		assert.strictEqual(globalRef, mod.globals.get("a-global"));
	});

	test("initial value.", () => {
		globalInfo = new binaryen.Module.Global(globalRef);
		const exprInfo: binaryen.expressions.Expression = binaryen.getExpressionInfo(globalInfo.init);
		assert.ok(exprInfo instanceof binaryen.expressions.Const);
		assert.partialDeepStrictEqual(exprInfo.toJson(), {
			id: binaryen.ExpressionId.Const,
			type: binaryen.i32,
			value: 1,
		});
		assert.strictEqual(binaryen.emitText(globalInfo.init), "(i32.const 1)");
	});

	test("module is valid with imports/exports.", () => {
		mod.exports.addGlobal("a-global", "a-global-exp");
		mod.imports.addGlobal("a-global-imp", "module", "base", binaryen.i32, false);
		mod.imports.addGlobal("a-mut-global-imp", "module", "base", binaryen.i32, true);

		assert.ok(mod.validate());
		assert.strictEqual(mod.emitText(), `(module
 (import "module" "base" (global $a-global-imp i32))
 (import "module" "base" (global $a-mut-global-imp (mut i32)))
 (global $a-global i32 (i32.const 1))
 (export "a-global-exp" (global $a-global))
)
`);

		mod.exports.remove("a-global-exp");
		mod.globals.remove("a-global");

		assert.ok(mod.validate());
		assert.strictEqual(mod.emitText(), `(module
 (import "module" "base" (global $a-global-imp i32))
 (import "module" "base" (global $a-mut-global-imp (mut i32)))
)
`);
	});
});
