;; RUN: wasm-emscripten-finalize %s | filecheck %s

(module
  (tag $e1 (export "e1") (param i32))
  (tag $e2 (param f32))
  (export "e2" (tag $e2))
)

;; CHECK:  "exports": [
;; CHECK:    "e1",
;; CHECK:    "e2"
;; CHECK:  ],
