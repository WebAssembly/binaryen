;; array.init_data refers to a data segment and therefore requires the datacount
;; section be emitted (so it can be validated, per the spec, using only previous
;; sections), which means bulk memory must be enabled.

;; RUN: not wasm-opt --enable-reference-types --enable-gc %s 2>&1 | filecheck %s

;; CHECK: all used types should be allowed

(module
 (type $0 (array i8))

 (memory $0 16 17 shared)

 (data $0 (i32.const 0) "")

 (func $0 (result (ref $0))
  (array.init_data $0 $0
   (ref.null $0)
   (i32.const 0)
   (i32.const 0)
   (i32.const 0)
  )
 )
)

;; But it passes with the feature enabled.
;; RUN: wasm-opt --enable-reference-types --enable-gc --enable-bulk-memory %s
