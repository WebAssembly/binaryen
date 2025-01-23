;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.

;; RUN: foreach %s %t wasm-opt --outlining -S -all -o - | filecheck %s

;; TODO: Add a test that fails to outline a single control flow that repeats


(module
  ;; CHECK:      (type $0 (func (result i32)))

  ;; CHECK:      (type $1 (func (param i32)))

  ;; CHECK:      (func $outline$ (type $1) (param $0 i32)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (local.get $0)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (i32.const 1)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (i32.const 2)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )

  ;; CHECK:      (func $a (type $0) (result i32)
  ;; CHECK-NEXT:  (call $outline$
  ;; CHECK-NEXT:   (i32.const 7)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (return
  ;; CHECK-NEXT:   (i32.const 4)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $a (result i32)
    (drop
      (i32.const 7)
    )
    (drop
      (i32.const 1)
    )
    (drop
      (i32.const 2)
    )
    (return
      (i32.const 4)
    )
  )
  ;; CHECK:      (func $b (type $0) (result i32)
  ;; CHECK-NEXT:  (call $outline$
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (return
  ;; CHECK-NEXT:   (i32.const 5)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $b (result i32)
    (drop
      (i32.const 0)
    )
    (drop
      (i32.const 1)
    )
    (drop
      (i32.const 2)
    )
    (return
      (i32.const 5)
    )
  )
)

;; Tests that outlining occurs properly when the sequence is at the end of a function.
(module
  ;; CHECK:      (type $0 (func))

  ;; CHECK:      (func $outline$ (type $0)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (i32.const 1)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (i32.const 2)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )

  ;; CHECK:      (func $a (type $0)
  ;; CHECK-NEXT:  (call $outline$)
  ;; CHECK-NEXT: )
  (func $a
    (drop
      (i32.const 1)
    )
    (drop
      (i32.const 2)
    )
  )
  ;; CHECK:      (func $b (type $0)
  ;; CHECK-NEXT:  (call $outline$)
  ;; CHECK-NEXT: )
  (func $b
    (drop
      (i32.const 1)
    )
    (drop
      (i32.const 2)
    )
  )
)

;; Tests that outlining occurs properly when the sequence is at the beginning of a function.
;; Also tests that the outlined function has no arguments.
(module
  ;; CHECK:      (type $0 (func))

  ;; CHECK:      (func $outline$ (type $0)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (i32.add
  ;; CHECK-NEXT:    (i32.const 0)
  ;; CHECK-NEXT:    (i32.const 1)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (i32.const 1)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )

  ;; CHECK:      (func $a (type $0)
  ;; CHECK-NEXT:  (call $outline$)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (i32.const 6)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $a
    (drop
      (i32.const 0)
    )
    (drop
      (i32.add
        (i32.const 0)
        (i32.const 1)
      )
    )
    (drop
      (i32.const 1)
    )
    (drop
      (i32.const 6)
    )
  )
  ;; CHECK:      (func $b (type $0)
  ;; CHECK-NEXT:  (call $outline$)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (i32.const 7)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $b
    (drop
      (i32.const 0)
    )
    (drop
      (i32.add
        (i32.const 0)
        (i32.const 1)
      )
    )
    (drop
      (i32.const 1)
    )
    (drop
      (i32.const 7)
    )
  )
)

;; Tests multiple sequences being outlined from the same source function into different
;; outlined functions.
(module
  ;; CHECK:      (type $0 (func))

  ;; CHECK:      (func $outline$ (type $0)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (i32.add
  ;; CHECK-NEXT:    (i32.const 0)
  ;; CHECK-NEXT:    (i32.const 1)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )

  ;; CHECK:      (func $outline$_4 (type $0)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (i32.sub
  ;; CHECK-NEXT:    (i32.const 3)
  ;; CHECK-NEXT:    (i32.const 4)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )

  ;; CHECK:      (func $a (type $0)
  ;; CHECK-NEXT:  (call $outline$)
  ;; CHECK-NEXT:  (call $outline$_4)
  ;; CHECK-NEXT: )
  (func $a
    (drop
      (i32.add
        (i32.const 0)
        (i32.const 1)
      )
    )
    (drop
      (i32.sub
        (i32.const 3)
        (i32.const 4)
      )
    )
  )
  ;; CHECK:      (func $b (type $0)
  ;; CHECK-NEXT:  (call $outline$_4)
  ;; CHECK-NEXT: )
  (func $b
    (drop
      (i32.sub
        (i32.const 3)
        (i32.const 4)
      )
    )
  )
  ;; CHECK:      (func $c (type $0)
  ;; CHECK-NEXT:  (call $outline$)
  ;; CHECK-NEXT: )
  (func $c
    (drop
      (i32.add
        (i32.const 0)
        (i32.const 1)
      )
    )
  )
)

;; Tests that outlining works correctly with if-condition
(module
  ;; CHECK:      (type $0 (func))

  ;; CHECK:      (type $1 (func (result i32)))

  ;; CHECK:      (global $global$1 (mut i32) (i32.const 100))
  (global $global$1 (mut i32) (i32.const 100))
  ;; CHECK:      (func $outline$ (type $1) (result i32)
  ;; CHECK-NEXT:  (i32.eqz
  ;; CHECK-NEXT:   (global.get $global$1)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )

  ;; CHECK:      (func $a (type $0)
  ;; CHECK-NEXT:  (if
  ;; CHECK-NEXT:   (call $outline$)
  ;; CHECK-NEXT:   (then
  ;; CHECK-NEXT:    (global.set $global$1
  ;; CHECK-NEXT:     (i32.const 15)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $a
    (if
      (i32.eqz
        (global.get $global$1)
      )
      (then
        (global.set $global$1
          (i32.const 15)
        )
      )
    )
  )
  ;; CHECK:      (func $b (type $0)
  ;; CHECK-NEXT:  (if
  ;; CHECK-NEXT:   (call $outline$)
  ;; CHECK-NEXT:   (then
  ;; CHECK-NEXT:    (global.set $global$1
  ;; CHECK-NEXT:     (i32.const 20)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $b
    (if
      (i32.eqz
        (global.get $global$1)
      )
      (then
        (global.set $global$1
          (i32.const 20)
        )
      )
    )
  )
)

;; Outline if-true.
(module
  ;; CHECK:      (type $0 (func (param i32)))

  ;; CHECK:      (type $1 (func))

  ;; CHECK:      (func $outline$ (type $1)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (i32.const 10)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )

  ;; CHECK:      (func $a (type $0) (param $0 i32)
  ;; CHECK-NEXT:  (if
  ;; CHECK-NEXT:   (i32.eqz
  ;; CHECK-NEXT:    (local.get $0)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (then
  ;; CHECK-NEXT:    (call $outline$)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $a (param i32)
    (if
      (i32.eqz
        (local.get 0)
      )
      (then
        (drop
          (i32.const 10)
        )
      )
    )
  )
  ;; CHECK:      (func $b (type $0) (param $0 i32)
  ;; CHECK-NEXT:  (if
  ;; CHECK-NEXT:   (i32.eqz
  ;; CHECK-NEXT:    (local.get $0)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (then
  ;; CHECK-NEXT:    (call $outline$)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $b (param i32)
    (if
      (i32.eqz
        (local.get 0)
      )
      (then
        (drop
          (i32.const 10)
        )
      )
    )
  )
)

;; Outline if-false.
(module
  ;; CHECK:      (type $0 (func))

  ;; CHECK:      (global $global$1 (mut i32) (i32.const 100))
  (global $global$1 (mut i32) (i32.const 100))
  ;; CHECK:      (func $outline$ (type $0)
  ;; CHECK-NEXT:  (global.set $global$1
  ;; CHECK-NEXT:   (i32.const 100)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )

  ;; CHECK:      (func $a (type $0)
  ;; CHECK-NEXT:  (if
  ;; CHECK-NEXT:   (i32.eqz
  ;; CHECK-NEXT:    (global.get $global$1)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (then
  ;; CHECK-NEXT:    (global.set $global$1
  ;; CHECK-NEXT:     (i32.const 15)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (else
  ;; CHECK-NEXT:    (call $outline$)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $a
    (if
      (i32.eqz
        (global.get $global$1)
      )
      (then
        (global.set $global$1
          (i32.const 15)
        )
      )
      (else
        (block
          (global.set $global$1
            (i32.const 100)
          )
        )
      )
    )
  )
  ;; CHECK:      (func $b (type $0)
  ;; CHECK-NEXT:  (if
  ;; CHECK-NEXT:   (i32.ctz
  ;; CHECK-NEXT:    (global.get $global$1)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (then
  ;; CHECK-NEXT:    (global.set $global$1
  ;; CHECK-NEXT:     (i32.const 30)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (else
  ;; CHECK-NEXT:    (call $outline$)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $b
    (if
      (i32.ctz
        (global.get $global$1)
      )
      (then
        (global.set $global$1
          (i32.const 30)
        )
      )
      (else
        (block
          (global.set $global$1
            (i32.const 100)
          )
        )
      )
    )
  )
)

;; Outline if control flow, with matching if-condition, if-true, if-false
;; TODO: Ideally outlining would keep the if-true and if-false inline in
;; $outline$, instead of moving them to another outlined function ($outline$_3
;; & $outline$_4) because of the unique symbol between the if-condition and
;; if-true and the unique symbol between if-true and if-false.
(module
  ;; CHECK:      (type $0 (func))

  ;; CHECK:      (global $global$1 (mut i32) (i32.const 100))
  (global $global$1 (mut i32) (i32.const 100))
  ;; CHECK:      (func $outline$ (type $0)
  ;; CHECK-NEXT:  (if
  ;; CHECK-NEXT:   (i32.eqz
  ;; CHECK-NEXT:    (global.get $global$1)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (then
  ;; CHECK-NEXT:    (call $outline$_3)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (else
  ;; CHECK-NEXT:    (call $outline$_4)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )

  ;; CHECK:      (func $outline$_3 (type $0)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (i32.const 10)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )

  ;; CHECK:      (func $outline$_4 (type $0)
  ;; CHECK-NEXT:  (global.set $global$1
  ;; CHECK-NEXT:   (i32.const 20)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )

  ;; CHECK:      (func $a (type $0)
  ;; CHECK-NEXT:  (call $outline$)
  ;; CHECK-NEXT: )
  (func $a
    (if
      (i32.eqz
        (global.get $global$1)
      )
      (then
        (drop
          (i32.const 10)
        )
      )
      (else
        (global.set $global$1
          (i32.const 20)
        )
      )
    )
  )
  ;; CHECK:      (func $b (type $0)
  ;; CHECK-NEXT:  (call $outline$)
  ;; CHECK-NEXT: )
  (func $b
    (if
      (i32.eqz
        (global.get $global$1)
      )
      (then
        (drop
          (i32.const 10)
        )
      )
      (else
        (global.set $global$1
          (i32.const 20)
        )
      )
    )
  )
)

;; Tests that local.get instructions are correctly filtered from being outlined.
(module
  ;; CHECK:      (type $0 (func (param i32)))

  ;; CHECK:      (func $a (type $0) (param $0 i32)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (i32.add
  ;; CHECK-NEXT:    (local.get $0)
  ;; CHECK-NEXT:    (i32.const 1)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $a (param i32)
    (drop
      (i32.add
        (local.get 0)
        (i32.const 1)
      )
    )
  )
  ;; CHECK:      (func $b (type $0) (param $0 i32)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (i32.add
  ;; CHECK-NEXT:    (local.get $0)
  ;; CHECK-NEXT:    (i32.const 1)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $b (param i32)
    (drop
      (i32.add
        (local.get 0)
        (i32.const 1)
      )
    )
  )
)

;; Tests local.set instructions are correctly filtered from being outlined.
(module
  ;; CHECK:      (type $0 (func))

  ;; CHECK:      (func $a (type $0)
  ;; CHECK-NEXT:  (local $i i32)
  ;; CHECK-NEXT:  (local.set $i
  ;; CHECK-NEXT:   (i32.const 7)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $a
    (local $i i32)
    (local.set $i
      (i32.const 7)
    )
  )
  ;; CHECK:      (func $b (type $0)
  ;; CHECK-NEXT:  (local $i i32)
  ;; CHECK-NEXT:  (local.set $i
  ;; CHECK-NEXT:   (i32.const 7)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $b
    (local $i i32)
    (local.set $i
      (i32.const 7)
    )
  )
)

;; Tests branch instructions are correctly filtered from being outlined.
(module
  ;; CHECK:      (type $0 (func))

  ;; CHECK:      (func $a (type $0)
  ;; CHECK-NEXT:  (block $label1
  ;; CHECK-NEXT:   (drop
  ;; CHECK-NEXT:    (i32.const 4)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (br $label1)
  ;; CHECK-NEXT:   (drop
  ;; CHECK-NEXT:    (i32.const 4)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (br $label1)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $a
    (block $label1
      (drop
        (i32.const 4)
      )
      (br $label1)
      (drop
        (i32.const 4)
      )
      (br $label1)
    )
  )
)

;; Tests branch with condition is reconstructed without error.
(module
  ;; CHECK:      (type $0 (func))

  ;; CHECK:      (func $outline$ (type $0)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (i32.const 2)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (i32.const 1)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )

  ;; CHECK:      (func $a (type $0)
  ;; CHECK-NEXT:  (block $label1
  ;; CHECK-NEXT:   (call $outline$)
  ;; CHECK-NEXT:   (loop
  ;; CHECK-NEXT:    (br $label1)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (call $outline$)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $a
    (block $label1
      (drop
        (i32.const 2)
      )
      (drop
        (i32.const 1)
      )
      (loop
        (br $label1)
      )
      (drop
        (i32.const 2)
      )
      (drop
        (i32.const 1)
      )
    )
  )
)

;; Tests br_table instruction is reconstructed without error.
(module
  ;; CHECK:      (type $0 (func))

  ;; CHECK:      (type $1 (func (param i32) (result i32)))

  ;; CHECK:      (func $outline$ (type $0)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (i32.const 2)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (i32.const 1)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )

  ;; CHECK:      (func $a (type $1) (param $0 i32) (result i32)
  ;; CHECK-NEXT:  (call $outline$)
  ;; CHECK-NEXT:  (block $block
  ;; CHECK-NEXT:   (block $block1
  ;; CHECK-NEXT:    (br_table $block $block1
  ;; CHECK-NEXT:     (local.get $0)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (return
  ;; CHECK-NEXT:     (i32.const 21)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (return
  ;; CHECK-NEXT:    (i32.const 20)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (call $outline$)
  ;; CHECK-NEXT:  (i32.const 22)
  ;; CHECK-NEXT: )
  (func $a (param i32) (result i32)
    (drop
      (i32.const 2)
    )
    (drop
      (i32.const 1)
    )
    (block
      (block
        (br_table 1 0 (local.get 0))
        (return (i32.const 21))
      )
      (return (i32.const 20))
    )
    (drop
      (i32.const 2)
    )
    (drop
      (i32.const 1)
    )
    (i32.const 22)
  )
)

;; Tests return instructions are correctly filtered from being outlined.
(module
  ;; CHECK:      (type $0 (func (result i32)))

  ;; CHECK:      (func $a (type $0) (result i32)
  ;; CHECK-NEXT:  (return
  ;; CHECK-NEXT:   (i32.const 2)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $a (result i32)
    (return
      (i32.const 2)
    )
  )
  ;; CHECK:      (func $b (type $0) (result i32)
  ;; CHECK-NEXT:  (return
  ;; CHECK-NEXT:   (i32.const 2)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $b (result i32)
    (return
      (i32.const 2)
    )
  )
)

;; Test that an outlined function is created with one return value.
(module
  ;; CHECK:      (type $0 (func (result i32)))

  ;; CHECK:      (func $outline$ (type $0) (result i32)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (i32.const 1)
  ;; CHECK-NEXT: )

  ;; CHECK:      (func $a (type $0) (result i32)
  ;; CHECK-NEXT:  (call $outline$)
  ;; CHECK-NEXT: )
  (func $a (result i32)
    (drop
      (i32.const 0)
    )
    (i32.const 1)
  )
  ;; CHECK:      (func $b (type $0) (result i32)
  ;; CHECK-NEXT:  (call $outline$)
  ;; CHECK-NEXT: )
  (func $b (result i32)
    (drop
      (i32.const 0)
    )
    (i32.const 1)
  )
)

;; Test that an outlined function is created with multiple return values.
(module
  ;; CHECK:      (type $0 (func (result i32 i32)))

  ;; CHECK:      (type $1 (func))

  ;; CHECK:      (func $outline$ (type $0) (result i32 i32)
  ;; CHECK-NEXT:  (tuple.make 2
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:   (i32.const 1)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )

  ;; CHECK:      (func $a (type $1)
  ;; CHECK-NEXT:  (local $scratch (tuple i32 i32))
  ;; CHECK-NEXT:  (local $scratch_1 (tuple i32 i32))
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (i32.add
  ;; CHECK-NEXT:    (tuple.extract 2 0
  ;; CHECK-NEXT:     (local.tee $scratch
  ;; CHECK-NEXT:      (call $outline$)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (tuple.extract 2 1
  ;; CHECK-NEXT:     (local.get $scratch)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (i32.mul
  ;; CHECK-NEXT:    (tuple.extract 2 0
  ;; CHECK-NEXT:     (local.tee $scratch_1
  ;; CHECK-NEXT:      (call $outline$)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (tuple.extract 2 1
  ;; CHECK-NEXT:     (local.get $scratch_1)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $a
    (drop
      (i32.add
        (i32.const 0)
        (i32.const 1)
      )
    )
    (drop
      (i32.mul
        (i32.const 0)
        (i32.const 1)
      )
    )
  )
)

;; Test outlining works with call_indirect
;; 0 results, 2 params, 3 operands
(module
  (table 1 1 funcref)
  ;; CHECK:      (type $0 (func))

  ;; CHECK:      (type $1 (func (param i32 i32)))

  ;; CHECK:      (table $0 1 1 funcref)

  ;; CHECK:      (func $outline$ (type $0)
  ;; CHECK-NEXT:  (call_indirect $0 (type $1)
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:   (i32.const 1)
  ;; CHECK-NEXT:   (i32.const 2)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )

  ;; CHECK:      (func $a (type $0)
  ;; CHECK-NEXT:  (call $outline$)
  ;; CHECK-NEXT:  (call $outline$)
  ;; CHECK-NEXT: )
  (func $a
    (call_indirect
      (param i32 i32)
      (i32.const 0)
      (i32.const 1)
      (i32.const 2)
    )
    (call_indirect
      (param i32 i32)
      (i32.const 0)
      (i32.const 1)
      (i32.const 2)
    )
  )
)

;; Test outlining works with call_indirect
;; 0 results, 0 params, 1 operand
(module
  (table 1 1 funcref)
  ;; CHECK:      (type $0 (func))

  ;; CHECK:      (table $0 1 1 funcref)

  ;; CHECK:      (func $outline$ (type $0)
  ;; CHECK-NEXT:  (call_indirect $0 (type $0)
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )

  ;; CHECK:      (func $a (type $0)
  ;; CHECK-NEXT:  (call $outline$)
  ;; CHECK-NEXT:  (call $outline$)
  ;; CHECK-NEXT: )
  (func $a
    (call_indirect
      (i32.const 0)
    )
    (call_indirect
      (i32.const 0)
    )
  )
)

;; Test outlining works with call_indirect
;; 1 result, 0 params, 1 operand
(module
  (table 1 1 funcref)
  ;; CHECK:      (type $0 (func))

  ;; CHECK:      (type $1 (func (result i32)))

  ;; CHECK:      (table $0 1 1 funcref)

  ;; CHECK:      (func $outline$ (type $0)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (call_indirect $0 (type $1)
  ;; CHECK-NEXT:    (i32.const 0)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )

  ;; CHECK:      (func $a (type $0)
  ;; CHECK-NEXT:  (call $outline$)
  ;; CHECK-NEXT:  (call $outline$)
  ;; CHECK-NEXT: )
  (func $a
    (drop
      (call_indirect
        (result i32)
        (i32.const 0)
      )
    )
    (drop
      (call_indirect
        (result i32)
        (i32.const 0)
      )
    )
  )
)

;; Test outlining works with call_indirect
;; 2 results, 0 params, 1 operand
(module
  (table 1 1 funcref)
  ;; CHECK:      (type $0 (func))

  ;; CHECK:      (type $1 (func (result i32 i32)))

  ;; CHECK:      (table $0 1 1 funcref)

  ;; CHECK:      (func $outline$ (type $0)
  ;; CHECK-NEXT:  (tuple.drop 2
  ;; CHECK-NEXT:   (call_indirect $0 (type $1)
  ;; CHECK-NEXT:    (i32.const 0)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )

  ;; CHECK:      (func $a (type $0)
  ;; CHECK-NEXT:  (call $outline$)
  ;; CHECK-NEXT:  (call $outline$)
  ;; CHECK-NEXT: )
  (func $a
    (tuple.drop 2
      (call_indirect
        (result i32 i32)
        (i32.const 0)
      )
    )
    (tuple.drop 2
      (call_indirect
        (result i32 i32)
        (i32.const 0)
      )
    )
  )
)

;; Outline a loop
;; TODO: Ideally, a loop (like any control flow) repeated within a program can
;; be outlined by itself. Right now this is not possible since a control flow
;; is represented by a single symbol and only sequences of symbols >= 2 are
;; candidates for outlining.
(module
  ;; CHECK:      (type $0 (func))

  ;; CHECK:      (func $outline$ (type $0)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (loop
  ;; CHECK-NEXT:   (nop)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )

  ;; CHECK:      (func $a (type $0)
  ;; CHECK-NEXT:  (call $outline$)
  ;; CHECK-NEXT: )
  (func $a
    (drop
      (i32.const 0)
    )
    (loop (nop))
  )
  ;; CHECK:      (func $b (type $0)
  ;; CHECK-NEXT:  (call $outline$)
  ;; CHECK-NEXT: )
  (func $b
    (drop
      (i32.const 0)
    )
    (loop (nop))
  )
)

;; Test that no attempt is made to outline overlapping repeat substrings
(module
  (func $a
    (drop (i32.const 0))
    (drop (i32.const 1))
    (drop (i32.const 2))
    (drop (i32.const 3))
    (drop (i32.const 0))
    (drop (i32.const 1))
    (drop (i32.const 2))
    (drop (i32.const 3))
    (drop (i32.const 1))
    (drop (i32.const 2))
    (drop (i32.const 1))
    (drop (i32.const 2))
  )
)
