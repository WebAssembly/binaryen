(module
  (memory 0 4294967295)
  (func $eq_i32 (param $$0 i32) (param $$1 i32) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i32.eq
            (get_local $$1)
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $ne_i32 (param $$0 i32) (param $$1 i32) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i32.ne
            (get_local $$1)
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $slt_i32 (param $$0 i32) (param $$1 i32) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i32.lt_s
            (get_local $$1)
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $sle_i32 (param $$0 i32) (param $$1 i32) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i32.le_s
            (get_local $$1)
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $ult_i32 (param $$0 i32) (param $$1 i32) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i32.lt_u
            (get_local $$1)
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $ule_i32 (param $$0 i32) (param $$1 i32) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i32.le_u
            (get_local $$1)
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $sgt_i32 (param $$0 i32) (param $$1 i32) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i32.gt_s
            (get_local $$1)
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $sge_i32 (param $$0 i32) (param $$1 i32) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i32.ge_s
            (get_local $$1)
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $ugt_i32 (param $$0 i32) (param $$1 i32) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i32.gt_u
            (get_local $$1)
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $uge_i32 (param $$0 i32) (param $$1 i32) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i32.ge_u
            (get_local $$1)
            (get_local $$0)
          )
        )
      )
    )
  )
)
