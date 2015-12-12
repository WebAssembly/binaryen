(module
  (memory 0 4294967295)
  (func $add32 (param $$0 i32) (param $$1 i32) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i32.add
            (get_local $$1)
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $sub32 (param $$0 i32) (param $$1 i32) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i32.sub
            (get_local $$1)
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $mul32 (param $$0 i32) (param $$1 i32) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i32.mul
            (get_local $$1)
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $sdiv32 (param $$0 i32) (param $$1 i32) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i32.div_s
            (get_local $$1)
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $udiv32 (param $$0 i32) (param $$1 i32) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i32.div_u
            (get_local $$1)
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $srem32 (param $$0 i32) (param $$1 i32) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i32.rem_s
            (get_local $$1)
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $urem32 (param $$0 i32) (param $$1 i32) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i32.rem_u
            (get_local $$1)
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $and32 (param $$0 i32) (param $$1 i32) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i32.and
            (get_local $$1)
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $or32 (param $$0 i32) (param $$1 i32) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i32.or
            (get_local $$1)
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $xor32 (param $$0 i32) (param $$1 i32) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i32.xor
            (get_local $$1)
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $shl32 (param $$0 i32) (param $$1 i32) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i32.shl
            (get_local $$1)
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $shr32 (param $$0 i32) (param $$1 i32) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i32.shr_u
            (get_local $$1)
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $sar32 (param $$0 i32) (param $$1 i32) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i32.shr_s
            (get_local $$1)
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $clz32 (param $$0 i32) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i32.clz
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $clz32_zero_undef (param $$0 i32) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i32.clz
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $ctz32 (param $$0 i32) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i32.ctz
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $ctz32_zero_undef (param $$0 i32) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i32.ctz
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $popcnt32 (param $$0 i32) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i32.popcnt
            (get_local $$0)
          )
        )
      )
    )
  )
)
