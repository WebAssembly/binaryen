;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.
;; NOTE: This test was ported using port_test.py and could be cleaned up.

;; RUN: foreach %s %t wasm-opt --inlining --optimize-level=3 -S -o - | filecheck %s

(module
  ;; CHECK:      (type $none_=>_i32 (func (result i32)))

  ;; CHECK:      (type $i32_=>_i32 (func (param i32) (result i32)))

  ;; CHECK:      (type $none_=>_none (func))

  ;; CHECK:      (table $0 1 1 funcref)

  ;; CHECK:      (elem (i32.const 0) $no-loops-but-one-use-but-tabled)

  ;; CHECK:      (export "yes" (func $yes))
  (export "yes" (func $yes))
  ;; CHECK:      (export "no-loops-but-one-use-but-exported" (func $no-loops-but-one-use-but-exported))
  (export "no-loops-but-one-use-but-exported" (func $no-loops-but-one-use-but-exported))
  (table 1 1 funcref)
  (elem (i32.const 0) $no-loops-but-one-use-but-tabled)

  ;; CHECK:      (export "A" (func $recursive-inlining-1))

  ;; CHECK:      (export "B" (func $recursive-inlining-2))

  ;; CHECK:      (func $yes (result i32)
  ;; CHECK-NEXT:  (i32.const 1)
  ;; CHECK-NEXT: )
  (func $yes (result i32) ;; inlinable: small, lightweight, even with multi uses and a global use, ok when opt-level=3
    (i32.const 1)
  )
  (func $yes-big-but-single-use (result i32)
    (nop) (nop) (nop) (nop) (nop) (nop)
    (nop) (nop) (nop) (nop) (nop) (nop)
    (nop) (nop) (nop) (nop) (nop) (nop)
    (nop) (nop) (nop) (nop) (nop) (nop)
    (nop) (nop) (nop) (nop) (nop) (nop)
    (nop) (nop) (nop) (nop) (nop) (nop)
    (i32.const 1)
  )
  (func $no-calls (result i32)
    (call $yes)
  )
  (func $yes-calls-but-one-use (result i32)
    (call $yes)
  )
  (func $no-loops (result i32)
    (loop (result i32)
      (i32.const 1)
    )
  )
  (func $yes-loops-but-one-use (result i32)
    (loop (result i32)
      (i32.const 1)
    )
  )
  ;; CHECK:      (func $no-loops-but-one-use-but-exported (result i32)
  ;; CHECK-NEXT:  (loop $loop-in (result i32)
  ;; CHECK-NEXT:   (i32.const 1)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $no-loops-but-one-use-but-exported (result i32)
    (loop (result i32)
      (i32.const 1)
    )
  )
  ;; CHECK:      (func $no-loops-but-one-use-but-tabled (result i32)
  ;; CHECK-NEXT:  (loop $loop-in (result i32)
  ;; CHECK-NEXT:   (i32.const 1)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $no-loops-but-one-use-but-tabled (result i32)
    (loop (result i32)
      (i32.const 1)
    )
  )
  ;; CHECK:      (func $intoHere
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (block (result i32)
  ;; CHECK-NEXT:    (block $__inlined_func$yes (result i32)
  ;; CHECK-NEXT:     (i32.const 1)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (block (result i32)
  ;; CHECK-NEXT:    (block $__inlined_func$yes-big-but-single-use (result i32)
  ;; CHECK-NEXT:     (block (result i32)
  ;; CHECK-NEXT:      (nop)
  ;; CHECK-NEXT:      (nop)
  ;; CHECK-NEXT:      (nop)
  ;; CHECK-NEXT:      (nop)
  ;; CHECK-NEXT:      (nop)
  ;; CHECK-NEXT:      (nop)
  ;; CHECK-NEXT:      (nop)
  ;; CHECK-NEXT:      (nop)
  ;; CHECK-NEXT:      (nop)
  ;; CHECK-NEXT:      (nop)
  ;; CHECK-NEXT:      (nop)
  ;; CHECK-NEXT:      (nop)
  ;; CHECK-NEXT:      (nop)
  ;; CHECK-NEXT:      (nop)
  ;; CHECK-NEXT:      (nop)
  ;; CHECK-NEXT:      (nop)
  ;; CHECK-NEXT:      (nop)
  ;; CHECK-NEXT:      (nop)
  ;; CHECK-NEXT:      (nop)
  ;; CHECK-NEXT:      (nop)
  ;; CHECK-NEXT:      (nop)
  ;; CHECK-NEXT:      (nop)
  ;; CHECK-NEXT:      (nop)
  ;; CHECK-NEXT:      (nop)
  ;; CHECK-NEXT:      (nop)
  ;; CHECK-NEXT:      (nop)
  ;; CHECK-NEXT:      (nop)
  ;; CHECK-NEXT:      (nop)
  ;; CHECK-NEXT:      (nop)
  ;; CHECK-NEXT:      (nop)
  ;; CHECK-NEXT:      (nop)
  ;; CHECK-NEXT:      (nop)
  ;; CHECK-NEXT:      (nop)
  ;; CHECK-NEXT:      (nop)
  ;; CHECK-NEXT:      (nop)
  ;; CHECK-NEXT:      (nop)
  ;; CHECK-NEXT:      (i32.const 1)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (block (result i32)
  ;; CHECK-NEXT:    (block (result i32)
  ;; CHECK-NEXT:     (block $__inlined_func$no-calls (result i32)
  ;; CHECK-NEXT:      (block (result i32)
  ;; CHECK-NEXT:       (block $__inlined_func$yes0 (result i32)
  ;; CHECK-NEXT:        (i32.const 1)
  ;; CHECK-NEXT:       )
  ;; CHECK-NEXT:      )
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (block (result i32)
  ;; CHECK-NEXT:    (block (result i32)
  ;; CHECK-NEXT:     (block $__inlined_func$no-calls1 (result i32)
  ;; CHECK-NEXT:      (block (result i32)
  ;; CHECK-NEXT:       (block $__inlined_func$yes2 (result i32)
  ;; CHECK-NEXT:        (i32.const 1)
  ;; CHECK-NEXT:       )
  ;; CHECK-NEXT:      )
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (block (result i32)
  ;; CHECK-NEXT:    (block (result i32)
  ;; CHECK-NEXT:     (block $__inlined_func$yes-calls-but-one-use (result i32)
  ;; CHECK-NEXT:      (block (result i32)
  ;; CHECK-NEXT:       (block $__inlined_func$yes3 (result i32)
  ;; CHECK-NEXT:        (i32.const 1)
  ;; CHECK-NEXT:       )
  ;; CHECK-NEXT:      )
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (block (result i32)
  ;; CHECK-NEXT:    (block $__inlined_func$no-loops (result i32)
  ;; CHECK-NEXT:     (loop $loop-in (result i32)
  ;; CHECK-NEXT:      (i32.const 1)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (block (result i32)
  ;; CHECK-NEXT:    (block $__inlined_func$no-loops0 (result i32)
  ;; CHECK-NEXT:     (loop $loop-in1 (result i32)
  ;; CHECK-NEXT:      (i32.const 1)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (block (result i32)
  ;; CHECK-NEXT:    (block $__inlined_func$yes-loops-but-one-use (result i32)
  ;; CHECK-NEXT:     (loop $loop-in2 (result i32)
  ;; CHECK-NEXT:      (i32.const 1)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (block (result i32)
  ;; CHECK-NEXT:    (block $__inlined_func$no-loops-but-one-use-but-exported (result i32)
  ;; CHECK-NEXT:     (loop $loop-in3 (result i32)
  ;; CHECK-NEXT:      (i32.const 1)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (block (result i32)
  ;; CHECK-NEXT:    (block $__inlined_func$no-loops-but-one-use-but-tabled (result i32)
  ;; CHECK-NEXT:     (loop $loop-in4 (result i32)
  ;; CHECK-NEXT:      (i32.const 1)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $intoHere
    (drop (call $yes))
    (drop (call $yes-big-but-single-use))
    (drop (call $no-calls))
    (drop (call $no-calls))
    (drop (call $yes-calls-but-one-use))
    (drop (call $no-loops))
    (drop (call $no-loops))
    (drop (call $yes-loops-but-one-use))
    (drop (call $no-loops-but-one-use-but-exported))
    (drop (call $no-loops-but-one-use-but-tabled))
  )

  ;; Limit how much recursive inlining we perform to around 5 iterations.
  ;; CHECK:      (func $recursive-inlining-1 (param $x i32) (result i32)
  ;; CHECK-NEXT:  (local $1 i32)
  ;; CHECK-NEXT:  (i32.add
  ;; CHECK-NEXT:   (local.get $x)
  ;; CHECK-NEXT:   (block (result i32)
  ;; CHECK-NEXT:    (block $__inlined_func$recursive-inlining-2 (result i32)
  ;; CHECK-NEXT:     (local.set $1
  ;; CHECK-NEXT:      (local.get $x)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:     (i32.add
  ;; CHECK-NEXT:      (local.get $1)
  ;; CHECK-NEXT:      (block (result i32)
  ;; CHECK-NEXT:       (call $recursive-inlining-1
  ;; CHECK-NEXT:        (local.get $1)
  ;; CHECK-NEXT:       )
  ;; CHECK-NEXT:      )
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $recursive-inlining-1 (export "A") (param $x i32) (result i32)
    (i32.add
      (local.get $x)
      (call $recursive-inlining-2
        (local.get $x)
      )
    )
  )

  ;; CHECK:      (func $recursive-inlining-2 (param $x i32) (result i32)
  ;; CHECK-NEXT:  (local $1 i32)
  ;; CHECK-NEXT:  (local $2 i32)
  ;; CHECK-NEXT:  (local $3 i32)
  ;; CHECK-NEXT:  (local $4 i32)
  ;; CHECK-NEXT:  (local $5 i32)
  ;; CHECK-NEXT:  (local $6 i32)
  ;; CHECK-NEXT:  (local $7 i32)
  ;; CHECK-NEXT:  (local $8 i32)
  ;; CHECK-NEXT:  (local $9 i32)
  ;; CHECK-NEXT:  (local $10 i32)
  ;; CHECK-NEXT:  (i32.add
  ;; CHECK-NEXT:   (local.get $x)
  ;; CHECK-NEXT:   (block (result i32)
  ;; CHECK-NEXT:    (block (result i32)
  ;; CHECK-NEXT:     (block $__inlined_func$recursive-inlining-1 (result i32)
  ;; CHECK-NEXT:      (local.set $1
  ;; CHECK-NEXT:       (local.get $x)
  ;; CHECK-NEXT:      )
  ;; CHECK-NEXT:      (local.set $2
  ;; CHECK-NEXT:       (i32.const 0)
  ;; CHECK-NEXT:      )
  ;; CHECK-NEXT:      (i32.add
  ;; CHECK-NEXT:       (local.get $1)
  ;; CHECK-NEXT:       (block (result i32)
  ;; CHECK-NEXT:        (block $__inlined_func$recursive-inlining-2 (result i32)
  ;; CHECK-NEXT:         (local.set $2
  ;; CHECK-NEXT:          (local.get $1)
  ;; CHECK-NEXT:         )
  ;; CHECK-NEXT:         (i32.add
  ;; CHECK-NEXT:          (local.get $2)
  ;; CHECK-NEXT:          (block (result i32)
  ;; CHECK-NEXT:           (block (result i32)
  ;; CHECK-NEXT:            (block $__inlined_func$recursive-inlining-10 (result i32)
  ;; CHECK-NEXT:             (local.set $3
  ;; CHECK-NEXT:              (local.get $2)
  ;; CHECK-NEXT:             )
  ;; CHECK-NEXT:             (local.set $4
  ;; CHECK-NEXT:              (i32.const 0)
  ;; CHECK-NEXT:             )
  ;; CHECK-NEXT:             (i32.add
  ;; CHECK-NEXT:              (local.get $3)
  ;; CHECK-NEXT:              (block (result i32)
  ;; CHECK-NEXT:               (block $__inlined_func$recursive-inlining-21 (result i32)
  ;; CHECK-NEXT:                (local.set $4
  ;; CHECK-NEXT:                 (local.get $3)
  ;; CHECK-NEXT:                )
  ;; CHECK-NEXT:                (i32.add
  ;; CHECK-NEXT:                 (local.get $4)
  ;; CHECK-NEXT:                 (block (result i32)
  ;; CHECK-NEXT:                  (block (result i32)
  ;; CHECK-NEXT:                   (block $__inlined_func$recursive-inlining-11 (result i32)
  ;; CHECK-NEXT:                    (local.set $5
  ;; CHECK-NEXT:                     (local.get $4)
  ;; CHECK-NEXT:                    )
  ;; CHECK-NEXT:                    (local.set $6
  ;; CHECK-NEXT:                     (i32.const 0)
  ;; CHECK-NEXT:                    )
  ;; CHECK-NEXT:                    (i32.add
  ;; CHECK-NEXT:                     (local.get $5)
  ;; CHECK-NEXT:                     (block (result i32)
  ;; CHECK-NEXT:                      (block $__inlined_func$recursive-inlining-22 (result i32)
  ;; CHECK-NEXT:                       (local.set $6
  ;; CHECK-NEXT:                        (local.get $5)
  ;; CHECK-NEXT:                       )
  ;; CHECK-NEXT:                       (i32.add
  ;; CHECK-NEXT:                        (local.get $6)
  ;; CHECK-NEXT:                        (block (result i32)
  ;; CHECK-NEXT:                         (block (result i32)
  ;; CHECK-NEXT:                          (block $__inlined_func$recursive-inlining-12 (result i32)
  ;; CHECK-NEXT:                           (local.set $7
  ;; CHECK-NEXT:                            (local.get $6)
  ;; CHECK-NEXT:                           )
  ;; CHECK-NEXT:                           (local.set $8
  ;; CHECK-NEXT:                            (i32.const 0)
  ;; CHECK-NEXT:                           )
  ;; CHECK-NEXT:                           (i32.add
  ;; CHECK-NEXT:                            (local.get $7)
  ;; CHECK-NEXT:                            (block (result i32)
  ;; CHECK-NEXT:                             (block $__inlined_func$recursive-inlining-23 (result i32)
  ;; CHECK-NEXT:                              (local.set $8
  ;; CHECK-NEXT:                               (local.get $7)
  ;; CHECK-NEXT:                              )
  ;; CHECK-NEXT:                              (i32.add
  ;; CHECK-NEXT:                               (local.get $8)
  ;; CHECK-NEXT:                               (block (result i32)
  ;; CHECK-NEXT:                                (block (result i32)
  ;; CHECK-NEXT:                                 (block $__inlined_func$recursive-inlining-13 (result i32)
  ;; CHECK-NEXT:                                  (local.set $9
  ;; CHECK-NEXT:                                   (local.get $8)
  ;; CHECK-NEXT:                                  )
  ;; CHECK-NEXT:                                  (local.set $10
  ;; CHECK-NEXT:                                   (i32.const 0)
  ;; CHECK-NEXT:                                  )
  ;; CHECK-NEXT:                                  (i32.add
  ;; CHECK-NEXT:                                   (local.get $9)
  ;; CHECK-NEXT:                                   (block (result i32)
  ;; CHECK-NEXT:                                    (block $__inlined_func$recursive-inlining-24 (result i32)
  ;; CHECK-NEXT:                                     (local.set $10
  ;; CHECK-NEXT:                                      (local.get $9)
  ;; CHECK-NEXT:                                     )
  ;; CHECK-NEXT:                                     (i32.add
  ;; CHECK-NEXT:                                      (local.get $10)
  ;; CHECK-NEXT:                                      (block (result i32)
  ;; CHECK-NEXT:                                       (call $recursive-inlining-1
  ;; CHECK-NEXT:                                        (local.get $10)
  ;; CHECK-NEXT:                                       )
  ;; CHECK-NEXT:                                      )
  ;; CHECK-NEXT:                                     )
  ;; CHECK-NEXT:                                    )
  ;; CHECK-NEXT:                                   )
  ;; CHECK-NEXT:                                  )
  ;; CHECK-NEXT:                                 )
  ;; CHECK-NEXT:                                )
  ;; CHECK-NEXT:                               )
  ;; CHECK-NEXT:                              )
  ;; CHECK-NEXT:                             )
  ;; CHECK-NEXT:                            )
  ;; CHECK-NEXT:                           )
  ;; CHECK-NEXT:                          )
  ;; CHECK-NEXT:                         )
  ;; CHECK-NEXT:                        )
  ;; CHECK-NEXT:                       )
  ;; CHECK-NEXT:                      )
  ;; CHECK-NEXT:                     )
  ;; CHECK-NEXT:                    )
  ;; CHECK-NEXT:                   )
  ;; CHECK-NEXT:                  )
  ;; CHECK-NEXT:                 )
  ;; CHECK-NEXT:                )
  ;; CHECK-NEXT:               )
  ;; CHECK-NEXT:              )
  ;; CHECK-NEXT:             )
  ;; CHECK-NEXT:            )
  ;; CHECK-NEXT:           )
  ;; CHECK-NEXT:          )
  ;; CHECK-NEXT:         )
  ;; CHECK-NEXT:        )
  ;; CHECK-NEXT:       )
  ;; CHECK-NEXT:      )
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $recursive-inlining-2 (export "B") (param $x i32) (result i32)
    (i32.add
      (local.get $x)
      (call $recursive-inlining-1
        (local.get $x)
      )
    )
  )
)

