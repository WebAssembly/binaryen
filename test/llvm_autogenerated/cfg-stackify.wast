(module
  (memory 0 4294967295)
  (type $FUNCSIG$v (func))
  (type $FUNCSIG$i (func (result i32)))
  (import $something "env" "something")
  (import $bar "env" "bar")
  (import $a "env" "a" (result i32))
  (export "test0" $test0)
  (export "test1" $test1)
  (export "test2" $test2)
  (export "doublediamond" $doublediamond)
  (export "triangle" $triangle)
  (export "diamond" $diamond)
  (export "single_block" $single_block)
  (export "minimal_loop" $minimal_loop)
  (export "simple_loop" $simple_loop)
  (export "doubletriangle" $doubletriangle)
  (export "ifelse_earlyexits" $ifelse_earlyexits)
  (export "doublediamond_in_a_loop" $doublediamond_in_a_loop)
  (export "test3" $test3)
  (export "test4" $test4)
  (export "test5" $test5)
  (export "test6" $test6)
  (export "test7" $test7)
  (export "test8" $test8)
  (export "test9" $test9)
  (export "test10" $test10)
  (export "test11" $test11)
  (export "test12" $test12)
  (export "test13" $test13)
  (func $test0 (param $$0 i32)
    (local $$1 i32)
    (block $fake_return_waka123
      (block
        (set_local $$1
          (i32.const 0)
        )
        (loop $.LBB0_3 $.LBB0_1
          (block
            (set_local $$1
              (i32.add
                (get_local $$1)
                (i32.const 1)
              )
            )
            (br_if
              (i32.ge_s
                (get_local $$1)
                (get_local $$0)
              )
              $.LBB0_3
            )
            (call_import $something)
            (br $.LBB0_1)
          )
        )
        (br $fake_return_waka123)
      )
    )
  )
  (func $test1 (param $$0 i32)
    (local $$1 i32)
    (block $fake_return_waka123
      (block
        (set_local $$1
          (i32.const 0)
        )
        (loop $.LBB1_3 $.LBB1_1
          (block
            (set_local $$1
              (i32.add
                (get_local $$1)
                (i32.const 1)
              )
            )
            (br_if
              (i32.ge_s
                (get_local $$1)
                (get_local $$0)
              )
              $.LBB1_3
            )
            (call_import $something)
            (br $.LBB1_1)
          )
        )
        (br $fake_return_waka123)
      )
    )
  )
  (func $test2 (param $$0 i32) (param $$1 i32)
    (block $fake_return_waka123
      (block
        (block $.LBB2_2
          (br_if
            (i32.lt_s
              (get_local $$1)
              (i32.const 1)
            )
            $.LBB2_2
          )
          (loop $.LBB2_1
            (block
              (set_local $$1
                (i32.add
                  (get_local $$1)
                  (i32.const -1)
                )
              )
              (f64.store align=8
                (get_local $$0)
                (f64.mul
                  (f64.load align=8
                    (get_local $$0)
                  )
                  (f64.const 3.2)
                )
              )
              (set_local $$0
                (i32.add
                  (get_local $$0)
                  (i32.const 8)
                )
              )
              (br_if
                (get_local $$1)
                $.LBB2_1
              )
            )
          )
        )
        (br $fake_return_waka123)
      )
    )
  )
  (func $doublediamond (param $$0 i32) (param $$1 i32) (param $$2 i32) (result i32)
    (local $$3 i32)
    (block $fake_return_waka123
      (block
        (block $.LBB3_5
          (block $.LBB3_2
            (set_local $$3
              (i32.store align=4
                (get_local $$2)
                (i32.const 0)
              )
            )
            (br_if
              (get_local $$0)
              $.LBB3_2
            )
            (i32.store align=4
              (get_local $$2)
              (i32.const 1)
            )
            (br $.LBB3_5)
          )
          (block $.LBB3_4
            (i32.store align=4
              (get_local $$2)
              (i32.const 2)
            )
            (br_if
              (get_local $$1)
              $.LBB3_4
            )
            (i32.store align=4
              (get_local $$2)
              (i32.const 3)
            )
            (br $.LBB3_5)
          )
          (i32.store align=4
            (get_local $$2)
            (i32.const 4)
          )
        )
        (i32.store align=4
          (get_local $$2)
          (i32.const 5)
        )
        (br $fake_return_waka123
          (get_local $$3)
        )
      )
    )
  )
  (func $triangle (param $$0 i32) (param $$1 i32) (result i32)
    (local $$2 i32)
    (block $fake_return_waka123
      (block
        (block $.LBB4_2
          (set_local $$2
            (i32.store align=4
              (get_local $$0)
              (i32.const 0)
            )
          )
          (br_if
            (get_local $$1)
            $.LBB4_2
          )
          (i32.store align=4
            (get_local $$0)
            (i32.const 1)
          )
        )
        (i32.store align=4
          (get_local $$0)
          (i32.const 2)
        )
        (br $fake_return_waka123
          (get_local $$2)
        )
      )
    )
  )
  (func $diamond (param $$0 i32) (param $$1 i32) (result i32)
    (local $$2 i32)
    (block $fake_return_waka123
      (block
        (block $.LBB5_3
          (block $.LBB5_2
            (set_local $$2
              (i32.store align=4
                (get_local $$0)
                (i32.const 0)
              )
            )
            (br_if
              (get_local $$1)
              $.LBB5_2
            )
            (i32.store align=4
              (get_local $$0)
              (i32.const 1)
            )
            (br $.LBB5_3)
          )
          (i32.store align=4
            (get_local $$0)
            (i32.const 2)
          )
        )
        (i32.store align=4
          (get_local $$0)
          (i32.const 3)
        )
        (br $fake_return_waka123
          (get_local $$2)
        )
      )
    )
  )
  (func $single_block (param $$0 i32) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i32.store align=4
            (get_local $$0)
            (i32.const 0)
          )
        )
      )
    )
  )
  (func $minimal_loop (param $$0 i32) (result i32)
    (i32.store align=4
      (get_local $$0)
      (i32.const 0)
    )
    (loop $.LBB7_2 $.LBB7_1
      (block
        (i32.store align=4
          (get_local $$0)
          (i32.const 1)
        )
        (br $.LBB7_1)
      )
    )
  )
  (func $simple_loop (param $$0 i32) (param $$1 i32) (result i32)
    (local $$2 i32)
    (block $fake_return_waka123
      (block
        (set_local $$2
          (i32.store align=4
            (get_local $$0)
            (i32.const 0)
          )
        )
        (loop $.LBB8_2 $.LBB8_1
          (block
            (i32.store align=4
              (get_local $$0)
              (i32.const 1)
            )
            (br_if
              (i32.eq
                (get_local $$1)
                (i32.const 0)
              )
              $.LBB8_1
            )
          )
        )
        (i32.store align=4
          (get_local $$0)
          (i32.const 2)
        )
        (br $fake_return_waka123
          (get_local $$2)
        )
      )
    )
  )
  (func $doubletriangle (param $$0 i32) (param $$1 i32) (param $$2 i32) (result i32)
    (local $$3 i32)
    (block $fake_return_waka123
      (block
        (block $.LBB9_4
          (set_local $$3
            (i32.store align=4
              (get_local $$2)
              (i32.const 0)
            )
          )
          (br_if
            (get_local $$0)
            $.LBB9_4
          )
          (block $.LBB9_3
            (i32.store align=4
              (get_local $$2)
              (i32.const 2)
            )
            (br_if
              (get_local $$1)
              $.LBB9_3
            )
            (i32.store align=4
              (get_local $$2)
              (i32.const 3)
            )
          )
          (i32.store align=4
            (get_local $$2)
            (i32.const 4)
          )
        )
        (i32.store align=4
          (get_local $$2)
          (i32.const 5)
        )
        (br $fake_return_waka123
          (get_local $$3)
        )
      )
    )
  )
  (func $ifelse_earlyexits (param $$0 i32) (param $$1 i32) (param $$2 i32) (result i32)
    (local $$3 i32)
    (block $fake_return_waka123
      (block
        (block $.LBB10_4
          (block $.LBB10_2
            (set_local $$3
              (i32.store align=4
                (get_local $$2)
                (i32.const 0)
              )
            )
            (br_if
              (get_local $$0)
              $.LBB10_2
            )
            (i32.store align=4
              (get_local $$2)
              (i32.const 1)
            )
            (br $.LBB10_4)
          )
          (i32.store align=4
            (get_local $$2)
            (i32.const 2)
          )
          (br_if
            (get_local $$1)
            $.LBB10_4
          )
          (i32.store align=4
            (get_local $$2)
            (i32.const 3)
          )
        )
        (i32.store align=4
          (get_local $$2)
          (i32.const 4)
        )
        (br $fake_return_waka123
          (get_local $$3)
        )
      )
    )
  )
  (func $doublediamond_in_a_loop (param $$0 i32) (param $$1 i32) (param $$2 i32) (result i32)
    (loop $.LBB11_7 $.LBB11_1
      (block
        (block $.LBB11_6
          (block $.LBB11_3
            (i32.store align=4
              (get_local $$2)
              (i32.const 0)
            )
            (br_if
              (get_local $$0)
              $.LBB11_3
            )
            (i32.store align=4
              (get_local $$2)
              (i32.const 1)
            )
            (br $.LBB11_6)
          )
          (block $.LBB11_5
            (i32.store align=4
              (get_local $$2)
              (i32.const 2)
            )
            (br_if
              (get_local $$1)
              $.LBB11_5
            )
            (i32.store align=4
              (get_local $$2)
              (i32.const 3)
            )
            (br $.LBB11_6)
          )
          (i32.store align=4
            (get_local $$2)
            (i32.const 4)
          )
        )
        (i32.store align=4
          (get_local $$2)
          (i32.const 5)
        )
        (br $.LBB11_1)
      )
    )
  )
  (func $test3 (param $$0 i32)
    (block $fake_return_waka123
      (block
        (block $.LBB12_5
          (br_if
            (i32.const 0)
            $.LBB12_5
          )
          (loop $.LBB12_4 $.LBB12_1
            (block
              (br_if
                (get_local $$0)
                $.LBB12_4
              )
              (loop $.LBB12_3 $.LBB12_2
                (block
                  (br_if
                    (i32.ne
                      (get_local $$0)
                      (get_local $$0)
                    )
                    $.LBB12_2
                  )
                )
              )
              (call_import $bar)
              (br $.LBB12_1)
            )
          )
          (unreachable)
        )
        (br $fake_return_waka123)
      )
    )
  )
  (func $test4 (param $$0 i32)
    (block $fake_return_waka123
      (block
        (block $.LBB13_8
          (block $.LBB13_7
            (block $.LBB13_4
              (br_if
                (i32.gt_s
                  (get_local $$0)
                  (i32.const 3)
                )
                $.LBB13_4
              )
              (block $.LBB13_3
                (br_if
                  (i32.eq
                    (get_local $$0)
                    (i32.const 0)
                  )
                  $.LBB13_3
                )
                (br_if
                  (i32.ne
                    (get_local $$0)
                    (i32.const 2)
                  )
                  $.LBB13_7
                )
              )
              (br $fake_return_waka123)
            )
            (br_if
              (i32.eq
                (get_local $$0)
                (i32.const 4)
              )
              $.LBB13_8
            )
            (br_if
              (i32.ne
                (get_local $$0)
                (i32.const 622)
              )
              $.LBB13_7
            )
            (br $fake_return_waka123)
          )
          (br $fake_return_waka123)
        )
        (br $fake_return_waka123)
      )
    )
  )
  (func $test5 (param $$0 i32) (param $$1 i32)
    (local $$2 i32)
    (local $$3 i32)
    (block $fake_return_waka123
      (block
        (block $.LBB14_4
          (loop $.LBB14_3 $.LBB14_1
            (block
              (set_local $$2
                (i32.const 0)
              )
              (set_local $$3
                (i32.store align=4
                  (get_local $$2)
                  (get_local $$2)
                )
              )
              (set_local $$2
                (i32.const 1)
              )
              (br_if
                (i32.eq
                  (i32.and
                    (get_local $$0)
                    (get_local $$2)
                  )
                  (i32.const 0)
                )
                $.LBB14_4
              )
              (br_if
                (i32.and
                  (get_local $$1)
                  (i32.store align=4
                    (get_local $$3)
                    (get_local $$2)
                  )
                )
                $.LBB14_1
              )
            )
          )
          (i32.store align=4
            (get_local $$3)
            (i32.const 3)
          )
          (br $fake_return_waka123)
        )
        (i32.store align=4
          (get_local $$3)
          (i32.const 2)
        )
        (br $fake_return_waka123)
      )
    )
  )
  (func $test6 (param $$0 i32) (param $$1 i32)
    (local $$2 i32)
    (local $$3 i32)
    (local $$4 i32)
    (block $fake_return_waka123
      (block
        (block $.LBB15_6
          (block $.LBB15_5
            (loop $.LBB15_4 $.LBB15_1
              (block
                (set_local $$2
                  (i32.const 0)
                )
                (i32.store align=4
                  (get_local $$2)
                  (get_local $$2)
                )
                (set_local $$3
                  (i32.const 1)
                )
                (br_if
                  (i32.eq
                    (i32.and
                      (get_local $$0)
                      (get_local $$3)
                    )
                    (i32.const 0)
                  )
                  $.LBB15_6
                )
                (i32.store align=4
                  (get_local $$2)
                  (get_local $$3)
                )
                (set_local $$4
                  (i32.and
                    (get_local $$1)
                    (get_local $$3)
                  )
                )
                (br_if
                  (i32.eq
                    (get_local $$4)
                    (i32.const 0)
                  )
                  $.LBB15_5
                )
                (i32.store align=4
                  (get_local $$2)
                  (get_local $$3)
                )
                (br_if
                  (get_local $$4)
                  $.LBB15_1
                )
              )
            )
            (i32.store align=4
              (get_local $$2)
              (i32.const 2)
            )
            (br $fake_return_waka123)
          )
          (i32.store align=4
            (get_local $$2)
            (i32.const 3)
          )
        )
        (i32.store align=4
          (get_local $$2)
          (i32.const 4)
        )
        (br $fake_return_waka123)
      )
    )
  )
  (func $test7 (param $$0 i32) (param $$1 i32)
    (local $$2 i32)
    (local $$3 i32)
    (set_local $$3
      (i32.const 0)
    )
    (set_local $$2
      (i32.store align=4
        (get_local $$3)
        (get_local $$3)
      )
    )
    (loop $.LBB16_5 $.LBB16_1
      (block
        (block $.LBB16_4
          (set_local $$3
            (i32.store align=4
              (get_local $$2)
              (i32.const 1)
            )
          )
          (br_if
            (i32.and
              (get_local $$0)
              (get_local $$3)
            )
            $.LBB16_4
          )
          (i32.store align=4
            (get_local $$2)
            (i32.const 2)
          )
          (br_if
            (i32.and
              (get_local $$1)
              (get_local $$3)
            )
            $.LBB16_1
          )
          (i32.store align=4
            (get_local $$2)
            (i32.const 4)
          )
          (unreachable)
        )
        (i32.store align=4
          (get_local $$2)
          (i32.const 3)
        )
        (br_if
          (i32.and
            (get_local $$1)
            (get_local $$3)
          )
          $.LBB16_1
        )
      )
    )
    (i32.store align=4
      (get_local $$2)
      (i32.const 5)
    )
    (unreachable)
  )
  (func $test8 (result i32)
    (local $$0 i32)
    (set_local $$0
      (i32.const 0)
    )
    (loop $.LBB17_4 $.LBB17_1
      (block
        (block $.LBB17_3
          (br_if
            (i32.eq
              (get_local $$0)
              (i32.const 0)
            )
            $.LBB17_3
          )
          (br_if
            (i32.eq
              (get_local $$0)
              (i32.const 0)
            )
            $.LBB17_1
          )
        )
        (loop $.LBB17_4 $.LBB17_3
          (block
            (br_if
              (get_local $$0)
              $.LBB17_3
            )
            (br $.LBB17_1)
          )
        )
      )
    )
  )
  (func $test9
    (local $$0 i32)
    (local $$1 i32)
    (block $fake_return_waka123
      (block
        (set_local $$1
          (i32.const 0)
        )
        (set_local $$0
          (i32.store align=4
            (get_local $$1)
            (get_local $$1)
          )
        )
        (loop $.LBB18_5 $.LBB18_1
          (block
            (set_local $$1
              (i32.store align=4
                (get_local $$0)
                (i32.const 1)
              )
            )
            (br_if
              (i32.eq
                (i32.and
                  (call_import $a)
                  (get_local $$1)
                )
                (i32.const 0)
              )
              $.LBB18_5
            )
            (loop $.LBB18_5 $.LBB18_2
              (block
                (block $.LBB18_4
                  (i32.store align=4
                    (get_local $$0)
                    (i32.const 2)
                  )
                  (br_if
                    (i32.eq
                      (i32.and
                        (call_import $a)
                        (get_local $$1)
                      )
                      (i32.const 0)
                    )
                    $.LBB18_4
                  )
                  (i32.store align=4
                    (get_local $$0)
                    (i32.const 3)
                  )
                  (br_if
                    (i32.and
                      (call_import $a)
                      (get_local $$1)
                    )
                    $.LBB18_2
                  )
                  (br $.LBB18_1)
                )
                (i32.store align=4
                  (get_local $$0)
                  (i32.const 4)
                )
                (br_if
                  (i32.and
                    (call_import $a)
                    (get_local $$1)
                  )
                  $.LBB18_2
                )
                (br $.LBB18_1)
              )
            )
          )
        )
        (i32.store align=4
          (get_local $$0)
          (i32.const 5)
        )
        (br $fake_return_waka123)
      )
    )
  )
  (func $test10
    (local $$0 i32)
    (local $$1 i32)
    (local $$2 i32)
    (local $$3 i32)
    (local $$4 i32)
    (block $fake_return_waka123
      (block
        (set_local $$0
          (i32.const 2)
        )
        (loop $.LBB19_7 $.LBB19_1
          (block
            (set_local $$4
              (get_local $$1)
            )
            (set_local $$3
              (get_local $$0)
            )
            (set_local $$1
              (i32.const 0)
            )
            (set_local $$0
              (i32.const 3)
            )
            (set_local $$2
              (i32.const 4)
            )
            (br_if
              (get_local $$4)
              $.LBB19_1
            )
            (block $.LBB19_6
              (loop $.LBB19_5 $.LBB19_2
                (block
                  (set_local $$4
                    (get_local $$3)
                  )
                  (set_local $$3
                    (get_local $$2)
                  )
                  (loop $.LBB19_5 $.LBB19_3
                    (block
                      (set_local $$2
                        (get_local $$4)
                      )
                      (br_if
                        (i32.gt_u
                          (get_local $$2)
                          (i32.const 4)
                        )
                        $.LBB19_1
                      )
                      (set_local $$4
                        (get_local $$3)
                      )
                      (tableswitch 
                        (get_local $$2)
                        (table (br $.LBB19_3) (br $.LBB19_5) (br $.LBB19_1) (br $.LBB19_2) (br $.LBB19_6)) (br $.LBB19_3)
                      )
                    )
                  )
                )
              )
              (br $fake_return_waka123)
            )
            (set_local $$1
              (i32.const 1)
            )
            (br $.LBB19_1)
          )
        )
      )
    )
  )
  (func $test11
    (local $$0 i32)
    (block $fake_return_waka123
      (block
        (set_local $$0
          (i32.const 0)
        )
        (i32.store align=4
          (get_local $$0)
          (get_local $$0)
        )
        (block $.LBB20_8
          (block $.LBB20_7
            (block $.LBB20_6
              (block $.LBB20_4
                (br_if
                  (get_local $$0)
                  $.LBB20_4
                )
                (block $.LBB20_3
                  (i32.store align=4
                    (get_local $$0)
                    (i32.const 1)
                  )
                  (br_if
                    (get_local $$0)
                    $.LBB20_3
                  )
                  (i32.store align=4
                    (get_local $$0)
                    (i32.const 2)
                  )
                  (br_if
                    (get_local $$0)
                    $.LBB20_6
                  )
                )
                (i32.store align=4
                  (get_local $$0)
                  (i32.const 3)
                )
                (br $fake_return_waka123)
              )
              (i32.store align=4
                (get_local $$0)
                (i32.const 4)
              )
              (br_if
                (get_local $$0)
                $.LBB20_8
              )
              (i32.store align=4
                (get_local $$0)
                (i32.const 5)
              )
              (br_if
                (i32.eq
                  (get_local $$0)
                  (i32.const 0)
                )
                $.LBB20_7
              )
            )
            (i32.store align=4
              (get_local $$0)
              (i32.const 7)
            )
            (br $fake_return_waka123)
          )
          (i32.store align=4
            (get_local $$0)
            (i32.const 6)
          )
          (br $fake_return_waka123)
        )
        (i32.store align=4
          (get_local $$0)
          (i32.const 8)
        )
        (br $fake_return_waka123)
      )
    )
  )
  (func $test12 (param $$0 i32)
    (local $$1 i32)
    (block $fake_return_waka123
      (block
        (loop $.LBB21_8 $.LBB21_1
          (block
            (set_local $$1
              (i32.load8_u align=1
                (get_local $$0)
              )
            )
            (block $.LBB21_7
              (block $.LBB21_6
                (block $.LBB21_4
                  (br_if
                    (i32.gt_s
                      (get_local $$1)
                      (i32.const 103)
                    )
                    $.LBB21_4
                  )
                  (br_if
                    (i32.eq
                      (get_local $$1)
                      (i32.const 42)
                    )
                    $.LBB21_7
                  )
                  (br_if
                    (i32.eq
                      (get_local $$1)
                      (i32.const 76)
                    )
                    $.LBB21_7
                  )
                  (br $.LBB21_6)
                )
                (br_if
                  (i32.eq
                    (get_local $$1)
                    (i32.const 108)
                  )
                  $.LBB21_7
                )
                (br_if
                  (i32.eq
                    (get_local $$1)
                    (i32.const 104)
                  )
                  $.LBB21_7
                )
              )
              (br $fake_return_waka123)
            )
            (set_local $$0
              (i32.add
                (get_local $$0)
                (i32.const 1)
              )
            )
            (br $.LBB21_1)
          )
        )
      )
    )
  )
  (func $test13
    (local $$0 i32)
    (block $fake_return_waka123
      (block
        (block $.LBB22_2
          (br_if
            (i32.eq
              (i32.const 0)
              (i32.const 0)
            )
            $.LBB22_2
          )
          (br $fake_return_waka123)
        )
        (set_local $$0
          (i32.const 0)
        )
        (block $.LBB22_4
          (br_if
            (get_local $$0)
            $.LBB22_4
          )
          (set_local $$0
            (i32.const 0)
          )
        )
        (block $.LBB22_5
          (br_if
            (i32.eq
              (i32.and
                (get_local $$0)
                (i32.const 1)
              )
              (i32.const 0)
            )
            $.LBB22_5
          )
        )
        (unreachable)
      )
    )
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 0 }
