// # Preprocess # //
// Artifacts provided by the Emscripten build.



/** The main object provided by Emscripten. This is what gets wrapped. */
export declare const BinaryenObj: Readonly<Record<string, (...args: readonly (number | boolean)[]) => number>>;



export declare function _free(ptr: number): void;
export declare function _malloc(ptr: number): number;
export declare function stackSave(): unknown;
export declare function stackRestore(stack: unknown): unknown;
export declare function stackAlloc(length: number): number;
export declare function stringToUTF8OnStack(str: string): number;
export declare function UTF8ToString(n: number): string;
export declare function stringToAscii(text: string, buffer: number): void;
export declare function getExceptionMessage(e: number | Error): [unknown, string];
