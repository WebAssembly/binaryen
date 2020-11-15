;; RUN: %wasm-opt %s --optimize-instructions -S -o - | filecheck %s

;; RUN: %wasm-opt %s --optimize-instructions -o %t.wasm -g
;; RUN: %wasm-dis %t.wasm | filecheck %s

(module
  (memory 0)

  ;; CHECK: (func $f (param $i1 i32) (param $i2 i64)
  (func $f (param $i1 i32) (param $i2 i64)

    ;; ((i1 & 5) & 3)  ==>  (i1 & 1)
    ;; CHECK-NEXT: (drop
    ;; CHECK-NEXT:   (i32.and
    ;; CHECK-NEXT:     (local.get $i1)
    ;; CHECK-NEXT:     (i32.const 1)
    ;; CHECK-NEXT:    )
    ;; CHECK-NEXT: )
    (drop
      (i32.and
        (i32.and
          (local.get $i1)
          (i32.const 5)
        )
        (i32.const 3)
      )
    )

    ;; ((i1 | 1) | 2)  ==>  (i1 | 3)
    ;; CHECK-NEXT: (drop
    ;; CHECK-NEXT:   (i32.or
    ;; CHECK-NEXT:     (local.get $i1)
    ;; CHECK-NEXT:     (i32.const 3)
    ;; CHECK-NEXT:   )
    ;; CHECK-NEXT: )
    (drop
      (i32.or
        (i32.or
          (local.get $i1)
          (i32.const 1)
        )
        (i32.const 2)
      )
    )

    ;; ((i1 ^ -2) ^ -5)  ==>  (i1 ^ 5)
    ;; CHECK-NEXT: (drop
    ;; CHECK-NEXT:   (i32.xor
    ;; CHECK-NEXT:     (local.get $i1)
    ;; CHECK-NEXT:     (i32.const 5)
    ;; CHECK-NEXT:   )
    ;; CHECK-NEXT: )
    (drop
      (i32.xor
        (i32.xor
          (local.get $i1)
          (i32.const -2)
        )
        (i32.const -5)
      )
    )
  )
)