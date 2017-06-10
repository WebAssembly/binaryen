(module
 (type $FUNCSIG$v (func))
 (type $FUNCSIG$i (func (result i32)))
 (import "env" "a" (func $a (result i32)))
 (import "env" "bar" (func $bar))
 (import "env" "something" (func $something))
 (import "env" "test15_callee0" (func $test15_callee0))
 (import "env" "test15_callee1" (func $test15_callee1))
 (import "env" "memory" (memory $0 1))
 (table 0 anyfunc)
 (data (i32.const 4) "\10\04\00\00")
 (export "stackSave" (func $stackSave))
 (export "stackAlloc" (func $stackAlloc))
 (export "stackRestore" (func $stackRestore))
 (export "test0" (func $test0))
 (export "test1" (func $test1))
 (export "test2" (func $test2))
 (export "doublediamond" (func $doublediamond))
 (export "triangle" (func $triangle))
 (export "diamond" (func $diamond))
 (export "single_block" (func $single_block))
 (export "minimal_loop" (func $minimal_loop))
 (export "simple_loop" (func $simple_loop))
 (export "doubletriangle" (func $doubletriangle))
 (export "ifelse_earlyexits" (func $ifelse_earlyexits))
 (export "doublediamond_in_a_loop" (func $doublediamond_in_a_loop))
 (export "test3" (func $test3))
 (export "test4" (func $test4))
 (export "test5" (func $test5))
 (export "test6" (func $test6))
 (export "test7" (func $test7))
 (export "test8" (func $test8))
 (export "test9" (func $test9))
 (export "test10" (func $test10))
 (export "test11" (func $test11))
 (export "test12" (func $test12))
 (export "test13" (func $test13))
 (export "test14" (func $test14))
 (export "test15" (func $test15))
 (func $test0 (param $0 i32)
  (local $1 i32)
  (set_local $1
   (i32.const 1)
  )
  (loop $label$0
   (block $label$1
    (br_if $label$1
     (i32.lt_s
      (get_local $1)
      (get_local $0)
     )
    )
    (return)
   )
   (set_local $1
    (i32.add
     (get_local $1)
     (i32.const 1)
    )
   )
   (call $something)
   (br $label$0)
  )
 )
 (func $test1 (param $0 i32)
  (local $1 i32)
  (set_local $1
   (i32.const 1)
  )
  (loop $label$0
   (block $label$1
    (br_if $label$1
     (i32.lt_s
      (get_local $1)
      (get_local $0)
     )
    )
    (return)
   )
   (set_local $1
    (i32.add
     (get_local $1)
     (i32.const 1)
    )
   )
   (call $something)
   (br $label$0)
  )
 )
 (func $test2 (param $0 i32) (param $1 i32)
  (block $label$0
   (br_if $label$0
    (i32.lt_s
     (get_local $1)
     (i32.const 1)
    )
   )
   (loop $label$1
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
 (func $doublediamond (param $0 i32) (param $1 i32) (param $2 i32) (result i32)
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
 (func $triangle (param $0 i32) (param $1 i32) (result i32)
  (i32.store
   (get_local $0)
   (i32.const 0)
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
   (i32.const 0)
  )
 )
 (func $diamond (param $0 i32) (param $1 i32) (result i32)
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
 (func $single_block (param $0 i32) (result i32)
  (i32.store
   (get_local $0)
   (i32.const 0)
  )
  (return
   (i32.const 0)
  )
 )
 (func $minimal_loop (param $0 i32) (result i32)
  (i32.store
   (get_local $0)
   (i32.const 0)
  )
  (loop $label$0 (result i32)
   (i32.store
    (get_local $0)
    (i32.const 1)
   )
   (br $label$0)
  )
 )
 (func $simple_loop (param $0 i32) (param $1 i32) (result i32)
  (i32.store
   (get_local $0)
   (i32.const 0)
  )
  (loop $label$0
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
 (func $doubletriangle (param $0 i32) (param $1 i32) (param $2 i32) (result i32)
  (i32.store
   (get_local $2)
   (i32.const 0)
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
   (i32.const 0)
  )
 )
 (func $ifelse_earlyexits (param $0 i32) (param $1 i32) (param $2 i32) (result i32)
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
 (func $doublediamond_in_a_loop (param $0 i32) (param $1 i32) (param $2 i32) (result i32)
  (loop $label$0 (result i32)
   (i32.store
    (get_local $2)
    (i32.const 0)
   )
   (block $label$1
    (br_if $label$1
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
   (block $label$2
    (br_if $label$2
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
 (func $test3 (param $0 i32)
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
   (block $label$1
    (loop $label$2
     (br_if $label$1
      (get_local $0)
     )
     (loop $label$3
      (br_if $label$3
       (i32.eqz
        (get_local $0)
       )
      )
     )
     (call $bar)
     (br $label$2)
    )
   )
   (unreachable)
  )
  (return)
 )
 (func $test4 (param $0 i32)
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
 (func $test5 (param $0 i32) (param $1 i32)
  (set_local $0
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
   (loop $label$1
    (i32.store
     (i32.const 0)
     (i32.const 0)
    )
    (br_if $label$0
     (i32.eqz
      (get_local $0)
     )
    )
    (i32.store
     (i32.const 0)
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
 (func $test6 (param $0 i32) (param $1 i32)
  (local $2 i32)
  (set_local $2
   (i32.and
    (get_local $0)
    (i32.const 1)
   )
  )
  (block $label$0
   (block $label$1
    (loop $label$2
     (i32.store
      (i32.const 0)
      (i32.const 0)
     )
     (br_if $label$0
      (i32.eqz
       (get_local $2)
      )
     )
     (i32.store
      (i32.const 0)
      (i32.const 1)
     )
     (br_if $label$1
      (i32.eqz
       (tee_local $0
        (i32.and
         (get_local $1)
         (i32.const 1)
        )
       )
      )
     )
     (i32.store
      (i32.const 0)
      (i32.const 1)
     )
     (br_if $label$2
      (get_local $0)
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
 (func $test7 (param $0 i32) (param $1 i32)
  (i32.store
   (i32.const 0)
   (i32.const 0)
  )
  (set_local $0
   (i32.and
    (get_local $0)
    (i32.const 1)
   )
  )
  (loop $label$0
   (i32.store
    (i32.const 0)
    (i32.const 1)
   )
   (block $label$1
    (br_if $label$1
     (get_local $0)
    )
    (i32.store
     (i32.const 0)
     (i32.const 2)
    )
    (br_if $label$0
     (i32.and
      (get_local $1)
      (i32.const 1)
     )
    )
    (i32.store
     (i32.const 0)
     (i32.const 4)
    )
    (unreachable)
   )
   (i32.store
    (i32.const 0)
    (i32.const 3)
   )
   (br_if $label$0
    (i32.and
     (get_local $1)
     (i32.const 1)
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
  (loop $label$0 (result i32)
   (br_if $label$0
    (i32.const 0)
   )
   (br $label$0)
  )
 )
 (func $test9
  (i32.store
   (i32.const 0)
   (i32.const 0)
  )
  (block $label$0
   (loop $label$1
    (i32.store
     (i32.const 0)
     (i32.const 1)
    )
    (br_if $label$0
     (i32.eqz
      (i32.and
       (call $a)
       (i32.const 1)
      )
     )
    )
    (loop $label$2
     (i32.store
      (i32.const 0)
      (i32.const 2)
     )
     (block $label$3
      (br_if $label$3
       (i32.eqz
        (i32.and
         (call $a)
         (i32.const 1)
        )
       )
      )
      (i32.store
       (i32.const 0)
       (i32.const 3)
      )
      (br_if $label$1
       (i32.eqz
        (i32.and
         (call $a)
         (i32.const 1)
        )
       )
      )
      (br $label$2)
     )
     (i32.store
      (i32.const 0)
      (i32.const 4)
     )
     (br_if $label$1
      (i32.eqz
       (i32.and
        (call $a)
        (i32.const 1)
       )
      )
     )
     (br $label$2)
    )
   )
  )
  (i32.store
   (i32.const 0)
   (i32.const 5)
  )
  (return)
 )
 (func $test10
  (local $0 i32)
  (local $1 i32)
  (local $2 i32)
  (local $3 i32)
  (local $4 i32)
  (set_local $0
   (i32.const 2)
  )
  (loop $label$0
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
   (block $label$1
    (loop $label$2
     (set_local $4
      (get_local $3)
     )
     (set_local $3
      (get_local $2)
     )
     (loop $label$3
      (br_if $label$0
       (i32.gt_u
        (tee_local $2
         (get_local $4)
        )
        (i32.const 4)
       )
      )
      (block $label$4
       (set_local $4
        (get_local $3)
       )
       (br_table $label$3 $label$4 $label$0 $label$2 $label$1 $label$3
        (get_local $2)
       )
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
 (func $test11
  (i32.store
   (i32.const 0)
   (i32.const 0)
  )
  (block $label$0
   (block $label$1
    (block $label$2
     (block $label$3
      (br_if $label$3
       (i32.const 0)
      )
      (i32.store
       (i32.const 0)
       (i32.const 1)
      )
      (block $label$4
       (br_if $label$4
        (i32.const 0)
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
      (i32.const 0)
      (i32.const 4)
     )
     (br_if $label$1
      (i32.const 0)
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
 (func $test12 (param $0 i32)
  (local $1 i32)
  (block $label$0
   (loop $label$1
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
      (br $label$0)
     )
     (br_if $label$2
      (i32.eq
       (get_local $1)
       (i32.const 108)
      )
     )
     (br_if $label$0
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
    (br $label$1)
   )
  )
  (return)
 )
 (func $test13
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
 (func $test14
  (loop $label$0
   (br_if $label$0
    (i32.const 0)
   )
  )
  (loop $label$1
   (br_if $label$1
    (i32.const 0)
   )
  )
  (return)
 )
 (func $test15
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
     (block $label$3
      (loop $label$4
       (br_if $label$3
        (i32.const 1)
       )
       (set_local $1
        (i32.const 0)
       )
       (br_if $label$4
        (tee_local $0
         (i32.add
          (get_local $0)
          (i32.const -4)
         )
        )
       )
       (br $label$2)
      )
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
    (call $test15_callee0)
    (return)
   )
   (call $test15_callee1)
  )
  (return)
 )
 (func $stackSave (result i32)
  (i32.load offset=4
   (i32.const 0)
  )
 )
 (func $stackAlloc (param $0 i32) (result i32)
  (local $1 i32)
  (set_local $1
   (i32.load offset=4
    (i32.const 0)
   )
  )
  (i32.store offset=4
   (i32.const 0)
   (i32.and
    (i32.add
     (i32.add
      (get_local $1)
      (get_local $0)
     )
     (i32.const 15)
    )
    (i32.const -16)
   )
  )
  (get_local $1)
 )
 (func $stackRestore (param $0 i32)
  (i32.store offset=4
   (i32.const 0)
   (get_local $0)
  )
 )
)
;; METADATA: { "asmConsts": {},"staticBump": 1040, "initializers": [] }
