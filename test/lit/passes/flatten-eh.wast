;; NOTE: Assertions have been generated by update_lit_checks.py and should not be edited.
;; RUN: wasm-opt %s -all --flatten -S -o - | filecheck %s

(module
  ;; CHECK:      (tag $e-i32 (param i32))
  (tag $e-i32 (param i32))
  ;; CHECK:      (tag $e-f32 (param f32))
  (tag $e-f32 (param f32))

  ;; CHECK:      (func $try_catch
  ;; CHECK-NEXT:  (local $x i32)
  ;; CHECK-NEXT:  (local $1 i32)
  ;; CHECK-NEXT:  (local $2 f32)
  ;; CHECK-NEXT:  (try $try
  ;; CHECK-NEXT:   (do
  ;; CHECK-NEXT:    (throw $e-i32
  ;; CHECK-NEXT:     (i32.const 0)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (unreachable)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (catch $e-i32
  ;; CHECK-NEXT:    (local.set $1
  ;; CHECK-NEXT:     (pop i32)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (drop
  ;; CHECK-NEXT:     (local.get $1)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (catch $e-f32
  ;; CHECK-NEXT:    (local.set $2
  ;; CHECK-NEXT:     (pop f32)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (drop
  ;; CHECK-NEXT:     (local.get $2)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $try_catch (local $x i32)
    ;; Basic try-catch test
    (try
      (do
        (throw $e-i32 (i32.const 0))
      )
      (catch $e-i32
        (drop
          (pop i32)
        )
      )
      (catch $e-f32
        (drop
          (pop f32)
        )
      )
    )
  )

  ;; CHECK:      (func $try_catch_pop_fixup
  ;; CHECK-NEXT:  (local $0 i32)
  ;; CHECK-NEXT:  (local $1 i32)
  ;; CHECK-NEXT:  (block $l0
  ;; CHECK-NEXT:   (try $try
  ;; CHECK-NEXT:    (do
  ;; CHECK-NEXT:     (nop)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (catch $e-i32
  ;; CHECK-NEXT:     (local.set $1
  ;; CHECK-NEXT:      (pop i32)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:     (block
  ;; CHECK-NEXT:      (block
  ;; CHECK-NEXT:       (local.set $0
  ;; CHECK-NEXT:        (local.get $1)
  ;; CHECK-NEXT:       )
  ;; CHECK-NEXT:       (drop
  ;; CHECK-NEXT:        (local.get $0)
  ;; CHECK-NEXT:       )
  ;; CHECK-NEXT:       (br $l0)
  ;; CHECK-NEXT:       (unreachable)
  ;; CHECK-NEXT:      )
  ;; CHECK-NEXT:      (unreachable)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $try_catch_pop_fixup
    ;; After --flatten, a block is created within the 'catch', which makes the
    ;; pop's location invalid. This tests whether it is fixed up correctly after
    ;; --flatten.
    (block $l0
      (try
        (do)
        (catch $e-i32
          (drop
            (pop i32)
          )
          (br $l0)
        )
      )
    )
  )

  ;; CHECK:      (func $try_catch_return_value (result i32)
  ;; CHECK-NEXT:  (local $0 i32)
  ;; CHECK-NEXT:  (local $1 i32)
  ;; CHECK-NEXT:  (local $2 i32)
  ;; CHECK-NEXT:  (try $try
  ;; CHECK-NEXT:   (do
  ;; CHECK-NEXT:    (local.set $1
  ;; CHECK-NEXT:     (i32.const 0)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (catch $e-i32
  ;; CHECK-NEXT:    (local.set $0
  ;; CHECK-NEXT:     (pop i32)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (local.set $1
  ;; CHECK-NEXT:     (local.get $0)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (local.set $2
  ;; CHECK-NEXT:   (local.get $1)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (return
  ;; CHECK-NEXT:   (local.get $2)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $try_catch_return_value (result i32)
    (try (result i32)
      (do
        (i32.const 0)
      )
      (catch $e-i32
        (pop i32)
      )
    )
  )

  ;; CHECK:      (func $try_unreachable (result i32)
  ;; CHECK-NEXT:  (local $0 i32)
  ;; CHECK-NEXT:  (local $1 i32)
  ;; CHECK-NEXT:  (local $2 i32)
  ;; CHECK-NEXT:  (try $try
  ;; CHECK-NEXT:   (do
  ;; CHECK-NEXT:    (unreachable)
  ;; CHECK-NEXT:    (unreachable)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (catch $e-i32
  ;; CHECK-NEXT:    (local.set $0
  ;; CHECK-NEXT:     (pop i32)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (local.set $1
  ;; CHECK-NEXT:     (local.get $0)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (local.set $2
  ;; CHECK-NEXT:   (local.get $1)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (return
  ;; CHECK-NEXT:   (local.get $2)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $try_unreachable (result i32)
    (try (result i32)
      (do
        (unreachable)
      )
      (catch $e-i32
        (pop i32)
      )
    )
  )

  ;; CHECK:      (func $catch_unreachable (result i32)
  ;; CHECK-NEXT:  (local $0 i32)
  ;; CHECK-NEXT:  (local $1 i32)
  ;; CHECK-NEXT:  (local $2 i32)
  ;; CHECK-NEXT:  (local $3 i32)
  ;; CHECK-NEXT:  (local $4 i32)
  ;; CHECK-NEXT:  (local $5 i32)
  ;; CHECK-NEXT:  (try $try
  ;; CHECK-NEXT:   (do
  ;; CHECK-NEXT:    (local.set $3
  ;; CHECK-NEXT:     (i32.const 3)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (catch $e-i32
  ;; CHECK-NEXT:    (local.set $5
  ;; CHECK-NEXT:     (pop i32)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (block
  ;; CHECK-NEXT:     (block
  ;; CHECK-NEXT:      (local.set $0
  ;; CHECK-NEXT:       (local.get $5)
  ;; CHECK-NEXT:      )
  ;; CHECK-NEXT:      (drop
  ;; CHECK-NEXT:       (local.get $0)
  ;; CHECK-NEXT:      )
  ;; CHECK-NEXT:      (unreachable)
  ;; CHECK-NEXT:      (unreachable)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:     (local.set $2
  ;; CHECK-NEXT:      (local.get $1)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:     (local.set $3
  ;; CHECK-NEXT:      (local.get $2)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (local.set $4
  ;; CHECK-NEXT:   (local.get $3)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (return
  ;; CHECK-NEXT:   (local.get $4)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $catch_unreachable (result i32)
    (try (result i32)
      (do
        (i32.const 3)
      )
      (catch $e-i32
        (drop
          (pop i32)
        )
        (unreachable)
      )
    )
  )
)
