;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.
;; RUN: wasm-merge %s first %s.second second %s.third third -all -S -o - | filecheck %s

;; Test that we merge start functions. The first module here has none, but the
;; second and third do, so we'll first copy in the second's and then merge in
;; the third's.

(module
)
;; CHECK:      (type $0 (func))

;; CHECK:      (export "start" (func $start))

;; CHECK:      (export "user" (func $user))

;; CHECK:      (start $merged.start.old)

;; CHECK:      (func $start (type $0)
;; CHECK-NEXT:  (local $x i32)
;; CHECK-NEXT:  (drop
;; CHECK-NEXT:   (local.get $x)
;; CHECK-NEXT:  )
;; CHECK-NEXT:  (drop
;; CHECK-NEXT:   (i32.const 1)
;; CHECK-NEXT:  )
;; CHECK-NEXT: )

;; CHECK:      (func $user (type $0)
;; CHECK-NEXT:  (call $start)
;; CHECK-NEXT:  (call $start)
;; CHECK-NEXT: )

;; CHECK:      (func $merged.start.old (type $0)
;; CHECK-NEXT:  (local $x i32)
;; CHECK-NEXT:  (block
;; CHECK-NEXT:   (drop
;; CHECK-NEXT:    (local.get $x)
;; CHECK-NEXT:   )
;; CHECK-NEXT:   (drop
;; CHECK-NEXT:    (i32.const 1)
;; CHECK-NEXT:   )
;; CHECK-NEXT:  )
;; CHECK-NEXT:  (call $merged.start.new)
;; CHECK-NEXT: )

;; CHECK:      (func $merged.start.new (type $0)
;; CHECK-NEXT:  (local $x f64)
;; CHECK-NEXT:  (drop
;; CHECK-NEXT:   (local.get $x)
;; CHECK-NEXT:  )
;; CHECK-NEXT:  (drop
;; CHECK-NEXT:   (i32.const 2)
;; CHECK-NEXT:  )
;; CHECK-NEXT: )
