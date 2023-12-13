declare var Module: object;
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

Module['utils'] = {
    "swapOut": swapOut,
    "stringToAscii": stringToAscii,
    "stackSave": stackSave,
    "stackAlloc": stackAlloc,
    "stackRestore": stackRestore,
    "allocateUTF8OnStack": allocateUTF8OnStack,
    "_BinaryenSizeofLiteral": _BinaryenSizeofLiteral,
    "_BinaryenSizeofAllocateAndWriteResult": _BinaryenSizeofAllocateAndWriteResult,
    "UTF8ToString": UTF8ToString
};