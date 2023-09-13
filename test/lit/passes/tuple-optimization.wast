;; NOTE: Assertions have been generated by update_lit_checks.py and should not be edited.
;; RUN: wasm-opt %s --tuple-optimization -all -S -o - | filecheck %s

(module
  ;; CHECK:      (func $just-set (type $0)
  ;; CHECK-NEXT:  (local $tuple (i32 i32))
  ;; CHECK-NEXT:  (local $1 i32)
  ;; CHECK-NEXT:  (local $2 i32)
  ;; CHECK-NEXT:  (local.set $1
  ;; CHECK-NEXT:   (i32.const 1)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (local.set $2
  ;; CHECK-NEXT:   (i32.const 2)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $just-set
    (local $tuple (i32 i32))
    (local.set $tuple
      (tuple.make
        (i32.const 1)
        (i32.const 2)
      )
    )
  )

  ;; CHECK:      (func $just-get (type $0)
  ;; CHECK-NEXT:  (local $tuple (i32 i32))
  ;; CHECK-NEXT:  (local $1 i32)
  ;; CHECK-NEXT:  (local $2 i32)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (local.get $1)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (local.get $2)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $just-get
    (local $tuple (i32 i32))
    (drop
      (tuple.extract 0
        (local.get $tuple)
      )
    )
    (drop
      (tuple.extract 1
        (local.get $tuple)
      )
    )
  )
)
