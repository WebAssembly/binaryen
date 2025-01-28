;; RUN: wasm-opt %s --remove-memory-init -all -S -o - | filecheck %s

(module
 (type $0 (func))
 ;; CHECK:      (memory $mem 2)
 (memory $mem 2)
 (data (memory $mem) (i32.const 0) "Hello, world\00")
 (func $__wasm_init_memory (type $0)
  (memory.fill 0
   (i32.const 0)
   (i32.const 0)
   (i32.const 0)
  )
 )
 (start $__wasm_init_memory)
)

;; CHECK-NOT: data
;; CHECK-NOT: __wasm_init_memory
