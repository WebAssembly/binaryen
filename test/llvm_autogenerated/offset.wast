(module
  (memory 1)
  (data (i32.const 4) "\10\04\00\00")
  (data (i32.const 12) "\00\00\00\00")
  (export "memory" memory)
  (type $0 (func (param i32) (result i32)))
  (type $1 (func (param i32) (result i64)))
  (type $2 (func (param i32)))
  (type $3 (func (result i32)))
  (type $4 (func))
  (type $5 (func (param i32 i32)))
  (export "load_i32_with_folded_offset" $load_i32_with_folded_offset)
  (export "load_i32_with_folded_gep_offset" $load_i32_with_folded_gep_offset)
  (export "load_i32_with_unfolded_gep_negative_offset" $load_i32_with_unfolded_gep_negative_offset)
  (export "load_i32_with_unfolded_offset" $load_i32_with_unfolded_offset)
  (export "load_i32_with_unfolded_gep_offset" $load_i32_with_unfolded_gep_offset)
  (export "load_i64_with_folded_offset" $load_i64_with_folded_offset)
  (export "load_i64_with_folded_gep_offset" $load_i64_with_folded_gep_offset)
  (export "load_i64_with_unfolded_gep_negative_offset" $load_i64_with_unfolded_gep_negative_offset)
  (export "load_i64_with_unfolded_offset" $load_i64_with_unfolded_offset)
  (export "load_i64_with_unfolded_gep_offset" $load_i64_with_unfolded_gep_offset)
  (export "load_i32_with_folded_or_offset" $load_i32_with_folded_or_offset)
  (export "store_i32_with_folded_offset" $store_i32_with_folded_offset)
  (export "store_i32_with_folded_gep_offset" $store_i32_with_folded_gep_offset)
  (export "store_i32_with_unfolded_gep_negative_offset" $store_i32_with_unfolded_gep_negative_offset)
  (export "store_i32_with_unfolded_offset" $store_i32_with_unfolded_offset)
  (export "store_i32_with_unfolded_gep_offset" $store_i32_with_unfolded_gep_offset)
  (export "store_i64_with_folded_offset" $store_i64_with_folded_offset)
  (export "store_i64_with_folded_gep_offset" $store_i64_with_folded_gep_offset)
  (export "store_i64_with_unfolded_gep_negative_offset" $store_i64_with_unfolded_gep_negative_offset)
  (export "store_i64_with_unfolded_offset" $store_i64_with_unfolded_offset)
  (export "store_i64_with_unfolded_gep_offset" $store_i64_with_unfolded_gep_offset)
  (export "store_i32_with_folded_or_offset" $store_i32_with_folded_or_offset)
  (export "load_i32_from_numeric_address" $load_i32_from_numeric_address)
  (export "load_i32_from_global_address" $load_i32_from_global_address)
  (export "store_i32_to_numeric_address" $store_i32_to_numeric_address)
  (export "store_i32_to_global_address" $store_i32_to_global_address)
  (export "load_i8_s_with_folded_offset" $load_i8_s_with_folded_offset)
  (export "load_i8_s_with_folded_gep_offset" $load_i8_s_with_folded_gep_offset)
  (export "load_i8_u_with_folded_offset" $load_i8_u_with_folded_offset)
  (export "load_i8_u_with_folded_gep_offset" $load_i8_u_with_folded_gep_offset)
  (export "store_i8_with_folded_offset" $store_i8_with_folded_offset)
  (export "store_i8_with_folded_gep_offset" $store_i8_with_folded_gep_offset)
  (export "aggregate_load_store" $aggregate_load_store)
  (export "aggregate_return" $aggregate_return)
  (export "aggregate_return_without_merge" $aggregate_return_without_merge)
  (func $load_i32_with_folded_offset (type $0) (param $0 i32) (result i32)
    (i32.load offset=24
      (get_local $0)
    )
  )
  (func $load_i32_with_folded_gep_offset (type $0) (param $0 i32) (result i32)
    (i32.load offset=24
      (get_local $0)
    )
  )
  (func $load_i32_with_unfolded_gep_negative_offset (type $0) (param $0 i32) (result i32)
    (i32.load
      (i32.add
        (get_local $0)
        (i32.const -24)
      )
    )
  )
  (func $load_i32_with_unfolded_offset (type $0) (param $0 i32) (result i32)
    (i32.load
      (i32.add
        (get_local $0)
        (i32.const 24)
      )
    )
  )
  (func $load_i32_with_unfolded_gep_offset (type $0) (param $0 i32) (result i32)
    (i32.load
      (i32.add
        (get_local $0)
        (i32.const 24)
      )
    )
  )
  (func $load_i64_with_folded_offset (type $1) (param $0 i32) (result i64)
    (i64.load offset=24
      (get_local $0)
    )
  )
  (func $load_i64_with_folded_gep_offset (type $1) (param $0 i32) (result i64)
    (i64.load offset=24
      (get_local $0)
    )
  )
  (func $load_i64_with_unfolded_gep_negative_offset (type $1) (param $0 i32) (result i64)
    (i64.load
      (i32.add
        (get_local $0)
        (i32.const -24)
      )
    )
  )
  (func $load_i64_with_unfolded_offset (type $1) (param $0 i32) (result i64)
    (i64.load
      (i32.add
        (get_local $0)
        (i32.const 24)
      )
    )
  )
  (func $load_i64_with_unfolded_gep_offset (type $1) (param $0 i32) (result i64)
    (i64.load
      (i32.add
        (get_local $0)
        (i32.const 24)
      )
    )
  )
  (func $load_i32_with_folded_or_offset (type $0) (param $0 i32) (result i32)
    (i32.load8_s offset=2
      (i32.and
        (get_local $0)
        (i32.const -4)
      )
    )
  )
  (func $store_i32_with_folded_offset (type $2) (param $0 i32)
    (i32.store offset=24
      (get_local $0)
      (i32.const 0)
    )
  )
  (func $store_i32_with_folded_gep_offset (type $2) (param $0 i32)
    (i32.store offset=24
      (get_local $0)
      (i32.const 0)
    )
  )
  (func $store_i32_with_unfolded_gep_negative_offset (type $2) (param $0 i32)
    (i32.store
      (i32.add
        (get_local $0)
        (i32.const -24)
      )
      (i32.const 0)
    )
  )
  (func $store_i32_with_unfolded_offset (type $2) (param $0 i32)
    (i32.store
      (i32.add
        (get_local $0)
        (i32.const 24)
      )
      (i32.const 0)
    )
  )
  (func $store_i32_with_unfolded_gep_offset (type $2) (param $0 i32)
    (i32.store
      (i32.add
        (get_local $0)
        (i32.const 24)
      )
      (i32.const 0)
    )
  )
  (func $store_i64_with_folded_offset (type $2) (param $0 i32)
    (i64.store offset=24
      (get_local $0)
      (i64.const 0)
    )
  )
  (func $store_i64_with_folded_gep_offset (type $2) (param $0 i32)
    (i64.store offset=24
      (get_local $0)
      (i64.const 0)
    )
  )
  (func $store_i64_with_unfolded_gep_negative_offset (type $2) (param $0 i32)
    (i64.store
      (i32.add
        (get_local $0)
        (i32.const -24)
      )
      (i64.const 0)
    )
  )
  (func $store_i64_with_unfolded_offset (type $2) (param $0 i32)
    (i64.store
      (i32.add
        (get_local $0)
        (i32.const 24)
      )
      (i64.const 0)
    )
  )
  (func $store_i64_with_unfolded_gep_offset (type $2) (param $0 i32)
    (i64.store
      (i32.add
        (get_local $0)
        (i32.const 24)
      )
      (i64.const 0)
    )
  )
  (func $store_i32_with_folded_or_offset (type $2) (param $0 i32)
    (i32.store8 offset=2
      (i32.and
        (get_local $0)
        (i32.const -4)
      )
      (i32.const 0)
    )
  )
  (func $load_i32_from_numeric_address (type $3) (result i32)
    (i32.load offset=42
      (i32.const 0)
    )
  )
  (func $load_i32_from_global_address (type $3) (result i32)
    (i32.load offset=12
      (i32.const 0)
    )
  )
  (func $store_i32_to_numeric_address (type $4)
    (i32.store offset=42
      (i32.const 0)
      (i32.const 0)
    )
  )
  (func $store_i32_to_global_address (type $4)
    (i32.store offset=12
      (i32.const 0)
      (i32.const 0)
    )
  )
  (func $load_i8_s_with_folded_offset (type $0) (param $0 i32) (result i32)
    (i32.load8_s offset=24
      (get_local $0)
    )
  )
  (func $load_i8_s_with_folded_gep_offset (type $0) (param $0 i32) (result i32)
    (i32.load8_s offset=24
      (get_local $0)
    )
  )
  (func $load_i8_u_with_folded_offset (type $0) (param $0 i32) (result i32)
    (i32.load8_u offset=24
      (get_local $0)
    )
  )
  (func $load_i8_u_with_folded_gep_offset (type $0) (param $0 i32) (result i32)
    (i32.load8_u offset=24
      (get_local $0)
    )
  )
  (func $store_i8_with_folded_offset (type $2) (param $0 i32)
    (i32.store8 offset=24
      (get_local $0)
      (i32.const 0)
    )
  )
  (func $store_i8_with_folded_gep_offset (type $2) (param $0 i32)
    (i32.store8 offset=24
      (get_local $0)
      (i32.const 0)
    )
  )
  (func $aggregate_load_store (type $5) (param $0 i32) (param $1 i32)
    (local $2 i32)
    (local $3 i32)
    (local $4 i32)
    (set_local $2
      (i32.load
        (get_local $0)
      )
    )
    (set_local $3
      (i32.load offset=4
        (get_local $0)
      )
    )
    (set_local $4
      (i32.load offset=8
        (get_local $0)
      )
    )
    (i32.store offset=12
      (get_local $1)
      (i32.load offset=12
        (get_local $0)
      )
    )
    (i32.store offset=8
      (get_local $1)
      (get_local $4)
    )
    (i32.store offset=4
      (get_local $1)
      (get_local $3)
    )
    (i32.store
      (get_local $1)
      (get_local $2)
    )
  )
  (func $aggregate_return (type $2) (param $0 i32)
    (local $1 i64)
    (i64.store align=4
      (get_local $0)
      (block
        (block
          (set_local $1
            (i64.const 0)
          )
          (i64.store offset=8 align=4
            (get_local $0)
            (get_local $1)
          )
        )
        (get_local $1)
      )
    )
  )
  (func $aggregate_return_without_merge (type $2) (param $0 i32)
    (local $1 i32)
    (local $2 i32)
    (i32.store offset=8
      (get_local $0)
      (block
        (block
          (set_local $2
            (block
              (block
                (set_local $1
                  (i32.const 0)
                )
                (i32.store8 offset=14
                  (get_local $0)
                  (get_local $1)
                )
              )
              (get_local $1)
            )
          )
          (i32.store16 offset=12
            (get_local $0)
            (get_local $2)
          )
        )
        (get_local $2)
      )
    )
    (i64.store
      (get_local $0)
      (i64.const 0)
    )
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 1040, "initializers": [] }
