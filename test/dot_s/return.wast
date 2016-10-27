(module
  (import "env" "memory" (memory $0 1))
  (table 0 anyfunc)
  (export "return_i32" (func $return_i32))
  (export "return_void" (func $return_void))
  (func $return_i32 (result i32)
    (i32.const 5)
  )
  (func $return_void
  )
  (func $fallthrough_return_nested_loop_i32 (result i32)
    (loop $label$0 i32
      (loop $label$1 i32
        (return
          (i32.const 1)
        )
      )
    )
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 12, "initializers": [] }
