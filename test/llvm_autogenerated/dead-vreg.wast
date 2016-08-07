(module
  (memory 1)
  (data (i32.const 4) "\10\04\00\00")
  (export "memory" memory)
  (type $0 (func (param i32 i32 i32)))
  (export "foo" $foo)
  (func $foo (type $0) (param $0 i32) (param $1 i32) (param $2 i32)
    (local $3 i32)
    (local $4 i32)
    (local $5 i32)
    (local $6 i32)
    (local $7 i32)
    (local $8 i32)
    (local $9 i32)
    (block $label$0
      (br_if $label$0
        (i32.lt_s
          (get_local $2)
          (i32.const 1)
        )
      )
      (set_local $3
        (i32.shl
          (get_local $1)
          (i32.const 2)
        )
      )
      (set_local $5
        (i32.const 0)
      )
      (set_local $4
        (i32.lt_s
          (get_local $1)
          (i32.const 1)
        )
      )
      (loop $label$2 $label$1
        (block $label$3
          (br_if $label$3
            (get_local $4)
          )
          (set_local $6
            (i32.const 0)
          )
          (set_local $7
            (get_local $0)
          )
          (set_local $8
            (get_local $1)
          )
          (loop $label$5 $label$4
            (set_local $6
              (i32.add
                (block
                  (block
                    (set_local $9
                      (get_local $6)
                    )
                    (i32.store
                      (get_local $7)
                      (get_local $9)
                    )
                  )
                  (get_local $9)
                )
                (get_local $5)
              )
            )
            (set_local $7
              (i32.add
                (get_local $7)
                (i32.const 4)
              )
            )
            (br_if $label$4
              (tee_local $8
                (i32.add
                  (get_local $8)
                  (i32.const -1)
                )
              )
            )
          )
        )
        (set_local $0
          (i32.add
            (get_local $0)
            (get_local $3)
          )
        )
        (br_if $label$1
          (i32.ne
            (tee_local $5
              (i32.add
                (get_local $5)
                (i32.const 1)
              )
            )
            (get_local $2)
          )
        )
      )
    )
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 1040, "initializers": [] }
