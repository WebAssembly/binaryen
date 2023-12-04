;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.

;; Enable both full and partial inlining, and show how we filter out functions
;; using --no-*-inline. The functions with "yes" in their names will always be
;; inlined, while the ones with "maybe" will be filtered out in some modes.

;; RUN: foreach %s %t wasm-opt                             --inlining --optimize-level=3 --partial-inlining-ifs=1 -S -o - | filecheck %s --check-prefix INLINE__ALL
;; RUN: foreach %s %t wasm-opt --no-partial-inline=*maybe* --inlining --optimize-level=3 --partial-inlining-ifs=1 -S -o - | filecheck %s --check-prefix INLINE_FULL
;; RUN: foreach %s %t wasm-opt --no-full-inline=*maybe*    --inlining --optimize-level=3 --partial-inlining-ifs=1 -S -o - | filecheck %s --check-prefix INLINE_PART
;; RUN: foreach %s %t wasm-opt --no-inline=*maybe*         --inlining --optimize-level=3 --partial-inlining-ifs=1 -S -o - | filecheck %s --check-prefix INLINE_NONE

(module
  ;; INLINE__ALL:      (type $0 (func))

  ;; INLINE__ALL:      (import "a" "b" (func $import))
  ;; INLINE_FULL:      (type $0 (func))

  ;; INLINE_FULL:      (import "a" "b" (func $import))
  ;; INLINE_PART:      (type $0 (func))

  ;; INLINE_PART:      (type $1 (func (param i32)))

  ;; INLINE_PART:      (import "a" "b" (func $import))
  ;; INLINE_NONE:      (type $0 (func))

  ;; INLINE_NONE:      (type $1 (func (param i32)))

  ;; INLINE_NONE:      (import "a" "b" (func $import))
  (import "a" "b" (func $import))

  (func $full-yes-inline (param $x i32)
    (call $import)
  )

  ;; INLINE_PART:      (func $full-maybe-inline (param $x i32)
  ;; INLINE_PART-NEXT:  (call $import)
  ;; INLINE_PART-NEXT: )
  ;; INLINE_NONE:      (func $full-maybe-inline (param $x i32)
  ;; INLINE_NONE-NEXT:  (call $import)
  ;; INLINE_NONE-NEXT: )
  (func $full-maybe-inline (param $x i32)
    (call $import)
  )

  (func $partial-yes-inline (param $x i32)
    (if
      (local.get $x)
      (return)
    )
    (loop $l
      (call $import)
      (br $l)
    )
  )

  ;; INLINE_NONE:      (func $partial-maybe-inline (param $x i32)
  ;; INLINE_NONE-NEXT:  (if
  ;; INLINE_NONE-NEXT:   (local.get $x)
  ;; INLINE_NONE-NEXT:   (return)
  ;; INLINE_NONE-NEXT:  )
  ;; INLINE_NONE-NEXT:  (loop $l
  ;; INLINE_NONE-NEXT:   (call $import)
  ;; INLINE_NONE-NEXT:   (br $l)
  ;; INLINE_NONE-NEXT:  )
  ;; INLINE_NONE-NEXT: )
  (func $partial-maybe-inline (param $x i32)
    (if
      (local.get $x)
      (return)
    )
    (loop $l
      (call $import)
      (br $l)
    )
  )

  ;; INLINE__ALL:      (func $caller
  ;; INLINE__ALL-NEXT:  (local $0 i32)
  ;; INLINE__ALL-NEXT:  (local $1 i32)
  ;; INLINE__ALL-NEXT:  (local $2 i32)
  ;; INLINE__ALL-NEXT:  (local $3 i32)
  ;; INLINE__ALL-NEXT:  (block
  ;; INLINE__ALL-NEXT:   (block $__inlined_func$full-yes-inline
  ;; INLINE__ALL-NEXT:    (local.set $0
  ;; INLINE__ALL-NEXT:     (i32.const 0)
  ;; INLINE__ALL-NEXT:    )
  ;; INLINE__ALL-NEXT:    (call $import)
  ;; INLINE__ALL-NEXT:   )
  ;; INLINE__ALL-NEXT:  )
  ;; INLINE__ALL-NEXT:  (block
  ;; INLINE__ALL-NEXT:   (block $__inlined_func$full-maybe-inline$1
  ;; INLINE__ALL-NEXT:    (local.set $1
  ;; INLINE__ALL-NEXT:     (i32.const 1)
  ;; INLINE__ALL-NEXT:    )
  ;; INLINE__ALL-NEXT:    (call $import)
  ;; INLINE__ALL-NEXT:   )
  ;; INLINE__ALL-NEXT:  )
  ;; INLINE__ALL-NEXT:  (block
  ;; INLINE__ALL-NEXT:   (block $__inlined_func$partial-yes-inline$2
  ;; INLINE__ALL-NEXT:    (local.set $2
  ;; INLINE__ALL-NEXT:     (i32.const 2)
  ;; INLINE__ALL-NEXT:    )
  ;; INLINE__ALL-NEXT:    (block
  ;; INLINE__ALL-NEXT:     (if
  ;; INLINE__ALL-NEXT:      (local.get $2)
  ;; INLINE__ALL-NEXT:      (br $__inlined_func$partial-yes-inline$2)
  ;; INLINE__ALL-NEXT:     )
  ;; INLINE__ALL-NEXT:     (loop $l
  ;; INLINE__ALL-NEXT:      (call $import)
  ;; INLINE__ALL-NEXT:      (br $l)
  ;; INLINE__ALL-NEXT:     )
  ;; INLINE__ALL-NEXT:    )
  ;; INLINE__ALL-NEXT:   )
  ;; INLINE__ALL-NEXT:  )
  ;; INLINE__ALL-NEXT:  (block
  ;; INLINE__ALL-NEXT:   (block $__inlined_func$partial-maybe-inline$3
  ;; INLINE__ALL-NEXT:    (local.set $3
  ;; INLINE__ALL-NEXT:     (i32.const 3)
  ;; INLINE__ALL-NEXT:    )
  ;; INLINE__ALL-NEXT:    (block
  ;; INLINE__ALL-NEXT:     (if
  ;; INLINE__ALL-NEXT:      (local.get $3)
  ;; INLINE__ALL-NEXT:      (br $__inlined_func$partial-maybe-inline$3)
  ;; INLINE__ALL-NEXT:     )
  ;; INLINE__ALL-NEXT:     (loop $l0
  ;; INLINE__ALL-NEXT:      (call $import)
  ;; INLINE__ALL-NEXT:      (br $l0)
  ;; INLINE__ALL-NEXT:     )
  ;; INLINE__ALL-NEXT:    )
  ;; INLINE__ALL-NEXT:   )
  ;; INLINE__ALL-NEXT:  )
  ;; INLINE__ALL-NEXT: )
  ;; INLINE_FULL:      (func $caller
  ;; INLINE_FULL-NEXT:  (local $0 i32)
  ;; INLINE_FULL-NEXT:  (local $1 i32)
  ;; INLINE_FULL-NEXT:  (local $2 i32)
  ;; INLINE_FULL-NEXT:  (local $3 i32)
  ;; INLINE_FULL-NEXT:  (block
  ;; INLINE_FULL-NEXT:   (block $__inlined_func$full-yes-inline
  ;; INLINE_FULL-NEXT:    (local.set $0
  ;; INLINE_FULL-NEXT:     (i32.const 0)
  ;; INLINE_FULL-NEXT:    )
  ;; INLINE_FULL-NEXT:    (call $import)
  ;; INLINE_FULL-NEXT:   )
  ;; INLINE_FULL-NEXT:  )
  ;; INLINE_FULL-NEXT:  (block
  ;; INLINE_FULL-NEXT:   (block $__inlined_func$full-maybe-inline$1
  ;; INLINE_FULL-NEXT:    (local.set $1
  ;; INLINE_FULL-NEXT:     (i32.const 1)
  ;; INLINE_FULL-NEXT:    )
  ;; INLINE_FULL-NEXT:    (call $import)
  ;; INLINE_FULL-NEXT:   )
  ;; INLINE_FULL-NEXT:  )
  ;; INLINE_FULL-NEXT:  (block
  ;; INLINE_FULL-NEXT:   (block $__inlined_func$partial-yes-inline$2
  ;; INLINE_FULL-NEXT:    (local.set $2
  ;; INLINE_FULL-NEXT:     (i32.const 2)
  ;; INLINE_FULL-NEXT:    )
  ;; INLINE_FULL-NEXT:    (block
  ;; INLINE_FULL-NEXT:     (if
  ;; INLINE_FULL-NEXT:      (local.get $2)
  ;; INLINE_FULL-NEXT:      (br $__inlined_func$partial-yes-inline$2)
  ;; INLINE_FULL-NEXT:     )
  ;; INLINE_FULL-NEXT:     (loop $l
  ;; INLINE_FULL-NEXT:      (call $import)
  ;; INLINE_FULL-NEXT:      (br $l)
  ;; INLINE_FULL-NEXT:     )
  ;; INLINE_FULL-NEXT:    )
  ;; INLINE_FULL-NEXT:   )
  ;; INLINE_FULL-NEXT:  )
  ;; INLINE_FULL-NEXT:  (block
  ;; INLINE_FULL-NEXT:   (block $__inlined_func$partial-maybe-inline$3
  ;; INLINE_FULL-NEXT:    (local.set $3
  ;; INLINE_FULL-NEXT:     (i32.const 3)
  ;; INLINE_FULL-NEXT:    )
  ;; INLINE_FULL-NEXT:    (block
  ;; INLINE_FULL-NEXT:     (if
  ;; INLINE_FULL-NEXT:      (local.get $3)
  ;; INLINE_FULL-NEXT:      (br $__inlined_func$partial-maybe-inline$3)
  ;; INLINE_FULL-NEXT:     )
  ;; INLINE_FULL-NEXT:     (loop $l0
  ;; INLINE_FULL-NEXT:      (call $import)
  ;; INLINE_FULL-NEXT:      (br $l0)
  ;; INLINE_FULL-NEXT:     )
  ;; INLINE_FULL-NEXT:    )
  ;; INLINE_FULL-NEXT:   )
  ;; INLINE_FULL-NEXT:  )
  ;; INLINE_FULL-NEXT: )
  ;; INLINE_PART:      (func $caller
  ;; INLINE_PART-NEXT:  (local $0 i32)
  ;; INLINE_PART-NEXT:  (local $1 i32)
  ;; INLINE_PART-NEXT:  (local $2 i32)
  ;; INLINE_PART-NEXT:  (block
  ;; INLINE_PART-NEXT:   (block $__inlined_func$full-yes-inline
  ;; INLINE_PART-NEXT:    (local.set $0
  ;; INLINE_PART-NEXT:     (i32.const 0)
  ;; INLINE_PART-NEXT:    )
  ;; INLINE_PART-NEXT:    (call $import)
  ;; INLINE_PART-NEXT:   )
  ;; INLINE_PART-NEXT:  )
  ;; INLINE_PART-NEXT:  (call $full-maybe-inline
  ;; INLINE_PART-NEXT:   (i32.const 1)
  ;; INLINE_PART-NEXT:  )
  ;; INLINE_PART-NEXT:  (block
  ;; INLINE_PART-NEXT:   (block $__inlined_func$partial-yes-inline$1
  ;; INLINE_PART-NEXT:    (local.set $1
  ;; INLINE_PART-NEXT:     (i32.const 2)
  ;; INLINE_PART-NEXT:    )
  ;; INLINE_PART-NEXT:    (block
  ;; INLINE_PART-NEXT:     (if
  ;; INLINE_PART-NEXT:      (local.get $1)
  ;; INLINE_PART-NEXT:      (br $__inlined_func$partial-yes-inline$1)
  ;; INLINE_PART-NEXT:     )
  ;; INLINE_PART-NEXT:     (loop $l
  ;; INLINE_PART-NEXT:      (call $import)
  ;; INLINE_PART-NEXT:      (br $l)
  ;; INLINE_PART-NEXT:     )
  ;; INLINE_PART-NEXT:    )
  ;; INLINE_PART-NEXT:   )
  ;; INLINE_PART-NEXT:  )
  ;; INLINE_PART-NEXT:  (block
  ;; INLINE_PART-NEXT:   (block $__inlined_func$partial-maybe-inline$2
  ;; INLINE_PART-NEXT:    (local.set $2
  ;; INLINE_PART-NEXT:     (i32.const 3)
  ;; INLINE_PART-NEXT:    )
  ;; INLINE_PART-NEXT:    (block
  ;; INLINE_PART-NEXT:     (if
  ;; INLINE_PART-NEXT:      (local.get $2)
  ;; INLINE_PART-NEXT:      (br $__inlined_func$partial-maybe-inline$2)
  ;; INLINE_PART-NEXT:     )
  ;; INLINE_PART-NEXT:     (loop $l0
  ;; INLINE_PART-NEXT:      (call $import)
  ;; INLINE_PART-NEXT:      (br $l0)
  ;; INLINE_PART-NEXT:     )
  ;; INLINE_PART-NEXT:    )
  ;; INLINE_PART-NEXT:   )
  ;; INLINE_PART-NEXT:  )
  ;; INLINE_PART-NEXT: )
  ;; INLINE_NONE:      (func $caller
  ;; INLINE_NONE-NEXT:  (local $0 i32)
  ;; INLINE_NONE-NEXT:  (local $1 i32)
  ;; INLINE_NONE-NEXT:  (block
  ;; INLINE_NONE-NEXT:   (block $__inlined_func$full-yes-inline
  ;; INLINE_NONE-NEXT:    (local.set $0
  ;; INLINE_NONE-NEXT:     (i32.const 0)
  ;; INLINE_NONE-NEXT:    )
  ;; INLINE_NONE-NEXT:    (call $import)
  ;; INLINE_NONE-NEXT:   )
  ;; INLINE_NONE-NEXT:  )
  ;; INLINE_NONE-NEXT:  (call $full-maybe-inline
  ;; INLINE_NONE-NEXT:   (i32.const 1)
  ;; INLINE_NONE-NEXT:  )
  ;; INLINE_NONE-NEXT:  (block
  ;; INLINE_NONE-NEXT:   (block $__inlined_func$partial-yes-inline$1
  ;; INLINE_NONE-NEXT:    (local.set $1
  ;; INLINE_NONE-NEXT:     (i32.const 2)
  ;; INLINE_NONE-NEXT:    )
  ;; INLINE_NONE-NEXT:    (block
  ;; INLINE_NONE-NEXT:     (if
  ;; INLINE_NONE-NEXT:      (local.get $1)
  ;; INLINE_NONE-NEXT:      (br $__inlined_func$partial-yes-inline$1)
  ;; INLINE_NONE-NEXT:     )
  ;; INLINE_NONE-NEXT:     (loop $l
  ;; INLINE_NONE-NEXT:      (call $import)
  ;; INLINE_NONE-NEXT:      (br $l)
  ;; INLINE_NONE-NEXT:     )
  ;; INLINE_NONE-NEXT:    )
  ;; INLINE_NONE-NEXT:   )
  ;; INLINE_NONE-NEXT:  )
  ;; INLINE_NONE-NEXT:  (call $partial-maybe-inline
  ;; INLINE_NONE-NEXT:   (i32.const 3)
  ;; INLINE_NONE-NEXT:  )
  ;; INLINE_NONE-NEXT: )
  (func $caller
    ;; The "yes" functions will be inlined, but no the "no"
    (call $full-yes-inline
      (i32.const 0)
    )
    (call $full-maybe-inline
      (i32.const 1)
    )
    (call $partial-yes-inline
      (i32.const 2)
    )
    (call $partial-maybe-inline
      (i32.const 3)
    )
  )
)
