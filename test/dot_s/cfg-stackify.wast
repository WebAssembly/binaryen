(module
  (memory 0 4294967295)
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
                (i32.const 1)
                (get_local $$1)
              )
            )
            (br_if
              (i32.ge_s
                (get_local $$0)
                (get_local $$1)
              )
              $BB0_3
            )
            (call $something)
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
                (i32.const 1)
                (get_local $$1)
              )
            )
            (br_if
              (i32.ge_s
                (get_local $$0)
                (get_local $$1)
              )
              $BB1_3
            )
            (call $something)
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
              (i32.const 1)
              (get_local $$1)
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
                  (i32.const -1)
                  (get_local $$1)
                )
              )
              (set_local $$0
                (i32.add
                  (i32.const 8)
                  (get_local $$0)
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
          (block $BB3_2
            (br_if
              (get_local $$0)
              $BB3_2
            )
            (i32.store align=4
              (get_local $$2)
              (i32.const 1)
            )
            (br $BB3_5)
          )
          (i32.store align=4
            (get_local $$2)
            (i32.const 2)
          )
          (block $BB3_4
            (br_if
              (get_local $$1)
              $BB3_4
            )
            (i32.store align=4
              (get_local $$2)
              (i32.const 3)
            )
            (br $BB3_5)
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
              (get_local $$1)
              $BB5_2
            )
            (i32.store align=4
              (get_local $$0)
              (i32.const 1)
            )
            (br $BB5_3)
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
                (i32.const 0)
                (get_local $$1)
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
          (block $BB10_2
            (br_if
              (get_local $$0)
              $BB10_2
            )
            (i32.store align=4
              (get_local $$2)
              (i32.const 1)
            )
            (br $BB10_4)
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
            (block $BB11_3
              (br_if
                (get_local $$0)
                $BB11_3
              )
              (i32.store align=4
                (get_local $$2)
                (i32.const 1)
              )
              (br $BB11_6)
            )
            (i32.store align=4
              (get_local $$2)
              (i32.const 2)
            )
            (block $BB11_5
              (br_if
                (get_local $$1)
                $BB11_5
              )
              (i32.store align=4
                (get_local $$2)
                (i32.const 3)
              )
              (br $BB11_6)
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
          (br $BB11_1)
        )
      )
    )
  )
  (func $test3 (param $$0 i32)
    (block $fake_return_waka123
      (block
        (block $BB12_5
          (br_if
            (i32.const 0)
            $BB12_5
          )
          (loop $BB12_4 $BB12_1
            (block
              (br_if
                (get_local $$0)
                $BB12_4
              )
              (loop $BB12_3 $BB12_2
                (block
                  (br_if
                    (i32.ne
                      (get_local $$0)
                      (get_local $$0)
                    )
                    $BB12_2
                  )
                )
              )
              (call $bar)
              (br $BB12_1)
            )
          )
          (unreachable)
        )
        (br $fake_return_waka123)
      )
    )
  )
)
