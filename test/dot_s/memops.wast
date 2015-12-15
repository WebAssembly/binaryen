(module
  (memory 0 4294967295 (segment 16 "{ Module.print(\"hello, world! \" + HEAP32[8>>2]); }\00"))
  (import $_emscripten_asm_const_vi "env" "_emscripten_asm_const_vi")
  (export "_Z6reporti" $_Z6reporti)
  (export "main" $main)
  (func $_Z6reporti (param $$0 i32)
    (block $fake_return_waka123
      (block
        (i32.store align=4
          (i32.const 8)
          (get_local $$0)
        )
        (call_import $_emscripten_asm_const_vi
          (i32.const 0)
        )
        (br $fake_return_waka123)
      )
    )
  )
  (func $main (result i32)
    (local $$0 i32)
    (local $$1 i32)
    (local $$2 i32)
    (local $$3 i32)
    (local $$4 i32)
    (local $$5 i32)
    (local $$6 i32)
    (local $$7 i32)
    (local $$8 i32)
    (local $$9 i32)
    (local $$10 i32)
    (local $$11 i32)
    (local $$12 i32)
    (block $fake_return_waka123
      (block
        (set_local $$7
          (i32.const 0)
        )
        (set_local $$7
          (i32.load align=4
            (get_local $$7)
          )
        )
        (set_local $$8
          (i32.const 1048576)
        )
        (set_local $$12
          (i32.sub
            (get_local $$7)
            (get_local $$8)
          )
        )
        (set_local $$8
          (i32.const 0)
        )
        (set_local $$12
          (i32.store align=4
            (get_local $$8)
            (get_local $$12)
          )
        )
        (set_local $$1
          (i32.const 0)
        )
        (set_local $$0
          (get_local $$1)
        )
        (set_local $$6
          (get_local $$1)
        )
        (loop $BB1_5 $BB1_1
          (block
            (set_local $$4
              (get_local $$1)
            )
            (loop $BB1_3 $BB1_2
              (block
                (set_local $$10
                  (i32.const 0)
                )
                (set_local $$10
                  (i32.add
                    (get_local $$12)
                    (get_local $$10)
                  )
                )
                (i32.store align=8
                  (i32.add
                    (get_local $$10)
                    (get_local $$4)
                  )
                  (i32.add
                    (get_local $$6)
                    (get_local $$4)
                  )
                )
                (set_local $$2
                  (i32.const 1)
                )
                (set_local $$4
                  (i32.add
                    (get_local $$4)
                    (get_local $$2)
                  )
                )
                (set_local $$3
                  (i32.const 1048576)
                )
                (set_local $$5
                  (get_local $$1)
                )
                (br_if
                  (i32.ne
                    (get_local $$4)
                    (get_local $$3)
                  )
                  $BB1_2
                )
              )
            )
            (loop $BB1_4 $BB1_3
              (block
                (set_local $$11
                  (i32.const 0)
                )
                (set_local $$11
                  (i32.add
                    (get_local $$12)
                    (get_local $$11)
                  )
                )
                (set_local $$6
                  (i32.add
                    (i32.and
                      (i32.load align=8
                        (i32.add
                          (get_local $$11)
                          (get_local $$5)
                        )
                      )
                      (get_local $$2)
                    )
                    (get_local $$6)
                  )
                )
                (set_local $$5
                  (i32.add
                    (get_local $$5)
                    (get_local $$2)
                  )
                )
                (br_if
                  (i32.ne
                    (get_local $$5)
                    (get_local $$3)
                  )
                  $BB1_3
                )
              )
            )
            (set_local $$6
              (i32.and
                (i32.add
                  (i32.add
                    (i32.mul
                      (get_local $$6)
                      (i32.const 3)
                    )
                    (i32.div_s
                      (get_local $$6)
                      (i32.const 5)
                    )
                  )
                  (i32.const 17)
                )
                (i32.const 65535)
              )
            )
            (set_local $$0
              (i32.add
                (get_local $$0)
                (get_local $$2)
              )
            )
            (br_if
              (i32.ne
                (get_local $$0)
                (i32.const 100)
              )
              $BB1_1
            )
          )
        )
        (call $_Z6reporti
          (get_local $$6)
        )
        (set_local $$9
          (i32.const 1048576)
        )
        (set_local $$12
          (i32.add
            (get_local $$12)
            (get_local $$9)
          )
        )
        (set_local $$9
          (i32.const 0)
        )
        (set_local $$12
          (i32.store align=4
            (get_local $$9)
            (get_local $$12)
          )
        )
        (br $fake_return_waka123
          (i32.const 0)
        )
      )
    )
  )
)
; METADATA: { "asmConsts": {"0": ["{ Module.print(\"hello, world! \" + HEAP32[8>>2]); }", ["vi"]]} }