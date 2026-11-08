;; RUN: not wasm-opt %s 2>&1 | filecheck %s

;; Tests feature-related validations.
;; Other validations are in the spec test spec/waitqueue.wast.
(module
  (type $struct (struct (field i32)))
  ;; CHECK: waitqueue.new requires additional features
  ;; CHECK: [--enable-reference-types --enable-gc --enable-shared-everything]
  (func $new
    (drop (waitqueue.new))
  )
  ;; CHECK: waitqueue.notify requires additional features
  ;; CHECK: [--enable-reference-types --enable-gc --enable-shared-everything]
  (func $notify (param $wq (ref null (shared waitqueue)))
    (drop (waitqueue.notify (local.get $wq) (i32.const 1)))
  )
  ;; CHECK: struct.wait requires additional features
  ;; CHECK: [--enable-reference-types --enable-gc --enable-shared-everything]
  (func $wait-no-feature (param $ref (ref $struct)) (param $wq (ref null (shared waitqueue)))
    (drop (struct.wait $struct 0 (local.get $ref) (local.get $wq) (i32.const 0) (i64.const 0)))
  )
)
