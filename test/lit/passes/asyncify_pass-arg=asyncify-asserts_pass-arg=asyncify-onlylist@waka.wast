;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.
;; NOTE: This test was ported using port_passes_tests_to_lit.py and could be cleaned up.

;; RUN: foreach %s %t wasm-opt --asyncify --pass-arg=asyncify-asserts --pass-arg=asyncify-onlylist@waka -S -o - | filecheck %s

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
  ;; CHECK-NEXT:  (call $import)
  ;; CHECK-NEXT: )
  (func $calls-import
    (call $import)
  )
  ;; CHECK:      (func $calls-import2-drop
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (call $import2)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $calls-import2-drop
    (drop (call $import2))
  )
  ;; CHECK:      (func $returns (result i32)
  ;; CHECK-NEXT:  (local $x i32)
  ;; CHECK-NEXT:  (local.set $x
  ;; CHECK-NEXT:   (call $import2)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (local.get $x)
  ;; CHECK-NEXT: )
  (func $returns (result i32)
    (local $x i32)
    (local.set $x (call $import2))
    (local.get $x)
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
