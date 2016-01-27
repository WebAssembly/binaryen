(module
  (memory 0 4294967295)
  (type $FUNCSIG$iiii (func (param i32 i32 i32) (result i32)))
  (type $FUNCSIG$i (func (result i32)))
  (import $memcpy "env" "memcpy" (param i32 i32 i32) (result i32))
  (import $memmove "env" "memmove" (param i32 i32 i32) (result i32))
  (import $memset "env" "memset" (param i32 i32 i32) (result i32))
  (import $def "env" "def" (result i32))
  (export "copy_yes" $copy_yes)
  (export "copy_no" $copy_no)
  (export "move_yes" $move_yes)
  (export "move_no" $move_no)
  (export "set_yes" $set_yes)
  (export "set_no" $set_no)
  (export "frame_index" $frame_index)
  (export "discard_result" $discard_result)
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
  (func $frame_index
    (local $$0 i32)
    (local $$1 i32)
    (local $$2 i32)
    (local $$3 i32)
    (local $$4 i32)
    (block $fake_return_waka123
      (block
        (set_local $$0
          (i32.const 1)
        )
        (set_local $$0
          (i32.load align=4
            (get_local $$0)
          )
        )
        (set_local $$1
          (i32.const 4096)
        )
        (set_local $$4
          (i32.sub
            (get_local $$0)
            (get_local $$1)
          )
        )
        (set_local $$1
          (i32.const 1)
        )
        (set_local $$4
          (i32.store align=4
            (get_local $$1)
            (get_local $$4)
          )
        )
        (set_local $$3
          (i32.const 2048)
        )
        (set_local $$3
          (i32.add
            (get_local $$4)
            (get_local $$3)
          )
        )
        (call_import $memset
          (get_local $$3)
          (i32.const 0)
          (i32.const 1024)
        )
        (call_import $memset
          (get_local $$4)
          (i32.const 0)
          (i32.const 1024)
        )
        (set_local $$2
          (i32.const 4096)
        )
        (set_local $$4
          (i32.add
            (get_local $$4)
            (get_local $$2)
          )
        )
        (set_local $$2
          (i32.const 1)
        )
        (set_local $$4
          (i32.store align=4
            (get_local $$2)
            (get_local $$4)
          )
        )
        (br $fake_return_waka123)
      )
    )
  )
  (func $discard_result (param $$0 i32) (param $$1 i32) (param $$2 i32) (param $$3 i32) (param $$4 i32) (result i32)
    (block $fake_return_waka123
      (block
        (block $label$0
          (block $label$1
            (br_if
              (i32.eq
                (get_local $$3)
                (i32.const 0)
              )
              $label$1
            )
            (set_local $$0
              (call_import $def)
            )
            (br $label$0)
          )
          (br_if
            (get_local $$4)
            $label$0
          )
          (call_import $memset
            (get_local $$0)
            (get_local $$1)
            (get_local $$2)
          )
        )
        (br $fake_return_waka123
          (get_local $$0)
        )
      )
    )
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 4 }
