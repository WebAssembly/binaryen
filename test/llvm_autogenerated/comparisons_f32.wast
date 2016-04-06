(module
  (memory 1)
  (export "memory" memory)
  (export "ord_f32" $ord_f32)
  (export "uno_f32" $uno_f32)
  (export "oeq_f32" $oeq_f32)
  (export "une_f32" $une_f32)
  (export "olt_f32" $olt_f32)
  (export "ole_f32" $ole_f32)
  (export "ogt_f32" $ogt_f32)
  (export "oge_f32" $oge_f32)
  (export "ueq_f32" $ueq_f32)
  (export "one_f32" $one_f32)
  (export "ult_f32" $ult_f32)
  (export "ule_f32" $ule_f32)
  (export "ugt_f32" $ugt_f32)
  (export "uge_f32" $uge_f32)
  (func $ord_f32 (param $$0 f32) (param $$1 f32) (result i32)
    (return
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
  (func $uno_f32 (param $$0 f32) (param $$1 f32) (result i32)
    (return
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
  (func $oeq_f32 (param $$0 f32) (param $$1 f32) (result i32)
    (return
      (f32.eq
        (get_local $$0)
        (get_local $$1)
      )
    )
  )
  (func $une_f32 (param $$0 f32) (param $$1 f32) (result i32)
    (return
      (f32.ne
        (get_local $$0)
        (get_local $$1)
      )
    )
  )
  (func $olt_f32 (param $$0 f32) (param $$1 f32) (result i32)
    (return
      (f32.lt
        (get_local $$0)
        (get_local $$1)
      )
    )
  )
  (func $ole_f32 (param $$0 f32) (param $$1 f32) (result i32)
    (return
      (f32.le
        (get_local $$0)
        (get_local $$1)
      )
    )
  )
  (func $ogt_f32 (param $$0 f32) (param $$1 f32) (result i32)
    (return
      (f32.gt
        (get_local $$0)
        (get_local $$1)
      )
    )
  )
  (func $oge_f32 (param $$0 f32) (param $$1 f32) (result i32)
    (return
      (f32.ge
        (get_local $$0)
        (get_local $$1)
      )
    )
  )
  (func $ueq_f32 (param $$0 f32) (param $$1 f32) (result i32)
    (return
      (i32.or
        (f32.eq
          (get_local $$0)
          (get_local $$1)
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
  (func $one_f32 (param $$0 f32) (param $$1 f32) (result i32)
    (return
      (i32.and
        (f32.ne
          (get_local $$0)
          (get_local $$1)
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
  (func $ult_f32 (param $$0 f32) (param $$1 f32) (result i32)
    (return
      (i32.or
        (f32.lt
          (get_local $$0)
          (get_local $$1)
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
  (func $ule_f32 (param $$0 f32) (param $$1 f32) (result i32)
    (return
      (i32.or
        (f32.le
          (get_local $$0)
          (get_local $$1)
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
  (func $ugt_f32 (param $$0 f32) (param $$1 f32) (result i32)
    (return
      (i32.or
        (f32.gt
          (get_local $$0)
          (get_local $$1)
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
  (func $uge_f32 (param $$0 f32) (param $$1 f32) (result i32)
    (return
      (i32.or
        (f32.ge
          (get_local $$0)
          (get_local $$1)
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
;; METADATA: { "asmConsts": {},"staticBump": 4, "initializers": [] }
