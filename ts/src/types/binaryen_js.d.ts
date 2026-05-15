// Artifacts provided by the Emscripten build, located at `./build/binaryen_js.js`.



declare module "binaryen-raw" {
	interface BinaryenObjType {
		// https://github.com/emscripten-core/emscripten/blob/main/src/preamble.js
		_free(ptr: number): void;
		_malloc(ptr: number): number;

		// https://github.com/emscripten-core/emscripten/blob/main/src/lib/libcore.js
		HEAP8: Int8Array;
		HEAPU8: Uint8Array;
		HEAP32: Int32Array;
		HEAPU32: Uint32Array;
		stackSave(): number;
		stackRestore(stack: number): number;
		stackAlloc(length: number): number;

		// https://github.com/emscripten-core/emscripten/blob/main/src/lib/libstrings.js
		UTF8ToString(n: number): string;
		stringToAscii(text: string, buffer: number): void;
		stringToUTF8OnStack(str: string): number;

		// https://github.com/emscripten-core/emscripten/blob/main/src/lib/libexceptions.js
		getExceptionMessage(e: number | Error): [string, string];

		// C-defined functions
		[key: string]: (...args: readonly (number | bigint | boolean)[]) => number;
	}

	export default function Binaryen(): Promise<BinaryenObjType>;
}
