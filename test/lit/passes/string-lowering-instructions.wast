;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.

;; RUN: foreach %s %t wasm-opt --string-lowering  -all -S -o - | filecheck %s

(module
  ;; CHECK:      (type $0 (func))

  ;; CHECK:      (type $array16 (array (mut i16)))
  (type $array16 (array (mut i16)))

  ;; CHECK:      (rec
  ;; CHECK-NEXT:  (type $2 (func (param (ref $array16))))

  ;; CHECK:       (type $3 (func (param externref externref externref externref)))

  ;; CHECK:      (type $4 (func (param (ref null $array16) i32 i32) (result (ref extern))))

  ;; CHECK:      (type $5 (func (param i32) (result (ref extern))))

  ;; CHECK:      (import "colliding" "name" (func $fromCodePoint (type $0)))
  (import "colliding" "name" (func $fromCodePoint))

  ;; CHECK:      (import "wasm:js-string" "fromCharCodeArray" (func $fromCharCodeArray (type $4) (param (ref null $array16) i32 i32) (result (ref extern))))

  ;; CHECK:      (import "wasm:js-string" "fromCodePoint" (func $fromCodePoint_5 (type $5) (param i32) (result (ref extern))))

  ;; CHECK:      (func $string.as (type $3) (param $a externref) (param $b externref) (param $c externref) (param $d externref)
  ;; CHECK-NEXT:  (local.set $b
  ;; CHECK-NEXT:   (local.get $a)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (local.set $c
  ;; CHECK-NEXT:   (local.get $a)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (local.set $d
  ;; CHECK-NEXT:   (local.get $a)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $string.as
    (param $a stringref)
    (param $b stringview_wtf8)
    (param $c stringview_wtf16)
    (param $d stringview_iter)
    ;; These operations all vanish in the lowering, as they all become extref
    ;; (JS strings).
    (local.set $b
      (string.as_wtf8
        (local.get $a)
      )
    )
    (local.set $c
      (string.as_wtf16
        (local.get $a)
      )
    )
    (local.set $d
      (string.as_iter
        (local.get $a)
      )
    )
  )

  ;; CHECK:      (func $string.new.gc (type $2) (param $array16 (ref $array16))
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (call $fromCharCodeArray
  ;; CHECK-NEXT:    (local.get $array16)
  ;; CHECK-NEXT:    (i32.const 7)
  ;; CHECK-NEXT:    (i32.const 8)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $string.new.gc (param $array16 (ref $array16))
    (drop
      (string.new_wtf16_array
        (local.get $array16)
        (i32.const 7)
        (i32.const 8)
      )
    )
  )

  ;; CHECK:      (func $string.from_code_point (type $0)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (call $fromCodePoint_5
  ;; CHECK-NEXT:    (i32.const 1)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $string.from_code_point
    (drop
      (string.from_code_point
        (i32.const 1)
      )
    )
  )
)