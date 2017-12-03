(module
 (export "wasm_func_a" (func $a_wasm_func))
 (export "wasm_func_b" (func $b_wasm_func))

 (func $a_wasm_func
  (unreachable)
 )
 (func $b_wasm_func
  (unreachable)
 )
)

