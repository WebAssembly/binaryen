(module
  (memory 0 4294967295)
  (export "add32" $add32)
  (export "sub32" $sub32)
  (export "mul32" $mul32)
  (export "sdiv32" $sdiv32)
  (export "udiv32" $udiv32)
  (export "srem32" $srem32)
  (export "urem32" $urem32)
  (export "and32" $and32)
  (export "or32" $or32)
  (export "xor32" $xor32)
  (export "shl32" $shl32)
  (export "shr32" $shr32)
  (export "sar32" $sar32)
  (export "clz32" $clz32)
  (export "clz32_zero_undef" $clz32_zero_undef)
  (export "ctz32" $ctz32)
  (export "ctz32_zero_undef" $ctz32_zero_undef)
  (export "popcnt32" $popcnt32)
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
; METADATA: { "asmConsts": {} }