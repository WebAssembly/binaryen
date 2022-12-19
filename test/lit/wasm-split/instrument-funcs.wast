;; RUN: wasm-split %s --instrument -all -S -o - | filecheck %s

;; Check that the output round trips and validates as well
;; RUN: wasm-split %s --instrument -all -g -o %t.wasm
;; RUN: wasm-opt -all %t.wasm -S -o -

(module
  (import "env" "foo" (func $foo))
  (export "bar" (func $bar))
  (memory $0 1 1)
  (func $bar
    (call $foo)
  )
  (func $baz (param i32) (result i32)
    (local.get 0)
  )
)

;; Check that a memory has been added
;; CHECK: (memory $combined_memory (shared 2 2))

;; And the profiling function exported
;; CHECK: (export "__write_profile" (func $__write_profile))

;; And main memory has been exported
;; CHECK: (export "profile-memory" (memory $combined_memory))

;; Check that the function instrumentation is correct

;; CHECK:      (func $bar (type $none_=>_none)
;; CHECK-NEXT:  (i32.atomic.store8
;; CHECK-NEXT:   (i32.add
;; CHECK-NEXT:    (global.get $profile-data_byte_offset)
;; CHECK-NEXT:    (i32.const 0)
;; CHECK-NEXT:   )
;; CHECK-NEXT:   (i32.const 1)
;; CHECK-NEXT:  )
;; CHECK-NEXT:  (call $foo)
;; CHECK-NEXT: )

;; CHECK:      (func $baz (type $i32_=>_i32) (param $0 i32) (result i32)
;; CHECK-NEXT:  (i32.atomic.store8 offset=1
;; CHECK-NEXT:   (i32.add
;; CHECK-NEXT:    (global.get $profile-data_byte_offset)
;; CHECK-NEXT:    (i32.const 0)
;; CHECK-NEXT:   )
;; CHECK-NEXT:   (i32.const 1)
;; CHECK-NEXT:  )
;; CHECK-NEXT:  (local.get $0)
;; CHECK-NEXT: )

;; Check that the profiling function is correct.
;;CHECK: (func $__write_profile (type $i32_i32_=>_i32) (param $addr i32) (param $size i32) (result i32)
;;CHECK-NEXT: (local $funcIdx i32)
;;CHECK-NEXT: (if
;;CHECK-NEXT:  (i32.ge_u
;;CHECK-NEXT:   (local.get $size)
;;CHECK-NEXT:   (i32.const 16)
;;CHECK-NEXT:  )
;;CHECK-NEXT:  (block
;;CHECK-NEXT:   (i64.store align=1
;;CHECK-NEXT:    (local.get $addr)
;;CHECK-NEXT:    (i64.const {{.*}})
;;CHECK-NEXT:   )
;;CHECK-NEXT:   (block $outer
;;CHECK-NEXT:    (loop $l
;;CHECK-NEXT:     (br_if $outer
;;CHECK-NEXT:      (i32.eq
;;CHECK-NEXT:       (local.get $funcIdx)
;;CHECK-NEXT:       (i32.const 2)
;;CHECK-NEXT:      )
;;CHECK-NEXT:     )
;;CHECK-NEXT:     (i32.store offset=8
;;CHECK-NEXT:      (i32.add
;;CHECK-NEXT:       (local.get $addr)
;;CHECK-NEXT:       (i32.mul
;;CHECK-NEXT:        (local.get $funcIdx)
;;CHECK-NEXT:        (i32.const 4)
;;CHECK-NEXT:       )
;;CHECK-NEXT:      )
;;CHECK-NEXT:      (i32.atomic.load8_u
;;CHECK-NEXT:       (i32.add
;;CHECK-NEXT:        (global.get $profile-data_byte_offset)
;;CHECK-NEXT:        (local.get $funcIdx)
;;CHECK-NEXT:       )
;;CHECK-NEXT:      )
;;CHECK-NEXT:     )
;;CHECK-NEXT:     (local.set $funcIdx
;;CHECK-NEXT:      (i32.add
;;CHECK-NEXT:       (local.get $funcIdx)
;;CHECK-NEXT:       (i32.const 1)
;;CHECK-NEXT:      )
;;CHECK-NEXT:     )
;;CHECK-NEXT:     (br $l)
;;CHECK-NEXT:    )
;;CHECK-NEXT:   )
;;CHECK-NEXT:  )
;;CHECK-NEXT: )
;;CHECK-NEXT: (i32.const 16)
;;CHECK-NEXT:)

;; Check that the Multi-Memory Lowering Pass grow/size functions are correct
;; CHECK: (func $0_size (type $none_=>_i32) (result i32)
;;CHECK-NEXT:  (return
;;CHECK-NEXT:   (i32.div_u
;;CHECK-NEXT:    (global.get $profile-data_byte_offset)
;;CHECK-NEXT:    (i32.const 65536)
;;CHECK-NEXT:   )
;;CHECK-NEXT:  )
;;CHECK-NEXT: )
;;CHECK-NEXT: (func $profile-data_size (type $none_=>_i32) (result i32)
;;CHECK-NEXT:  (return
;;CHECK-NEXT:   (i32.sub
;;CHECK-NEXT:    (memory.size)
;;CHECK-NEXT:    (i32.div_u
;;CHECK-NEXT:     (global.get $profile-data_byte_offset)
;;CHECK-NEXT:     (i32.const 65536)
;;CHECK-NEXT:    )
;;CHECK-NEXT:   )
;;CHECK-NEXT:  )
;;CHECK-NEXT: )
;;CHECK-NEXT: (func $0_grow (type $i32_=>_i32) (param $page_delta i32) (result i32)
;;CHECK-NEXT:  (local $return_size i32)
;;CHECK-NEXT:  (local $memory_size i32)
;;CHECK-NEXT:  (local.set $return_size
;;CHECK-NEXT:   (call $0_size)
;;CHECK-NEXT:  )
;;CHECK-NEXT:  (local.set $memory_size
;;CHECK-NEXT:   (memory.size)
;;CHECK-NEXT:  )
;;CHECK-NEXT:  (if
;;CHECK-NEXT:   (i32.eq
;;CHECK-NEXT:    (memory.grow
;;CHECK-NEXT:     (local.get $page_delta)
;;CHECK-NEXT:    )
;;CHECK-NEXT:    (i32.const -1)
;;CHECK-NEXT:   )
;;CHECK-NEXT:   (return
;;CHECK-NEXT:    (i32.const -1)
;;CHECK-NEXT:   )
;;CHECK-NEXT:  )
;;CHECK-NEXT:  (memory.copy
;;CHECK-NEXT:   (i32.add
;;CHECK-NEXT:    (global.get $profile-data_byte_offset)
;;CHECK-NEXT:    (i32.mul
;;CHECK-NEXT:     (local.get $page_delta)
;;CHECK-NEXT:     (i32.const 65536)
;;CHECK-NEXT:    )
;;CHECK-NEXT:   )
;;CHECK-NEXT:   (global.get $profile-data_byte_offset)
;;CHECK-NEXT:   (i32.sub
;;CHECK-NEXT:    (i32.mul
;;CHECK-NEXT:     (local.get $memory_size)
;;CHECK-NEXT:     (i32.const 65536)
;;CHECK-NEXT:    )
;;CHECK-NEXT:    (global.get $profile-data_byte_offset)
;;CHECK-NEXT:   )
;;CHECK-NEXT:  )
;;CHECK-NEXT:  (global.set $profile-data_byte_offset
;;CHECK-NEXT:   (i32.add
;;CHECK-NEXT:    (global.get $profile-data_byte_offset)
;;CHECK-NEXT:    (i32.mul
;;CHECK-NEXT:     (local.get $page_delta)
;;CHECK-NEXT:     (i32.const 65536)
;;CHECK-NEXT:    )
;;CHECK-NEXT:   )
;;CHECK-NEXT:  )
;;CHECK-NEXT:  (local.get $return_size)
;;CHECK-NEXT: )
;;CHECK-NEXT: (func $profile-data_grow (type $i32_=>_i32) (param $page_delta i32) (result i32)
;;CHECK-NEXT:  (local $return_size i32)
;;CHECK-NEXT:  (local.set $return_size
;;CHECK-NEXT:   (call $profile-data_size)
;;CHECK-NEXT:  )
;;CHECK-NEXT:  (if
;;CHECK-NEXT:   (i32.eq
;;CHECK-NEXT:    (memory.grow
;;CHECK-NEXT:     (local.get $page_delta)
;;CHECK-NEXT:    )
;;CHECK-NEXT:    (i32.const -1)
;;CHECK-NEXT:   )
;;CHECK-NEXT:   (return
;;CHECK-NEXT:    (i32.const -1)
;;CHECK-NEXT:   )
;;CHECK-NEXT:  )
;;CHECK-NEXT:  (local.get $return_size)
;;CHECK-NEXT: )
;;CHECK-NEXT:)
