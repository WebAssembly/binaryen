import * as assert from "node:assert";
import {
	beforeEach,
	suite,
	test,
} from "node:test";
import * as binaryen from "../../src/binaryen.ts";



suite("Table", () => {
	let mod: binaryen.Module;
	let tableRef: binaryen.TableRef;
	let tableInfo: binaryen.Module.Table;

	beforeEach(() => {
		mod = new binaryen.Module();
		tableRef = mod.tables.add("a-table", 5, 15);
		assert.strictEqual(mod.tables.count(), 1);
		tableInfo = new binaryen.Module.Table(tableRef);
	});

	test(".constructor", () => {
		assert.partialDeepStrictEqual(tableInfo, {
			module: "",
			base: "",
		});
		// getter methods are not enumerable; testing them individually
		assert.strictEqual(tableInfo.name, "a-table");
		assert.strictEqual(tableInfo.initial, 5);
		assert.strictEqual(tableInfo.max, 15);
		assert.strictEqual(tableInfo.type, binaryen.funcref);
	});

	test("`Module#tables.get` returns the ref returned by `Module#tables.add`.", () => {
		assert.strictEqual(tableRef, mod.tables.get("a-table"));
	});

	test("get/set name.", () => {
		assert.strictEqual(tableInfo.name, "a-table");
		tableInfo.name = "new-table-name";
		assert.strictEqual(tableInfo.name, "new-table-name");

		// `new Table().name` setter has the same side-effect
		new binaryen.Module.Table(tableRef).name = "another-table-name";
		assert.strictEqual(tableInfo.name, "another-table-name");

		// reset for next test
		tableInfo.name = "a-table";
	});

	test("get/set initial.", () => {
		assert.strictEqual(tableInfo.initial, 5);
		tableInfo.initial = 10;
		assert.strictEqual(tableInfo.initial, 10);

		// `new Table().initial` setter has the same side-effect
		new binaryen.Module.Table(tableRef).initial = 12;
		assert.strictEqual(tableInfo.initial, 12);

		// reset for next test
		tableInfo.initial = 5;
	});

	test("has/get/set max.", () => {
		assert.ok(tableInfo.hasMax());

		assert.strictEqual(tableInfo.max, 15);
		tableInfo.max = 20;
		assert.strictEqual(tableInfo.max, 20);

		// `new Table().max` setter has the same side-effect
		new binaryen.Module.Table(tableRef).max = 25;
		assert.strictEqual(tableInfo.max, 25);

		// reset for next test
		tableInfo.max = 15;
	});

	test("get/set type.", () => {
		assert.strictEqual(tableInfo.type, binaryen.funcref);
		tableInfo.type = binaryen.anyref;
		assert.strictEqual(tableInfo.type, binaryen.anyref);

		// `new Table().type` setter has the same side-effect
		new binaryen.Module.Table(tableRef).type = binaryen.eqref;
		assert.strictEqual(tableInfo.type, binaryen.eqref);

		// reset for next test
		tableInfo.type = binaryen.funcref;
	});

	test("module is valid.", () => {
		assert.ok(mod.validate());
		assert.strictEqual(mod.emitText(), `(module
 (table $a-table 5 15 funcref)
)
`);
	});
});
