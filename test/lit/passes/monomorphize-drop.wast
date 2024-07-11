;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.

;; As in monomorphize-types.wast, test in both "always" mode, which always
;; monomorphizes, and in "careful" mode which does it only when it appears to
;; actually help.

;; RUN: foreach %s %t wasm-opt --monomorphize-always -all -S -o - | filecheck %s --check-prefix ALWAYS
;; RUN: foreach %s %t wasm-opt --monomorphize        -all -S -o - | filecheck %s --check-prefix CAREFUL

(module
  ;; Test that dropped functions are monomorphized, and the drop is reverse-
  ;; inlined into the called function, enabling more optimizations.

  ;; ALWAYS:      (type $0 (func (param i32 i32) (result i32)))

  ;; ALWAYS:      (type $1 (func (param i32)))

  ;; ALWAYS:      (type $2 (func))

  ;; ALWAYS:      (type $3 (func (param i32 i32)))

  ;; ALWAYS:      (import "a" "b" (func $import (type $0) (param i32 i32) (result i32)))
  ;; CAREFUL:      (type $0 (func (param i32 i32) (result i32)))

  ;; CAREFUL:      (type $1 (func (param i32)))

  ;; CAREFUL:      (type $2 (func))

  ;; CAREFUL:      (type $3 (func (param i32 i32)))

  ;; CAREFUL:      (import "a" "b" (func $import (type $0) (param i32 i32) (result i32)))
  (import "a" "b" (func $import (param i32 i32) (result i32)))

  ;; ALWAYS:      (func $work (type $0) (param $x i32) (param $y i32) (result i32)
  ;; ALWAYS-NEXT:  (i32.mul
  ;; ALWAYS-NEXT:   (i32.xor
  ;; ALWAYS-NEXT:    (local.get $x)
  ;; ALWAYS-NEXT:    (local.get $y)
  ;; ALWAYS-NEXT:   )
  ;; ALWAYS-NEXT:   (i32.add
  ;; ALWAYS-NEXT:    (local.get $x)
  ;; ALWAYS-NEXT:    (local.get $y)
  ;; ALWAYS-NEXT:   )
  ;; ALWAYS-NEXT:  )
  ;; ALWAYS-NEXT: )
  ;; CAREFUL:      (func $work (type $0) (param $0 i32) (param $1 i32) (result i32)
  ;; CAREFUL-NEXT:  (i32.mul
  ;; CAREFUL-NEXT:   (i32.add
  ;; CAREFUL-NEXT:    (local.get $0)
  ;; CAREFUL-NEXT:    (local.get $1)
  ;; CAREFUL-NEXT:   )
  ;; CAREFUL-NEXT:   (i32.xor
  ;; CAREFUL-NEXT:    (local.get $0)
  ;; CAREFUL-NEXT:    (local.get $1)
  ;; CAREFUL-NEXT:   )
  ;; CAREFUL-NEXT:  )
  ;; CAREFUL-NEXT: )
  (func $work (param $x i32) (param $y i32) (result i32)
    ;; Do some nontrivial work that we return. If this is dropped then we don't
    ;; need that work.
    (i32.mul
      (i32.xor
        (local.get $x)
        (local.get $y)
      )
      (i32.add
        (local.get $x)
        (local.get $y)
      )
    )
  )

  ;; ALWAYS:      (func $calls (type $1) (param $x i32)
  ;; ALWAYS-NEXT:  (call $work_4)
  ;; ALWAYS-NEXT:  (call $work_4)
  ;; ALWAYS-NEXT:  (call $work_5
  ;; ALWAYS-NEXT:   (local.get $x)
  ;; ALWAYS-NEXT:  )
  ;; ALWAYS-NEXT:  (call $work_6
  ;; ALWAYS-NEXT:   (local.get $x)
  ;; ALWAYS-NEXT:   (local.get $x)
  ;; ALWAYS-NEXT:  )
  ;; ALWAYS-NEXT: )
  ;; CAREFUL:      (func $calls (type $1) (param $x i32)
  ;; CAREFUL-NEXT:  (call $work_4)
  ;; CAREFUL-NEXT:  (call $work_4)
  ;; CAREFUL-NEXT:  (call $work_5
  ;; CAREFUL-NEXT:   (local.get $x)
  ;; CAREFUL-NEXT:  )
  ;; CAREFUL-NEXT:  (call $work_6
  ;; CAREFUL-NEXT:   (local.get $x)
  ;; CAREFUL-NEXT:   (local.get $x)
  ;; CAREFUL-NEXT:  )
  ;; CAREFUL-NEXT: )
  (func $calls (param $x i32)
    ;; Both of these can call the same monomorphized function. In CAREFUL mode
    ;; that function's body can also be optimized into a nop.
    (drop
      (call $work
        (i32.const 3)
        (i32.const 4)
      )
    )
    (drop
      (call $work
        (i32.const 3)
        (i32.const 4)
      )
    )
    ;; Another call, now with an unknown parameter. This calls a different
    ;; monomorphized function, but once again the body can be optimized into a
    ;; nop in CAREFUL.
    (drop
      (call $work
        (i32.const 3)
        (local.get $x)
      )
    )
    ;; Two unknown parameters. Yet another monomorphized function, but the same
    ;; outcome.
    (drop
      (call $work
        (local.get $x)
        (local.get $x)
      )
    )
  )

  ;; ALWAYS:      (func $call-import (type $2)
  ;; ALWAYS-NEXT:  (drop
  ;; ALWAYS-NEXT:   (call $import
  ;; ALWAYS-NEXT:    (i32.const 3)
  ;; ALWAYS-NEXT:    (i32.const 4)
  ;; ALWAYS-NEXT:   )
  ;; ALWAYS-NEXT:  )
  ;; ALWAYS-NEXT: )
  ;; CAREFUL:      (func $call-import (type $2)
  ;; CAREFUL-NEXT:  (drop
  ;; CAREFUL-NEXT:   (call $import
  ;; CAREFUL-NEXT:    (i32.const 3)
  ;; CAREFUL-NEXT:    (i32.const 4)
  ;; CAREFUL-NEXT:   )
  ;; CAREFUL-NEXT:  )
  ;; CAREFUL-NEXT: )
  (func $call-import
    ;; Calling an import allows no optimizations.
    (drop
      (call $import
        (i32.const 3)
        (i32.const 4)
      )
    )
  )
)
;; ALWAYS:      (func $work_4 (type $2)
;; ALWAYS-NEXT:  (local $x i32)
;; ALWAYS-NEXT:  (local $y i32)
;; ALWAYS-NEXT:  (drop
;; ALWAYS-NEXT:   (block (result i32)
;; ALWAYS-NEXT:    (local.set $x
;; ALWAYS-NEXT:     (i32.const 3)
;; ALWAYS-NEXT:    )
;; ALWAYS-NEXT:    (local.set $y
;; ALWAYS-NEXT:     (i32.const 4)
;; ALWAYS-NEXT:    )
;; ALWAYS-NEXT:    (i32.mul
;; ALWAYS-NEXT:     (i32.xor
;; ALWAYS-NEXT:      (local.get $x)
;; ALWAYS-NEXT:      (local.get $y)
;; ALWAYS-NEXT:     )
;; ALWAYS-NEXT:     (i32.add
;; ALWAYS-NEXT:      (local.get $x)
;; ALWAYS-NEXT:      (local.get $y)
;; ALWAYS-NEXT:     )
;; ALWAYS-NEXT:    )
;; ALWAYS-NEXT:   )
;; ALWAYS-NEXT:  )
;; ALWAYS-NEXT: )

;; ALWAYS:      (func $work_5 (type $1) (param $0 i32)
;; ALWAYS-NEXT:  (local $x i32)
;; ALWAYS-NEXT:  (local $y i32)
;; ALWAYS-NEXT:  (drop
;; ALWAYS-NEXT:   (block (result i32)
;; ALWAYS-NEXT:    (local.set $x
;; ALWAYS-NEXT:     (i32.const 3)
;; ALWAYS-NEXT:    )
;; ALWAYS-NEXT:    (local.set $y
;; ALWAYS-NEXT:     (local.get $0)
;; ALWAYS-NEXT:    )
;; ALWAYS-NEXT:    (i32.mul
;; ALWAYS-NEXT:     (i32.xor
;; ALWAYS-NEXT:      (local.get $x)
;; ALWAYS-NEXT:      (local.get $y)
;; ALWAYS-NEXT:     )
;; ALWAYS-NEXT:     (i32.add
;; ALWAYS-NEXT:      (local.get $x)
;; ALWAYS-NEXT:      (local.get $y)
;; ALWAYS-NEXT:     )
;; ALWAYS-NEXT:    )
;; ALWAYS-NEXT:   )
;; ALWAYS-NEXT:  )
;; ALWAYS-NEXT: )

;; ALWAYS:      (func $work_6 (type $3) (param $0 i32) (param $1 i32)
;; ALWAYS-NEXT:  (local $x i32)
;; ALWAYS-NEXT:  (local $y i32)
;; ALWAYS-NEXT:  (drop
;; ALWAYS-NEXT:   (block (result i32)
;; ALWAYS-NEXT:    (local.set $x
;; ALWAYS-NEXT:     (local.get $0)
;; ALWAYS-NEXT:    )
;; ALWAYS-NEXT:    (local.set $y
;; ALWAYS-NEXT:     (local.get $1)
;; ALWAYS-NEXT:    )
;; ALWAYS-NEXT:    (i32.mul
;; ALWAYS-NEXT:     (i32.xor
;; ALWAYS-NEXT:      (local.get $x)
;; ALWAYS-NEXT:      (local.get $y)
;; ALWAYS-NEXT:     )
;; ALWAYS-NEXT:     (i32.add
;; ALWAYS-NEXT:      (local.get $x)
;; ALWAYS-NEXT:      (local.get $y)
;; ALWAYS-NEXT:     )
;; ALWAYS-NEXT:    )
;; ALWAYS-NEXT:   )
;; ALWAYS-NEXT:  )
;; ALWAYS-NEXT: )

;; CAREFUL:      (func $work_4 (type $2)
;; CAREFUL-NEXT:  (nop)
;; CAREFUL-NEXT: )

;; CAREFUL:      (func $work_5 (type $1) (param $0 i32)
;; CAREFUL-NEXT:  (nop)
;; CAREFUL-NEXT: )

;; CAREFUL:      (func $work_6 (type $3) (param $0 i32) (param $1 i32)
;; CAREFUL-NEXT:  (nop)
;; CAREFUL-NEXT: )