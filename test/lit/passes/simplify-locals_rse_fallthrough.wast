;; NOTE: Assertions have been generated by update_lit_checks.py and should not be edited.
;; RUN: wasm-opt %s --simplify-locals --rse -S -o - \
;; RUN:   | filecheck %s

(module
  ;; CHECK:      (func $no (param $x i32) (result i32)
  ;; CHECK-NEXT:  (i32.add
  ;; CHECK-NEXT:   (block $block (result i32)
  ;; CHECK-NEXT:    (local.tee $x
  ;; CHECK-NEXT:     (br_if $block
  ;; CHECK-NEXT:      (local.get $x)
  ;; CHECK-NEXT:      (local.tee $x
  ;; CHECK-NEXT:       (i32.const 42)
  ;; CHECK-NEXT:      )
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (local.get $x)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $no (param $x i32) (result i32)
    (i32.add
      (block $block (result i32)
        ;; This local.tee is necessary. It might seem that the br_if flows out
        ;; $x, so we don't need to write that same value to $x once more.
        ;; SimplifyLocals and RedundantSetElimination try to find such sets and
        ;; remove them. But this set is necessary, since a tee of $x executes
        ;; after that local.get. That is, the br_if flows out the *old* value of
        ;; $x. What happens in practice is that we branch (since the condition
        ;; is 42), and flow out the old $x, which gets tee'd into $x once more.
        ;; As a result, the block flows out the original value of $x, and the
        ;; local.get reads that same value, so the final add returns 2 times the
        ;; original value of $x. For all that to happen, we need those
        ;; optimization passes to *not* remove the outer local.tee.
        (local.tee $x
          (br_if $block
            (local.get $x)
            (local.tee $x
              (i32.const 42)
            )
          )
        )
      )
      (local.get $x)
    )
  )
)
