declare var Module: object;
declare var out: (s: string) => void;
declare var _BinaryenSizeofLiteral: () => number;
declare var _BinaryenSizeofAllocateAndWriteResult: () => number;

type Writer = (s: string) => void;
function swapOut(writer: Writer): Writer {
    const saved = out;
    out = writer;
    return saved;
}

Module['utils'] = {
    "swapOut": swapOut,
    "_BinaryenSizeofLiteral": _BinaryenSizeofLiteral,
    "_BinaryenSizeofAllocateAndWriteResult": _BinaryenSizeofAllocateAndWriteResult
};