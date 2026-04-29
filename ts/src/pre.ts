// # Preprocess # //
// Artifacts provided by the Emscripten build.



/** The main object provided by Emscripten. This is what gets wrapped. */
export declare const BinaryenObj: Readonly<Record<string, (...args: readonly (number | boolean)[]) => number>>;



export declare function stackSave(): unknown;
export declare function stackRestore(stack: unknown): unknown;
export declare function stackAlloc(length: number): number;
export declare function stringToUTF8OnStack(str: string): number;
