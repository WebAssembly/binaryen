;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.

;; RUN: wasm-opt --enable-multi-memories --asyncify --pass-arg=asyncify-in-secondary-memory %s -S -o - | filecheck %s
;; RUN: wasm-opt --enable-multi-memories --asyncify --pass-arg=asyncify-in-secondary-memory --pass-arg=asyncify-secondary-memory-size@3 %s -S -o - | filecheck %s --check-prefix SIZE

(module
  (memory 1 2)
  ;; CHECK:      (type $i32_=>_none (func (param i32)))

  ;; CHECK:      (type $none_=>_none (func))

  ;; CHECK:      (type $i32_i32_=>_none (func (param i32 i32)))

  ;; CHECK:      (type $none_=>_i32 (func (result i32)))

  ;; CHECK:      (global $__asyncify_state (mut i32) (i32.const 0))

  ;; CHECK:      (global $__asyncify_data (mut i32) (i32.const 0))

  ;; CHECK:      (memory $0 1 2)

  ;; CHECK:      (memory $asyncify_memory 1 1)

  ;; CHECK:      (export "asyncify_start_unwind" (func $asyncify_start_unwind))

  ;; CHECK:      (export "asyncify_stop_unwind" (func $asyncify_stop_unwind))

  ;; CHECK:      (export "asyncify_start_rewind" (func $asyncify_start_rewind))

  ;; CHECK:      (export "asyncify_stop_rewind" (func $asyncify_stop_rewind))

  ;; CHECK:      (export "asyncify_get_state" (func $asyncify_get_state))

  ;; CHECK:      (func $liveness1 (param $live0 i32) (param $dead0 i32)
  ;; CHECK-NEXT:  (local $2 i32)
  ;; CHECK-NEXT:  (local.set $2
  ;; CHECK-NEXT:   (local.get $dead0)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (local.get $2)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  ;; SIZE:      (type $i32_=>_none (func (param i32)))

  ;; SIZE:      (type $none_=>_none (func))

  ;; SIZE:      (type $i32_i32_=>_none (func (param i32 i32)))

  ;; SIZE:      (type $none_=>_i32 (func (result i32)))

  ;; SIZE:      (global $__asyncify_state (mut i32) (i32.const 0))

  ;; SIZE:      (global $__asyncify_data (mut i32) (i32.const 0))

  ;; SIZE:      (memory $0 1 2)

  ;; SIZE:      (memory $asyncify_memory 3 3)

  ;; SIZE:      (export "asyncify_start_unwind" (func $asyncify_start_unwind))

  ;; SIZE:      (export "asyncify_stop_unwind" (func $asyncify_stop_unwind))

  ;; SIZE:      (export "asyncify_start_rewind" (func $asyncify_start_rewind))

  ;; SIZE:      (export "asyncify_stop_rewind" (func $asyncify_stop_rewind))

  ;; SIZE:      (export "asyncify_get_state" (func $asyncify_get_state))

  ;; SIZE:      (func $liveness1 (param $live0 i32) (param $dead0 i32)
  ;; SIZE-NEXT:  (local $2 i32)
  ;; SIZE-NEXT:  (local.set $2
  ;; SIZE-NEXT:   (local.get $dead0)
  ;; SIZE-NEXT:  )
  ;; SIZE-NEXT:  (drop
  ;; SIZE-NEXT:   (local.get $2)
  ;; SIZE-NEXT:  )
  ;; SIZE-NEXT: )
  (func $liveness1 (param $live0 i32) (param $dead0 i32)
    (drop (local.get $dead0))
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
;; CHECK-NEXT:    (i32.load $asyncify_memory
;; CHECK-NEXT:     (global.get $__asyncify_data)
;; CHECK-NEXT:    )
;; CHECK-NEXT:    (i32.load $asyncify_memory offset=4
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
;; CHECK-NEXT:    (i32.load $asyncify_memory
;; CHECK-NEXT:     (global.get $__asyncify_data)
;; CHECK-NEXT:    )
;; CHECK-NEXT:    (i32.load $asyncify_memory offset=4
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
;; CHECK-NEXT:    (i32.load $asyncify_memory
;; CHECK-NEXT:     (global.get $__asyncify_data)
;; CHECK-NEXT:    )
;; CHECK-NEXT:    (i32.load $asyncify_memory offset=4
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
;; CHECK-NEXT:    (i32.load $asyncify_memory
;; CHECK-NEXT:     (global.get $__asyncify_data)
;; CHECK-NEXT:    )
;; CHECK-NEXT:    (i32.load $asyncify_memory offset=4
;; CHECK-NEXT:     (global.get $__asyncify_data)
;; CHECK-NEXT:    )
;; CHECK-NEXT:   )
;; CHECK-NEXT:   (unreachable)
;; CHECK-NEXT:  )
;; CHECK-NEXT: )

;; CHECK:      (func $asyncify_get_state (result i32)
;; CHECK-NEXT:  (global.get $__asyncify_state)
;; CHECK-NEXT: )

;; SIZE:      (func $asyncify_start_unwind (param $0 i32)
;; SIZE-NEXT:  (global.set $__asyncify_state
;; SIZE-NEXT:   (i32.const 1)
;; SIZE-NEXT:  )
;; SIZE-NEXT:  (global.set $__asyncify_data
;; SIZE-NEXT:   (local.get $0)
;; SIZE-NEXT:  )
;; SIZE-NEXT:  (if
;; SIZE-NEXT:   (i32.gt_u
;; SIZE-NEXT:    (i32.load $asyncify_memory
;; SIZE-NEXT:     (global.get $__asyncify_data)
;; SIZE-NEXT:    )
;; SIZE-NEXT:    (i32.load $asyncify_memory offset=4
;; SIZE-NEXT:     (global.get $__asyncify_data)
;; SIZE-NEXT:    )
;; SIZE-NEXT:   )
;; SIZE-NEXT:   (unreachable)
;; SIZE-NEXT:  )
;; SIZE-NEXT: )

;; SIZE:      (func $asyncify_stop_unwind
;; SIZE-NEXT:  (global.set $__asyncify_state
;; SIZE-NEXT:   (i32.const 0)
;; SIZE-NEXT:  )
;; SIZE-NEXT:  (if
;; SIZE-NEXT:   (i32.gt_u
;; SIZE-NEXT:    (i32.load $asyncify_memory
;; SIZE-NEXT:     (global.get $__asyncify_data)
;; SIZE-NEXT:    )
;; SIZE-NEXT:    (i32.load $asyncify_memory offset=4
;; SIZE-NEXT:     (global.get $__asyncify_data)
;; SIZE-NEXT:    )
;; SIZE-NEXT:   )
;; SIZE-NEXT:   (unreachable)
;; SIZE-NEXT:  )
;; SIZE-NEXT: )

;; SIZE:      (func $asyncify_start_rewind (param $0 i32)
;; SIZE-NEXT:  (global.set $__asyncify_state
;; SIZE-NEXT:   (i32.const 2)
;; SIZE-NEXT:  )
;; SIZE-NEXT:  (global.set $__asyncify_data
;; SIZE-NEXT:   (local.get $0)
;; SIZE-NEXT:  )
;; SIZE-NEXT:  (if
;; SIZE-NEXT:   (i32.gt_u
;; SIZE-NEXT:    (i32.load $asyncify_memory
;; SIZE-NEXT:     (global.get $__asyncify_data)
;; SIZE-NEXT:    )
;; SIZE-NEXT:    (i32.load $asyncify_memory offset=4
;; SIZE-NEXT:     (global.get $__asyncify_data)
;; SIZE-NEXT:    )
;; SIZE-NEXT:   )
;; SIZE-NEXT:   (unreachable)
;; SIZE-NEXT:  )
;; SIZE-NEXT: )

;; SIZE:      (func $asyncify_stop_rewind
;; SIZE-NEXT:  (global.set $__asyncify_state
;; SIZE-NEXT:   (i32.const 0)
;; SIZE-NEXT:  )
;; SIZE-NEXT:  (if
;; SIZE-NEXT:   (i32.gt_u
;; SIZE-NEXT:    (i32.load $asyncify_memory
;; SIZE-NEXT:     (global.get $__asyncify_data)
;; SIZE-NEXT:    )
;; SIZE-NEXT:    (i32.load $asyncify_memory offset=4
;; SIZE-NEXT:     (global.get $__asyncify_data)
;; SIZE-NEXT:    )
;; SIZE-NEXT:   )
;; SIZE-NEXT:   (unreachable)
;; SIZE-NEXT:  )
;; SIZE-NEXT: )

;; SIZE:      (func $asyncify_get_state (result i32)
;; SIZE-NEXT:  (global.get $__asyncify_state)
;; SIZE-NEXT: )
