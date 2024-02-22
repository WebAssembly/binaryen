;; Check that we fail to validate a call_indirect whose cast type is not a
;; subtype of the table type.

;; RUN: not wasm-opt -all %s -o - -S 2>&1 | filecheck %s

;; CHECK: call-indirect cast type must be a subtype of table

(module
 (rec
  (type $type-A (sub (func)))
  (type $type-B (sub (func)))
 )

 (table $table-A 1 1 (ref null $type-A))

 (func $test
  (call_indirect $table-A (type $type-B)
   (i32.const 0)
  )
 )
)

