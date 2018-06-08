(module
 (type $FUNCSIG$vi (func (param i32)))
 (type $FUNCSIG$v (func))
 (type $FUNCSIG$iii (func (param i32 i32) (result i32)))
 (import "env" "puts" (func $puts (param i32)))
 (import "env" "memory" (memory $0 1))
 (table 2 2 anyfunc)
 (elem (i32.const 0) $__wasm_nullptr $main)
 (data (i32.const 16) "hello, world!\n\00")
 (data (i32.const 32) "vcq")
 (data (i32.const 48) "\16\00\00\00")
 (export "main" (func $main))
 (export "stackSave" (func $stackSave))
 (export "stackAlloc" (func $stackAlloc))
 (export "stackRestore" (func $stackRestore))
 (export "dynCall_iii" (func $dynCall_iii))
 (func $main (; 1 ;) (type $FUNCSIG$iii) (param $0 i32) (param $1 i32) (result i32)
  (call $puts
   (i32.const 16)
  )
  (block $label$0
   (block $label$1
    (br_if $label$1
     (i32.ne
      (i32.sub
       (get_local $0)
       (i32.and
        (i32.add
         (get_local $0)
         (i32.shr_u
          (i32.shr_s
           (get_local $0)
           (i32.const 31)
          )
          (i32.const 30)
         )
        )
        (i32.const -4)
       )
      )
      (i32.const 1)
     )
    )
    (block $label$2
     (loop $label$3
      (set_local $0
       (i32.add
        (i32.gt_s
         (get_local $0)
         (i32.const 10)
        )
        (get_local $0)
       )
      )
      (block $label$4
       (br_if $label$4
        (i32.ne
         (i32.rem_s
          (get_local $0)
          (i32.const 5)
         )
         (i32.const 3)
        )
       )
       (set_local $0
        (i32.add
         (i32.rem_s
          (get_local $0)
          (i32.const 111)
         )
         (get_local $0)
        )
       )
      )
      (br_if $label$1
       (i32.eq
        (i32.rem_s
         (get_local $0)
         (i32.const 7)
        )
        (i32.const 0)
       )
      )
      (br $label$3)
     )
    )
   )
   (set_local $0
    (i32.add
     (get_local $0)
     (i32.const -12)
    )
   )
   (drop
    (i32.const 1)
   )
  )
  (get_local $0)
 )
 (func $__wasm_nullptr (; 2 ;) (type $FUNCSIG$v)
  (unreachable)
 )
 (func $stackSave (; 3 ;) (result i32)
  (i32.load offset=4
   (i32.const 0)
  )
 )
 (func $stackAlloc (; 4 ;) (param $0 i32) (result i32)
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
 (func $stackRestore (; 5 ;) (param $0 i32)
  (i32.store offset=4
   (i32.const 0)
   (get_local $0)
  )
 )
 (func $dynCall_iii (; 6 ;) (param $fptr i32) (param $0 i32) (param $1 i32) (result i32)
  (call_indirect (type $FUNCSIG$iii)
   (get_local $0)
   (get_local $1)
   (get_local $fptr)
  )
 )
)
;; METADATA: { "asmConsts": {},"staticBump": 52, "initializers": [], "declares": ["puts"], "externs": [], "implementedFunctions": ["_main","_stackSave","_stackAlloc","_stackRestore","_dynCall_iii"], "exports": ["main","stackSave","stackAlloc","stackRestore","dynCall_iii"], "invokeFuncs": [] }
