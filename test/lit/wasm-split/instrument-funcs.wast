;; RUN: wasm-split %s --instrument -S -o - | filecheck %s

;; Check that the output round trips and validates as well
;; RUN: wasm-split %s --instrument -g -o %t.wasm
;; RUN: wasm-opt %t.wasm --enable-bulk-memory -S -o -

;; RUN: wasm-split %s --instrument --enable-threads -S -o - | filecheck %s --check-prefix ATOMIC

;; Check that the output round trips and validates as well
;; RUN: wasm-split %s --instrument --enable-threads -g -o %t.wasm
;; RUN: wasm-opt %t.wasm --enable-threads --enable-bulk-memory -S -o -

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
;; CHECK: (memory $combined_memory 2 2)

;; Check that atomic memory is shared
;; ATOMIC: (memory $combined_memory (shared 2 2))

;; And the profiling function exported
;; CHECK: (export "__write_profile" (func $__write_profile))
;; ATOMIC: (export "__write_profile" (func $__write_profile))

;; And main memory has been exported
;; CHECK: (export "profile-memory" (memory $combined_memory))
;; ATOMIC: (export "profile-memory" (memory $combined_memory))

;; Check that the function instrumentation is correct
;; CHECK:      (func $bar
;; CHECK-NEXT:  (i32.store8
;; CHECK-NEXT:   (i32.add
;; CHECK-NEXT:    (global.get $profile-data_byte_offset)
;; CHECK-NEXT:    (i32.const 0)
;; CHECK-NEXT:   )
;; CHECK-NEXT:   (i32.const 1)
;; CHECK-NEXT:  )
;; CHECK-NEXT:  (call $foo)
;; CHECK-NEXT: )

;; CHECK:      (func $baz (param $0 i32) (result i32)
;; CHECK-NEXT:  (i32.store8 offset=1
;; CHECK-NEXT:   (i32.add
;; CHECK-NEXT:    (global.get $profile-data_byte_offset)
;; CHECK-NEXT:    (i32.const 0)
;; CHECK-NEXT:   )
;; CHECK-NEXT:   (i32.const 1)
;; CHECK-NEXT:  )
;; CHECK-NEXT:  (local.get $0)
;; CHECK-NEXT: )

;; Check that the atomic function instrumentation is correct
;; ATOMIC:      (func $bar
;; ATOMIC-NEXT:  (i32.atomic.store8
;; ATOMIC-NEXT:   (i32.add
;; ATOMIC-NEXT:    (global.get $profile-data_byte_offset)
;; ATOMIC-NEXT:    (i32.const 0)
;; ATOMIC-NEXT:   )
;; ATOMIC-NEXT:   (i32.const 1)
;; ATOMIC-NEXT:  )
;; ATOMIC-NEXT:  (call $foo)
;; ATOMIC-NEXT: )

;; ATOMIC:      (func $baz (param $0 i32) (result i32)
;; ATOMIC-NEXT:  (i32.atomic.store8 offset=1
;; ATOMIC-NEXT:   (i32.add
;; ATOMIC-NEXT:    (global.get $profile-data_byte_offset)
;; ATOMIC-NEXT:    (i32.const 0)
;; ATOMIC-NEXT:   )
;; ATOMIC-NEXT:   (i32.const 1)
;; ATOMIC-NEXT:  )
;; ATOMIC-NEXT:  (local.get $0)
;; ATOMIC-NEXT: )

;; Check that the profiling function is correct.
;;CHECK: (func $__write_profile (param $addr i32) (param $size i32) (result i32)
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
;;CHECK-NEXT:      (i32.load8_u
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

;; Check that the atomic profiling function is correct.
;;ATOMIC: (func $__write_profile (param $addr i32) (param $size i32) (result i32)
;;ATOMIC-NEXT: (local $funcIdx i32)
;;ATOMIC-NEXT: (if
;;ATOMIC-NEXT:  (i32.ge_u
;;ATOMIC-NEXT:   (local.get $size)
;;ATOMIC-NEXT:   (i32.const 16)
;;ATOMIC-NEXT:  )
;;ATOMIC-NEXT:  (block
;;ATOMIC-NEXT:   (i64.store align=1
;;ATOMIC-NEXT:    (local.get $addr)
;;ATOMIC-NEXT:    (i64.const {{.*}})
;;ATOMIC-NEXT:   )
;;ATOMIC-NEXT:   (block $outer
;;ATOMIC-NEXT:    (loop $l
;;ATOMIC-NEXT:     (br_if $outer
;;ATOMIC-NEXT:      (i32.eq
;;ATOMIC-NEXT:       (local.get $funcIdx)
;;ATOMIC-NEXT:       (i32.const 2)
;;ATOMIC-NEXT:      )
;;ATOMIC-NEXT:     )
;;ATOMIC-NEXT:     (i32.store offset=8
;;ATOMIC-NEXT:      (i32.add
;;ATOMIC-NEXT:       (local.get $addr)
;;ATOMIC-NEXT:       (i32.mul
;;ATOMIC-NEXT:        (local.get $funcIdx)
;;ATOMIC-NEXT:        (i32.const 4)
;;ATOMIC-NEXT:       )
;;ATOMIC-NEXT:      )
;;ATOMIC-NEXT:      (i32.atomic.load8_u
;;ATOMIC-NEXT:       (i32.add
;;ATOMIC-NEXT:        (global.get $profile-data_byte_offset)
;;ATOMIC-NEXT:        (local.get $funcIdx)
;;ATOMIC-NEXT:       )
;;ATOMIC-NEXT:      )
;;ATOMIC-NEXT:     )
;;ATOMIC-NEXT:     (local.set $funcIdx
;;ATOMIC-NEXT:      (i32.add
;;ATOMIC-NEXT:       (local.get $funcIdx)
;;ATOMIC-NEXT:       (i32.const 1)
;;ATOMIC-NEXT:      )
;;ATOMIC-NEXT:     )
;;ATOMIC-NEXT:     (br $l)
;;ATOMIC-NEXT:    )
;;ATOMIC-NEXT:   )
;;ATOMIC-NEXT:  )
;;ATOMIC-NEXT: )
;;ATOMIC-NEXT: (i32.const 16)
;;ATOMIC-NEXT:)

;; Check that the Multi-Memory Lowering Pass grow/size functions are correct
;; CHECK: (func $0_size (result i32)
;;CHECK-NEXT:  (return
;;CHECK-NEXT:   (i32.div_u
;;CHECK-NEXT:    (global.get $profile-data_byte_offset)
;;CHECK-NEXT:    (i32.const 65536)
;;CHECK-NEXT:   )
;;CHECK-NEXT:  )
;;CHECK-NEXT: )
;;CHECK-NEXT: (func $profile-data_size (result i32)
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
;;CHECK-NEXT: (func $0_grow (param $page_delta i32) (result i32)
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
;;CHECK-NEXT: (func $profile-data_grow (param $page_delta i32) (result i32)
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
