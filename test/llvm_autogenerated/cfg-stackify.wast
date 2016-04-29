(module
  (memory 1
    (segment 4 "\10\04\00\00")
  )
  (export "memory" memory)
  (type $FUNCSIG$i (func (result i32)))
  (type $FUNCSIG$v (func))
  (import $a "env" "a" (result i32))
  (import $bar "env" "bar")
  (import $something "env" "something")
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
    (set_local $$1
      (i32.const 0)
    )
    (loop $label$1 $label$0
      (set_local $$1
        (i32.add
          (get_local $$1)
          (i32.const 1)
        )
      )
      (br_if $label$1
        (i32.ge_s
          (get_local $$1)
          (get_local $$0)
        )
      )
      (call_import $something)
      (br $label$0)
    )
    (return)
  )
  (func $test1 (param $$0 i32)
    (local $$1 i32)
    (set_local $$1
      (i32.const 0)
    )
    (loop $label$1 $label$0
      (set_local $$1
        (i32.add
          (get_local $$1)
          (i32.const 1)
        )
      )
      (br_if $label$1
        (i32.ge_s
          (get_local $$1)
          (get_local $$0)
        )
      )
      (call_import $something)
      (br $label$0)
    )
    (return)
  )
  (func $test2 (param $$0 i32) (param $$1 i32)
    (block $label$0
      (br_if $label$0
        (i32.lt_s
          (get_local $$1)
          (i32.const 1)
        )
      )
      (loop $label$2 $label$1
        (set_local $$1
          (i32.add
            (get_local $$1)
            (i32.const -1)
          )
        )
        (f64.store
          (get_local $$0)
          (f64.mul
            (f64.load
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
        (br_if $label$1
          (get_local $$1)
        )
      )
    )
    (return)
  )
  (func $doublediamond (param $$0 i32) (param $$1 i32) (param $$2 i32) (result i32)
    (i32.store
      (get_local $$2)
      (i32.const 0)
    )
    (block $label$0
      (block $label$1
        (br_if $label$1
          (get_local $$0)
        )
        (i32.store
          (get_local $$2)
          (i32.const 1)
        )
        (br $label$0)
      )
      (i32.store
        (get_local $$2)
        (i32.const 2)
      )
      (block $label$2
        (br_if $label$2
          (get_local $$1)
        )
        (i32.store
          (get_local $$2)
          (i32.const 3)
        )
        (br $label$0)
      )
      (i32.store
        (get_local $$2)
        (i32.const 4)
      )
    )
    (i32.store
      (get_local $$2)
      (i32.const 5)
    )
    (return
      (i32.const 0)
    )
  )
  (func $triangle (param $$0 i32) (param $$1 i32) (result i32)
    (local $$2 i32)
    (set_local $$2
      (i32.store
        (get_local $$0)
        (i32.const 0)
      )
    )
    (block $label$0
      (br_if $label$0
        (get_local $$1)
      )
      (i32.store
        (get_local $$0)
        (i32.const 1)
      )
    )
    (i32.store
      (get_local $$0)
      (i32.const 2)
    )
    (return
      (get_local $$2)
    )
  )
  (func $diamond (param $$0 i32) (param $$1 i32) (result i32)
    (i32.store
      (get_local $$0)
      (i32.const 0)
    )
    (block $label$0
      (block $label$1
        (br_if $label$1
          (get_local $$1)
        )
        (i32.store
          (get_local $$0)
          (i32.const 1)
        )
        (br $label$0)
      )
      (i32.store
        (get_local $$0)
        (i32.const 2)
      )
    )
    (i32.store
      (get_local $$0)
      (i32.const 3)
    )
    (return
      (i32.const 0)
    )
  )
  (func $single_block (param $$0 i32) (result i32)
    (return
      (i32.store
        (get_local $$0)
        (i32.const 0)
      )
    )
  )
  (func $minimal_loop (param $$0 i32) (result i32)
    (i32.store
      (get_local $$0)
      (i32.const 0)
    )
    (loop $label$1 $label$0
      (i32.store
        (get_local $$0)
        (i32.const 1)
      )
      (br $label$0)
    )
  )
  (func $simple_loop (param $$0 i32) (param $$1 i32) (result i32)
    (i32.store
      (get_local $$0)
      (i32.const 0)
    )
    (loop $label$1 $label$0
      (i32.store
        (get_local $$0)
        (i32.const 1)
      )
      (br_if $label$0
        (i32.eq
          (get_local $$1)
          (i32.const 0)
        )
      )
    )
    (i32.store
      (get_local $$0)
      (i32.const 2)
    )
    (return
      (i32.const 0)
    )
  )
  (func $doubletriangle (param $$0 i32) (param $$1 i32) (param $$2 i32) (result i32)
    (local $$3 i32)
    (set_local $$3
      (i32.store
        (get_local $$2)
        (i32.const 0)
      )
    )
    (block $label$0
      (br_if $label$0
        (get_local $$0)
      )
      (i32.store
        (get_local $$2)
        (i32.const 2)
      )
      (block $label$1
        (br_if $label$1
          (get_local $$1)
        )
        (i32.store
          (get_local $$2)
          (i32.const 3)
        )
      )
      (i32.store
        (get_local $$2)
        (i32.const 4)
      )
    )
    (i32.store
      (get_local $$2)
      (i32.const 5)
    )
    (return
      (get_local $$3)
    )
  )
  (func $ifelse_earlyexits (param $$0 i32) (param $$1 i32) (param $$2 i32) (result i32)
    (i32.store
      (get_local $$2)
      (i32.const 0)
    )
    (block $label$0
      (block $label$1
        (br_if $label$1
          (get_local $$0)
        )
        (i32.store
          (get_local $$2)
          (i32.const 1)
        )
        (br $label$0)
      )
      (i32.store
        (get_local $$2)
        (i32.const 2)
      )
      (br_if $label$0
        (get_local $$1)
      )
      (i32.store
        (get_local $$2)
        (i32.const 3)
      )
    )
    (i32.store
      (get_local $$2)
      (i32.const 4)
    )
    (return
      (i32.const 0)
    )
  )
  (func $doublediamond_in_a_loop (param $$0 i32) (param $$1 i32) (param $$2 i32) (result i32)
    (loop $label$1 $label$0
      (i32.store
        (get_local $$2)
        (i32.const 0)
      )
      (block $label$2
        (block $label$3
          (br_if $label$3
            (get_local $$0)
          )
          (i32.store
            (get_local $$2)
            (i32.const 1)
          )
          (br $label$2)
        )
        (i32.store
          (get_local $$2)
          (i32.const 2)
        )
        (block $label$4
          (br_if $label$4
            (get_local $$1)
          )
          (i32.store
            (get_local $$2)
            (i32.const 3)
          )
          (br $label$2)
        )
        (i32.store
          (get_local $$2)
          (i32.const 4)
        )
      )
      (i32.store
        (get_local $$2)
        (i32.const 5)
      )
      (br $label$0)
    )
  )
  (func $test3 (param $$0 i32)
    (block $label$0
      (br_if $label$0
        (i32.const 0)
      )
      (loop $label$2 $label$1
        (br_if $label$2
          (get_local $$0)
        )
        (loop $label$4 $label$3
          (br_if $label$3
            (i32.ne
              (get_local $$0)
              (get_local $$0)
            )
          )
        )
        (call_import $bar)
        (br $label$1)
      )
      (unreachable)
    )
    (return)
  )
  (func $test4 (param $$0 i32)
    (block $label$0
      (block $label$1
        (block $label$2
          (br_if $label$2
            (i32.gt_s
              (get_local $$0)
              (i32.const 3)
            )
          )
          (block $label$3
            (br_if $label$3
              (i32.eq
                (get_local $$0)
                (i32.const 0)
              )
            )
            (br_if $label$1
              (i32.ne
                (get_local $$0)
                (i32.const 2)
              )
            )
          )
          (return)
        )
        (br_if $label$0
          (i32.eq
            (get_local $$0)
            (i32.const 4)
          )
        )
        (br_if $label$1
          (i32.ne
            (get_local $$0)
            (i32.const 622)
          )
        )
        (return)
      )
      (return)
    )
    (return)
  )
  (func $test5 (param $$0 i32) (param $$1 i32)
    (local $$2 i32)
    (set_local $$0
      (i32.and
        (get_local $$0)
        (i32.const 1)
      )
    )
    (set_local $$2
      (i32.and
        (get_local $$1)
        (i32.const 1)
      )
    )
    (block $label$0
      (loop $label$2 $label$1
        (set_local $$1
          (i32.store
            (i32.const 0)
            (i32.const 0)
          )
        )
        (br_if $label$0
          (i32.eq
            (get_local $$0)
            (i32.const 0)
          )
        )
        (i32.store
          (get_local $$1)
          (i32.const 1)
        )
        (br_if $label$1
          (get_local $$2)
        )
      )
      (i32.store
        (i32.const 0)
        (i32.const 3)
      )
      (return)
    )
    (i32.store
      (i32.const 0)
      (i32.const 2)
    )
    (return)
  )
  (func $test6 (param $$0 i32) (param $$1 i32)
    (local $$2 i32)
    (local $$3 i32)
    (local $$4 i32)
    (set_local $$2
      (i32.and
        (get_local $$0)
        (i32.const 1)
      )
    )
    (block $label$0
      (block $label$1
        (loop $label$3 $label$2
          (set_local $$0
            (i32.store
              (i32.const 0)
              (i32.const 0)
            )
          )
          (br_if $label$0
            (i32.eq
              (get_local $$2)
              (i32.const 0)
            )
          )
          (br_if $label$1
            (i32.eq
              (set_local $$3
                (i32.and
                  (get_local $$1)
                  (set_local $$4
                    (i32.store
                      (get_local $$0)
                      (i32.const 1)
                    )
                  )
                )
              )
              (i32.const 0)
            )
          )
          (i32.store
            (get_local $$0)
            (get_local $$4)
          )
          (br_if $label$2
            (get_local $$3)
          )
        )
        (i32.store
          (i32.const 0)
          (i32.const 2)
        )
        (return)
      )
      (i32.store
        (i32.const 0)
        (i32.const 3)
      )
    )
    (i32.store
      (i32.const 0)
      (i32.const 4)
    )
    (return)
  )
  (func $test7 (param $$0 i32) (param $$1 i32)
    (local $$2 i32)
    (local $$3 i32)
    (set_local $$2
      (i32.store
        (i32.const 0)
        (i32.const 0)
      )
    )
    (set_local $$3
      (i32.and
        (get_local $$0)
        (i32.const 1)
      )
    )
    (loop $label$1 $label$0
      (set_local $$0
        (i32.store
          (get_local $$2)
          (i32.const 1)
        )
      )
      (block $label$2
        (br_if $label$2
          (get_local $$3)
        )
        (i32.store
          (get_local $$2)
          (i32.const 2)
        )
        (br_if $label$0
          (i32.and
            (get_local $$1)
            (get_local $$0)
          )
        )
        (i32.store
          (i32.const 0)
          (i32.const 4)
        )
        (unreachable)
      )
      (i32.store
        (get_local $$2)
        (i32.const 3)
      )
      (br_if $label$0
        (i32.and
          (get_local $$1)
          (get_local $$0)
        )
      )
    )
    (i32.store
      (i32.const 0)
      (i32.const 5)
    )
    (unreachable)
  )
  (func $test8 (result i32)
    (loop $label$1 $label$0
      (block $label$2
        (br_if $label$2
          (i32.eq
            (i32.const 0)
            (i32.const 0)
          )
        )
        (br_if $label$0
          (i32.eq
            (i32.const 0)
            (i32.const 0)
          )
        )
      )
      (loop $label$4 $label$3
        (br_if $label$3
          (i32.const 0)
        )
        (br $label$0)
      )
    )
  )
  (func $test9
    (local $$0 i32)
    (local $$1 i32)
    (set_local $$0
      (i32.store
        (i32.const 0)
        (i32.const 0)
      )
    )
    (loop $label$1 $label$0
      (br_if $label$1
        (i32.eq
          (i32.and
            (set_local $$1
              (i32.store
                (get_local $$0)
                (i32.const 1)
              )
            )
            (call_import $a)
          )
          (i32.const 0)
        )
      )
      (loop $label$3 $label$2
        (i32.store
          (get_local $$0)
          (i32.const 2)
        )
        (block $label$4
          (br_if $label$4
            (i32.eq
              (i32.and
                (call_import $a)
                (get_local $$1)
              )
              (i32.const 0)
            )
          )
          (i32.store
            (get_local $$0)
            (i32.const 3)
          )
          (br_if $label$2
            (i32.and
              (call_import $a)
              (get_local $$1)
            )
          )
          (br $label$0)
        )
        (i32.store
          (get_local $$0)
          (i32.const 4)
        )
        (br_if $label$2
          (i32.and
            (call_import $a)
            (get_local $$1)
          )
        )
        (br $label$0)
      )
    )
    (i32.store
      (i32.const 0)
      (i32.const 5)
    )
    (return)
  )
  (func $test10
    (local $$0 i32)
    (local $$1 i32)
    (local $$2 i32)
    (local $$3 i32)
    (local $$4 i32)
    (set_local $$0
      (i32.const 2)
    )
    (loop $label$1 $label$0
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
      (br_if $label$0
        (get_local $$4)
      )
      (block $label$2
        (loop $label$4 $label$3
          (set_local $$4
            (get_local $$3)
          )
          (set_local $$3
            (get_local $$2)
          )
          (loop $label$6 $label$5
            (set_local $$2
              (get_local $$4)
            )
            (br_if $label$0
              (i32.gt_u
                (get_local $$2)
                (i32.const 4)
              )
            )
            (set_local $$4
              (get_local $$3)
            )
            (br_table $label$5 $label$6 $label$0 $label$3 $label$2 $label$5
              (get_local $$2)
            )
          )
        )
        (return)
      )
      (set_local $$1
        (i32.const 1)
      )
      (br $label$0)
    )
  )
  (func $test11
    (local $$0 i32)
    (block $label$0
      (block $label$1
        (block $label$2
          (block $label$3
            (br_if $label$3
              (set_local $$0
                (i32.store
                  (i32.const 0)
                  (i32.const 0)
                )
              )
            )
            (i32.store
              (get_local $$0)
              (i32.const 1)
            )
            (block $label$4
              (br_if $label$4
                (get_local $$0)
              )
              (i32.store
                (i32.const 0)
                (i32.const 2)
              )
              (br_if $label$2
                (i32.const 0)
              )
            )
            (i32.store
              (i32.const 0)
              (i32.const 3)
            )
            (return)
          )
          (i32.store
            (get_local $$0)
            (i32.const 4)
          )
          (br_if $label$0
            (get_local $$0)
          )
          (i32.store
            (i32.const 0)
            (i32.const 5)
          )
          (br_if $label$1
            (i32.eq
              (i32.const 0)
              (i32.const 0)
            )
          )
        )
        (i32.store
          (i32.const 0)
          (i32.const 7)
        )
        (return)
      )
      (i32.store
        (i32.const 0)
        (i32.const 6)
      )
      (return)
    )
    (i32.store
      (i32.const 0)
      (i32.const 8)
    )
    (return)
  )
  (func $test12 (param $$0 i32)
    (local $$1 i32)
    (loop $label$1 $label$0
      (block $label$2
        (block $label$3
          (block $label$4
            (br_if $label$4
              (i32.gt_s
                (set_local $$1
                  (i32.load8_u
                    (get_local $$0)
                  )
                )
                (i32.const 103)
              )
            )
            (br_if $label$2
              (i32.eq
                (get_local $$1)
                (i32.const 42)
              )
            )
            (br_if $label$2
              (i32.eq
                (get_local $$1)
                (i32.const 76)
              )
            )
            (br $label$3)
          )
          (br_if $label$2
            (i32.eq
              (get_local $$1)
              (i32.const 108)
            )
          )
          (br_if $label$2
            (i32.eq
              (get_local $$1)
              (i32.const 104)
            )
          )
        )
        (return)
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
  (func $test13
    (local $$0 i32)
    (block $label$0
      (br_if $label$0
        (i32.eq
          (i32.const 0)
          (i32.const 0)
        )
      )
      (return)
    )
    (set_local $$0
      (i32.const 0)
    )
    (block $label$1
      (br_if $label$1
        (i32.const 0)
      )
      (set_local $$0
        (i32.const 0)
      )
    )
    (block $label$2
      (br_if $label$2
        (i32.eq
          (i32.and
            (get_local $$0)
            (i32.const 1)
          )
          (i32.const 0)
        )
      )
    )
    (unreachable)
  )
  (func $test14
    (loop $label$1 $label$0
      (br_if $label$0
        (i32.const 0)
      )
    )
    (loop $label$3 $label$2
      (i32.const 0)
      (br_if $label$2
        (i32.const 0)
      )
    )
    (return)
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 1040, "initializers": [] }
