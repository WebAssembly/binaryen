type Writer = (...data: any[]) => void;

declare var Module: object;
declare var out: Writer;
declare var err: Writer;
declare var _BinaryenSizeofLiteral: () => number;
declare var _BinaryenSizeofAllocateAndWriteResult: () => number;

function swapOut(writer: Writer): Writer {
    const saved = out;
    out = writer;
    return saved;
}

function swapErr(writer) {
    const saved = err;
    err = writer;
    return saved;
}

Module['utils'] = {
    "out": out,
    "err": err,
    "swapOut": swapOut,
    "swapErr": swapErr,
    "_BinaryenSizeofLiteral": _BinaryenSizeofLiteral,
    "_BinaryenSizeofAllocateAndWriteResult": _BinaryenSizeofAllocateAndWriteResult
};