import * as assert from "node:assert";
import {
	beforeEach,
	suite,
	test,
} from "node:test";
import * as binaryen from "../../src/binaryen.ts";



suite("Memory", () => {
	const INITIAL = 1;
	const MAXIMUM = 64;

	let mod: binaryen.Module;

	beforeEach(() => {
		mod = new binaryen.Module();
		assert.ok(!mod.memories.has());
	});

	test("not shared.", () => {
		mod.memories.set(INITIAL, MAXIMUM, "");
		assert.ok(mod.validate());
		assert.ok(mod.memories.has());
		assert.partialDeepStrictEqual(new binaryen.Module.Memory(mod, ""), {
			module: "",
			base: "",
			initial: 1,
			max: 64,
			shared: false,
			is64: false,
		});
	});

	test("shared.", () => {
		mod.features = (
			binaryen.Feature.MVP |
			binaryen.Feature.Atomics
		);
		mod.memories.set(INITIAL, MAXIMUM, "", [], true);
		assert.ok(mod.validate());
		assert.ok(mod.memories.has());
		assert.partialDeepStrictEqual(new binaryen.Module.Memory(mod, ""), {
			module: "",
			base: "",
			initial: 1,
			max: 64,
			shared: true,
			is64: false,
		});
	});

	test("imported, not shared.", () => {
		mod.imports.addMemory("my_mem", "env", "memory", false);
		assert.ok(mod.validate());
		assert.ok(mod.memories.has());
		assert.partialDeepStrictEqual(new binaryen.Module.Memory(mod, ""), {
			module: "env",
			base: "memory",
			initial: 0,
			max: 65536,
			shared: false,
			is64: false,
		});
	});

	test("imported, shared.", () => {
		mod.features = (
			binaryen.Feature.MVP |
			binaryen.Feature.Atomics
		);
		mod.imports.addMemory("my_mem", "env", "memory", true);
		assert.ok(mod.validate());
		assert.ok(mod.memories.has());
		assert.partialDeepStrictEqual(new binaryen.Module.Memory(mod, ""), {
			module: "env",
			base: "memory",
			initial: 0,
			max: 65536,
			shared: true,
			is64: false,
		});
	});
});
