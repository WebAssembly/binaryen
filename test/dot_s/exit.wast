(module
  (memory 0 4294967295)
  (import $exit "env" "exit" (param i32))
  (export "main" $main)
  (func $main (result i32)
    (local $$0 i32)
    (call_import $exit
      (i32.const 0)
    )
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 0 }
