(module
  (func $dummy)

  (func (export "sign") (param $0 i32) (result i32)
    (select
      (i32.const -1)
      (select
        (i32.const 1)
        (i32.const 0)
        (i32.gt_s
          (get_local $0)
          (i32.const 0)
        )
      )
      (i32.lt_s
        (get_local $0)
        (i32.const 0)
      )
    )
  )
)
