import * as assert from "node:assert";
import {
	beforeEach,
	suite,
	test,
} from "node:test";
import * as binaryen from "../../src/binaryen.ts";



suite("Tag", () => {
	let mod: binaryen.Module;
	let tagRef: binaryen.TagRef;

	beforeEach(() => {
		mod = new binaryen.Module();
		mod.features = (
			binaryen.Feature.ExceptionHandling |
			binaryen.Feature.ReferenceTypes |
			binaryen.Feature.Multivalue
		);
		tagRef = mod.tags.add("a-tag", binaryen.i32, binaryen.none);
	});

	test(".constructor", () => {
		assert.partialDeepStrictEqual(new binaryen.Module.Tag(tagRef), {
			name: "a-tag",
			module: "",
			base: "",
			params: binaryen.i32,
			results: binaryen.none,
		});
	});

	test("`Module#tags.get` returns the ref returned by `Module#tags.add`.", () => {
		assert.strictEqual(tagRef, mod.tags.get("a-tag"));
	});

	test("module is valid with imports/exports.", () => {
		const pairType: binaryen.Type = binaryen.createType([binaryen.i32, binaryen.f32]);

		mod.exports.addTag("a-tag", "a-tag-exp");
		mod.imports.addTag("a-tag-imp", "module", "base", pairType, binaryen.none);

		assert.ok(mod.validate());
		assert.strictEqual(mod.emitText(), `(module
 (type $0 (func (param i32)))
 (type $1 (func (param i32 f32)))
 (import "module" "base" (tag $a-tag-imp (type $1) (param i32 f32)))
 (tag $a-tag (type $0) (param i32))
 (export "a-tag-exp" (tag $a-tag))
)
`);

		mod.exports.remove("a-tag-exp");
		mod.tags.remove("a-tag");

		assert.ok(mod.validate());
		assert.strictEqual(mod.emitText(), `(module
 (type $0 (func (param i32 f32)))
 (import "module" "base" (tag $a-tag-imp (type $0) (param i32 f32)))
)
`);
	});
});
