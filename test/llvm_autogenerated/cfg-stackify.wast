(module
  (memory 1)
  (data (i32.const 4) "\10\04\00\00")
  (export "memory" memory)
  (type $FUNCSIG$i (func (result i32)))
  (type $FUNCSIG$v (func))
  (type $2 (func (param i32)))
  (type $3 (func (param i32 i32)))
  (type $4 (func (param i32 i32 i32) (result i32)))
  (type $5 (func (param i32 i32) (result i32)))
  (type $6 (func (param i32) (result i32)))
  (import $a "env" "a" (result i32))
  (import $bar "env" "bar")
  (import $something "env" "something")
  (import $test15_callee0 "env" "test15_callee0")
  (import $test15_callee1 "env" "test15_callee1")
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
  (export "test15" $test15)
  (func $test0 (type $2) (param $0 i32)
    (local $1 i32)
    (set_local $1
      (i32.const 0)
    )
    (loop $label$1 $label$0
      (block $label$2
        (br_if $label$2
          (i32.lt_s
            (tee_local $1
              (i32.add
                (get_local $1)
                (i32.const 1)
              )
            )
            (get_local $0)
          )
        )
        (return)
      )
      (call_import $something)
      (br $label$0)
    )
  )
  (func $test1 (type $2) (param $0 i32)
    (local $1 i32)
    (set_local $1
      (i32.const 0)
    )
    (loop $label$1 $label$0
      (block $label$2
        (br_if $label$2
          (i32.lt_s
            (tee_local $1
              (i32.add
                (get_local $1)
                (i32.const 1)
              )
            )
            (get_local $0)
          )
        )
        (return)
      )
      (call_import $something)
      (br $label$0)
    )
  )
  (func $test2 (type $3) (param $0 i32) (param $1 i32)
    (block $label$0
      (br_if $label$0
        (i32.lt_s
          (get_local $1)
          (i32.const 1)
        )
      )
      (loop $label$2 $label$1
        (f64.store
          (get_local $0)
          (f64.mul
            (f64.load
              (get_local $0)
            )
            (f64.const 3.2)
          )
        )
        (set_local $0
          (i32.add
            (get_local $0)
            (i32.const 8)
          )
        )
        (br_if $label$1
          (tee_local $1
            (i32.add
              (get_local $1)
              (i32.const -1)
            )
          )
        )
      )
    )
    (return)
  )
  (func $doublediamond (type $4) (param $0 i32) (param $1 i32) (param $2 i32) (result i32)
    (i32.store
      (get_local $2)
      (i32.const 0)
    )
    (block $label$0
      (block $label$1
        (br_if $label$1
          (get_local $0)
        )
        (i32.store
          (get_local $2)
          (i32.const 1)
        )
        (br $label$0)
      )
      (i32.store
        (get_local $2)
        (i32.const 2)
      )
      (block $label$2
        (br_if $label$2
          (get_local $1)
        )
        (i32.store
          (get_local $2)
          (i32.const 3)
        )
        (br $label$0)
      )
      (i32.store
        (get_local $2)
        (i32.const 4)
      )
    )
    (i32.store
      (get_local $2)
      (i32.const 5)
    )
    (return
      (i32.const 0)
    )
  )
  (func $triangle (type $5) (param $0 i32) (param $1 i32) (result i32)
    (local $2 i32)
    (local $3 i32)
    (set_local $2
      (block
        (block
          (set_local $3
            (i32.const 0)
          )
          (i32.store
            (get_local $0)
            (get_local $3)
          )
        )
        (get_local $3)
      )
    )
    (block $label$0
      (br_if $label$0
        (get_local $1)
      )
      (i32.store
        (get_local $0)
        (i32.const 1)
      )
    )
    (i32.store
      (get_local $0)
      (i32.const 2)
    )
    (return
      (get_local $2)
    )
  )
  (func $diamond (type $5) (param $0 i32) (param $1 i32) (result i32)
    (i32.store
      (get_local $0)
      (i32.const 0)
    )
    (block $label$0
      (block $label$1
        (br_if $label$1
          (get_local $1)
        )
        (i32.store
          (get_local $0)
          (i32.const 1)
        )
        (br $label$0)
      )
      (i32.store
        (get_local $0)
        (i32.const 2)
      )
    )
    (i32.store
      (get_local $0)
      (i32.const 3)
    )
    (return
      (i32.const 0)
    )
  )
  (func $single_block (type $6) (param $0 i32) (result i32)
    (local $1 i32)
    (return
      (block
        (block
          (set_local $1
            (i32.const 0)
          )
          (i32.store
            (get_local $0)
            (get_local $1)
          )
        )
        (get_local $1)
      )
    )
  )
  (func $minimal_loop (type $6) (param $0 i32) (result i32)
    (i32.store
      (get_local $0)
      (i32.const 0)
    )
    (loop $label$1 $label$0
      (i32.store
        (get_local $0)
        (i32.const 1)
      )
      (br $label$0)
    )
  )
  (func $simple_loop (type $5) (param $0 i32) (param $1 i32) (result i32)
    (i32.store
      (get_local $0)
      (i32.const 0)
    )
    (loop $label$1 $label$0
      (i32.store
        (get_local $0)
        (i32.const 1)
      )
      (br_if $label$0
        (i32.eqz
          (get_local $1)
        )
      )
    )
    (i32.store
      (get_local $0)
      (i32.const 2)
    )
    (return
      (i32.const 0)
    )
  )
  (func $doubletriangle (type $4) (param $0 i32) (param $1 i32) (param $2 i32) (result i32)
    (local $3 i32)
    (local $4 i32)
    (set_local $3
      (block
        (block
          (set_local $4
            (i32.const 0)
          )
          (i32.store
            (get_local $2)
            (get_local $4)
          )
        )
        (get_local $4)
      )
    )
    (block $label$0
      (br_if $label$0
        (get_local $0)
      )
      (i32.store
        (get_local $2)
        (i32.const 2)
      )
      (block $label$1
        (br_if $label$1
          (get_local $1)
        )
        (i32.store
          (get_local $2)
          (i32.const 3)
        )
      )
      (i32.store
        (get_local $2)
        (i32.const 4)
      )
    )
    (i32.store
      (get_local $2)
      (i32.const 5)
    )
    (return
      (get_local $3)
    )
  )
  (func $ifelse_earlyexits (type $4) (param $0 i32) (param $1 i32) (param $2 i32) (result i32)
    (i32.store
      (get_local $2)
      (i32.const 0)
    )
    (block $label$0
      (block $label$1
        (br_if $label$1
          (get_local $0)
        )
        (i32.store
          (get_local $2)
          (i32.const 1)
        )
        (br $label$0)
      )
      (i32.store
        (get_local $2)
        (i32.const 2)
      )
      (br_if $label$0
        (get_local $1)
      )
      (i32.store
        (get_local $2)
        (i32.const 3)
      )
    )
    (i32.store
      (get_local $2)
      (i32.const 4)
    )
    (return
      (i32.const 0)
    )
  )
  (func $doublediamond_in_a_loop (type $4) (param $0 i32) (param $1 i32) (param $2 i32) (result i32)
    (loop $label$1 $label$0
      (i32.store
        (get_local $2)
        (i32.const 0)
      )
      (block $label$2
        (br_if $label$2
          (get_local $0)
        )
        (i32.store
          (get_local $2)
          (i32.const 1)
        )
        (i32.store
          (get_local $2)
          (i32.const 5)
        )
        (br $label$0)
      )
      (i32.store
        (get_local $2)
        (i32.const 2)
      )
      (block $label$3
        (br_if $label$3
          (get_local $1)
        )
        (i32.store
          (get_local $2)
          (i32.const 3)
        )
        (i32.store
          (get_local $2)
          (i32.const 5)
        )
        (br $label$0)
      )
      (i32.store
        (get_local $2)
        (i32.const 4)
      )
      (i32.store
        (get_local $2)
        (i32.const 5)
      )
      (br $label$0)
    )
  )
  (func $test3 (type $2) (param $0 i32)
    (block $label$0
      (br_if $label$0
        (i32.const 0)
      )
      (set_local $0
        (i32.eq
          (get_local $0)
          (get_local $0)
        )
      )
      (loop $label$2 $label$1
        (br_if $label$2
          (get_local $0)
        )
        (loop $label$4 $label$3
          (br_if $label$3
            (i32.eqz
              (get_local $0)
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
  (func $test4 (type $2) (param $0 i32)
    (block $label$0
      (block $label$1
        (br_if $label$1
          (i32.gt_s
            (get_local $0)
            (i32.const 3)
          )
        )
        (br_if $label$0
          (i32.eqz
            (get_local $0)
          )
        )
        (drop
          (i32.eq
            (get_local $0)
            (i32.const 2)
          )
        )
        (br $label$0)
      )
      (block $label$2
        (br_if $label$2
          (i32.eq
            (get_local $0)
            (i32.const 4)
          )
        )
        (br_if $label$0
          (i32.ne
            (get_local $0)
            (i32.const 622)
          )
        )
      )
      (return)
    )
    (return)
  )
  (func $test5 (type $3) (param $0 i32) (param $1 i32)
    (local $2 i32)
    (local $3 i32)
    (set_local $2
      (i32.and
        (get_local $0)
        (i32.const 1)
      )
    )
    (set_local $1
      (i32.and
        (get_local $1)
        (i32.const 1)
      )
    )
    (block $label$0
      (loop $label$2 $label$1
        (set_local $0
          (block
            (block
              (set_local $3
                (i32.const 0)
              )
              (i32.store
                (i32.const 0)
                (get_local $3)
              )
            )
            (get_local $3)
          )
        )
        (br_if $label$0
          (i32.eqz
            (get_local $2)
          )
        )
        (i32.store
          (get_local $0)
          (i32.const 1)
        )
        (br_if $label$1
          (get_local $1)
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
  (func $test6 (type $3) (param $0 i32) (param $1 i32)
    (local $2 i32)
    (local $3 i32)
    (local $4 i32)
    (local $5 i32)
    (local $6 i32)
    (set_local $3
      (i32.and
        (get_local $0)
        (i32.const 1)
      )
    )
    (block $label$0
      (block $label$1
        (loop $label$3 $label$2
          (set_local $0
            (block
              (block
                (set_local $5
                  (i32.const 0)
                )
                (i32.store
                  (i32.const 0)
                  (get_local $5)
                )
              )
              (get_local $5)
            )
          )
          (br_if $label$0
            (i32.eqz
              (get_local $3)
            )
          )
          (br_if $label$1
            (i32.eqz
              (tee_local $4
                (i32.and
                  (get_local $1)
                  (tee_local $2
                    (block
                      (block
                        (set_local $6
                          (i32.const 1)
                        )
                        (i32.store
                          (get_local $0)
                          (get_local $6)
                        )
                      )
                      (get_local $6)
                    )
                  )
                )
              )
            )
          )
          (i32.store
            (get_local $0)
            (get_local $2)
          )
          (br_if $label$2
            (get_local $4)
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
  (func $test7 (type $3) (param $0 i32) (param $1 i32)
    (local $2 i32)
    (local $3 i32)
    (local $4 i32)
    (local $5 i32)
    (set_local $2
      (block
        (block
          (set_local $4
            (i32.const 0)
          )
          (i32.store
            (i32.const 0)
            (get_local $4)
          )
        )
        (get_local $4)
      )
    )
    (set_local $3
      (i32.and
        (get_local $0)
        (i32.const 1)
      )
    )
    (loop $label$1 $label$0
      (set_local $0
        (block
          (block
            (set_local $5
              (i32.const 1)
            )
            (i32.store
              (get_local $2)
              (get_local $5)
            )
          )
          (get_local $5)
        )
      )
      (block $label$2
        (br_if $label$2
          (get_local $3)
        )
        (i32.store
          (get_local $2)
          (i32.const 2)
        )
        (br_if $label$0
          (i32.and
            (get_local $1)
            (get_local $0)
          )
        )
        (i32.store
          (i32.const 0)
          (i32.const 4)
        )
        (unreachable)
      )
      (i32.store
        (get_local $2)
        (i32.const 3)
      )
      (br_if $label$0
        (i32.and
          (get_local $1)
          (get_local $0)
        )
      )
    )
    (i32.store
      (i32.const 0)
      (i32.const 5)
    )
    (unreachable)
  )
  (func $test8 (type $FUNCSIG$i) (result i32)
    (loop $label$1 $label$0
      (br_if $label$0
        (i32.const 0)
      )
      (br $label$0)
    )
  )
  (func $test9 (type $FUNCSIG$v)
    (local $0 i32)
    (local $1 i32)
    (local $2 i32)
    (local $3 i32)
    (set_local $0
      (block
        (block
          (set_local $2
            (i32.const 0)
          )
          (i32.store
            (i32.const 0)
            (get_local $2)
          )
        )
        (get_local $2)
      )
    )
    (loop $label$1 $label$0
      (br_if $label$1
        (i32.eqz
          (i32.and
            (tee_local $1
              (block
                (block
                  (set_local $3
                    (i32.const 1)
                  )
                  (i32.store
                    (get_local $0)
                    (get_local $3)
                  )
                )
                (get_local $3)
              )
            )
            (call_import $a)
          )
        )
      )
      (loop $label$3 $label$2
        (i32.store
          (get_local $0)
          (i32.const 2)
        )
        (block $label$4
          (br_if $label$4
            (i32.eqz
              (i32.and
                (call_import $a)
                (get_local $1)
              )
            )
          )
          (i32.store
            (get_local $0)
            (i32.const 3)
          )
          (br_if $label$0
            (i32.eqz
              (i32.and
                (call_import $a)
                (get_local $1)
              )
            )
          )
          (br $label$2)
        )
        (i32.store
          (get_local $0)
          (i32.const 4)
        )
        (br_if $label$0
          (i32.eqz
            (i32.and
              (call_import $a)
              (get_local $1)
            )
          )
        )
        (br $label$2)
      )
    )
    (i32.store
      (i32.const 0)
      (i32.const 5)
    )
    (return)
  )
  (func $test10 (type $FUNCSIG$v)
    (local $0 i32)
    (local $1 i32)
    (local $2 i32)
    (local $3 i32)
    (local $4 i32)
    (set_local $0
      (i32.const 2)
    )
    (loop $label$1 $label$0
      (set_local $2
        (get_local $1)
      )
      (set_local $3
        (get_local $0)
      )
      (set_local $1
        (i32.const 0)
      )
      (set_local $0
        (i32.const 3)
      )
      (br_if $label$0
        (get_local $2)
      )
      (set_local $2
        (i32.const 4)
      )
      (block $label$2
        (loop $label$4 $label$3
          (set_local $4
            (get_local $3)
          )
          (set_local $3
            (get_local $2)
          )
          (loop $label$6 $label$5
            (br_if $label$0
              (i32.gt_u
                (tee_local $2
                  (get_local $4)
                )
                (i32.const 4)
              )
            )
            (set_local $4
              (get_local $3)
            )
            (br_table $label$5 $label$6 $label$0 $label$3 $label$2 $label$5
              (get_local $2)
            )
          )
        )
        (return)
      )
      (set_local $1
        (i32.const 1)
      )
      (br $label$0)
    )
  )
  (func $test11 (type $FUNCSIG$v)
    (local $0 i32)
    (local $1 i32)
    (block $label$0
      (block $label$1
        (block $label$2
          (block $label$3
            (br_if $label$3
              (tee_local $0
                (block
                  (block
                    (set_local $1
                      (i32.const 0)
                    )
                    (i32.store
                      (i32.const 0)
                      (get_local $1)
                    )
                  )
                  (get_local $1)
                )
              )
            )
            (i32.store
              (get_local $0)
              (i32.const 1)
            )
            (block $label$4
              (br_if $label$4
                (get_local $0)
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
            (get_local $0)
            (i32.const 4)
          )
          (br_if $label$1
            (get_local $0)
          )
          (i32.store
            (i32.const 0)
            (i32.const 5)
          )
          (br_if $label$0
            (i32.eqz
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
        (i32.const 8)
      )
      (return)
    )
    (i32.store
      (i32.const 0)
      (i32.const 6)
    )
    (return)
  )
  (func $test12 (type $2) (param $0 i32)
    (local $1 i32)
    (loop $label$1 $label$0
      (block $label$2
        (block $label$3
          (br_if $label$3
            (i32.gt_s
              (tee_local $1
                (i32.load8_u
                  (get_local $0)
                )
              )
              (i32.const 103)
            )
          )
          (br_if $label$2
            (i32.eq
              (get_local $1)
              (i32.const 42)
            )
          )
          (br_if $label$2
            (i32.eq
              (get_local $1)
              (i32.const 76)
            )
          )
          (br $label$1)
        )
        (br_if $label$2
          (i32.eq
            (get_local $1)
            (i32.const 108)
          )
        )
        (br_if $label$1
          (i32.ne
            (get_local $1)
            (i32.const 104)
          )
        )
      )
      (set_local $0
        (i32.add
          (get_local $0)
          (i32.const 1)
        )
      )
      (br $label$0)
    )
    (return)
  )
  (func $test13 (type $FUNCSIG$v)
    (local $0 i32)
    (block $label$0
      (block $label$1
        (br_if $label$1
          (i32.const 0)
        )
        (set_local $0
          (i32.const 0)
        )
        (block $label$2
          (br_if $label$2
            (i32.const 0)
          )
          (set_local $0
            (i32.const 0)
          )
        )
        (br_if $label$0
          (i32.and
            (get_local $0)
            (i32.const 1)
          )
        )
        (br $label$0)
      )
      (return)
    )
    (unreachable)
  )
  (func $test14 (type $FUNCSIG$v)
    (loop $label$1 $label$0
      (br_if $label$0
        (i32.const 0)
      )
    )
    (loop $label$3 $label$2
      (br_if $label$2
        (i32.const 0)
      )
    )
    (return)
  )
  (func $test15 (type $FUNCSIG$v)
    (local $0 i32)
    (local $1 i32)
    (block $label$0
      (block $label$1
        (br_if $label$1
          (i32.const 1)
        )
        (set_local $0
          (i32.const 0)
        )
        (block $label$2
          (loop $label$4 $label$3
            (br_if $label$4
              (i32.const 1)
            )
            (set_local $1
              (i32.const 0)
            )
            (br_if $label$3
              (tee_local $0
                (i32.add
                  (get_local $0)
                  (i32.const -4)
                )
              )
            )
            (br $label$2)
          )
          (set_local $1
            (i32.const 0)
          )
        )
        (br_if $label$0
          (i32.eqz
            (get_local $1)
          )
        )
        (call_import $test15_callee0)
        (return)
      )
      (call_import $test15_callee1)
    )
    (return)
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 1040, "initializers": [] }
