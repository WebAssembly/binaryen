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
  ;; Not dropped, so keep it.
  (local.set $x
   (call $calls-unmarked
    (i32.const 1)
   )
  )
  (i32.const 2)
 )
)

;; CHECK: (module
;; CHECK-NEXT:  (type $0 (func))
;; CHECK-NEXT:  (@metadata.code.inline "\12")
;; CHECK-NEXT:  (func $func-annotation
;; CHECK-NEXT:   (drop
;; CHECK-NEXT:    (i32.const 0)
;; CHECK-NEXT:   )
;; CHECK-NEXT:  )
;; CHECK-NEXT: )

