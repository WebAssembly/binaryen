;; NOTE: Assertions have been generated by update_lit_checks.py and should not be edited.
;; RUN: wasm-opt %s --optimize-instructions --enable-multivalue -S -o - | filecheck %s

(module
  ;; CHECK:      (func $if-identical-arms-tuple (param $x i32) (result i32)
  ;; CHECK-NEXT:  (local $1 i32)
  ;; CHECK-NEXT:  (local $2 i32)
  ;; CHECK-NEXT:  (if (result i32)
  ;; CHECK-NEXT:   (local.get $x)
  ;; CHECK-NEXT:   (block (result i32)
  ;; CHECK-NEXT:    (drop
  ;; CHECK-NEXT:     (local.tee $1
  ;; CHECK-NEXT:      (i32.const 0)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (local.get $1)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (block (result i32)
  ;; CHECK-NEXT:    (drop
  ;; CHECK-NEXT:     (local.tee $2
  ;; CHECK-NEXT:      (i32.const 2)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (local.get $2)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $if-identical-arms-tuple (param $x i32) (result i32)
    (if (result i32)
      (local.get $x)
      ;; The tuple.extract can be hoisted out.
      (tuple.extract 0
        (tuple.make
          (i32.const 0)
          (i32.const 1)
        )
      )
      (tuple.extract 0
        (tuple.make
          (i32.const 2)
          (i32.const 3)
        )
      )
    )
  )
  ;; CHECK:      (func $select-identical-arms-tuple (param $x i32) (result i32)
  ;; CHECK-NEXT:  (local $1 i32)
  ;; CHECK-NEXT:  (local $2 i32)
  ;; CHECK-NEXT:  (select
  ;; CHECK-NEXT:   (block (result i32)
  ;; CHECK-NEXT:    (drop
  ;; CHECK-NEXT:     (local.tee $1
  ;; CHECK-NEXT:      (i32.const 0)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (local.get $1)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (block (result i32)
  ;; CHECK-NEXT:    (drop
  ;; CHECK-NEXT:     (local.tee $2
  ;; CHECK-NEXT:      (i32.const 2)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (local.get $2)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (local.get $x)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $select-identical-arms-tuple (param $x i32) (result i32)
    (select
      ;; The tuple.extract cannot be hoisted out, as the spec disallows a
      ;; select with multiple values in its arms.
      (tuple.extract 0
        (tuple.make
          (i32.const 0)
          (i32.const 1)
        )
      )
      (tuple.extract 0
        (tuple.make
          (i32.const 2)
          (i32.const 3)
        )
      )
      (local.get $x)
    )
  )

  ;; CHECK:      (func $extract-make (param $x i32) (param $y i32) (result i32)
  ;; CHECK-NEXT:  (local $2 i32)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (local.tee $2
  ;; CHECK-NEXT:    (local.get $x)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (local.get $2)
  ;; CHECK-NEXT: )
  (func $extract-make (param $x i32) (param $y i32) (result i32)
    ;; An extraction from a make can be simplified to just get the right lane.
    (tuple.extract 0
      (tuple.make
        (local.get $x)
        (local.get $y)
      )
    )
  )

  ;; CHECK:      (func $extract-make-2 (param $x i32) (param $y i32) (result i32)
  ;; CHECK-NEXT:  (local $2 i32)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (local.tee $2
  ;; CHECK-NEXT:    (local.get $y)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (local.get $2)
  ;; CHECK-NEXT: )
  (func $extract-make-2 (param $x i32) (param $y i32) (result i32)
    ;; As above, but the second lane.
    (tuple.extract 1
      (tuple.make
        (local.get $x)
        (local.get $y)
      )
    )
  )

  ;; CHECK:      (func $extract-make-unreachable (param $x i32) (param $y i32) (result i32)
  ;; CHECK-NEXT:  (tuple.extract 0
  ;; CHECK-NEXT:   (tuple.make
  ;; CHECK-NEXT:    (unreachable)
  ;; CHECK-NEXT:    (local.get $y)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $extract-make-unreachable (param $x i32) (param $y i32) (result i32)
    (tuple.extract 0
      (tuple.make
        (unreachable) ;; because of this we should do nothing
        (local.get $y)
      )
    )
  )
)
