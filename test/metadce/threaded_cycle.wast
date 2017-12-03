(module
 (import "env" "js_func1" (func $js_func_1))
 (import "env" "js_func2" (func $js_func_2))
 (import "env" "js_func3" (func $js_func_3))
 (import "env" "js_func4" (func $js_func_4))

 (export "wasm_func1" (func $wasm_func_1))
 (export "wasm_func2" (func $wasm_func_2))
 (export "wasm_func3" (func $wasm_func_3))
 (export "wasm_func4" (func $wasm_func_4))

 (func $wasm_func_1
  (call $js_func_2)
 )
 (func $wasm_func_2
  (call $js_func_3)
 )
 (func $wasm_func_3
  (call $js_func_4)
 )
 (func $wasm_func_4
  (call $js_func_1)
 )
)

