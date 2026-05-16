// Artifacts provided by the Emscripten build, located at `./build/binaryen_js.js`.



declare module "#binaryen-raw" {
	interface BinaryenObjType {
		// Standard C functions listed in `EXPORTED_FUNCTIONS`.
		// https://github.com/emscripten-core/emscripten/blob/main/src/preamble.js
		_malloc(ptr: number): number;
		_free(ptr: number): void;


		// Helper tools defined in Emscripten’s codebase needed in TS. Listed in `EXPORTED_RUNTIME_METHODS`.
		// https://github.com/emscripten-core/emscripten/blob/main/src/shell_minimal.js
		out(x: unknown): void; // alias of `console.log`
		err(x: unknown): void; // alias of `console.error`

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
		getExceptionMessage(e: number | Error | object): [string, string];


		// Binaryen’s functions in the C++ codebase, e.g. `_BinaryenTypeUnreachable`.
		// These are exposed via `-sEXPORT_NAME=Binaryen` in the makelists.
		[key: string]: (...args: readonly (number | bigint | boolean)[]) => number;
	}

	export default function Binaryen<T extends object = object>(moduleArg?: T): Promise<BinaryenObjType & T>;
}
