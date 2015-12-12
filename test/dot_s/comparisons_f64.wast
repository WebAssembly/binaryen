(module
  (memory 0 4294967295)
  (func $ord_f64 (param $$0 f64) (param $$1 f64) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i32.and
            (f64.eq
              (get_local $$0)
              (get_local $$0)
            )
            (f64.eq
              (get_local $$1)
              (get_local $$1)
            )
          )
        )
      )
    )
  )
  (func $uno_f64 (param $$0 f64) (param $$1 f64) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i32.or
            (f64.ne
              (get_local $$0)
              (get_local $$0)
            )
            (f64.ne
              (get_local $$1)
              (get_local $$1)
            )
          )
        )
      )
    )
  )
  (func $oeq_f64 (param $$0 f64) (param $$1 f64) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (f64.eq
            (get_local $$1)
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $une_f64 (param $$0 f64) (param $$1 f64) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (f64.ne
            (get_local $$1)
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $olt_f64 (param $$0 f64) (param $$1 f64) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (f64.lt
            (get_local $$1)
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $ole_f64 (param $$0 f64) (param $$1 f64) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (f64.le
            (get_local $$1)
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $ogt_f64 (param $$0 f64) (param $$1 f64) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (f64.gt
            (get_local $$1)
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $oge_f64 (param $$0 f64) (param $$1 f64) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (f64.ge
            (get_local $$1)
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $ueq_f64 (param $$0 f64) (param $$1 f64) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i32.or
            (f64.eq
              (get_local $$1)
              (get_local $$0)
            )
            (i32.or
              (f64.ne
                (get_local $$0)
                (get_local $$0)
              )
              (f64.ne
                (get_local $$1)
                (get_local $$1)
              )
            )
          )
        )
      )
    )
  )
  (func $one_f64 (param $$0 f64) (param $$1 f64) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i32.and
            (f64.ne
              (get_local $$1)
              (get_local $$0)
            )
            (i32.and
              (f64.eq
                (get_local $$0)
                (get_local $$0)
              )
              (f64.eq
                (get_local $$1)
                (get_local $$1)
              )
            )
          )
        )
      )
    )
  )
  (func $ult_f64 (param $$0 f64) (param $$1 f64) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i32.or
            (f64.lt
              (get_local $$1)
              (get_local $$0)
            )
            (i32.or
              (f64.ne
                (get_local $$0)
                (get_local $$0)
              )
              (f64.ne
                (get_local $$1)
                (get_local $$1)
              )
            )
          )
        )
      )
    )
  )
  (func $ule_f64 (param $$0 f64) (param $$1 f64) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i32.or
            (f64.le
              (get_local $$1)
              (get_local $$0)
            )
            (i32.or
              (f64.ne
                (get_local $$0)
                (get_local $$0)
              )
              (f64.ne
                (get_local $$1)
                (get_local $$1)
              )
            )
          )
        )
      )
    )
  )
  (func $ugt_f64 (param $$0 f64) (param $$1 f64) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i32.or
            (f64.gt
              (get_local $$1)
              (get_local $$0)
            )
            (i32.or
              (f64.ne
                (get_local $$0)
                (get_local $$0)
              )
              (f64.ne
                (get_local $$1)
                (get_local $$1)
              )
            )
          )
        )
      )
    )
  )
  (func $uge_f64 (param $$0 f64) (param $$1 f64) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i32.or
            (f64.ge
              (get_local $$1)
              (get_local $$0)
            )
            (i32.or
              (f64.ne
                (get_local $$0)
                (get_local $$0)
              )
              (f64.ne
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
