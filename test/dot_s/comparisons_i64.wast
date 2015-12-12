(module
  (memory 0 4294967295)
  (func $eq_i64 (param $$0 i64) (param $$1 i64) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i64.eq
            (get_local $$1)
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $ne_i64 (param $$0 i64) (param $$1 i64) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i64.ne
            (get_local $$1)
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $slt_i64 (param $$0 i64) (param $$1 i64) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i64.lt_s
            (get_local $$1)
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $sle_i64 (param $$0 i64) (param $$1 i64) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i64.le_s
            (get_local $$1)
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $ult_i64 (param $$0 i64) (param $$1 i64) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i64.lt_u
            (get_local $$1)
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $ule_i64 (param $$0 i64) (param $$1 i64) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i64.le_u
            (get_local $$1)
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $sgt_i64 (param $$0 i64) (param $$1 i64) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i64.gt_s
            (get_local $$1)
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $sge_i64 (param $$0 i64) (param $$1 i64) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i64.ge_s
            (get_local $$1)
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $ugt_i64 (param $$0 i64) (param $$1 i64) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i64.gt_u
            (get_local $$1)
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $uge_i64 (param $$0 i64) (param $$1 i64) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i64.ge_u
            (get_local $$1)
            (get_local $$0)
          )
        )
      )
    )
  )
)
