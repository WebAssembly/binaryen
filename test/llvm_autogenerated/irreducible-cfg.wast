(module
  (memory 1
    (segment 4 "\10\04\00\00")
  )
  (export "memory" memory)
  (export "test0" $test0)
  (export "test1" $test1)
  (func $test0 (param $0 i32) (param $1 i32) (param $2 i32) (param $3 i32)
    (local $4 f64)
    (local $5 i32)
    (local $6 i32)
    (set_local $5
      (i32.const 0)
    )
    (block $label$0
      (block $label$1
        (br_if $label$1
          (i32.eqz
            (get_local $2)
          )
        )
        (set_local $4
          (f64.load align=4
            (i32.add
              (get_local $0)
              (i32.shl
                (get_local $3)
                (i32.const 3)
              )
            )
          )
        )
        (set_local $6
          (i32.const 0)
        )
        (br $label$0)
      )
      (set_local $6
        (i32.const 1)
      )
    )
    (loop $label$3 $label$2
      (block $label$4
        (block $label$5
          (block $label$6
            (block $label$7
              (block $label$8
                (block $label$9
                  (br_table $label$7 $label$9 $label$6 $label$8 $label$8
                    (get_local $6)
                  )
                )
                (br_if $label$4
                  (i32.ge_s
                    (get_local $5)
                    (get_local $1)
                  )
                )
                (set_local $6
                  (i32.const 3)
                )
                (br $label$2)
              )
              (f64.store align=4
                (set_local $2
                  (i32.add
                    (get_local $0)
                    (i32.shl
                      (get_local $5)
                      (i32.const 3)
                    )
                  )
                )
                (set_local $4
                  (f64.mul
                    (f64.load align=4
                      (get_local $2)
                    )
                    (f64.const 2.3)
                  )
                )
              )
              (set_local $6
                (i32.const 0)
              )
              (br $label$2)
            )
            (f64.store align=4
              (i32.add
                (get_local $0)
                (i32.shl
                  (get_local $5)
                  (i32.const 3)
                )
              )
              (f64.add
                (get_local $4)
                (f64.const 1.3)
              )
            )
            (set_local $5
              (i32.add
                (get_local $5)
                (i32.const 1)
              )
            )
            (br $label$5)
          )
          (return)
        )
        (set_local $6
          (i32.const 1)
        )
        (br $label$2)
      )
      (set_local $6
        (i32.const 2)
      )
      (br $label$2)
    )
  )
  (func $test1 (param $0 i32) (param $1 i32) (param $2 i32) (param $3 i32)
    (local $4 f64)
    (local $5 i32)
    (local $6 i32)
    (set_local $5
      (i32.const 0)
    )
    (block $label$0
      (block $label$1
        (br_if $label$1
          (i32.eqz
            (get_local $2)
          )
        )
        (set_local $4
          (f64.load align=4
            (i32.add
              (get_local $0)
              (i32.shl
                (get_local $3)
                (i32.const 3)
              )
            )
          )
        )
        (set_local $6
          (i32.const 0)
        )
        (br $label$0)
      )
      (set_local $6
        (i32.const 1)
      )
    )
    (loop $label$3 $label$2
      (block $label$4
        (block $label$5
          (block $label$6
            (block $label$7
              (block $label$8
                (block $label$9
                  (block $label$10
                    (block $label$11
                      (br_table $label$8 $label$11 $label$7 $label$10 $label$9 $label$9
                        (get_local $6)
                      )
                    )
                    (br_if $label$4
                      (i32.ge_s
                        (get_local $5)
                        (get_local $1)
                      )
                    )
                    (set_local $6
                      (i32.const 3)
                    )
                    (br $label$2)
                  )
                  (f64.store align=4
                    (set_local $2
                      (i32.add
                        (get_local $0)
                        (i32.shl
                          (get_local $5)
                          (i32.const 3)
                        )
                      )
                    )
                    (set_local $4
                      (f64.mul
                        (f64.load align=4
                          (get_local $2)
                        )
                        (f64.const 2.3)
                      )
                    )
                  )
                  (set_local $2
                    (i32.const 0)
                  )
                  (set_local $6
                    (i32.const 4)
                  )
                  (br $label$2)
                )
                (br_if $label$5
                  (i32.lt_s
                    (set_local $2
                      (i32.add
                        (get_local $2)
                        (i32.const 1)
                      )
                    )
                    (i32.const 256)
                  )
                )
                (set_local $6
                  (i32.const 0)
                )
                (br $label$2)
              )
              (f64.store align=4
                (i32.add
                  (get_local $0)
                  (i32.shl
                    (get_local $5)
                    (i32.const 3)
                  )
                )
                (f64.add
                  (get_local $4)
                  (f64.const 1.3)
                )
              )
              (set_local $5
                (i32.add
                  (get_local $5)
                  (i32.const 1)
                )
              )
              (br $label$6)
            )
            (return)
          )
          (set_local $6
            (i32.const 1)
          )
          (br $label$2)
        )
        (set_local $6
          (i32.const 4)
        )
        (br $label$2)
      )
      (set_local $6
        (i32.const 2)
      )
      (br $label$2)
    )
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 1040, "initializers": [] }
