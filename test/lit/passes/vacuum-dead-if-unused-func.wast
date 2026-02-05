;; RUN: wasm-opt -all --vacuum %s -S -o - | filecheck %s

;; Test the function-level annotation of dead.if.unused.
(module
 (@binaryen.dead.if.unused)
 (func $calls-marked (param $x i32) (result i32)
  ;; The function is marked as dead if unused, and this is dropped, so optimize.
  (drop
   (call $calls-marked
    (i32.const 0)
   )
  )
  ;; Not dropped, so keep it.
  (local.set $x
   (call $calls-marked
    (i32.const 1)
   )
  )
  (i32.const 2)
 )

 (func $calls-unmarked (param $x i32) (result i32)
  ;; As above, but unmarked with the hint. We change nothing here.
  (drop
   (call $calls-unmarked
    (i32.const 0)
   )
  )
  (local.set $x
   (call $calls-unmarked
    (i32.const 1)
   )
  )
  (i32.const 2)
 )

 (func $calls-other (param $x i32) (result i32)
  ;; As above, but calling another function, to check we look for annotations in
  ;; the right place. Both calls are dropped, and only the one to the marked
  ;; function should be removed.
  (drop
   (call $calls-marked
    (i32.const 0)
   )
  )
  (drop
   (call $calls-unmarked
    (i32.const 1)
   )
  )
  (i32.const 2)
 )
)

;; CHECK:      (module
;; CHECK-NEXT:  (type $0 (func (param i32) (result i32)))
;; CHECK-NEXT:  (@binaryen.dead.if.unused)
;; CHECK-NEXT:  (func $calls-marked (type $0) (param $x i32) (result i32)
;; CHECK-NEXT:   (local.set $x
;; CHECK-NEXT:    (call $calls-marked
;; CHECK-NEXT:     (i32.const 1)
;; CHECK-NEXT:    )
;; CHECK-NEXT:   )
;; CHECK-NEXT:   (i32.const 2)
;; CHECK-NEXT:  )
;; CHECK-NEXT:  (func $calls-unmarked (type $0) (param $x i32) (result i32)
;; CHECK-NEXT:   (drop
;; CHECK-NEXT:    (call $calls-unmarked
;; CHECK-NEXT:     (i32.const 0)
;; CHECK-NEXT:    )
;; CHECK-NEXT:   )
;; CHECK-NEXT:   (local.set $x
;; CHECK-NEXT:    (call $calls-unmarked
;; CHECK-NEXT:     (i32.const 1)
;; CHECK-NEXT:    )
;; CHECK-NEXT:   )
;; CHECK-NEXT:   (i32.const 2)
;; CHECK-NEXT:  )
;; CHECK-NEXT:  (func $calls-other (type $0) (param $x i32) (result i32)
;; CHECK-NEXT:   (drop
;; CHECK-NEXT:    (call $calls-unmarked
;; CHECK-NEXT:     (i32.const 1)
;; CHECK-NEXT:    )
;; CHECK-NEXT:   )
;; CHECK-NEXT:   (i32.const 2)
;; CHECK-NEXT:  )
;; CHECK-NEXT: )

