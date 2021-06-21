(module
 (export "wasm_func_a" (func $a_wasm_func))
 (export "wasm_func_b" (func $b_wasm_func))

 (func $a_wasm_func
  (unreachable)
 )
 (func $b_wasm_func
  (unreachable)
 )

 (export "wasm_tag_a" (tag $a_wasm_tag))
 (export "wasm_tag_b" (tag $b_wasm_tag))

 (tag $a_wasm_tag (param i32))
 (tag $b_wasm_tag (param i32))
)

