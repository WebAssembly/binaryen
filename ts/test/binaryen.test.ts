import * as assert from "node:assert";
import {
	suite,
	test,
} from "node:test";



suite("binaryen", () => {
	test("[internal] Emscripten artifacts and module arguments exist.", async () => {
		const __pre = await import("../src/-pre.ts");
		assert.ok(__pre.BinaryenObj);
		assert.ok(__pre._malloc);
		assert.ok(__pre._free);
		assert.ok(__pre.out);
		assert.ok(__pre.err);
		assert.ok(__pre.stackSave);
		assert.ok(__pre.stackRestore);
		assert.ok(__pre.stackAlloc);
		assert.ok(__pre.UTF8ToString);
		assert.ok(__pre.stringToAscii);
		assert.ok(__pre.stringToUTF8OnStack);
		assert.ok(__pre.getExceptionMessage);

		assert.ok(__pre.BinaryenObj.print);
		assert.ok(__pre.BinaryenObj.printWarn);
		assert.ok(__pre.BinaryenObj.printErr);
	});
});
