;; RUN: wasm2js %s -O | filecheck %s

(module
 (memory $mem 1 1)
 (table $tab 1 1 funcref)
 (elem (i32.const 0) $f1)
 (export "mem" (memory $mem))
 (export "tab" (table $tab))

 (func $f1 (param $x i32) (result i32)
  (i32.eqz (local.get $x))
 )
 (func $f2 (param $x i32) (result i32)
  ;; $f2 will be merged into $f1 by duplicate-function-elimination.
  ;; The export will point to $f1, and it should correctly receive coercions.
  (i32.eqz (local.get $x))
 )
 (export "test" (func $f2))
)

;; CHECK:      function f1($0) {
;; CHECK-NEXT:  $0 = $0 | 0;
;; CHECK-NEXT:  return !$0 | 0;
;; CHECK-NEXT: }

;; CHECK:      "mem": Object.create(Object.prototype, {

;; CHECK:      "tab": FUNCTION_TABLE,

;; CHECK:      "test": f1
