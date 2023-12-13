declare var Module: object;
declare var HEAP8: Int8Array;
declare var HEAPU8: Uint8Array;
declare var HEAP32: Int32Array;
declare var HEAPU32: Uint32Array;
declare var out: (s: string) => void;
declare var stringToAscii: (s: string, ptr: number) => void;
declare var stackSave: () => number;
declare var stackAlloc: (size: number) => number;
declare var stackRestore: (ref: number) => void;
declare var allocateUTF8OnStack: (s: string) => number;
declare var _BinaryenSizeofLiteral: () => number;
declare var _BinaryenSizeofAllocateAndWriteResult: () => number;
declare var UTF8ToString: (ptr: number) => string | null;

type Writer = (s: string) => void;
function swapOut(writer: Writer): Writer {
    const saved = out;
    out = writer;
    return saved;
}

Module['utils'] = { HEAP8, HEAPU8, HEAP32, HEAPU32, swapOut, stringToAscii, stackSave, stackAlloc, stackRestore, allocateUTF8OnStack, _BinaryenSizeofLiteral, _BinaryenSizeofAllocateAndWriteResult, UTF8ToString  };