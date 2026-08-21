;; RUN: not wasm-opt --enable-reference-types --enable-gc %s 2>&1 | filecheck %s

;; Tests feature-related validations.
;; Other validations are in the spec test spec/waitqueue.wast.
(module
  (type $struct (struct (field i32)))
  ;; CHECK:      waitqueue.new requires shared-everything [--enable-shared-everything]
  (func $new
    (drop (waitqueue.new))
  )
  ;; CHECK:      struct.wait requires shared-everything [--enable-shared-everything]
  (func $wait-no-feature (param $ref (ref $struct)) (param $wq (ref null (shared waitqueue)))
    (drop (struct.wait $struct 0 (local.get $ref) (local.get $wq) (i32.const 0) (i64.const 0)))
  )
)
