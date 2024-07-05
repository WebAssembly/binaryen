;; RUN: foreach %s %t wasm-opt -O2 --skip-pass=coalesce-locals --skip-pass=simplify-locals --skip-pass=simplify-locals-nostructure -S -o - 2>&1 | filecheck %s

;; Check that we can skip several passes. Note that no local.tee is introduced.

;; There should also be no warning in the output.
;; CHECK-NOT: warning:

(module
 ;; CHECK:      (type $0 (func (param i32 i32)))

 ;; CHECK:      (type $1 (func (param i32)))

 ;; CHECK:      (import "a" "b" (func $log (param i32 i32)))
 (import "a" "b" (func $log (param i32 i32)))

 (func $foo (export "foo") (param $p i32)
  ;; The locals $x and $y can be coalesced into a single local, but as we do not
  ;; run that pass, they will not be. Other minor optimizations will occur here,
  ;; such as using a tee.
  (local $x i32)
  (local $y i32)

  (local.set $x
   (i32.add
    (local.get $p)
    (i32.const 1)
   )
  )
  (call $log
   (local.get $x)
   (local.get $x)
  )

  (local.set $y
   (i32.add
    (local.get $p)
    (i32.const 1)
   )
  )
  (call $log
   (local.get $y)
   (local.get $y)
  )
 )
)
;; CHECK:      (export "foo" (func $foo))

;; CHECK:      (func $foo (param $p i32)
;; CHECK-NEXT:  (local $x i32)
;; CHECK-NEXT:  (local $y i32)
;; CHECK-NEXT:  (local.set $x
;; CHECK-NEXT:   (i32.add
;; CHECK-NEXT:    (local.get $p)
;; CHECK-NEXT:    (i32.const 1)
;; CHECK-NEXT:   )
;; CHECK-NEXT:  )
;; CHECK-NEXT:  (call $log
;; CHECK-NEXT:   (local.get $x)
;; CHECK-NEXT:   (local.get $x)
;; CHECK-NEXT:  )
;; CHECK-NEXT:  (local.set $y
;; CHECK-NEXT:   (i32.add
;; CHECK-NEXT:    (local.get $p)
;; CHECK-NEXT:    (i32.const 1)
;; CHECK-NEXT:   )
;; CHECK-NEXT:  )
;; CHECK-NEXT:  (call $log
;; CHECK-NEXT:   (local.get $y)
;; CHECK-NEXT:   (local.get $y)
;; CHECK-NEXT:  )
;; CHECK-NEXT: )
