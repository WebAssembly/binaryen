(module
  (memory 0)
  (export "memory" memory)
  (type $FUNCSIG$vi (func (param i32)))
  (import $exit "env" "exit" (param i32))
  (export "main" $main)
  (func $main (result i32)
    (local $$0 i32)
    (call_import $exit
      (i32.const 0)
    )
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 4 }
