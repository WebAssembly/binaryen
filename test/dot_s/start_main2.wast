(module
  (memory 1)
  (start $_start)
  (export "memory" (memory $0))
  (export "main" (func $main))
  (export "_start" (func $_start))
  (func $main (param $0 i32) (param $1 i32) (result i32)
    (return
      (get_local $0)
    )
  )
  (func $_start
    (local $0 i32)
    (local $1 i32)
    (drop
      (call $main
        (get_local $0)
        (get_local $1)
      )
    )
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 12, "initializers": [] }
