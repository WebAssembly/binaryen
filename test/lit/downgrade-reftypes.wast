;; NOTE: Assertions have been generated by update_lit_checks.py and should not be edited.

;; Write to a binary, lowering away refined GC types.
;; RUN: wasm-as %s -all --disable-gc -g -o %t.wasm

;; Read it back and verify that the types were lowered away.
;; RUN: wasm-dis %t.wasm -all -o - | filecheck %s

(module

  ;; CHECK:      (type $f (func))
  (type $f (func))

  ;; CHECK:      (func $foo (type $f)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (block $block (result funcref)
  ;; CHECK-NEXT:    (br $block
  ;; CHECK-NEXT:     (ref.func $foo)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (block $block1 (result funcref)
  ;; CHECK-NEXT:    (br $block1
  ;; CHECK-NEXT:     (ref.null nofunc)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (block $block2 (result externref)
  ;; CHECK-NEXT:    (br $block2
  ;; CHECK-NEXT:     (ref.null noextern)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (block $block3 (result stringref)
  ;; CHECK-NEXT:    (br $block3
  ;; CHECK-NEXT:     (string.const "hello world")
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $foo (type $f)
    (drop
      (block $l1 (result (ref $f))
        (br $l1
          (ref.func $foo)
        )
      )
    )
    (drop
      (block $l2 (result nullfuncref)
        ;; Branch to ensure the blocks remain in the output.
        (br $l2
          (ref.null nofunc)
        )
      )
    )
    (drop
      (block $l3 (result nullexternref)
        (br $l3
          (ref.null noextern)
        )
      )
    )
    (drop
      (block $l4 (result (ref string))
        (br $l4
          (string.const "hello world")
        )
      )
    )
  )
)
