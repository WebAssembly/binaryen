(module
  (memory 0 4294967295)
  (type $FUNCSIG$iiii (func (param i32 i32 i32) (result i32)))
  (import $memcpy "env" "memcpy" (param i32 i32 i32) (result i32))
  (import $memmove "env" "memmove" (param i32 i32 i32) (result i32))
  (import $memset "env" "memset" (param i32 i32 i32) (result i32))
  (export "copy_yes" $copy_yes)
  (export "copy_no" $copy_no)
  (export "move_yes" $move_yes)
  (export "move_no" $move_no)
  (export "set_yes" $set_yes)
  (export "set_no" $set_no)
  (func $copy_yes (param $$0 i32) (param $$1 i32) (param $$2 i32) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (call_import $memcpy
            (get_local $$0)
            (get_local $$1)
            (get_local $$2)
          )
        )
      )
    )
  )
  (func $copy_no (param $$0 i32) (param $$1 i32) (param $$2 i32)
    (block $fake_return_waka123
      (block
        (call_import $memcpy
          (get_local $$0)
          (get_local $$1)
          (get_local $$2)
        )
        (br $fake_return_waka123)
      )
    )
  )
  (func $move_yes (param $$0 i32) (param $$1 i32) (param $$2 i32) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (call_import $memmove
            (get_local $$0)
            (get_local $$1)
            (get_local $$2)
          )
        )
      )
    )
  )
  (func $move_no (param $$0 i32) (param $$1 i32) (param $$2 i32)
    (block $fake_return_waka123
      (block
        (call_import $memmove
          (get_local $$0)
          (get_local $$1)
          (get_local $$2)
        )
        (br $fake_return_waka123)
      )
    )
  )
  (func $set_yes (param $$0 i32) (param $$1 i32) (param $$2 i32) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (call_import $memset
            (get_local $$0)
            (get_local $$1)
            (get_local $$2)
          )
        )
      )
    )
  )
  (func $set_no (param $$0 i32) (param $$1 i32) (param $$2 i32)
    (block $fake_return_waka123
      (block
        (call_import $memset
          (get_local $$0)
          (get_local $$1)
          (get_local $$2)
        )
        (br $fake_return_waka123)
      )
    )
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 4 }
