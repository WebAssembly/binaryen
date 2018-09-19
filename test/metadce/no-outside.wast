(module
 (import "env" "js_func" (func $a_js_func))
 (import "env" "js_func_unused" (func $an_unused_js_func))
 (export "wasm_func" (func $a_wasm_func))
 (export "wasm_func_unused" (func $an_unused_wasm_func))
 (func $a_wasm_func
  (call $a_js_func)
 )
 (func $an_unused_wasm_func
 )
)

