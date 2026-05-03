import * as assert from "node:assert";
import {
	suite,
	test,
} from "node:test";



suite("Demo", () => {
	test("basic assertions.", () => {
		assert.ok(true, "expected value to be truthy.");
		assert.strictEqual(2 ** 7, 128, "expected values to be value-equal.");

		const arr = ["f64", "i32"];
		assert.strictEqual(arr, arr.sort(), "expected values to be reference-equal.");
		assert.notStrictEqual(arr, ["f64", "i32"], "expected values not to be reference-equal.");
		assert.deepStrictEqual(arr, ["f64", "i32"], "expected values to be recursively deep equal.");
		assert.notDeepStrictEqual(arr, ["i32", "f64"], "arrays are not deep-equal when item order differs.");

		const obj = {i: 32, f: 64};
		assert.deepStrictEqual(obj, {f: 64, i: 32}, "deep-equal objects need not have the same property order.");
		assert.partialDeepStrictEqual(obj, {i: 32}, "expected the left to contain all properties & values in the right.");
	});
});
