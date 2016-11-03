(module
  (import "env" "memory" (memory $0 1))
  (table 0 anyfunc)
  (data (i32.const 4) "\10\04\00\00")
  (export "load_u_i1_i32" (func $load_u_i1_i32))
  (export "load_s_i1_i32" (func $load_s_i1_i32))
  (export "load_u_i1_i64" (func $load_u_i1_i64))
  (export "load_s_i1_i64" (func $load_s_i1_i64))
  (export "store_i32_i1" (func $store_i32_i1))
  (export "store_i64_i1" (func $store_i64_i1))
  (func $load_u_i1_i32 (param $0 i32) (result i32)
    (return
      (i32.load8_u
        (get_local $0)
      )
    )
  )
  (func $load_s_i1_i32 (param $0 i32) (result i32)
    (return
      (i32.sub
        (i32.const 0)
        (i32.and
          (i32.load8_u
            (get_local $0)
          )
          (i32.const 1)
        )
      )
    )
  )
  (func $load_u_i1_i64 (param $0 i32) (result i64)
    (return
      (i64.load8_u
        (get_local $0)
      )
    )
  )
  (func $load_s_i1_i64 (param $0 i32) (result i64)
    (return
      (i64.sub
        (i64.const 0)
        (i64.and
          (i64.load8_u
            (get_local $0)
          )
          (i64.const 1)
        )
      )
    )
  )
  (func $store_i32_i1 (param $0 i32) (param $1 i32)
    (i32.store8
      (get_local $0)
      (i32.and
        (get_local $1)
        (i32.const 1)
      )
    )
    (return)
  )
  (func $store_i64_i1 (param $0 i32) (param $1 i64)
    (i64.store8
      (get_local $0)
      (i64.and
        (get_local $1)
        (i64.const 1)
      )
    )
    (return)
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 1040, "initializers": [] }
