(module
  (memory 0 4294967295)
  (import $something "env" "something")
  (import $bar "env" "bar")
  (import $a "env" "a")
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
        (loop $BB0_3 $BB0_1
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
              $BB0_3
            )
            (call_import $something)
            (br $BB0_1)
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
        (loop $BB1_3 $BB1_1
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
              $BB1_3
            )
            (call_import $something)
            (br $BB1_1)
          )
        )
        (br $fake_return_waka123)
      )
    )
  )
  (func $test2 (param $$0 i32) (param $$1 i32)
    (block $fake_return_waka123
      (block
        (block $BB2_2
          (br_if
            (i32.lt_s
              (get_local $$1)
              (i32.const 1)
            )
            $BB2_2
          )
          (loop $BB2_1
            (block
              (f64.store align=8
                (get_local $$0)
                (f64.mul
                  (f64.load align=8
                    (get_local $$0)
                  )
                  (f64.const 3.2)
                )
              )
              (set_local $$1
                (i32.add
                  (get_local $$1)
                  (i32.const -1)
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
                $BB2_1
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
        (set_local $$3
          (i32.store align=4
            (get_local $$2)
            (i32.const 0)
          )
        )
        (block $BB3_5
          (block $BB3_4
            (br_if
              (i32.eq
                (get_local $$0)
                (i32.const 0)
              )
              $BB3_4
            )
            (i32.store align=4
              (get_local $$2)
              (i32.const 2)
            )
            (block $BB3_3
              (br_if
                (i32.eq
                  (get_local $$1)
                  (i32.const 0)
                )
                $BB3_3
              )
              (i32.store align=4
                (get_local $$2)
                (i32.const 4)
              )
              (br $BB3_5)
            )
            (i32.store align=4
              (get_local $$2)
              (i32.const 3)
            )
            (br $BB3_5)
          )
          (i32.store align=4
            (get_local $$2)
            (i32.const 1)
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
        (set_local $$2
          (i32.store align=4
            (get_local $$0)
            (i32.const 0)
          )
        )
        (block $BB4_2
          (br_if
            (get_local $$1)
            $BB4_2
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
        (set_local $$2
          (i32.store align=4
            (get_local $$0)
            (i32.const 0)
          )
        )
        (block $BB5_3
          (block $BB5_2
            (br_if
              (i32.eq
                (get_local $$1)
                (i32.const 0)
              )
              $BB5_2
            )
            (i32.store align=4
              (get_local $$0)
              (i32.const 2)
            )
            (br $BB5_3)
          )
          (i32.store align=4
            (get_local $$0)
            (i32.const 1)
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
    (block
      (i32.store align=4
        (get_local $$0)
        (i32.const 0)
      )
      (loop $BB7_2 $BB7_1
        (block
          (i32.store align=4
            (get_local $$0)
            (i32.const 1)
          )
          (br $BB7_1)
        )
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
        (loop $BB8_2 $BB8_1
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
              $BB8_1
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
        (set_local $$3
          (i32.store align=4
            (get_local $$2)
            (i32.const 0)
          )
        )
        (block $BB9_4
          (br_if
            (get_local $$0)
            $BB9_4
          )
          (i32.store align=4
            (get_local $$2)
            (i32.const 2)
          )
          (block $BB9_3
            (br_if
              (get_local $$1)
              $BB9_3
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
        (set_local $$3
          (i32.store align=4
            (get_local $$2)
            (i32.const 0)
          )
        )
        (block $BB10_4
          (block $BB10_3
            (br_if
              (i32.eq
                (get_local $$0)
                (i32.const 0)
              )
              $BB10_3
            )
            (i32.store align=4
              (get_local $$2)
              (i32.const 2)
            )
            (br_if
              (get_local $$1)
              $BB10_4
            )
            (i32.store align=4
              (get_local $$2)
              (i32.const 3)
            )
            (br $BB10_4)
          )
          (i32.store align=4
            (get_local $$2)
            (i32.const 1)
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
    (block
      (loop $BB11_7 $BB11_1
        (block
          (i32.store align=4
            (get_local $$2)
            (i32.const 0)
          )
          (block $BB11_6
            (block $BB11_5
              (br_if
                (i32.eq
                  (get_local $$0)
                  (i32.const 0)
                )
                $BB11_5
              )
              (i32.store align=4
                (get_local $$2)
                (i32.const 2)
              )
              (block $BB11_4
                (br_if
                  (i32.eq
                    (get_local $$1)
                    (i32.const 0)
                  )
                  $BB11_4
                )
                (i32.store align=4
                  (get_local $$2)
                  (i32.const 4)
                )
                (br $BB11_6)
              )
              (i32.store align=4
                (get_local $$2)
                (i32.const 3)
              )
              (br $BB11_6)
            )
            (i32.store align=4
              (get_local $$2)
              (i32.const 1)
            )
          )
          (i32.store align=4
            (get_local $$2)
            (i32.const 5)
          )
          (br $BB11_1)
        )
      )
    )
  )
  (func $test3 (param $$0 i32)
    (block $fake_return_waka123
      (block
        (block $BB12_2
          (br_if
            (i32.eq
              (i32.const 0)
              (i32.const 0)
            )
            $BB12_2
          )
          (br $fake_return_waka123)
        )
        (loop $BB12_5 $BB12_2
          (block
            (br_if
              (get_local $$0)
              $BB12_5
            )
            (loop $BB12_4 $BB12_3
              (block
                (br_if
                  (i32.ne
                    (get_local $$0)
                    (get_local $$0)
                  )
                  $BB12_3
                )
              )
            )
            (call_import $bar)
            (br $BB12_2)
          )
        )
        (unreachable)
      )
    )
  )
  (func $test4 (param $$0 i32)
    (block $fake_return_waka123
      (block
        (block $BB13_8
          (block $BB13_7
            (block $BB13_4
              (br_if
                (i32.gt_s
                  (get_local $$0)
                  (i32.const 3)
                )
                $BB13_4
              )
              (block $BB13_3
                (br_if
                  (i32.eq
                    (get_local $$0)
                    (i32.const 0)
                  )
                  $BB13_3
                )
                (br_if
                  (i32.ne
                    (get_local $$0)
                    (i32.const 2)
                  )
                  $BB13_7
                )
              )
              (br $fake_return_waka123)
            )
            (br_if
              (i32.eq
                (get_local $$0)
                (i32.const 4)
              )
              $BB13_8
            )
            (br_if
              (i32.ne
                (get_local $$0)
                (i32.const 622)
              )
              $BB13_7
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
        (block $BB14_4
          (loop $BB14_3 $BB14_1
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
                $BB14_4
              )
              (br_if
                (i32.and
                  (get_local $$1)
                  (i32.store align=4
                    (get_local $$3)
                    (get_local $$2)
                  )
                )
                $BB14_1
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
        (block $BB15_6
          (block $BB15_5
            (loop $BB15_4 $BB15_1
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
                  $BB15_6
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
                  $BB15_5
                )
                (i32.store align=4
                  (get_local $$2)
                  (get_local $$3)
                )
                (br_if
                  (get_local $$4)
                  $BB15_1
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
    (block
      (set_local $$3
        (i32.const 0)
      )
      (set_local $$2
        (i32.store align=4
          (get_local $$3)
          (get_local $$3)
        )
      )
      (loop $BB16_5 $BB16_1
        (block
          (set_local $$3
            (i32.store align=4
              (get_local $$2)
              (i32.const 1)
            )
          )
          (block $BB16_4
            (br_if
              (i32.eq
                (i32.and
                  (get_local $$0)
                  (get_local $$3)
                )
                (i32.const 0)
              )
              $BB16_4
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
              $BB16_1
            )
            (i32.store align=4
              (get_local $$2)
              (i32.const 5)
            )
            (unreachable)
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
            $BB16_1
          )
        )
      )
      (i32.store align=4
        (get_local $$2)
        (i32.const 4)
      )
      (unreachable)
    )
  )
  (func $test8 (result i32)
    (local $$0 i32)
    (block
      (set_local $$0
        (i32.const 0)
      )
      (loop $BB17_4 $BB17_1
        (block
          (block $BB17_3
            (br_if
              (i32.eq
                (get_local $$0)
                (i32.const 0)
              )
              $BB17_3
            )
            (br_if
              (i32.eq
                (get_local $$0)
                (i32.const 0)
              )
              $BB17_1
            )
          )
          (loop $BB17_4 $BB17_3
            (block
              (br_if
                (get_local $$0)
                $BB17_3
              )
              (br $BB17_1)
            )
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
        (loop $BB18_5 $BB18_1
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
              $BB18_5
            )
            (loop $BB18_5 $BB18_2
              (block
                (i32.store align=4
                  (get_local $$0)
                  (i32.const 2)
                )
                (block $BB18_4
                  (br_if
                    (i32.eq
                      (i32.and
                        (call_import $a)
                        (get_local $$1)
                      )
                      (i32.const 0)
                    )
                    $BB18_4
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
                    $BB18_2
                  )
                  (br $BB18_1)
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
                  $BB18_2
                )
                (br $BB18_1)
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
        (loop $BB19_7 $BB19_1
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
              $BB19_1
            )
            (block $BB19_6
              (loop $BB19_5 $BB19_2
                (block
                  (set_local $$4
                    (get_local $$3)
                  )
                  (set_local $$3
                    (get_local $$2)
                  )
                  (loop $BB19_5 $BB19_3
                    (block
                      (set_local $$2
                        (get_local $$4)
                      )
                      (br_if
                        (i32.gt_u
                          (get_local $$2)
                          (i32.const 4)
                        )
                        $BB19_1
                      )
                      (set_local $$4
                        (get_local $$3)
                      )
                      (tableswitch 
                        (get_local $$2)
                        (table (case $BB19_3) (case $BB19_5) (case $BB19_1) (case $BB19_2) (case $BB19_6)) (case $BB19_3)
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
            (br $BB19_1)
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
        (block $BB20_8
          (block $BB20_4
            (br_if
              (get_local $$0)
              $BB20_4
            )
            (i32.store align=4
              (get_local $$0)
              (i32.const 1)
            )
            (block $BB20_3
              (br_if
                (get_local $$0)
                $BB20_3
              )
              (i32.store align=4
                (get_local $$0)
                (i32.const 2)
              )
              (br_if
                (get_local $$0)
                $BB20_8
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
          (block $BB20_6
            (br_if
              (i32.eq
                (get_local $$0)
                (i32.const 0)
              )
              $BB20_6
            )
            (i32.store align=4
              (get_local $$0)
              (i32.const 8)
            )
            (br $fake_return_waka123)
          )
          (i32.store align=4
            (get_local $$0)
            (i32.const 5)
          )
          (br_if
            (get_local $$0)
            $BB20_8
          )
          (i32.store align=4
            (get_local $$0)
            (i32.const 6)
          )
          (br $fake_return_waka123)
        )
        (i32.store align=4
          (get_local $$0)
          (i32.const 7)
        )
        (br $fake_return_waka123)
      )
    )
  )
  (func $test12 (param $$0 i32)
    (local $$1 i32)
    (block $fake_return_waka123
      (block
        (loop $BB21_8 $BB21_1
          (block
            (set_local $$1
              (i32.load8_u align=1
                (get_local $$0)
              )
            )
            (block $BB21_7
              (block $BB21_6
                (block $BB21_4
                  (br_if
                    (i32.gt_s
                      (get_local $$1)
                      (i32.const 103)
                    )
                    $BB21_4
                  )
                  (br_if
                    (i32.eq
                      (get_local $$1)
                      (i32.const 42)
                    )
                    $BB21_7
                  )
                  (br_if
                    (i32.eq
                      (get_local $$1)
                      (i32.const 76)
                    )
                    $BB21_7
                  )
                  (br $BB21_6)
                )
                (br_if
                  (i32.eq
                    (get_local $$1)
                    (i32.const 108)
                  )
                  $BB21_7
                )
                (br_if
                  (i32.eq
                    (get_local $$1)
                    (i32.const 104)
                  )
                  $BB21_7
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
            (br $BB21_1)
          )
        )
      )
    )
  )
  (func $test13
    (local $$0 i32)
    (block $fake_return_waka123
      (block
        (block $BB22_2
          (br_if
            (i32.eq
              (i32.const 0)
              (i32.const 0)
            )
            $BB22_2
          )
          (br $fake_return_waka123)
        )
        (set_local $$0
          (i32.const 0)
        )
        (block $BB22_4
          (br_if
            (get_local $$0)
            $BB22_4
          )
          (set_local $$0
            (i32.const 0)
          )
        )
        (block $BB22_5
          (br_if
            (i32.eq
              (i32.and
                (get_local $$0)
                (i32.const 1)
              )
              (i32.const 0)
            )
            $BB22_5
          )
        )
        (unreachable)
      )
    )
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 0 }
