(module
  (memory 0 4294967295)
  (func $ord_f32 (param $$0 f32) (param $$1 f32) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i32.and
            (f32.eq
              (get_local $$0)
              (get_local $$0)
            )
            (f32.eq
              (get_local $$1)
              (get_local $$1)
            )
          )
        )
      )
    )
  )
  (func $uno_f32 (param $$0 f32) (param $$1 f32) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i32.or
            (f32.ne
              (get_local $$0)
              (get_local $$0)
            )
            (f32.ne
              (get_local $$1)
              (get_local $$1)
            )
          )
        )
      )
    )
  )
  (func $oeq_f32 (param $$0 f32) (param $$1 f32) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (f32.eq
            (get_local $$1)
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $une_f32 (param $$0 f32) (param $$1 f32) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (f32.ne
            (get_local $$1)
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $olt_f32 (param $$0 f32) (param $$1 f32) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (f32.lt
            (get_local $$1)
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $ole_f32 (param $$0 f32) (param $$1 f32) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (f32.le
            (get_local $$1)
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $ogt_f32 (param $$0 f32) (param $$1 f32) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (f32.gt
            (get_local $$1)
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $oge_f32 (param $$0 f32) (param $$1 f32) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (f32.ge
            (get_local $$1)
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $ueq_f32 (param $$0 f32) (param $$1 f32) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i32.or
            (f32.eq
              (get_local $$1)
              (get_local $$0)
            )
            (i32.or
              (f32.ne
                (get_local $$0)
                (get_local $$0)
              )
              (f32.ne
                (get_local $$1)
                (get_local $$1)
              )
            )
          )
        )
      )
    )
  )
  (func $one_f32 (param $$0 f32) (param $$1 f32) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i32.and
            (f32.ne
              (get_local $$1)
              (get_local $$0)
            )
            (i32.and
              (f32.eq
                (get_local $$0)
                (get_local $$0)
              )
              (f32.eq
                (get_local $$1)
                (get_local $$1)
              )
            )
          )
        )
      )
    )
  )
  (func $ult_f32 (param $$0 f32) (param $$1 f32) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i32.or
            (f32.lt
              (get_local $$1)
              (get_local $$0)
            )
            (i32.or
              (f32.ne
                (get_local $$0)
                (get_local $$0)
              )
              (f32.ne
                (get_local $$1)
                (get_local $$1)
              )
            )
          )
        )
      )
    )
  )
  (func $ule_f32 (param $$0 f32) (param $$1 f32) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i32.or
            (f32.le
              (get_local $$1)
              (get_local $$0)
            )
            (i32.or
              (f32.ne
                (get_local $$0)
                (get_local $$0)
              )
              (f32.ne
                (get_local $$1)
                (get_local $$1)
              )
            )
          )
        )
      )
    )
  )
  (func $ugt_f32 (param $$0 f32) (param $$1 f32) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i32.or
            (f32.gt
              (get_local $$1)
              (get_local $$0)
            )
            (i32.or
              (f32.ne
                (get_local $$0)
                (get_local $$0)
              )
              (f32.ne
                (get_local $$1)
                (get_local $$1)
              )
            )
          )
        )
      )
    )
  )
  (func $uge_f32 (param $$0 f32) (param $$1 f32) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i32.or
            (f32.ge
              (get_local $$1)
              (get_local $$0)
            )
            (i32.or
              (f32.ne
                (get_local $$0)
                (get_local $$0)
              )
              (f32.ne
                (get_local $$1)
                (get_local $$1)
              )
            )
          )
        )
      )
    )
  )
)
