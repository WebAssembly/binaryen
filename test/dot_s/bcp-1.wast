(module
 (type $FUNCSIG$i (func (result i32)))
 (type $FUNCSIG$ii (func (param i32) (result i32)))
 (type $FUNCSIG$v (func))
 (type $FUNCSIG$vi (func (param i32)))
 (import "env" "abort" (func $abort))
 (import "env" "exit" (func $exit (param i32)))
 (import "env" "memory" (memory $0 1))
 (table 18 18 anyfunc)
 (elem (i32.const 0) $__wasm_nullptr $bad0 $bad1 $bad5 $bad7 $bad8 $bad10 $bad2 $bad3 $bad6 $bad4 $bad9 $good0 $good1 $good2 $opt0 $opt1 $opt2)
 (data (i32.const 16) "\01\00\00\00\02\00\00\00\03\00\00\00\04\00\00\00\05\00\00\00\06\00\00\00")
 (data (i32.const 40) "\07\00\00\00\08\00\00\00\t\00\00\00")
 (data (i32.const 52) "\n\00\00\00\0b\00\00\00")
 (data (i32.const 60) "\0c\00\00\00\0d\00\00\00\0e\00\00\00")
 (data (i32.const 72) "\0f\00\00\00\10\00\00\00\11\00\00\00")
 (data (i32.const 96) "hi\00")
 (data (i32.const 100) "\00\00\00\00")
 (export "bad0" (func $bad0))
 (export "bad1" (func $bad1))
 (export "bad2" (func $bad2))
 (export "bad3" (func $bad3))
 (export "bad4" (func $bad4))
 (export "bad5" (func $bad5))
 (export "bad6" (func $bad6))
 (export "bad7" (func $bad7))
 (export "bad8" (func $bad8))
 (export "bad9" (func $bad9))
 (export "bad10" (func $bad10))
 (export "good0" (func $good0))
 (export "good1" (func $good1))
 (export "good2" (func $good2))
 (export "opt0" (func $opt0))
 (export "opt1" (func $opt1))
 (export "opt2" (func $opt2))
 (export "main" (func $main))
 (export "stackSave" (func $stackSave))
 (export "stackAlloc" (func $stackAlloc))
 (export "stackRestore" (func $stackRestore))
 (export "dynCall_i" (func $dynCall_i))
 (export "dynCall_ii" (func $dynCall_ii))
 (func $bad0 (; 2 ;) (type $FUNCSIG$i) (result i32)
  (return
   (i32.const 0)
  )
 )
 (func $bad1 (; 3 ;) (type $FUNCSIG$i) (result i32)
  (return
   (i32.const 0)
  )
 )
 (func $bad2 (; 4 ;) (type $FUNCSIG$ii) (param $0 i32) (result i32)
  (return
   (i32.const 0)
  )
 )
 (func $bad3 (; 5 ;) (type $FUNCSIG$ii) (param $0 i32) (result i32)
  (return
   (i32.const 0)
  )
 )
 (func $bad4 (; 6 ;) (type $FUNCSIG$ii) (param $0 i32) (result i32)
  (return
   (i32.const 0)
  )
 )
 (func $bad5 (; 7 ;) (type $FUNCSIG$i) (result i32)
  (return
   (i32.const 0)
  )
 )
 (func $bad6 (; 8 ;) (type $FUNCSIG$ii) (param $0 i32) (result i32)
  (return
   (i32.const 0)
  )
 )
 (func $bad7 (; 9 ;) (type $FUNCSIG$i) (result i32)
  (return
   (i32.const 0)
  )
 )
 (func $bad8 (; 10 ;) (type $FUNCSIG$i) (result i32)
  (return
   (i32.const 0)
  )
 )
 (func $bad9 (; 11 ;) (type $FUNCSIG$ii) (param $0 i32) (result i32)
  (return
   (i32.const 0)
  )
 )
 (func $bad10 (; 12 ;) (type $FUNCSIG$i) (result i32)
  (return
   (i32.const 0)
  )
 )
 (func $good0 (; 13 ;) (type $FUNCSIG$i) (result i32)
  (return
   (i32.const 1)
  )
 )
 (func $good1 (; 14 ;) (type $FUNCSIG$i) (result i32)
  (return
   (i32.const 1)
  )
 )
 (func $good2 (; 15 ;) (type $FUNCSIG$i) (result i32)
  (return
   (i32.const 1)
  )
 )
 (func $opt0 (; 16 ;) (type $FUNCSIG$i) (result i32)
  (return
   (i32.const 0)
  )
 )
 (func $opt1 (; 17 ;) (type $FUNCSIG$i) (result i32)
  (return
   (i32.const 0)
  )
 )
 (func $opt2 (; 18 ;) (type $FUNCSIG$i) (result i32)
  (return
   (i32.const 1)
  )
 )
 (func $main (; 19 ;) (result i32)
  (local $0 i32)
  (local $1 i32)
  (local $2 i32)
  (set_local $0
   (i32.const 0)
  )
  (block $label$0
   (br_if $label$0
    (call_indirect (type $FUNCSIG$i)
     (i32.load offset=16
      (get_local $0)
     )
    )
   )
   (br_if $label$0
    (call_indirect (type $FUNCSIG$i)
     (i32.load offset=20
      (get_local $0)
     )
    )
   )
   (br_if $label$0
    (call_indirect (type $FUNCSIG$i)
     (i32.load offset=24
      (get_local $0)
     )
    )
   )
   (br_if $label$0
    (call_indirect (type $FUNCSIG$i)
     (i32.load offset=28
      (get_local $0)
     )
    )
   )
   (br_if $label$0
    (call_indirect (type $FUNCSIG$i)
     (i32.load offset=32
      (get_local $0)
     )
    )
   )
   (br_if $label$0
    (call_indirect (type $FUNCSIG$i)
     (i32.load offset=36
      (get_local $0)
     )
    )
   )
   (set_local $1
    (i32.load offset=40
     (get_local $0)
    )
   )
   (set_local $2
    (i32.const 1)
   )
   (block $label$1
    (br_if $label$1
     (call_indirect (type $FUNCSIG$ii)
      (get_local $2)
      (get_local $1)
     )
    )
    (br_if $label$1
     (call_indirect (type $FUNCSIG$ii)
      (get_local $2)
      (i32.load offset=44
       (get_local $0)
      )
     )
    )
    (br_if $label$1
     (call_indirect (type $FUNCSIG$ii)
      (get_local $2)
      (i32.load offset=48
       (get_local $0)
      )
     )
    )
    (set_local $1
     (i32.load offset=52
      (get_local $0)
     )
    )
    (set_local $2
     (i32.const 96)
    )
    (block $label$2
     (br_if $label$2
      (call_indirect (type $FUNCSIG$ii)
       (get_local $2)
       (get_local $1)
      )
     )
     (br_if $label$2
      (call_indirect (type $FUNCSIG$ii)
       (get_local $2)
       (i32.load offset=56
        (get_local $0)
       )
      )
     )
     (block $label$3
      (br_if $label$3
       (i32.eq
        (call_indirect (type $FUNCSIG$i)
         (i32.load offset=60
          (get_local $0)
         )
        )
        (i32.const 0)
       )
      )
      (br_if $label$3
       (i32.eq
        (call_indirect (type $FUNCSIG$i)
         (i32.load offset=64
          (get_local $0)
         )
        )
        (i32.const 0)
       )
      )
      (br_if $label$3
       (i32.eq
        (call_indirect (type $FUNCSIG$i)
         (i32.load offset=68
          (get_local $0)
         )
        )
        (i32.const 0)
       )
      )
      (block $label$4
       (br_if $label$4
        (i32.eq
         (call_indirect (type $FUNCSIG$i)
          (i32.load offset=72
           (get_local $0)
          )
         )
         (i32.const 0)
        )
       )
       (br_if $label$4
        (i32.eq
         (call_indirect (type $FUNCSIG$i)
          (i32.load offset=76
           (get_local $0)
          )
         )
         (i32.const 0)
        )
       )
       (br_if $label$4
        (i32.eq
         (call_indirect (type $FUNCSIG$i)
          (i32.load offset=80
           (get_local $0)
          )
         )
         (i32.const 0)
        )
       )
       (call $exit
        (get_local $0)
       )
       (unreachable)
      )
      (call $abort)
      (unreachable)
     )
     (call $abort)
     (unreachable)
    )
    (call $abort)
    (unreachable)
   )
   (call $abort)
   (unreachable)
  )
  (call $abort)
  (unreachable)
 )
 (func $__wasm_nullptr (; 20 ;) (type $FUNCSIG$v)
  (unreachable)
 )
 (func $stackSave (; 21 ;) (result i32)
  (i32.load offset=4
   (i32.const 0)
  )
 )
 (func $stackAlloc (; 22 ;) (param $0 i32) (result i32)
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
 (func $stackRestore (; 23 ;) (param $0 i32)
  (i32.store offset=4
   (i32.const 0)
   (get_local $0)
  )
 )
 (func $dynCall_i (; 24 ;) (param $fptr i32) (result i32)
  (call_indirect (type $FUNCSIG$i)
   (get_local $fptr)
  )
 )
 (func $dynCall_ii (; 25 ;) (param $fptr i32) (param $0 i32) (result i32)
  (call_indirect (type $FUNCSIG$ii)
   (get_local $0)
   (get_local $fptr)
  )
 )
)
;; METADATA: { "asmConsts": {},"staticBump": 104, "initializers": [], "declares": ["abort","exit"], "externs": [], "implementedFunctions": ["_bad0","_bad1","_bad2","_bad3","_bad4","_bad5","_bad6","_bad7","_bad8","_bad9","_bad10","_good0","_good1","_good2","_opt0","_opt1","_opt2","_main","_stackSave","_stackAlloc","_stackRestore","_dynCall_i","_dynCall_ii"], "exports": ["bad0","bad1","bad2","bad3","bad4","bad5","bad6","bad7","bad8","bad9","bad10","good0","good1","good2","opt0","opt1","opt2","main","stackSave","stackAlloc","stackRestore","dynCall_i","dynCall_ii"], "invokeFuncs": [] }
