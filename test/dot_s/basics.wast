(module
  (memory 1
    (segment 16 "hello, world!\n\00")
    (segment 32 "vcq")
    (segment 48 "\16\00\00\00")
  )
  (export "memory" memory)
  (type $FUNCSIG$vi (func (param i32)))
  (type $FUNCSIG$iii (func (param i32 i32) (result i32)))
  (import $puts "env" "puts" (param i32))
  (export "main" $main)
  (export "dynCall_iii" $dynCall_iii)
  (table $main)
  (func $main (type $FUNCSIG$iii) (param $$0 i32) (param $$1 i32) (result i32)
    (call_import $puts
      (i32.const 16)
    )
    (block $label$0
      (block $label$1
        (br_if $label$1
          (i32.ne
            (i32.sub
              (get_local $$0)
              (i32.and
                (i32.add
                  (get_local $$0)
                  (i32.shr_u
                    (i32.shr_s
                      (get_local $$0)
                      (i32.const 31)
                    )
                    (i32.const 30)
                  )
                )
                (i32.const -4)
              )
            )
            (i32.const 1)
          )
        )
        (loop $label$3 $label$2
          (set_local $$0
            (i32.add
              (i32.gt_s
                (get_local $$0)
                (i32.const 10)
              )
              (get_local $$0)
            )
          )
          (block $label$4
            (br_if $label$4
              (i32.ne
                (i32.rem_s
                  (get_local $$0)
                  (i32.const 5)
                )
                (i32.const 3)
              )
            )
            (set_local $$0
              (i32.add
                (i32.rem_s
                  (get_local $$0)
                  (i32.const 111)
                )
                (get_local $$0)
              )
            )
          )
          (br_if $label$1
            (i32.eq
              (i32.rem_s
                (get_local $$0)
                (i32.const 7)
              )
              (i32.const 0)
            )
          )
          (br $label$2)
        )
      )
      (set_local $$0
        (i32.add
          (get_local $$0)
          (i32.const -12)
        )
      )
      (i32.const 0)
    )
    (return
      (get_local $$0)
    )
  )
  (func $dynCall_iii (param $fptr i32) (param $$0 i32) (param $$1 i32) (result i32)
    (return
      (call_indirect $FUNCSIG$iii
        (get_local $fptr)
        (get_local $$0)
        (get_local $$1)
      )
    )
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 52, "initializers": [] }
