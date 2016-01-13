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
  (export "test14" $test14)
  (func $test0 (param $$0 i32)
    (local $$1 i32)
    (block $fake_return_waka123
      (block
        (set_local $$1
          (i32.const 0)
        )
        (loop $label$1 $label$0
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
              $label$1
            )
            (call_import $something)
            (br $label$0)
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
        (loop $label$1 $label$0
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
              $label$1
            )
            (call_import $something)
            (br $label$0)
          )
        )
        (br $fake_return_waka123)
      )
    )
  )
  (func $test2 (param $$0 i32) (param $$1 i32)
    (block $fake_return_waka123
      (block
        (block $label$0
          (br_if
            (i32.lt_s
              (get_local $$1)
              (i32.const 1)
            )
            $label$0
          )
          (loop $label$2 $label$1
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
                $label$1
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
        (block $label$0
          (block $label$1
            (set_local $$3
              (i32.store align=4
                (get_local $$2)
                (i32.const 0)
              )
            )
            (br_if
              (get_local $$0)
              $label$1
            )
            (i32.store align=4
              (get_local $$2)
              (i32.const 1)
            )
            (br $label$0)
          )
          (block $label$2
            (i32.store align=4
              (get_local $$2)
              (i32.const 2)
            )
            (br_if
              (get_local $$1)
              $label$2
            )
            (i32.store align=4
              (get_local $$2)
              (i32.const 3)
            )
            (br $label$0)
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
        (block $label$0
          (set_local $$2
            (i32.store align=4
              (get_local $$0)
              (i32.const 0)
            )
          )
          (br_if
            (get_local $$1)
            $label$0
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
        (block $label$0
          (block $label$1
            (set_local $$2
              (i32.store align=4
                (get_local $$0)
                (i32.const 0)
              )
            )
            (br_if
              (get_local $$1)
              $label$1
            )
            (i32.store align=4
              (get_local $$0)
              (i32.const 1)
            )
            (br $label$0)
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
    (loop $label$1 $label$0
      (block
        (i32.store align=4
          (get_local $$0)
          (i32.const 1)
        )
        (br $label$0)
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
        (loop $label$1 $label$0
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
              $label$0
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
        (block $label$0
          (set_local $$3
            (i32.store align=4
              (get_local $$2)
              (i32.const 0)
            )
          )
          (br_if
            (get_local $$0)
            $label$0
          )
          (block $label$1
            (i32.store align=4
              (get_local $$2)
              (i32.const 2)
            )
            (br_if
              (get_local $$1)
              $label$1
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
        (block $label$0
          (block $label$1
            (set_local $$3
              (i32.store align=4
                (get_local $$2)
                (i32.const 0)
              )
            )
            (br_if
              (get_local $$0)
              $label$1
            )
            (i32.store align=4
              (get_local $$2)
              (i32.const 1)
            )
            (br $label$0)
          )
          (i32.store align=4
            (get_local $$2)
            (i32.const 2)
          )
          (br_if
            (get_local $$1)
            $label$0
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
    (loop $label$1 $label$0
      (block
        (block $label$2
          (block $label$3
            (i32.store align=4
              (get_local $$2)
              (i32.const 0)
            )
            (br_if
              (get_local $$0)
              $label$3
            )
            (i32.store align=4
              (get_local $$2)
              (i32.const 1)
            )
            (br $label$2)
          )
          (block $label$4
            (i32.store align=4
              (get_local $$2)
              (i32.const 2)
            )
            (br_if
              (get_local $$1)
              $label$4
            )
            (i32.store align=4
              (get_local $$2)
              (i32.const 3)
            )
            (br $label$2)
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
        (br $label$0)
      )
    )
  )
  (func $test3 (param $$0 i32)
    (block $fake_return_waka123
      (block
        (block $label$0
          (br_if
            (i32.const 0)
            $label$0
          )
          (loop $label$2 $label$1
            (block
              (br_if
                (get_local $$0)
                $label$2
              )
              (loop $label$4 $label$3
                (block
                  (br_if
                    (i32.ne
                      (get_local $$0)
                      (get_local $$0)
                    )
                    $label$3
                  )
                )
              )
              (call_import $bar)
              (br $label$1)
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
        (block $label$0
          (block $label$1
            (block $label$2
              (br_if
                (i32.gt_s
                  (get_local $$0)
                  (i32.const 3)
                )
                $label$2
              )
              (block $label$3
                (br_if
                  (i32.eq
                    (get_local $$0)
                    (i32.const 0)
                  )
                  $label$3
                )
                (br_if
                  (i32.ne
                    (get_local $$0)
                    (i32.const 2)
                  )
                  $label$1
                )
              )
              (br $fake_return_waka123)
            )
            (br_if
              (i32.eq
                (get_local $$0)
                (i32.const 4)
              )
              $label$0
            )
            (br_if
              (i32.ne
                (get_local $$0)
                (i32.const 622)
              )
              $label$1
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
        (block $label$0
          (loop $label$2 $label$1
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
                $label$0
              )
              (br_if
                (i32.and
                  (get_local $$1)
                  (i32.store align=4
                    (get_local $$3)
                    (get_local $$2)
                  )
                )
                $label$1
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
        (block $label$0
          (block $label$1
            (loop $label$3 $label$2
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
                  $label$0
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
                  $label$1
                )
                (i32.store align=4
                  (get_local $$2)
                  (get_local $$3)
                )
                (br_if
                  (get_local $$4)
                  $label$2
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
    (loop $label$1 $label$0
      (block
        (block $label$2
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
            $label$2
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
            $label$0
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
          $label$0
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
    (loop $label$1 $label$0
      (block
        (block $label$2
          (br_if
            (i32.eq
              (get_local $$0)
              (i32.const 0)
            )
            $label$2
          )
          (br_if
            (i32.eq
              (get_local $$0)
              (i32.const 0)
            )
            $label$0
          )
        )
        (loop $label$4 $label$3
          (block
            (br_if
              (get_local $$0)
              $label$3
            )
            (br $label$0)
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
        (loop $label$1 $label$0
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
              $label$1
            )
            (loop $label$3 $label$2
              (block
                (block $label$4
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
                    $label$4
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
                    $label$2
                  )
                  (br $label$0)
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
                  $label$2
                )
                (br $label$0)
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
        (loop $label$1 $label$0
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
              $label$0
            )
            (block $label$2
              (loop $label$4 $label$3
                (block
                  (set_local $$4
                    (get_local $$3)
                  )
                  (set_local $$3
                    (get_local $$2)
                  )
                  (loop $label$6 $label$5
                    (block
                      (set_local $$2
                        (get_local $$4)
                      )
                      (br_if
                        (i32.gt_u
                          (get_local $$2)
                          (i32.const 4)
                        )
                        $label$0
                      )
                      (set_local $$4
                        (get_local $$3)
                      )
                      (tableswitch 
                        (get_local $$2)
                        (table (br $label$5) (br $label$6) (br $label$0) (br $label$3) (br $label$2)) (br $label$5)
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
            (br $label$0)
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
        (block $label$0
          (block $label$1
            (block $label$2
              (block $label$3
                (br_if
                  (get_local $$0)
                  $label$3
                )
                (block $label$4
                  (i32.store align=4
                    (get_local $$0)
                    (i32.const 1)
                  )
                  (br_if
                    (get_local $$0)
                    $label$4
                  )
                  (i32.store align=4
                    (get_local $$0)
                    (i32.const 2)
                  )
                  (br_if
                    (get_local $$0)
                    $label$2
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
                $label$0
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
                $label$1
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
        (loop $label$1 $label$0
          (block
            (set_local $$1
              (i32.load8_u align=1
                (get_local $$0)
              )
            )
            (block $label$2
              (block $label$3
                (block $label$4
                  (br_if
                    (i32.gt_s
                      (get_local $$1)
                      (i32.const 103)
                    )
                    $label$4
                  )
                  (br_if
                    (i32.eq
                      (get_local $$1)
                      (i32.const 42)
                    )
                    $label$2
                  )
                  (br_if
                    (i32.eq
                      (get_local $$1)
                      (i32.const 76)
                    )
                    $label$2
                  )
                  (br $label$3)
                )
                (br_if
                  (i32.eq
                    (get_local $$1)
                    (i32.const 108)
                  )
                  $label$2
                )
                (br_if
                  (i32.eq
                    (get_local $$1)
                    (i32.const 104)
                  )
                  $label$2
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
            (br $label$0)
          )
        )
      )
    )
  )
  (func $test13
    (local $$0 i32)
    (block $fake_return_waka123
      (block
        (block $label$0
          (br_if
            (i32.eq
              (i32.const 0)
              (i32.const 0)
            )
            $label$0
          )
          (br $fake_return_waka123)
        )
        (set_local $$0
          (i32.const 0)
        )
        (block $label$1
          (br_if
            (get_local $$0)
            $label$1
          )
          (set_local $$0
            (i32.const 0)
          )
        )
        (block $label$2
          (br_if
            (i32.eq
              (i32.and
                (get_local $$0)
                (i32.const 1)
              )
              (i32.const 0)
            )
            $label$2
          )
        )
        (unreachable)
      )
    )
  )
  (func $test14
    (local $$0 i32)
    (block $fake_return_waka123
      (block
        (set_local $$0
          (i32.const 0)
        )
        (loop $label$1 $label$0
          (block
            (br_if
              (get_local $$0)
              $label$0
            )
          )
        )
        (loop $label$3 $label$2
          (block
            (br_if
              (get_local $$0)
              $label$2
            )
          )
        )
        (br $fake_return_waka123)
      )
    )
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 0 }
