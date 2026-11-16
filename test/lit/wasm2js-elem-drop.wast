;; RUN: wasm2js %s --enable-bulk-memory | filecheck %s

(module
 (table 1 funcref)
 (elem (i32.const 0))
 (func (export "test_elem_drop")
  (elem.drop 0)
 )
)

;; CHECK:      function asmFunc(imports) {
;; CHECK-NEXT:  var Math_imul = Math.imul;
;; CHECK-NEXT:  var Math_fround = Math.fround;
;; CHECK-NEXT:  var Math_abs = Math.abs;
;; CHECK-NEXT:  var Math_clz32 = Math.clz32;
;; CHECK-NEXT:  var Math_min = Math.min;
;; CHECK-NEXT:  var Math_max = Math.max;
;; CHECK-NEXT:  var Math_floor = Math.floor;
;; CHECK-NEXT:  var Math_ceil = Math.ceil;
;; CHECK-NEXT:  var Math_trunc = Math.trunc;
;; CHECK-NEXT:  var Math_sqrt = Math.sqrt;
;; CHECK-NEXT:  function $0() {
;; CHECK-NEXT:  {{^  $}}
;; CHECK-NEXT:  }
;; CHECK-NEXT:  {{^ $}}
;; CHECK-NEXT:  var FUNCTION_TABLE = [];
;; CHECK-NEXT:  return {
;; CHECK-NEXT:   "test_elem_drop": $0
;; CHECK-NEXT:  };
;; CHECK-NEXT: }
;; CHECK-EMPTY:
;; CHECK-NEXT: var retasmFunc = asmFunc({
;; CHECK-NEXT: });
;; CHECK-NEXT: export var test_elem_drop = retasmFunc.test_elem_drop;
