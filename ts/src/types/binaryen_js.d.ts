// Artifacts provided by the Emscripten build, located at `/build/bin/binaryen_js.js`.



declare module "binaryen-raw" {
	interface BinaryenObjType {
		_free(ptr: number): void;
		_malloc(ptr: number): number;
		stackSave(): unknown;
		stackRestore(stack: unknown): unknown;
		stackAlloc(length: number): number;
		stringToUTF8OnStack(str: string): number;
		UTF8ToString(n: number): string;
		stringToAscii(text: string, buffer: number): void;
		getExceptionMessage(e: number | Error): [string, string]; // https://emscripten.org/docs/porting/exceptions.html#handling-c-exceptions-from-javascript
		_BinaryenSizeofAllocateAndWriteResult(): number;

		[key: string]: (...args: readonly (number | bigint | boolean)[]) => number;
	}

	export default function Binaryen(): Promise<BinaryenObjType>;
}
