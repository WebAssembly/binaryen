//
// Test i64 support in wasm-only builds. In this case, fastcomp emits code that is
// not asm.js, it will only ever run as wasm, and contains special intrinsics for
// asm2wasm that map LLVM IR into i64s.
//

function asm(global, env, buffer) {
  "use asm";

  var illegalImportResult = env.illegalImportResult;

  var tempRet0 = 0; // this should be used to legalize the illegal result

  function illegalResult() { // illegal result, exported
    return i64_const(1, 2);
  }

  function imports() {
    return i64_trunc(i64(illegalImportResult())) | 0;
  }

  return { illegalResult: illegalResult, imports: imports };
}

