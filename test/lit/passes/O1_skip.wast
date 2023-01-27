;; RUN: foreach %s %t wasm-opt -O2 --coalesce-locals --skip-pass=coalesce-locals -S -o - 2>&1 | filecheck %s

;; We should skip coalese-locals even though it is run in -O2 and also we ask to
;; run it directly: the skip instruction overrides everything else.

;; There should also be no warning in the output.
;; CHECK-NOT: warning:

(module
 ;; CHECK:      (type $i32_i32_=>_none (func (param i32 i32)))

 ;; CHECK:      (type $i32_=>_none (func (param i32)))

 ;; CHECK:      (import "a" "b" (func $log (param i32 i32)))
 (import "a" "b" (func $log (param i32 i32)))

 (func "foo" (param $p i32)
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
;; CHECK:      (export "foo" (func $0))

;; CHECK:      (func $0 (; has Stack IR ;) (param $p i32)
;; CHECK-NEXT:  (local $x i32)
;; CHECK-NEXT:  (local $y i32)
;; CHECK-NEXT:  (call $log
;; CHECK-NEXT:   (local.tee $x
;; CHECK-NEXT:    (i32.add
;; CHECK-NEXT:     (local.get $p)
;; CHECK-NEXT:     (i32.const 1)
;; CHECK-NEXT:    )
;; CHECK-NEXT:   )
;; CHECK-NEXT:   (local.get $x)
;; CHECK-NEXT:  )
;; CHECK-NEXT:  (call $log
;; CHECK-NEXT:   (local.tee $y
;; CHECK-NEXT:    (i32.add
;; CHECK-NEXT:     (local.get $p)
;; CHECK-NEXT:     (i32.const 1)
;; CHECK-NEXT:    )
;; CHECK-NEXT:   )
;; CHECK-NEXT:   (local.get $y)
;; CHECK-NEXT:  )
;; CHECK-NEXT: )
