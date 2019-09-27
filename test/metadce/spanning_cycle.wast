(module
 (memory 1 1)
 (data passive "Hello, datacount section!")

 (import "env" "js_func" (func $a_js_func))

 (export "wasm_func_a" (func $a_wasm_func))

 (func $a_wasm_func
  ;; refer to the data segment to keep it around
  (memory.init 0
   (i32.const 0)
   (i32.const 0)
   (i32.const 25)
  )
  (call $a_js_func)
 )
)
