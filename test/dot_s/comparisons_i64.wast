(module
  (memory 0 4294967295)
  (export "eq_i64" $eq_i64)
  (export "ne_i64" $ne_i64)
  (export "slt_i64" $slt_i64)
  (export "sle_i64" $sle_i64)
  (export "ult_i64" $ult_i64)
  (export "ule_i64" $ule_i64)
  (export "sgt_i64" $sgt_i64)
  (export "sge_i64" $sge_i64)
  (export "ugt_i64" $ugt_i64)
  (export "uge_i64" $uge_i64)
  (func $eq_i64 (param $$0 i64) (param $$1 i64) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i64.eq
            (get_local $$0)
            (get_local $$1)
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
            (get_local $$0)
            (get_local $$1)
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
            (get_local $$0)
            (get_local $$1)
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
            (get_local $$0)
            (get_local $$1)
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
            (get_local $$0)
            (get_local $$1)
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
            (get_local $$0)
            (get_local $$1)
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
            (get_local $$0)
            (get_local $$1)
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
            (get_local $$0)
            (get_local $$1)
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
            (get_local $$0)
            (get_local $$1)
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
            (get_local $$0)
            (get_local $$1)
          )
        )
      )
    )
  )
)
;; METADATA: { "asmConsts": {} }