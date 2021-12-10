;; RUN: foreach %s %t wasm-opt -O3 --all-features -S -o - | filecheck %s

(module
  (memory $0 1 1)
  (export "splat_i32x4" (func $splat_i32x4))

  (func $splat_i32x4 (result v128)
    (i32x4.splat
      (i32.const 0)
    )
  )
)
