;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.

;; RUN: wasm-opt %s --multi-memory-lowering -all -S -o - | filecheck %s

(module
  (import "env" "mem" (memory $memory1 1 1))
  (memory $memory2 1 1)
)

;; CHECK:      (type $0 (func (result i32)))

;; CHECK:      (type $1 (func (param i32) (result i32)))

;; CHECK:      (import "env" "mem" (memory $combined_memory 2 2))

;; CHECK:      (global $memory2_byte_offset (mut i32) (i32.const 65536))

;; CHECK:      (func $memory1_size (type $0) (result i32)
;; CHECK-NEXT:  (return
;; CHECK-NEXT:   (i32.div_u
;; CHECK-NEXT:    (global.get $memory2_byte_offset)
;; CHECK-NEXT:    (i32.const 65536)
;; CHECK-NEXT:   )
;; CHECK-NEXT:  )
;; CHECK-NEXT: )

;; CHECK:      (func $memory2_size (type $0) (result i32)
;; CHECK-NEXT:  (return
;; CHECK-NEXT:   (i32.sub
;; CHECK-NEXT:    (memory.size)
;; CHECK-NEXT:    (i32.div_u
;; CHECK-NEXT:     (global.get $memory2_byte_offset)
;; CHECK-NEXT:     (i32.const 65536)
;; CHECK-NEXT:    )
;; CHECK-NEXT:   )
;; CHECK-NEXT:  )
;; CHECK-NEXT: )

;; CHECK:      (func $memory1_grow (type $1) (param $page_delta i32) (result i32)
;; CHECK-NEXT:  (local $return_size i32)
;; CHECK-NEXT:  (local $memory_size i32)
;; CHECK-NEXT:  (local.set $return_size
;; CHECK-NEXT:   (call $memory1_size)
;; CHECK-NEXT:  )
;; CHECK-NEXT:  (local.set $memory_size
;; CHECK-NEXT:   (memory.size)
;; CHECK-NEXT:  )
;; CHECK-NEXT:  (if
;; CHECK-NEXT:   (i32.eq
;; CHECK-NEXT:    (memory.grow
;; CHECK-NEXT:     (local.get $page_delta)
;; CHECK-NEXT:    )
;; CHECK-NEXT:    (i32.const -1)
;; CHECK-NEXT:   )
;; CHECK-NEXT:   (then
;; CHECK-NEXT:    (return
;; CHECK-NEXT:     (i32.const -1)
;; CHECK-NEXT:    )
;; CHECK-NEXT:   )
;; CHECK-NEXT:  )
;; CHECK-NEXT:  (memory.copy
;; CHECK-NEXT:   (i32.add
;; CHECK-NEXT:    (global.get $memory2_byte_offset)
;; CHECK-NEXT:    (i32.mul
;; CHECK-NEXT:     (local.get $page_delta)
;; CHECK-NEXT:     (i32.const 65536)
;; CHECK-NEXT:    )
;; CHECK-NEXT:   )
;; CHECK-NEXT:   (global.get $memory2_byte_offset)
;; CHECK-NEXT:   (i32.sub
;; CHECK-NEXT:    (i32.mul
;; CHECK-NEXT:     (local.get $memory_size)
;; CHECK-NEXT:     (i32.const 65536)
;; CHECK-NEXT:    )
;; CHECK-NEXT:    (global.get $memory2_byte_offset)
;; CHECK-NEXT:   )
;; CHECK-NEXT:  )
;; CHECK-NEXT:  (global.set $memory2_byte_offset
;; CHECK-NEXT:   (i32.add
;; CHECK-NEXT:    (global.get $memory2_byte_offset)
;; CHECK-NEXT:    (i32.mul
;; CHECK-NEXT:     (local.get $page_delta)
;; CHECK-NEXT:     (i32.const 65536)
;; CHECK-NEXT:    )
;; CHECK-NEXT:   )
;; CHECK-NEXT:  )
;; CHECK-NEXT:  (local.get $return_size)
;; CHECK-NEXT: )

;; CHECK:      (func $memory2_grow (type $1) (param $page_delta i32) (result i32)
;; CHECK-NEXT:  (local $return_size i32)
;; CHECK-NEXT:  (local.set $return_size
;; CHECK-NEXT:   (call $memory2_size)
;; CHECK-NEXT:  )
;; CHECK-NEXT:  (if
;; CHECK-NEXT:   (i32.eq
;; CHECK-NEXT:    (memory.grow
;; CHECK-NEXT:     (local.get $page_delta)
;; CHECK-NEXT:    )
;; CHECK-NEXT:    (i32.const -1)
;; CHECK-NEXT:   )
;; CHECK-NEXT:   (then
;; CHECK-NEXT:    (return
;; CHECK-NEXT:     (i32.const -1)
;; CHECK-NEXT:    )
;; CHECK-NEXT:   )
;; CHECK-NEXT:  )
;; CHECK-NEXT:  (local.get $return_size)
;; CHECK-NEXT: )
