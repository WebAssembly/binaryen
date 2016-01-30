(module
  (memory 0 4294967295)
  (export "sext_i8_i32" $sext_i8_i32)
  (export "zext_i8_i32" $zext_i8_i32)
  (export "sext_i16_i32" $sext_i16_i32)
  (export "zext_i16_i32" $zext_i16_i32)
  (export "sext_i8_i64" $sext_i8_i64)
  (export "zext_i8_i64" $zext_i8_i64)
  (export "sext_i16_i64" $sext_i16_i64)
  (export "zext_i16_i64" $zext_i16_i64)
  (export "sext_i32_i64" $sext_i32_i64)
  (export "zext_i32_i64" $zext_i32_i64)
  (func $sext_i8_i32 (param $$0 i32) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i32.load8_s align=1
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $zext_i8_i32 (param $$0 i32) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i32.load8_u align=1
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $sext_i16_i32 (param $$0 i32) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i32.load16_s align=2
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $zext_i16_i32 (param $$0 i32) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i32.load16_u align=2
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $sext_i8_i64 (param $$0 i32) (result i64)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i64.load8_s align=1
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $zext_i8_i64 (param $$0 i32) (result i64)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i64.load8_u align=1
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $sext_i16_i64 (param $$0 i32) (result i64)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i64.load16_s align=2
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $zext_i16_i64 (param $$0 i32) (result i64)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i64.load16_u align=2
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $sext_i32_i64 (param $$0 i32) (result i64)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i64.load32_s align=4
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $zext_i32_i64 (param $$0 i32) (result i64)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i64.load32_u align=4
            (get_local $$0)
          )
        )
      )
    )
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 4 }
