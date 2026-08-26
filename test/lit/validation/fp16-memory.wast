;; RUN: foreach %s %t not wasm-opt 2>&1 | filecheck %s
;; RUN: foreach %s %t wasm-opt --enable-fp16 -o /dev/null

;; CHECK: FP16 operations require FP16 [--enable-fp16]
(module
  (memory 1)
  (func (result f32) (f32.load_f16 (i32.const 0))))

;; CHECK: FP16 operations require FP16 [--enable-fp16]
(module
  (memory 1)
  (func (param f32) (f32.store_f16 (i32.const 0) (local.get 0))))
