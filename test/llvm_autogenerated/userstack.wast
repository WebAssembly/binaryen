(module
  (memory 1
    (segment 4 "\10\04\00\00")
  )
  (export "memory" memory)
  (type $FUNCSIG$vi (func (param i32)))
  (import $ext_func "env" "ext_func" (param i32))
  (export "alloca32" $alloca32)
  (export "alloca3264" $alloca3264)
  (export "allocarray" $allocarray)
  (export "non_mem_use" $non_mem_use)
  (export "allocarray_inbounds" $allocarray_inbounds)
  (export "dynamic_alloca" $dynamic_alloca)
  (export "dynamic_static_alloca" $dynamic_static_alloca)
  (func $alloca32
    (local $0 i32)
    (local $1 i32)
    (local $2 i32)
    (local $3 i32)
    (set_local $0
      (i32.const 4)
    )
    (set_local $0
      (i32.load
        (get_local $0)
      )
    )
    (set_local $1
      (i32.const 16)
    )
    (set_local $3
      (i32.sub
        (get_local $0)
        (get_local $1)
      )
    )
    (set_local $1
      (i32.const 4)
    )
    (set_local $3
      (i32.store
        (get_local $1)
        (get_local $3)
      )
    )
    (i32.store offset=12
      (get_local $3)
      (i32.const 0)
    )
    (set_local $2
      (i32.const 16)
    )
    (set_local $3
      (i32.add
        (get_local $3)
        (get_local $2)
      )
    )
    (set_local $2
      (i32.const 4)
    )
    (set_local $3
      (i32.store
        (get_local $2)
        (get_local $3)
      )
    )
    (return)
  )
  (func $alloca3264
    (local $0 i32)
    (local $1 i32)
    (local $2 i32)
    (local $3 i32)
    (set_local $0
      (i32.const 4)
    )
    (set_local $0
      (i32.load
        (get_local $0)
      )
    )
    (set_local $1
      (i32.const 16)
    )
    (set_local $3
      (i32.sub
        (get_local $0)
        (get_local $1)
      )
    )
    (set_local $1
      (i32.const 4)
    )
    (set_local $3
      (i32.store
        (get_local $1)
        (get_local $3)
      )
    )
    (i32.store offset=12
      (get_local $3)
      (i32.const 0)
    )
    (i64.store
      (get_local $3)
      (i64.const 0)
    )
    (set_local $2
      (i32.const 16)
    )
    (set_local $3
      (i32.add
        (get_local $3)
        (get_local $2)
      )
    )
    (set_local $2
      (i32.const 4)
    )
    (set_local $3
      (i32.store
        (get_local $2)
        (get_local $3)
      )
    )
    (return)
  )
  (func $allocarray
    (local $0 i32)
    (local $1 i32)
    (local $2 i32)
    (local $3 i32)
    (local $4 i32)
    (set_local $0
      (i32.const 4)
    )
    (set_local $0
      (i32.load
        (get_local $0)
      )
    )
    (set_local $1
      (i32.const 32)
    )
    (set_local $4
      (i32.sub
        (get_local $0)
        (get_local $1)
      )
    )
    (set_local $1
      (i32.const 4)
    )
    (set_local $4
      (i32.store
        (get_local $1)
        (get_local $4)
      )
    )
    (set_local $3
      (i32.const 12)
    )
    (set_local $3
      (i32.add
        (get_local $4)
        (get_local $3)
      )
    )
    (i32.store
      (i32.add
        (get_local $3)
        (i32.const 12)
      )
      (i32.store offset=12
        (get_local $4)
        (i32.const 1)
      )
    )
    (set_local $2
      (i32.const 32)
    )
    (set_local $4
      (i32.add
        (get_local $4)
        (get_local $2)
      )
    )
    (set_local $2
      (i32.const 4)
    )
    (set_local $4
      (i32.store
        (get_local $2)
        (get_local $4)
      )
    )
    (return)
  )
  (func $non_mem_use (param $0 i32)
    (local $1 i32)
    (local $2 i32)
    (local $3 i32)
    (local $4 i32)
    (local $5 i32)
    (local $6 i32)
    (set_local $1
      (i32.const 4)
    )
    (set_local $1
      (i32.load
        (get_local $1)
      )
    )
    (set_local $2
      (i32.const 48)
    )
    (set_local $6
      (i32.sub
        (get_local $1)
        (get_local $2)
      )
    )
    (set_local $2
      (i32.const 4)
    )
    (set_local $6
      (i32.store
        (get_local $2)
        (get_local $6)
      )
    )
    (set_local $4
      (i32.const 8)
    )
    (set_local $4
      (i32.add
        (get_local $6)
        (get_local $4)
      )
    )
    (call_import $ext_func
      (get_local $4)
    )
    (call_import $ext_func
      (get_local $6)
    )
    (set_local $5
      (i32.const 16)
    )
    (set_local $5
      (i32.add
        (get_local $6)
        (get_local $5)
      )
    )
    (i32.store
      (get_local $0)
      (get_local $5)
    )
    (set_local $3
      (i32.const 48)
    )
    (set_local $6
      (i32.add
        (get_local $6)
        (get_local $3)
      )
    )
    (set_local $3
      (i32.const 4)
    )
    (set_local $6
      (i32.store
        (get_local $3)
        (get_local $6)
      )
    )
    (return)
  )
  (func $allocarray_inbounds
    (local $0 i32)
    (local $1 i32)
    (local $2 i32)
    (local $3 i32)
    (set_local $0
      (i32.const 4)
    )
    (set_local $0
      (i32.load
        (get_local $0)
      )
    )
    (set_local $1
      (i32.const 32)
    )
    (set_local $3
      (i32.sub
        (get_local $0)
        (get_local $1)
      )
    )
    (set_local $1
      (i32.const 4)
    )
    (set_local $3
      (i32.store
        (get_local $1)
        (get_local $3)
      )
    )
    (i32.store offset=24
      (get_local $3)
      (i32.store offset=12
        (get_local $3)
        (i32.const 1)
      )
    )
    (set_local $2
      (i32.const 32)
    )
    (set_local $3
      (i32.add
        (get_local $3)
        (get_local $2)
      )
    )
    (set_local $2
      (i32.const 4)
    )
    (set_local $3
      (i32.store
        (get_local $2)
        (get_local $3)
      )
    )
    (return)
  )
  (func $dynamic_alloca (param $0 i32)
    (local $1 i32)
    (local $2 i32)
    (local $3 i32)
    (local $4 i32)
    (set_local $1
      (i32.const 4)
    )
    (set_local $3
      (i32.load
        (get_local $1)
      )
    )
    (set_local $4
      (get_local $3)
    )
    (set_local $0
      (i32.sub
        (get_local $3)
        (i32.and
          (i32.add
            (i32.shl
              (get_local $0)
              (i32.const 2)
            )
            (i32.const 15)
          )
          (i32.const -16)
        )
      )
    )
    (set_local $3
      (get_local $0)
    )
    (i32.store
      (get_local $0)
      (i32.const 0)
    )
    (set_local $2
      (i32.const 4)
    )
    (set_local $3
      (i32.store
        (get_local $2)
        (get_local $4)
      )
    )
    (return)
  )
  (func $dynamic_static_alloca (param $0 i32)
    (local $1 i32)
    (local $2 i32)
    (local $3 i32)
    (local $4 i32)
    (local $5 i32)
    (set_local $1
      (i32.const 4)
    )
    (set_local $1
      (i32.load
        (get_local $1)
      )
    )
    (set_local $2
      (i32.const 16)
    )
    (set_local $4
      (i32.sub
        (get_local $1)
        (get_local $2)
      )
    )
    (set_local $5
      (get_local $4)
    )
    (set_local $2
      (i32.const 4)
    )
    (set_local $4
      (i32.store
        (get_local $2)
        (get_local $4)
      )
    )
    (set_local $0
      (i32.sub
        (get_local $4)
        (i32.and
          (i32.add
            (i32.shl
              (get_local $0)
              (i32.const 2)
            )
            (i32.const 15)
          )
          (i32.const -16)
        )
      )
    )
    (set_local $4
      (get_local $0)
    )
    (i32.store
      (get_local $0)
      (i32.const 0)
    )
    (set_local $3
      (i32.const 16)
    )
    (set_local $4
      (i32.add
        (get_local $5)
        (get_local $3)
      )
    )
    (set_local $3
      (i32.const 4)
    )
    (set_local $4
      (i32.store
        (get_local $3)
        (get_local $4)
      )
    )
    (return)
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 1040, "initializers": [] }
