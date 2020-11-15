(module
 (import "env" "puts" (func $puts (param i32) (result i32)))
 (memory $0 2)
 (data (i32.const 568) "Hello, world\00")
 (export "__wasm_call_ctors" (func $__wasm_call_ctors))
 (func $__wasm_call_ctors
  ;; print hello world from the global constructor
  (drop
   (call $puts
    (i32.const 568)
   )
  )
 )
)

