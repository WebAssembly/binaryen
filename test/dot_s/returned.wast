(module
  (memory 0 4294967295)
  (export "_Z3foov" $_Z3foov)
  (export "_Z3barPvS_l" $_Z3barPvS_l)
  (func $_Z3foov (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (call $_ZN5AppleC1Ev
            (call $_Znwm
              (i32.const 1)
            )
          )
        )
      )
    )
  )
  (func $_Z3barPvS_l (param $$0 i32) (param $$1 i32) (param $$2 i32) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (call $memcpy
            (get_local $$2)
            (get_local $$1)
            (get_local $$0)
          )
        )
      )
    )
  )
)
