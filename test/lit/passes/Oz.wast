;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.
;; NOTE: This test was ported using port_test.py and could be cleaned up.

;; RUN: foreach %s %t wasm-opt -Oz -S -o - | filecheck %s

(module
  (memory 100 100)
  ;; CHECK:      (type $i32_=>_i32 (func (param i32) (result i32)))

  ;; CHECK:      (type $i32_i32_=>_i32 (func (param i32 i32) (result i32)))

  ;; CHECK:      (type $i32_i32_i32_i32_=>_i32 (func (param i32 i32 i32 i32) (result i32)))

  ;; CHECK:      (memory $0 100 100)

  ;; CHECK:      (export "localcse" (func $basics))

  ;; CHECK:      (export "localcse-2" (func $8))

  ;; CHECK:      (export "propagate-sign-for-mul-i32-lhs-const-pot" (func $9))

  ;; CHECK:      (export "propagate-sign-for-mul-i32-smin" (func $10))

  ;; CHECK:      (func $basics (; has Stack IR ;) (param $0 i32) (param $1 i32) (result i32)
  ;; CHECK-NEXT:  (i32.add
  ;; CHECK-NEXT:   (local.tee $0
  ;; CHECK-NEXT:    (i32.add
  ;; CHECK-NEXT:     (local.get $0)
  ;; CHECK-NEXT:     (local.get $1)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (local.get $0)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $basics (export "localcse") (param $x i32) ($param $y i32) (result i32) ;; -O3 does localcse
    (local $x2 i32)
    (local $y2 i32)
    (local.set $x2
      (i32.add (local.get $x) (local.get $y))
    )
    (local.set $y2
      (i32.add (local.get $x) (local.get $y))
    )
    (i32.add (local.get $x2) (local.get $y2))
  )
  ;; CHECK:      (func $8 (; has Stack IR ;) (param $0 i32) (param $1 i32) (param $2 i32) (param $3 i32) (result i32)
  ;; CHECK-NEXT:  (i32.store
  ;; CHECK-NEXT:   (local.tee $0
  ;; CHECK-NEXT:    (local.tee $1
  ;; CHECK-NEXT:     (i32.add
  ;; CHECK-NEXT:      (local.get $1)
  ;; CHECK-NEXT:      (i32.const 4)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (i32.and
  ;; CHECK-NEXT:    (i32.load
  ;; CHECK-NEXT:     (local.get $0)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (i32.const -75)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (i32.store
  ;; CHECK-NEXT:   (local.tee $0
  ;; CHECK-NEXT:    (local.get $1)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (i32.or
  ;; CHECK-NEXT:    (i32.load
  ;; CHECK-NEXT:     (local.get $0)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (i32.const 8)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (i32.const 0)
  ;; CHECK-NEXT: )
  (func $8 (export "localcse-2") (param $var$0 i32)
    (param $var$1 i32)
    (param $var$2 i32)
    (param $var$3 i32)
    (result i32)
    (block $label$0 (result i32)
      (i32.store
        (local.tee $var$2
          (i32.add
            (local.get $var$1)
            (i32.const 4)
          )
        )
        (i32.and
          (i32.load
            (local.get $var$2)
          )
          (i32.xor
            (local.tee $var$2
              (i32.const 74)
            )
            (i32.const -1)
          )
        )
      )
      (i32.store
        (local.tee $var$1
          (i32.add
            (local.get $var$1)
            (i32.const 4)
          )
        )
        (i32.or
          (i32.load
            (local.get $var$1)
          )
          (i32.and
            (local.get $var$2)
            (i32.const 8)
          )
        )
      )
      (i32.const 0)
    )
  )

  ;; CHECK:      (func $9 (; has Stack IR ;) (param $0 i32) (result i32)
  ;; CHECK-NEXT:  (i32.mul
  ;; CHECK-NEXT:   (local.get $0)
  ;; CHECK-NEXT:   (i32.const -4)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $9 (export "propagate-sign-for-mul-i32-lhs-const-pot") (param $0 i32) (result i32)
    (i32.mul
      (i32.const 4)
      (i32.sub
        (i32.const 0)
        (local.get $0)
      )
    )
  )

  ;; CHECK:      (func $10 (; has Stack IR ;) (param $0 i32) (result i32)
  ;; CHECK-NEXT:  (i32.shl
  ;; CHECK-NEXT:   (local.get $0)
  ;; CHECK-NEXT:   (i32.const 31)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $10 (export "propagate-sign-for-mul-i32-smin") (param $0 i32) (result i32)
    (i32.mul
      (i32.sub
        (i32.const 0)
        (local.get $0)
      )
      (i32.const 0x80000000)
    )
  )
)
