;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.
;; NOTE: This test was ported using port_passes_tests_to_lit.py and could be cleaned up.

;; RUN: foreach %s %t wasm-opt --asyncify --pass-arg=asyncify-ignore-indirect -S -o - | filecheck %s

(module
  (memory 1 2)
  ;; CHECK:      (type $f (func))
  (type $f (func))
  ;; CHECK:      (type $i32_=>_none (func (param i32)))

  ;; CHECK:      (type $none_=>_i32 (func (result i32)))

  ;; CHECK:      (import "env" "import" (func $import))
  (import "env" "import" (func $import))
  ;; CHECK:      (import "env" "import2" (func $import2 (result i32)))
  (import "env" "import2" (func $import2 (result i32)))
  ;; CHECK:      (import "env" "import3" (func $import3 (param i32)))
  (import "env" "import3" (func $import3 (param i32)))
  (table funcref (elem $calls-import2-drop $calls-import2-drop))
  ;; CHECK:      (global $__asyncify_state (mut i32) (i32.const 0))

  ;; CHECK:      (global $__asyncify_data (mut i32) (i32.const 0))

  ;; CHECK:      (memory $0 1 2)

  ;; CHECK:      (table $0 2 2 funcref)

  ;; CHECK:      (elem (i32.const 0) $calls-import2-drop $calls-import2-drop)

  ;; CHECK:      (export "asyncify_start_unwind" (func $asyncify_start_unwind))

  ;; CHECK:      (export "asyncify_stop_unwind" (func $asyncify_stop_unwind))

  ;; CHECK:      (export "asyncify_start_rewind" (func $asyncify_start_rewind))

  ;; CHECK:      (export "asyncify_stop_rewind" (func $asyncify_stop_rewind))

  ;; CHECK:      (export "asyncify_get_state" (func $asyncify_get_state))

  ;; CHECK:      (func $calls-import
  ;; CHECK-NEXT:  (local $0 i32)
  ;; CHECK-NEXT:  (local $1 i32)
  ;; CHECK-NEXT:  (if
  ;; CHECK-NEXT:   (i32.eq
  ;; CHECK-NEXT:    (global.get $__asyncify_state)
  ;; CHECK-NEXT:    (i32.const 2)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (nop)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (local.set $0
  ;; CHECK-NEXT:   (block $__asyncify_unwind (result i32)
  ;; CHECK-NEXT:    (block
  ;; CHECK-NEXT:     (block
  ;; CHECK-NEXT:      (if
  ;; CHECK-NEXT:       (i32.eq
  ;; CHECK-NEXT:        (global.get $__asyncify_state)
  ;; CHECK-NEXT:        (i32.const 2)
  ;; CHECK-NEXT:       )
  ;; CHECK-NEXT:       (block
  ;; CHECK-NEXT:        (i32.store
  ;; CHECK-NEXT:         (global.get $__asyncify_data)
  ;; CHECK-NEXT:         (i32.add
  ;; CHECK-NEXT:          (i32.load
  ;; CHECK-NEXT:           (global.get $__asyncify_data)
  ;; CHECK-NEXT:          )
  ;; CHECK-NEXT:          (i32.const -4)
  ;; CHECK-NEXT:         )
  ;; CHECK-NEXT:        )
  ;; CHECK-NEXT:        (local.set $1
  ;; CHECK-NEXT:         (i32.load
  ;; CHECK-NEXT:          (i32.load
  ;; CHECK-NEXT:           (global.get $__asyncify_data)
  ;; CHECK-NEXT:          )
  ;; CHECK-NEXT:         )
  ;; CHECK-NEXT:        )
  ;; CHECK-NEXT:       )
  ;; CHECK-NEXT:      )
  ;; CHECK-NEXT:      (if
  ;; CHECK-NEXT:       (if (result i32)
  ;; CHECK-NEXT:        (i32.eq
  ;; CHECK-NEXT:         (global.get $__asyncify_state)
  ;; CHECK-NEXT:         (i32.const 0)
  ;; CHECK-NEXT:        )
  ;; CHECK-NEXT:        (i32.const 1)
  ;; CHECK-NEXT:        (i32.eq
  ;; CHECK-NEXT:         (local.get $1)
  ;; CHECK-NEXT:         (i32.const 0)
  ;; CHECK-NEXT:        )
  ;; CHECK-NEXT:       )
  ;; CHECK-NEXT:       (block
  ;; CHECK-NEXT:        (call $import)
  ;; CHECK-NEXT:        (if
  ;; CHECK-NEXT:         (i32.eq
  ;; CHECK-NEXT:          (global.get $__asyncify_state)
  ;; CHECK-NEXT:          (i32.const 1)
  ;; CHECK-NEXT:         )
  ;; CHECK-NEXT:         (br $__asyncify_unwind
  ;; CHECK-NEXT:          (i32.const 0)
  ;; CHECK-NEXT:         )
  ;; CHECK-NEXT:        )
  ;; CHECK-NEXT:       )
  ;; CHECK-NEXT:      )
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:     (return)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (block
  ;; CHECK-NEXT:   (i32.store
  ;; CHECK-NEXT:    (i32.load
  ;; CHECK-NEXT:     (global.get $__asyncify_data)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (local.get $0)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (i32.store
  ;; CHECK-NEXT:    (global.get $__asyncify_data)
  ;; CHECK-NEXT:    (i32.add
  ;; CHECK-NEXT:     (i32.load
  ;; CHECK-NEXT:      (global.get $__asyncify_data)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:     (i32.const 4)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  (func $calls-import
    (call $import)
  )
  ;; CHECK:      (func $calls-import2-drop
  ;; CHECK-NEXT:  (local $0 i32)
  ;; CHECK-NEXT:  (local $1 i32)
  ;; CHECK-NEXT:  (local $2 i32)
  ;; CHECK-NEXT:  (local $3 i32)
  ;; CHECK-NEXT:  (local $4 i32)
  ;; CHECK-NEXT:  (local $5 i32)
  ;; CHECK-NEXT:  (if
  ;; CHECK-NEXT:   (i32.eq
  ;; CHECK-NEXT:    (global.get $__asyncify_state)
  ;; CHECK-NEXT:    (i32.const 2)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (block
  ;; CHECK-NEXT:    (i32.store
  ;; CHECK-NEXT:     (global.get $__asyncify_data)
  ;; CHECK-NEXT:     (i32.add
  ;; CHECK-NEXT:      (i32.load
  ;; CHECK-NEXT:       (global.get $__asyncify_data)
  ;; CHECK-NEXT:      )
  ;; CHECK-NEXT:      (i32.const -4)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (local.set $4
  ;; CHECK-NEXT:     (i32.load
  ;; CHECK-NEXT:      (global.get $__asyncify_data)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (local.set $0
  ;; CHECK-NEXT:     (i32.load
  ;; CHECK-NEXT:      (local.get $4)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (local.set $1
  ;; CHECK-NEXT:   (block $__asyncify_unwind (result i32)
  ;; CHECK-NEXT:    (block
  ;; CHECK-NEXT:     (block
  ;; CHECK-NEXT:      (if
  ;; CHECK-NEXT:       (i32.eq
  ;; CHECK-NEXT:        (global.get $__asyncify_state)
  ;; CHECK-NEXT:        (i32.const 2)
  ;; CHECK-NEXT:       )
  ;; CHECK-NEXT:       (block
  ;; CHECK-NEXT:        (i32.store
  ;; CHECK-NEXT:         (global.get $__asyncify_data)
  ;; CHECK-NEXT:         (i32.add
  ;; CHECK-NEXT:          (i32.load
  ;; CHECK-NEXT:           (global.get $__asyncify_data)
  ;; CHECK-NEXT:          )
  ;; CHECK-NEXT:          (i32.const -4)
  ;; CHECK-NEXT:         )
  ;; CHECK-NEXT:        )
  ;; CHECK-NEXT:        (local.set $2
  ;; CHECK-NEXT:         (i32.load
  ;; CHECK-NEXT:          (i32.load
  ;; CHECK-NEXT:           (global.get $__asyncify_data)
  ;; CHECK-NEXT:          )
  ;; CHECK-NEXT:         )
  ;; CHECK-NEXT:        )
  ;; CHECK-NEXT:       )
  ;; CHECK-NEXT:      )
  ;; CHECK-NEXT:      (block
  ;; CHECK-NEXT:       (if
  ;; CHECK-NEXT:        (if (result i32)
  ;; CHECK-NEXT:         (i32.eq
  ;; CHECK-NEXT:          (global.get $__asyncify_state)
  ;; CHECK-NEXT:          (i32.const 0)
  ;; CHECK-NEXT:         )
  ;; CHECK-NEXT:         (i32.const 1)
  ;; CHECK-NEXT:         (i32.eq
  ;; CHECK-NEXT:          (local.get $2)
  ;; CHECK-NEXT:          (i32.const 0)
  ;; CHECK-NEXT:         )
  ;; CHECK-NEXT:        )
  ;; CHECK-NEXT:        (block
  ;; CHECK-NEXT:         (local.set $3
  ;; CHECK-NEXT:          (call $import2)
  ;; CHECK-NEXT:         )
  ;; CHECK-NEXT:         (if
  ;; CHECK-NEXT:          (i32.eq
  ;; CHECK-NEXT:           (global.get $__asyncify_state)
  ;; CHECK-NEXT:           (i32.const 1)
  ;; CHECK-NEXT:          )
  ;; CHECK-NEXT:          (br $__asyncify_unwind
  ;; CHECK-NEXT:           (i32.const 0)
  ;; CHECK-NEXT:          )
  ;; CHECK-NEXT:          (local.set $0
  ;; CHECK-NEXT:           (local.get $3)
  ;; CHECK-NEXT:          )
  ;; CHECK-NEXT:         )
  ;; CHECK-NEXT:        )
  ;; CHECK-NEXT:       )
  ;; CHECK-NEXT:       (if
  ;; CHECK-NEXT:        (i32.eq
  ;; CHECK-NEXT:         (global.get $__asyncify_state)
  ;; CHECK-NEXT:         (i32.const 0)
  ;; CHECK-NEXT:        )
  ;; CHECK-NEXT:        (drop
  ;; CHECK-NEXT:         (local.get $0)
  ;; CHECK-NEXT:        )
  ;; CHECK-NEXT:       )
  ;; CHECK-NEXT:      )
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:     (return)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (block
  ;; CHECK-NEXT:   (i32.store
  ;; CHECK-NEXT:    (i32.load
  ;; CHECK-NEXT:     (global.get $__asyncify_data)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (local.get $1)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (i32.store
  ;; CHECK-NEXT:    (global.get $__asyncify_data)
  ;; CHECK-NEXT:    (i32.add
  ;; CHECK-NEXT:     (i32.load
  ;; CHECK-NEXT:      (global.get $__asyncify_data)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:     (i32.const 4)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (block
  ;; CHECK-NEXT:   (local.set $5
  ;; CHECK-NEXT:    (i32.load
  ;; CHECK-NEXT:     (global.get $__asyncify_data)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (i32.store
  ;; CHECK-NEXT:    (local.get $5)
  ;; CHECK-NEXT:    (local.get $0)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (i32.store
  ;; CHECK-NEXT:    (global.get $__asyncify_data)
  ;; CHECK-NEXT:    (i32.add
  ;; CHECK-NEXT:     (i32.load
  ;; CHECK-NEXT:      (global.get $__asyncify_data)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:     (i32.const 4)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $calls-import2-drop
    (drop (call $import2))
  )
  ;; CHECK:      (func $calls-import2-if-else (param $x i32)
  ;; CHECK-NEXT:  (local $1 i32)
  ;; CHECK-NEXT:  (local $2 i32)
  ;; CHECK-NEXT:  (local $3 i32)
  ;; CHECK-NEXT:  (local $4 i32)
  ;; CHECK-NEXT:  (local $5 i32)
  ;; CHECK-NEXT:  (local $6 i32)
  ;; CHECK-NEXT:  (if
  ;; CHECK-NEXT:   (i32.eq
  ;; CHECK-NEXT:    (global.get $__asyncify_state)
  ;; CHECK-NEXT:    (i32.const 2)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (block
  ;; CHECK-NEXT:    (i32.store
  ;; CHECK-NEXT:     (global.get $__asyncify_data)
  ;; CHECK-NEXT:     (i32.add
  ;; CHECK-NEXT:      (i32.load
  ;; CHECK-NEXT:       (global.get $__asyncify_data)
  ;; CHECK-NEXT:      )
  ;; CHECK-NEXT:      (i32.const -4)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (local.set $5
  ;; CHECK-NEXT:     (i32.load
  ;; CHECK-NEXT:      (global.get $__asyncify_data)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (local.set $2
  ;; CHECK-NEXT:     (i32.load
  ;; CHECK-NEXT:      (local.get $5)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (local.set $3
  ;; CHECK-NEXT:   (block $__asyncify_unwind (result i32)
  ;; CHECK-NEXT:    (block
  ;; CHECK-NEXT:     (block
  ;; CHECK-NEXT:      (if
  ;; CHECK-NEXT:       (i32.eq
  ;; CHECK-NEXT:        (global.get $__asyncify_state)
  ;; CHECK-NEXT:        (i32.const 2)
  ;; CHECK-NEXT:       )
  ;; CHECK-NEXT:       (block
  ;; CHECK-NEXT:        (i32.store
  ;; CHECK-NEXT:         (global.get $__asyncify_data)
  ;; CHECK-NEXT:         (i32.add
  ;; CHECK-NEXT:          (i32.load
  ;; CHECK-NEXT:           (global.get $__asyncify_data)
  ;; CHECK-NEXT:          )
  ;; CHECK-NEXT:          (i32.const -4)
  ;; CHECK-NEXT:         )
  ;; CHECK-NEXT:        )
  ;; CHECK-NEXT:        (local.set $4
  ;; CHECK-NEXT:         (i32.load
  ;; CHECK-NEXT:          (i32.load
  ;; CHECK-NEXT:           (global.get $__asyncify_data)
  ;; CHECK-NEXT:          )
  ;; CHECK-NEXT:         )
  ;; CHECK-NEXT:        )
  ;; CHECK-NEXT:       )
  ;; CHECK-NEXT:      )
  ;; CHECK-NEXT:      (block
  ;; CHECK-NEXT:       (if
  ;; CHECK-NEXT:        (i32.eq
  ;; CHECK-NEXT:         (global.get $__asyncify_state)
  ;; CHECK-NEXT:         (i32.const 0)
  ;; CHECK-NEXT:        )
  ;; CHECK-NEXT:        (local.set $1
  ;; CHECK-NEXT:         (local.get $x)
  ;; CHECK-NEXT:        )
  ;; CHECK-NEXT:       )
  ;; CHECK-NEXT:       (block
  ;; CHECK-NEXT:        (if
  ;; CHECK-NEXT:         (i32.eq
  ;; CHECK-NEXT:          (global.get $__asyncify_state)
  ;; CHECK-NEXT:          (i32.const 0)
  ;; CHECK-NEXT:         )
  ;; CHECK-NEXT:         (local.set $2
  ;; CHECK-NEXT:          (local.get $1)
  ;; CHECK-NEXT:         )
  ;; CHECK-NEXT:        )
  ;; CHECK-NEXT:        (if
  ;; CHECK-NEXT:         (i32.or
  ;; CHECK-NEXT:          (local.get $2)
  ;; CHECK-NEXT:          (i32.eq
  ;; CHECK-NEXT:           (global.get $__asyncify_state)
  ;; CHECK-NEXT:           (i32.const 2)
  ;; CHECK-NEXT:          )
  ;; CHECK-NEXT:         )
  ;; CHECK-NEXT:         (if
  ;; CHECK-NEXT:          (if (result i32)
  ;; CHECK-NEXT:           (i32.eq
  ;; CHECK-NEXT:            (global.get $__asyncify_state)
  ;; CHECK-NEXT:            (i32.const 0)
  ;; CHECK-NEXT:           )
  ;; CHECK-NEXT:           (i32.const 1)
  ;; CHECK-NEXT:           (i32.eq
  ;; CHECK-NEXT:            (local.get $4)
  ;; CHECK-NEXT:            (i32.const 0)
  ;; CHECK-NEXT:           )
  ;; CHECK-NEXT:          )
  ;; CHECK-NEXT:          (block
  ;; CHECK-NEXT:           (call $import3
  ;; CHECK-NEXT:            (i32.const 1)
  ;; CHECK-NEXT:           )
  ;; CHECK-NEXT:           (if
  ;; CHECK-NEXT:            (i32.eq
  ;; CHECK-NEXT:             (global.get $__asyncify_state)
  ;; CHECK-NEXT:             (i32.const 1)
  ;; CHECK-NEXT:            )
  ;; CHECK-NEXT:            (br $__asyncify_unwind
  ;; CHECK-NEXT:             (i32.const 0)
  ;; CHECK-NEXT:            )
  ;; CHECK-NEXT:           )
  ;; CHECK-NEXT:          )
  ;; CHECK-NEXT:         )
  ;; CHECK-NEXT:        )
  ;; CHECK-NEXT:        (if
  ;; CHECK-NEXT:         (i32.or
  ;; CHECK-NEXT:          (i32.eqz
  ;; CHECK-NEXT:           (local.get $2)
  ;; CHECK-NEXT:          )
  ;; CHECK-NEXT:          (i32.eq
  ;; CHECK-NEXT:           (global.get $__asyncify_state)
  ;; CHECK-NEXT:           (i32.const 2)
  ;; CHECK-NEXT:          )
  ;; CHECK-NEXT:         )
  ;; CHECK-NEXT:         (if
  ;; CHECK-NEXT:          (if (result i32)
  ;; CHECK-NEXT:           (i32.eq
  ;; CHECK-NEXT:            (global.get $__asyncify_state)
  ;; CHECK-NEXT:            (i32.const 0)
  ;; CHECK-NEXT:           )
  ;; CHECK-NEXT:           (i32.const 1)
  ;; CHECK-NEXT:           (i32.eq
  ;; CHECK-NEXT:            (local.get $4)
  ;; CHECK-NEXT:            (i32.const 1)
  ;; CHECK-NEXT:           )
  ;; CHECK-NEXT:          )
  ;; CHECK-NEXT:          (block
  ;; CHECK-NEXT:           (call $import3
  ;; CHECK-NEXT:            (i32.const 2)
  ;; CHECK-NEXT:           )
  ;; CHECK-NEXT:           (if
  ;; CHECK-NEXT:            (i32.eq
  ;; CHECK-NEXT:             (global.get $__asyncify_state)
  ;; CHECK-NEXT:             (i32.const 1)
  ;; CHECK-NEXT:            )
  ;; CHECK-NEXT:            (br $__asyncify_unwind
  ;; CHECK-NEXT:             (i32.const 1)
  ;; CHECK-NEXT:            )
  ;; CHECK-NEXT:           )
  ;; CHECK-NEXT:          )
  ;; CHECK-NEXT:         )
  ;; CHECK-NEXT:        )
  ;; CHECK-NEXT:       )
  ;; CHECK-NEXT:      )
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:     (return)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (block
  ;; CHECK-NEXT:   (i32.store
  ;; CHECK-NEXT:    (i32.load
  ;; CHECK-NEXT:     (global.get $__asyncify_data)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (local.get $3)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (i32.store
  ;; CHECK-NEXT:    (global.get $__asyncify_data)
  ;; CHECK-NEXT:    (i32.add
  ;; CHECK-NEXT:     (i32.load
  ;; CHECK-NEXT:      (global.get $__asyncify_data)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:     (i32.const 4)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (block
  ;; CHECK-NEXT:   (local.set $6
  ;; CHECK-NEXT:    (i32.load
  ;; CHECK-NEXT:     (global.get $__asyncify_data)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (i32.store
  ;; CHECK-NEXT:    (local.get $6)
  ;; CHECK-NEXT:    (local.get $2)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (i32.store
  ;; CHECK-NEXT:    (global.get $__asyncify_data)
  ;; CHECK-NEXT:    (i32.add
  ;; CHECK-NEXT:     (i32.load
  ;; CHECK-NEXT:      (global.get $__asyncify_data)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:     (i32.const 4)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $calls-import2-if-else (param $x i32)
    (if (local.get $x)
      (call $import3 (i32.const 1))
      (call $import3 (i32.const 2))
    )
  )
  ;; CHECK:      (func $calls-indirect (param $x i32)
  ;; CHECK-NEXT:  (call_indirect (type $f)
  ;; CHECK-NEXT:   (local.get $x)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $calls-indirect (param $x i32)
    (call_indirect (type $f)
      (local.get $x)
    )
  )
)

;; CHECK:      (func $asyncify_start_unwind (param $0 i32)
;; CHECK-NEXT:  (global.set $__asyncify_state
;; CHECK-NEXT:   (i32.const 1)
;; CHECK-NEXT:  )
;; CHECK-NEXT:  (global.set $__asyncify_data
;; CHECK-NEXT:   (local.get $0)
;; CHECK-NEXT:  )
;; CHECK-NEXT:  (if
;; CHECK-NEXT:   (i32.gt_u
;; CHECK-NEXT:    (i32.load
;; CHECK-NEXT:     (global.get $__asyncify_data)
;; CHECK-NEXT:    )
;; CHECK-NEXT:    (i32.load offset=4
;; CHECK-NEXT:     (global.get $__asyncify_data)
;; CHECK-NEXT:    )
;; CHECK-NEXT:   )
;; CHECK-NEXT:   (unreachable)
;; CHECK-NEXT:  )
;; CHECK-NEXT: )

;; CHECK:      (func $asyncify_stop_unwind
;; CHECK-NEXT:  (global.set $__asyncify_state
;; CHECK-NEXT:   (i32.const 0)
;; CHECK-NEXT:  )
;; CHECK-NEXT:  (if
;; CHECK-NEXT:   (i32.gt_u
;; CHECK-NEXT:    (i32.load
;; CHECK-NEXT:     (global.get $__asyncify_data)
;; CHECK-NEXT:    )
;; CHECK-NEXT:    (i32.load offset=4
;; CHECK-NEXT:     (global.get $__asyncify_data)
;; CHECK-NEXT:    )
;; CHECK-NEXT:   )
;; CHECK-NEXT:   (unreachable)
;; CHECK-NEXT:  )
;; CHECK-NEXT: )

;; CHECK:      (func $asyncify_start_rewind (param $0 i32)
;; CHECK-NEXT:  (global.set $__asyncify_state
;; CHECK-NEXT:   (i32.const 2)
;; CHECK-NEXT:  )
;; CHECK-NEXT:  (global.set $__asyncify_data
;; CHECK-NEXT:   (local.get $0)
;; CHECK-NEXT:  )
;; CHECK-NEXT:  (if
;; CHECK-NEXT:   (i32.gt_u
;; CHECK-NEXT:    (i32.load
;; CHECK-NEXT:     (global.get $__asyncify_data)
;; CHECK-NEXT:    )
;; CHECK-NEXT:    (i32.load offset=4
;; CHECK-NEXT:     (global.get $__asyncify_data)
;; CHECK-NEXT:    )
;; CHECK-NEXT:   )
;; CHECK-NEXT:   (unreachable)
;; CHECK-NEXT:  )
;; CHECK-NEXT: )

;; CHECK:      (func $asyncify_stop_rewind
;; CHECK-NEXT:  (global.set $__asyncify_state
;; CHECK-NEXT:   (i32.const 0)
;; CHECK-NEXT:  )
;; CHECK-NEXT:  (if
;; CHECK-NEXT:   (i32.gt_u
;; CHECK-NEXT:    (i32.load
;; CHECK-NEXT:     (global.get $__asyncify_data)
;; CHECK-NEXT:    )
;; CHECK-NEXT:    (i32.load offset=4
;; CHECK-NEXT:     (global.get $__asyncify_data)
;; CHECK-NEXT:    )
;; CHECK-NEXT:   )
;; CHECK-NEXT:   (unreachable)
;; CHECK-NEXT:  )
;; CHECK-NEXT: )

;; CHECK:      (func $asyncify_get_state (result i32)
;; CHECK-NEXT:  (global.get $__asyncify_state)
;; CHECK-NEXT: )
