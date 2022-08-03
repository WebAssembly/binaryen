;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.
;; NOTE: This test was ported using port_test.py and could be cleaned up.

;; RUN: wasm-opt %s --stack-check --enable-memory64 -S -o - | filecheck %s

(module
 (memory i64 (data))
 ;; CHECK:      (type $none_=>_i64 (func (result i64)))

 ;; CHECK:      (global $sp (mut i64) (i64.const 0))
 (global $sp (mut i64) (i64.const 0))

 ;; CHECK:      (global $__stack_base (mut i64) (i64.const 0))
 (global $__stack_base (mut i64) (i64.const 0))

 ;; CHECK:      (global $__stack_end (mut i64) (i64.const 0))
 (global $__stack_end (mut i64) (i64.const 0))
 (func "use_stack" (result i64)
  (global.set $sp (i64.const 42))
  (global.get $sp)
 )
)

;; CHECK:      (memory $0 i64 0 65536)

;; CHECK:      (data (i64.const 0) "")

;; CHECK:      (export "use_stack" (func $0))

;; CHECK:      (func $0 (result i64)
;; CHECK-NEXT:  (local $0 i64)
;; CHECK-NEXT:  (block
;; CHECK-NEXT:   (if
;; CHECK-NEXT:    (i32.or
;; CHECK-NEXT:     (i64.gt_u
;; CHECK-NEXT:      (local.tee $0
;; CHECK-NEXT:       (i64.const 42)
;; CHECK-NEXT:      )
;; CHECK-NEXT:      (global.get $__stack_base)
;; CHECK-NEXT:     )
;; CHECK-NEXT:     (i64.lt_u
;; CHECK-NEXT:      (local.get $0)
;; CHECK-NEXT:      (global.get $__stack_end)
;; CHECK-NEXT:     )
;; CHECK-NEXT:    )
;; CHECK-NEXT:    (unreachable)
;; CHECK-NEXT:   )
;; CHECK-NEXT:   (global.set $sp
;; CHECK-NEXT:    (local.get $0)
;; CHECK-NEXT:   )
;; CHECK-NEXT:  )
;; CHECK-NEXT:  (global.get $sp)
;; CHECK-NEXT: )
