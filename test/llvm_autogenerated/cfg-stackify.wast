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
 (export "stackSave" (func $stackSave))
 (export "stackAlloc" (func $stackAlloc))
 (export "stackRestore" (func $stackRestore))
 (func $test0 (; 5 ;) (param $0 i32)
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
 (func $test1 (; 6 ;) (param $0 i32)
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
 (func $test2 (; 7 ;) (param $0 i32) (param $1 i32)
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
 (func $doublediamond (; 8 ;) (param $0 i32) (param $1 i32) (param $2 i32) (result i32)
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
 (func $triangle (; 9 ;) (param $0 i32) (param $1 i32) (result i32)
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
 (func $diamond (; 10 ;) (param $0 i32) (param $1 i32) (result i32)
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
 (func $single_block (; 11 ;) (param $0 i32) (result i32)
  (i32.store
   (get_local $0)
   (i32.const 0)
  )
  (return
   (i32.const 0)
  )
 )
 (func $minimal_loop (; 12 ;) (param $0 i32) (result i32)
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
 (func $simple_loop (; 13 ;) (param $0 i32) (param $1 i32) (result i32)
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
 (func $doubletriangle (; 14 ;) (param $0 i32) (param $1 i32) (param $2 i32) (result i32)
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
 (func $ifelse_earlyexits (; 15 ;) (param $0 i32) (param $1 i32) (param $2 i32) (result i32)
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
 (func $doublediamond_in_a_loop (; 16 ;) (param $0 i32) (param $1 i32) (param $2 i32) (result i32)
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
 (func $test3 (; 17 ;) (param $0 i32)
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
 (func $test4 (; 18 ;) (param $0 i32)
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
 (func $test5 (; 19 ;) (param $0 i32) (param $1 i32)
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
 (func $test6 (; 20 ;) (param $0 i32) (param $1 i32)
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
 (func $test7 (; 21 ;) (param $0 i32) (param $1 i32)
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
 (func $test8 (; 22 ;) (result i32)
  (loop $label$0 (result i32)
   (br_if $label$0
    (i32.const 0)
   )
   (br $label$0)
  )
 )
 (func $test9 (; 23 ;)
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
 (func $test10 (; 24 ;)
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
 (func $test11 (; 25 ;)
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
 (func $test12 (; 26 ;) (param $0 i32)
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
 (func $test13 (; 27 ;)
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
 (func $test14 (; 28 ;)
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
 (func $test15 (; 29 ;)
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
 (func $stackSave (; 30 ;) (result i32)
  (i32.load offset=4
   (i32.const 0)
  )
 )
 (func $stackAlloc (; 31 ;) (param $0 i32) (result i32)
  (local $1 i32)
  (i32.store offset=4
   (i32.const 0)
   (tee_local $1
    (i32.and
     (i32.sub
      (i32.load offset=4
       (i32.const 0)
      )
      (get_local $0)
     )
     (i32.const -16)
    )
   )
  )
  (get_local $1)
 )
 (func $stackRestore (; 32 ;) (param $0 i32)
  (i32.store offset=4
   (i32.const 0)
   (get_local $0)
  )
 )
)
;; METADATA: { "asmConsts": {},"staticBump": 1040, "initializers": [], "declares": ["a","bar","something","test15_callee0","test15_callee1"], "externs": [], "implementedFunctions": ["_test0","_test1","_test2","_doublediamond","_triangle","_diamond","_single_block","_minimal_loop","_simple_loop","_doubletriangle","_ifelse_earlyexits","_doublediamond_in_a_loop","_test3","_test4","_test5","_test6","_test7","_test8","_test9","_test10","_test11","_test12","_test13","_test14","_test15","_stackSave","_stackAlloc","_stackRestore"], "exports": ["test0","test1","test2","doublediamond","triangle","diamond","single_block","minimal_loop","simple_loop","doubletriangle","ifelse_earlyexits","doublediamond_in_a_loop","test3","test4","test5","test6","test7","test8","test9","test10","test11","test12","test13","test14","test15","stackSave","stackAlloc","stackRestore"], "invokeFuncs": [] }
