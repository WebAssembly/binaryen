(module
 (import "env" "js_func" (func $a_js_func))

 (export "wasm_func_a" (func $a_wasm_func))

 (func $a_wasm_func
  (call $a_js_func)
 )
)

