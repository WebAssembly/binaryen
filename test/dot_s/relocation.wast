(module
  (memory 16
    (segment 8 "\0c\00\00\00")
    (segment 12 "\08\00\00\00")
  )
  (export "main" $main)
  (func $main (result i32)
    (local $$0 i32)
    (return
      (i32.load align=4
        (i32.const 12)
      )
    )
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 15 }
