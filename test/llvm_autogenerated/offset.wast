(module
  (memory 1
    (segment 0 "\10\04\00\00")
    (segment 4 "\00\00\00\00")
  )
  (export "memory" memory)
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
  (func $load_i32_with_folded_offset (param $$0 i32) (result i32)
    (return
      (i32.load offset=24
        (get_local $$0)
      )
    )
  )
  (func $load_i32_with_folded_gep_offset (param $$0 i32) (result i32)
    (return
      (i32.load offset=24
        (get_local $$0)
      )
    )
  )
  (func $load_i32_with_unfolded_gep_negative_offset (param $$0 i32) (result i32)
    (return
      (i32.load
        (i32.add
          (get_local $$0)
          (i32.const -24)
        )
      )
    )
  )
  (func $load_i32_with_unfolded_offset (param $$0 i32) (result i32)
    (return
      (i32.load
        (i32.add
          (get_local $$0)
          (i32.const 24)
        )
      )
    )
  )
  (func $load_i32_with_unfolded_gep_offset (param $$0 i32) (result i32)
    (return
      (i32.load
        (i32.add
          (get_local $$0)
          (i32.const 24)
        )
      )
    )
  )
  (func $load_i64_with_folded_offset (param $$0 i32) (result i64)
    (return
      (i64.load offset=24
        (get_local $$0)
      )
    )
  )
  (func $load_i64_with_folded_gep_offset (param $$0 i32) (result i64)
    (return
      (i64.load offset=24
        (get_local $$0)
      )
    )
  )
  (func $load_i64_with_unfolded_gep_negative_offset (param $$0 i32) (result i64)
    (return
      (i64.load
        (i32.add
          (get_local $$0)
          (i32.const -24)
        )
      )
    )
  )
  (func $load_i64_with_unfolded_offset (param $$0 i32) (result i64)
    (return
      (i64.load
        (i32.add
          (get_local $$0)
          (i32.const 24)
        )
      )
    )
  )
  (func $load_i64_with_unfolded_gep_offset (param $$0 i32) (result i64)
    (return
      (i64.load
        (i32.add
          (get_local $$0)
          (i32.const 24)
        )
      )
    )
  )
  (func $store_i32_with_folded_offset (param $$0 i32)
    (i32.store offset=24
      (get_local $$0)
      (i32.const 0)
    )
    (return)
  )
  (func $store_i32_with_folded_gep_offset (param $$0 i32)
    (i32.store offset=24
      (get_local $$0)
      (i32.const 0)
    )
    (return)
  )
  (func $store_i32_with_unfolded_gep_negative_offset (param $$0 i32)
    (i32.store
      (i32.add
        (get_local $$0)
        (i32.const -24)
      )
      (i32.const 0)
    )
    (return)
  )
  (func $store_i32_with_unfolded_offset (param $$0 i32)
    (i32.store
      (i32.add
        (get_local $$0)
        (i32.const 24)
      )
      (i32.const 0)
    )
    (return)
  )
  (func $store_i32_with_unfolded_gep_offset (param $$0 i32)
    (i32.store
      (i32.add
        (get_local $$0)
        (i32.const 24)
      )
      (i32.const 0)
    )
    (return)
  )
  (func $store_i64_with_folded_offset (param $$0 i32)
    (i64.store offset=24
      (get_local $$0)
      (i64.const 0)
    )
    (return)
  )
  (func $store_i64_with_folded_gep_offset (param $$0 i32)
    (i64.store offset=24
      (get_local $$0)
      (i64.const 0)
    )
    (return)
  )
  (func $store_i64_with_unfolded_gep_negative_offset (param $$0 i32)
    (i64.store
      (i32.add
        (get_local $$0)
        (i32.const -24)
      )
      (i64.const 0)
    )
    (return)
  )
  (func $store_i64_with_unfolded_offset (param $$0 i32)
    (i64.store
      (i32.add
        (get_local $$0)
        (i32.const 24)
      )
      (i64.const 0)
    )
    (return)
  )
  (func $store_i64_with_unfolded_gep_offset (param $$0 i32)
    (i64.store
      (i32.add
        (get_local $$0)
        (i32.const 24)
      )
      (i64.const 0)
    )
    (return)
  )
  (func $load_i32_from_numeric_address (result i32)
    (return
      (i32.load offset=42
        (i32.const 0)
      )
    )
  )
  (func $load_i32_from_global_address (result i32)
    (return
      (i32.load offset=4
        (i32.const 0)
      )
    )
  )
  (func $store_i32_to_numeric_address
    (i32.store offset=42
      (i32.const 0)
      (i32.const 0)
    )
    (return)
  )
  (func $store_i32_to_global_address
    (i32.store offset=4
      (i32.const 0)
      (i32.const 0)
    )
    (return)
  )
  (func $load_i8_s_with_folded_offset (param $$0 i32) (result i32)
    (return
      (i32.load8_s offset=24
        (get_local $$0)
      )
    )
  )
  (func $load_i8_s_with_folded_gep_offset (param $$0 i32) (result i32)
    (return
      (i32.load8_s offset=24
        (get_local $$0)
      )
    )
  )
  (func $load_i8_u_with_folded_offset (param $$0 i32) (result i32)
    (return
      (i32.load8_u offset=24
        (get_local $$0)
      )
    )
  )
  (func $load_i8_u_with_folded_gep_offset (param $$0 i32) (result i32)
    (return
      (i32.load8_u offset=24
        (get_local $$0)
      )
    )
  )
  (func $store_i8_with_folded_offset (param $$0 i32)
    (i32.store8 offset=24
      (get_local $$0)
      (i32.const 0)
    )
    (return)
  )
  (func $store_i8_with_folded_gep_offset (param $$0 i32)
    (i32.store8 offset=24
      (get_local $$0)
      (i32.const 0)
    )
    (return)
  )
  (func $aggregate_load_store (param $$0 i32) (param $$1 i32)
    (local $$2 i32)
    (local $$3 i32)
    (local $$4 i32)
    (set_local $$2
      (i32.load
        (get_local $$0)
      )
    )
    (set_local $$3
      (i32.load offset=4
        (get_local $$0)
      )
    )
    (set_local $$4
      (i32.load offset=8
        (get_local $$0)
      )
    )
    (i32.store offset=12
      (get_local $$1)
      (i32.load offset=12
        (get_local $$0)
      )
    )
    (i32.store offset=8
      (get_local $$1)
      (get_local $$4)
    )
    (i32.store offset=4
      (get_local $$1)
      (get_local $$3)
    )
    (i32.store
      (get_local $$1)
      (get_local $$2)
    )
    (return)
  )
  (func $aggregate_return (param $$0 i32)
    (i64.store align=4
      (get_local $$0)
      (i64.store offset=8 align=4
        (get_local $$0)
        (i64.const 0)
      )
    )
    (return)
  )
  (func $aggregate_return_without_merge (param $$0 i32)
    (i32.store offset=8
      (get_local $$0)
      (i32.store16 offset=12
        (get_local $$0)
        (i32.store8 offset=14
          (get_local $$0)
          (i32.const 0)
        )
      )
    )
    (i64.store
      (get_local $$0)
      (i64.const 0)
    )
    (return)
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 1040, "initializers": [] }
