;; NOTE: Assertions have been generated by update_lit_checks.py and should not be edited.
;; We run wasm-opt with --no-validation because functions in this file contain
;; 'pop's in invalid positions and the objective of this test is to fix them.
;; But wasm-opt runs validation after reading functions, so we need to disable
;; it to proceed.
;; RUN: wasm-opt %s --catch-pop-fixup --no-validation -all -S -o - | filecheck %s

(module
  ;; CHECK:      (type $struct.A (struct (field i32)))

  ;; CHECK:      (tag $e-i32 (param i32))
  (tag $e-i32 (param i32))
  ;; CHECK:      (tag $e-i32-f32 (param i32 f32))
  (tag $e-i32-f32 (param i32 f32))

  (type $struct.A (struct i32))
  ;; CHECK:      (tag $e-struct.A (param (ref $struct.A)))
  (tag $e-struct.A (param (ref $struct.A)))

  ;; CHECK:      (func $pop-within-block1 (type $0)
  ;; CHECK-NEXT:  (local $0 i32)
  ;; CHECK-NEXT:  (try $try
  ;; CHECK-NEXT:   (do
  ;; CHECK-NEXT:    (nop)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (catch $e-i32
  ;; CHECK-NEXT:    (local.set $0
  ;; CHECK-NEXT:     (pop i32)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (throw $e-i32
  ;; CHECK-NEXT:     (block (result i32)
  ;; CHECK-NEXT:      (local.get $0)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $pop-within-block1
    (try
      (do)
      (catch $e-i32
        (throw $e-i32
          ;; The pop is within a block, so it will be handled
          (block (result i32)
            (pop i32)
          )
        )
      )
    )
  )

  ;; CHECK:      (func $pop-within-block2 (type $0)
  ;; CHECK-NEXT:  (local $0 i32)
  ;; CHECK-NEXT:  (try $try
  ;; CHECK-NEXT:   (do
  ;; CHECK-NEXT:    (nop)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (catch $e-i32
  ;; CHECK-NEXT:    (local.set $0
  ;; CHECK-NEXT:     (pop i32)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (throw $e-i32
  ;; CHECK-NEXT:     (block (result i32)
  ;; CHECK-NEXT:      (block (result i32)
  ;; CHECK-NEXT:       (block (result i32)
  ;; CHECK-NEXT:        (block (result i32)
  ;; CHECK-NEXT:         (block (result i32)
  ;; CHECK-NEXT:          (local.get $0)
  ;; CHECK-NEXT:         )
  ;; CHECK-NEXT:        )
  ;; CHECK-NEXT:       )
  ;; CHECK-NEXT:      )
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $pop-within-block2
    (try
      (do)
      (catch $e-i32
        (throw $e-i32
          ;; More nesting of blocks can be handled too
          (block (result i32)
            (block (result i32)
              (block (result i32)
                (block (result i32)
                  (block (result i32)
                    (pop i32)
                  )
                )
              )
            )
          )
        )
      )
    )
  )

  ;; CHECK:      (func $pop-within-block3 (type $1) (result i32)
  ;; CHECK-NEXT:  (local $0 i32)
  ;; CHECK-NEXT:  (try $try (result i32)
  ;; CHECK-NEXT:   (do
  ;; CHECK-NEXT:    (i32.const 0)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (catch $e-i32
  ;; CHECK-NEXT:    (local.set $0
  ;; CHECK-NEXT:     (pop i32)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (block $l0 (result i32)
  ;; CHECK-NEXT:     (drop
  ;; CHECK-NEXT:      (local.get $0)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:     (br $l0
  ;; CHECK-NEXT:      (i32.const 0)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $pop-within-block3 (result i32)
    (try (result i32)
      (do
        (i32.const 0)
      )
      (catch $e-i32
        ;; This block cannot be deleted when written back because there is a
        ;; branch targeting this block. So the pop inside will be handled.
        (block $l0 (result i32)
          (drop
            (pop i32)
          )
          (br $l0
            (i32.const 0)
          )
        )
      )
    )
  )

  ;; CHECK:      (func $helper (type $0)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  (func $helper)
  ;; CHECK:      (func $pop-within-implicit-block1 (type $0)
  ;; CHECK-NEXT:  (try $try
  ;; CHECK-NEXT:   (do
  ;; CHECK-NEXT:    (nop)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (catch $e-i32
  ;; CHECK-NEXT:    (drop
  ;; CHECK-NEXT:     (pop i32)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (call $helper)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $pop-within-implicit-block1
    (try
      (do)
      (catch $e-i32
        ;; Because this catch contains multiple instructions, an implicit
        ;; block will be created within the catch when parsed. But that block
        ;; will be deleted when written back, so this pop is not considered
        ;; nested in a block.
        (drop
          (pop i32)
        )
        (call $helper)
      )
    )
  )

  ;; CHECK:      (func $pop-within-implicit-block2 (type $0)
  ;; CHECK-NEXT:  (try $try
  ;; CHECK-NEXT:   (do
  ;; CHECK-NEXT:    (nop)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (catch $e-i32
  ;; CHECK-NEXT:    (drop
  ;; CHECK-NEXT:     (pop i32)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (call $helper)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $pop-within-implicit-block2
    (try
      (do)
      (catch $e-i32
        ;; In this case we explicitly wrap the pop with a 'block', but this
        ;; block doesn't have any targeting branches, it will be also deleted
        ;; when written back to binary. So this pop is fine and not considered
        ;; nested in a block.
        (block
          (drop
            (pop i32)
          )
          (call $helper)
        )
      )
    )
  )

  ;; CHECK:      (func $pop-within-try (type $1) (result i32)
  ;; CHECK-NEXT:  (local $0 i32)
  ;; CHECK-NEXT:  (try $try (result i32)
  ;; CHECK-NEXT:   (do
  ;; CHECK-NEXT:    (i32.const 0)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (catch $e-i32
  ;; CHECK-NEXT:    (local.set $0
  ;; CHECK-NEXT:     (pop i32)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (try $try4 (result i32)
  ;; CHECK-NEXT:     (do
  ;; CHECK-NEXT:      (local.get $0)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:     (catch_all
  ;; CHECK-NEXT:      (i32.const 0)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $pop-within-try (result i32)
    (try (result i32)
      (do
        (i32.const 0)
      )
      (catch $e-i32
        ;; The pop is wihtin a try, so it will be handled
        (try (result i32)
          (do
            (pop i32)
          )
          (catch_all
            (i32.const 0)
          )
        )
      )
    )
  )

  ;; CHECK:      (func $pop-within-if-condition (type $1) (result i32)
  ;; CHECK-NEXT:  (try $try (result i32)
  ;; CHECK-NEXT:   (do
  ;; CHECK-NEXT:    (i32.const 0)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (catch $e-i32
  ;; CHECK-NEXT:    (if (result i32)
  ;; CHECK-NEXT:     (pop i32)
  ;; CHECK-NEXT:     (then
  ;; CHECK-NEXT:      (i32.const 1)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:     (else
  ;; CHECK-NEXT:      (i32.const 0)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $pop-within-if-condition (result i32)
    (try (result i32)
      (do
        (i32.const 0)
      )
      (catch $e-i32
        ;; The pop is wihtin an if condition, which is considered not nested.
        ;; This will be not handled.
        (if (result i32)
          (pop i32)
          (then (i32.const 1))
          (else (i32.const 0))
        )
      )
    )
  )

  ;; CHECK:      (func $pop-within-block-within-if-condition (type $0)
  ;; CHECK-NEXT:  (local $0 i32)
  ;; CHECK-NEXT:  (try $try
  ;; CHECK-NEXT:   (do
  ;; CHECK-NEXT:    (nop)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (catch $e-i32
  ;; CHECK-NEXT:    (local.set $0
  ;; CHECK-NEXT:     (pop i32)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (block $l0
  ;; CHECK-NEXT:     (drop
  ;; CHECK-NEXT:      (if (result i32)
  ;; CHECK-NEXT:       (local.get $0)
  ;; CHECK-NEXT:       (then
  ;; CHECK-NEXT:        (i32.const 1)
  ;; CHECK-NEXT:       )
  ;; CHECK-NEXT:       (else
  ;; CHECK-NEXT:        (i32.const 0)
  ;; CHECK-NEXT:       )
  ;; CHECK-NEXT:      )
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:     (br $l0)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $pop-within-block-within-if-condition
    (try
      (do)
      (catch $e-i32
        ;; This block cannot be removed because there is a branch targeting
        ;; this. This pop should be handled because the whole 'if' is nested
        ;; within the block.
        (block $l0
          (drop
            (if (result i32)
              (pop i32)
              (then (i32.const 1))
              (else (i32.const 0))
            )
          )
          (br $l0)
        )
      )
    )
  )

  ;; CHECK:      (func $pop-tuple-within-block (type $0)
  ;; CHECK-NEXT:  (local $x (i32 f32))
  ;; CHECK-NEXT:  (local $1 (i32 f32))
  ;; CHECK-NEXT:  (try $try
  ;; CHECK-NEXT:   (do
  ;; CHECK-NEXT:    (nop)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (catch $e-i32-f32
  ;; CHECK-NEXT:    (local.set $1
  ;; CHECK-NEXT:     (pop i32 f32)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (throw $e-i32
  ;; CHECK-NEXT:     (block (result i32)
  ;; CHECK-NEXT:      (local.set $x
  ;; CHECK-NEXT:       (local.get $1)
  ;; CHECK-NEXT:      )
  ;; CHECK-NEXT:      (i32.const 0)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $pop-tuple-within-block (local $x (i32 f32))
    (try
      (do)
      (catch $e-i32-f32
        (throw $e-i32
          ;; This tests a pop taking a tuple type.
          (block (result i32)
            (local.set $x (pop i32 f32))
            (i32.const 0)
          )
        )
      )
    )
  )

  ;; CHECK:      (func $pop-non-defaultable-type-within-block (type $0)
  ;; CHECK-NEXT:  (local $0 (ref $struct.A))
  ;; CHECK-NEXT:  (try $try
  ;; CHECK-NEXT:   (do
  ;; CHECK-NEXT:    (nop)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (catch $e-struct.A
  ;; CHECK-NEXT:    (local.set $0
  ;; CHECK-NEXT:     (pop (ref $struct.A))
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (throw $e-struct.A
  ;; CHECK-NEXT:     (block (result (ref $struct.A))
  ;; CHECK-NEXT:      (local.get $0)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $pop-non-defaultable-type-within-block
    (try
      (do)
      (catch $e-struct.A
        (throw $e-struct.A
          ;; The pop is within a block, so it will be handled. But because this
          ;; pop is of non-defaultable type, we have to fix it up using
          ;; TypeUpdating::handleNonDefaultableLocals: the new local created is
          ;; converted to (ref null $struct.A) type and we read the local using
          ;; 'ref.as_non_null'.
          (block (result (ref $struct.A))
            (pop (ref $struct.A))
          )
        )
      )
    )
  )
)
