import * as assert from "node:assert";
import {
	beforeEach,
	suite,
	test,
} from "node:test";
import * as binaryen from "../../src/binaryen.ts";



suite("Function", () => {
	let mod: binaryen.Module;
	let funcRef: binaryen.FunctionRef;
	let funcInfo: binaryen.Module.Function;

	beforeEach(() => {
		mod = new binaryen.Module();
		funcRef = mod.functions.add(
			"a-function",
			binaryen.createType([binaryen.i32, binaryen.i32]),
			binaryen.i32,
			[binaryen.i32, binaryen.f64],
			mod.wasm.local.tee(2, mod.wasm.i32.add(
				mod.wasm.local.get(0, binaryen.i32),
				mod.wasm.local.get(1, binaryen.i32),
			), binaryen.i32),
		);
		assert.strictEqual(mod.functions.count(), 1);
		funcInfo = new binaryen.Module.Function(funcRef);
	});

	test(".constructor", () => {
		assert.partialDeepStrictEqual(funcInfo, {
			module: "",
			base: "",
			name: "a-function",
			params: binaryen.createType([binaryen.i32, binaryen.i32]),
			results: binaryen.i32,
			numVars: 2,
			numLocals: 4,
		});
		assert.deepStrictEqual(funcInfo.vars, [binaryen.i32, binaryen.f64]);
	});

	test("`Module#functions.get` returns the ref returned by `Module#functions.add`.", () => {
		assert.strictEqual(funcRef, mod.functions.get("a-function"));
	});

	test("module is valid.", () => {
		assert.ok(mod.validate());
		assert.strictEqual(mod.emitText(), `(module
 (type $0 (func (param i32 i32) (result i32)))
 (func $a-function (param $0 i32) (param $1 i32) (result i32)
  (local $2 i32)
  (local $3 f64)
  (local.tee $2
   (i32.add
    (local.get $0)
    (local.get $1)
   )
  )
 )
)
`);
	});

	test("#getVar", () => {
		assert.strictEqual(funcInfo.getVar(0), binaryen.i32);
		assert.strictEqual(funcInfo.getVar(1), binaryen.f64);
	});

	test("has/get/set local names.", () => {
		assert.ok(!funcInfo.hasLocalName(0));
		assert.ok(!funcInfo.hasLocalName(1));
		assert.ok(!funcInfo.hasLocalName(2));
		assert.ok(!funcInfo.hasLocalName(3));

		assert.throws(() => funcInfo.getLocalName(0));
		assert.throws(() => funcInfo.getLocalName(1));
		assert.throws(() => funcInfo.getLocalName(2));
		assert.throws(() => funcInfo.getLocalName(3));

		funcInfo.setLocalName(0, "a");
		funcInfo.setLocalName(1, "b");
		funcInfo.setLocalName(2, "ret");
		assert.strictEqual(funcInfo.getLocalName(0), "a");
		assert.strictEqual(funcInfo.getLocalName(1), "b");
		assert.strictEqual(funcInfo.getLocalName(2), "ret");

		// `new Function().setLocalName()` has the same side-effect
		new binaryen.Module.Function(funcRef).setLocalName(3, "unused");
		assert.strictEqual(funcInfo.getLocalName(3), "unused");
	});

	test("Module#runPassesOnFunction", () => {
		funcRef = mod.functions.add("b-function", binaryen.none, binaryen.i32, [], mod.wasm.i32.add(
			mod.wasm.i32.const(1),
			mod.wasm.i32.const(2),
		));
		assert.strictEqual(mod.functions.count(), 2);
		funcInfo = new binaryen.Module.Function(funcRef);
		mod.functions.remove("a-function");
		assert.strictEqual(mod.functions.count(), 1);

		let bodyExprObj: binaryen.expressions.Expression = binaryen.Expression(funcInfo.body);
		assert.ok(bodyExprObj instanceof binaryen.expressions.Binary);
		assert.partialDeepStrictEqual(bodyExprObj.toJson(), {
			id: binaryen.ExpressionId.Binary,
			type: binaryen.i32,
		});

		assert.ok(mod.validate());
		assert.strictEqual(binaryen.emitText(funcInfo.body), `(i32.add
 (i32.const 1)
 (i32.const 2)
)
`);

		mod.runPassesOnFunction(funcRef, ["precompute"]);

		bodyExprObj = binaryen.Expression(funcInfo.body);
		assert.ok(bodyExprObj instanceof binaryen.expressions.Const);
		assert.partialDeepStrictEqual(bodyExprObj.toJson(), {
			id: binaryen.ExpressionId.Const,
			type: binaryen.i32,
			value: 3,
		});
		assert.strictEqual(binaryen.emitText(funcInfo.body), "(i32.const 3)\n");

		assert.ok(mod.validate());
		assert.strictEqual(mod.emitText(), `(module
 (type $0 (func (result i32)))
 (func $b-function (result i32)
  (i32.const 3)
 )
)
`);
	});
});
