(module
  (memory 0 4294967295)
  (export "ldi32_a1" $ldi32_a1)
  (export "ldi32_a2" $ldi32_a2)
  (export "ldi32_a4" $ldi32_a4)
  (export "ldi32" $ldi32)
  (export "ldi32_a8" $ldi32_a8)
  (export "ldi8_a1" $ldi8_a1)
  (export "ldi8_a2" $ldi8_a2)
  (export "ldi16_a1" $ldi16_a1)
  (export "ldi16_a2" $ldi16_a2)
  (export "ldi16_a4" $ldi16_a4)
  (export "sti32_a1" $sti32_a1)
  (export "sti32_a2" $sti32_a2)
  (export "sti32_a4" $sti32_a4)
  (export "sti32" $sti32)
  (export "sti32_a8" $sti32_a8)
  (export "sti8_a1" $sti8_a1)
  (export "sti8_a2" $sti8_a2)
  (export "sti16_a1" $sti16_a1)
  (export "sti16_a2" $sti16_a2)
  (export "sti16_a4" $sti16_a4)
  (func $ldi32_a1 (param $$0 i32) (result i32)
    (return
      (i32.load align=1
        (get_local $$0)
      )
    )
  )
  (func $ldi32_a2 (param $$0 i32) (result i32)
    (return
      (i32.load align=2
        (get_local $$0)
      )
    )
  )
  (func $ldi32_a4 (param $$0 i32) (result i32)
    (return
      (i32.load align=4
        (get_local $$0)
      )
    )
  )
  (func $ldi32 (param $$0 i32) (result i32)
    (return
      (i32.load align=4
        (get_local $$0)
      )
    )
  )
  (func $ldi32_a8 (param $$0 i32) (result i32)
    (return
      (i32.load align=8
        (get_local $$0)
      )
    )
  )
  (func $ldi8_a1 (param $$0 i32) (result i32)
    (return
      (i32.load8_u align=1
        (get_local $$0)
      )
    )
  )
  (func $ldi8_a2 (param $$0 i32) (result i32)
    (return
      (i32.load8_u align=2
        (get_local $$0)
      )
    )
  )
  (func $ldi16_a1 (param $$0 i32) (result i32)
    (return
      (i32.load16_u align=1
        (get_local $$0)
      )
    )
  )
  (func $ldi16_a2 (param $$0 i32) (result i32)
    (return
      (i32.load16_u align=2
        (get_local $$0)
      )
    )
  )
  (func $ldi16_a4 (param $$0 i32) (result i32)
    (return
      (i32.load16_u align=4
        (get_local $$0)
      )
    )
  )
  (func $sti32_a1 (param $$0 i32) (param $$1 i32)
    (i32.store align=1
      (get_local $$0)
      (get_local $$1)
    )
    (return)
  )
  (func $sti32_a2 (param $$0 i32) (param $$1 i32)
    (i32.store align=2
      (get_local $$0)
      (get_local $$1)
    )
    (return)
  )
  (func $sti32_a4 (param $$0 i32) (param $$1 i32)
    (i32.store align=4
      (get_local $$0)
      (get_local $$1)
    )
    (return)
  )
  (func $sti32 (param $$0 i32) (param $$1 i32)
    (i32.store align=4
      (get_local $$0)
      (get_local $$1)
    )
    (return)
  )
  (func $sti32_a8 (param $$0 i32) (param $$1 i32)
    (i32.store align=8
      (get_local $$0)
      (get_local $$1)
    )
    (return)
  )
  (func $sti8_a1 (param $$0 i32) (param $$1 i32)
    (i32.store align=8
      (get_local $$0)
      (get_local $$1)
    )
    (return)
  )
  (func $sti8_a2 (param $$0 i32) (param $$1 i32)
    (i32.store align=2
      (get_local $$0)
      (get_local $$1)
    )
    (return)
  )
  (func $sti16_a1 (param $$0 i32) (param $$1 i32)
    (i32.store align=1
      (get_local $$0)
      (get_local $$1)
    )
    (return)
  )
  (func $sti16_a2 (param $$0 i32) (param $$1 i32)
    (i32.store align=16
      (get_local $$0)
      (get_local $$1)
    )
    (return)
  )
  (func $sti16_a4 (param $$0 i32) (param $$1 i32)
    (i32.store align=4
      (get_local $$0)
      (get_local $$1)
    )
    (return)
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 4 }
