(module
 (export "wasm_func_a" (func $a_wasm_func))
 (export "wasm_func_b" (func $b_wasm_func))

 (func $a_wasm_func
  (unreachable)
 )
 (func $b_wasm_func
  (unreachable)
 )

 (export "wasm_event_a" (event $a_wasm_event))
 (export "wasm_event_b" (event $b_wasm_event))

 (event $a_wasm_event (attr 0) (param i32))
 (event $b_wasm_event (attr 0) (param i32))
)

