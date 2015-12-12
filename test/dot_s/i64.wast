(module
  (memory 0 4294967295)
  (func $add64 (param $$0 i64) (param $$1 i64) (result i64)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i64.add
            (get_local $$1)
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $sub64 (param $$0 i64) (param $$1 i64) (result i64)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i64.sub
            (get_local $$1)
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $mul64 (param $$0 i64) (param $$1 i64) (result i64)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i64.mul
            (get_local $$1)
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $sdiv64 (param $$0 i64) (param $$1 i64) (result i64)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i64.div_s
            (get_local $$1)
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $udiv64 (param $$0 i64) (param $$1 i64) (result i64)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i64.div_u
            (get_local $$1)
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $srem64 (param $$0 i64) (param $$1 i64) (result i64)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i64.rem_s
            (get_local $$1)
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $urem64 (param $$0 i64) (param $$1 i64) (result i64)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i64.rem_u
            (get_local $$1)
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $and64 (param $$0 i64) (param $$1 i64) (result i64)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i64.and
            (get_local $$1)
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $or64 (param $$0 i64) (param $$1 i64) (result i64)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i64.or
            (get_local $$1)
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $xor64 (param $$0 i64) (param $$1 i64) (result i64)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i64.xor
            (get_local $$1)
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $shl64 (param $$0 i64) (param $$1 i64) (result i64)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i64.shl
            (get_local $$1)
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $shr64 (param $$0 i64) (param $$1 i64) (result i64)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i64.shr_u
            (get_local $$1)
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $sar64 (param $$0 i64) (param $$1 i64) (result i64)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i64.shr_s
            (get_local $$1)
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $clz64 (param $$0 i64) (result i64)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i64.clz
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $clz64_zero_undef (param $$0 i64) (result i64)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i64.clz
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $ctz64 (param $$0 i64) (result i64)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i64.ctz
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $ctz64_zero_undef (param $$0 i64) (result i64)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i64.ctz
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $popcnt64 (param $$0 i64) (result i64)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i64.popcnt
            (get_local $$0)
          )
        )
      )
    )
  )
)
