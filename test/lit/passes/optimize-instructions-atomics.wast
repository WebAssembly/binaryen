;; NOTE: Assertions have been generated by update_lit_checks.py and should not be edited.
;; RUN: wasm-opt %s --optimize-instructions --enable-threads -S -o - | filecheck %s

(module
 ;; CHECK:      (import "env" "memory" (memory $0 (shared 256 256)))
 (import "env" "memory" (memory $0 (shared 256 256)))

 ;; CHECK:      (func $x
 ;; CHECK-NEXT:  (drop
 ;; CHECK-NEXT:   (i32.shr_s
 ;; CHECK-NEXT:    (i32.shl
 ;; CHECK-NEXT:     (i32.atomic.load8_u
 ;; CHECK-NEXT:      (i32.const 100)
 ;; CHECK-NEXT:     )
 ;; CHECK-NEXT:     (i32.const 24)
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:    (i32.const 24)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $x
  (drop
   (i32.shr_s
    (i32.shl
     (i32.atomic.load8_u ;; can't be signed
      (i32.const 100)
     )
     (i32.const 24)
    )
    (i32.const 24)
   )
  )
 )

 ;; CHECK:      (func $dont_simplify_reinterpret_atomic_load_store (param $x i32) (param $y f32)
 ;; CHECK-NEXT:  (drop
 ;; CHECK-NEXT:   (f64.reinterpret_i64
 ;; CHECK-NEXT:    (i64.atomic.load
 ;; CHECK-NEXT:     (local.get $x)
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT:  (i32.atomic.store
 ;; CHECK-NEXT:   (i32.const 8)
 ;; CHECK-NEXT:   (i32.reinterpret_f32
 ;; CHECK-NEXT:    (local.get $y)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $dont_simplify_reinterpret_atomic_load_store (param $x i32) (param $y f32)
  (drop (f64.reinterpret_i64 (i64.atomic.load (local.get $x))))         ;; skip
  (i32.atomic.store (i32.const 8) (i32.reinterpret_f32 (local.get $y))) ;; skip
 )
)
