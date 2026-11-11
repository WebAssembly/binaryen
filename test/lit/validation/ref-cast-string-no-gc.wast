;; Test that string casts without GC are allowed.

;; RUN: wasm-opt %s --enable-reference-types --enable-strings -S -o - | filecheck %s

(module
  ;; CHECK:      (func $cast-from-nullable (param $x externref) (result stringref)
  ;; CHECK-NEXT:  (ref.cast stringref
  ;; CHECK-NEXT:   (local.get $x)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $cast-from-nullable (param $x externref) (result stringref)
    (ref.cast stringref
      (local.get $x)
    )
  )

  ;; CHECK:      (func $cast-from-non-nullable (param $x externref) (result (ref string))
  ;; CHECK-NEXT:  (ref.cast (ref string)
  ;; CHECK-NEXT:   (local.get $x)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $cast-from-non-nullable (param $x externref) (result (ref string))
    (ref.cast (ref string)
      (local.get $x)
    )
  )

  ;; CHECK:      (func $cast-from-string (param $x stringref) (result (ref string))
  ;; CHECK-NEXT:  (ref.cast (ref string)
  ;; CHECK-NEXT:   (local.get $x)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $cast-from-string (param $x stringref) (result (ref string))
    (ref.cast (ref string)
      (local.get $x)
    )
  )

  ;; CHECK:      (func $cast-from-null (result (ref noextern))
  ;; CHECK-NEXT:  (ref.cast (ref noextern)
  ;; CHECK-NEXT:   (ref.null noextern)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $cast-from-null (result (ref noextern))
    ;; A cast of a null is refinalized to have the bottom type.
    (ref.cast (ref string)
      (ref.null noextern)
    )
  )

  ;; CHECK:      (func $cast-from-unreachable (result (ref string))
  ;; CHECK-NEXT:  (block ;; (replaces unreachable RefCast we can't emit)
  ;; CHECK-NEXT:   (drop
  ;; CHECK-NEXT:    (unreachable)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (unreachable)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $cast-from-unreachable (result (ref string))
    (ref.cast (ref string)
      (unreachable)
    )
  )

  ;; CHECK:      (func $cast-to-nullexternref (param $x externref) (result nullexternref)
  ;; CHECK-NEXT:  (ref.cast nullexternref
  ;; CHECK-NEXT:   (local.get $x)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $cast-to-nullexternref (param $x externref) (result nullexternref)
    (ref.cast nullexternref
      (local.get $x)
    )
  )

  ;; CHECK:      (func $cast-to-non-nullable-noextern (param $x externref) (result (ref noextern))
  ;; CHECK-NEXT:  (ref.cast (ref noextern)
  ;; CHECK-NEXT:   (local.get $x)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $cast-to-non-nullable-noextern (param $x externref) (result (ref noextern))
    (ref.cast (ref noextern)
      (local.get $x)
    )
  )
)
