(module
 (type $FUNCSIG$i (func (result i32)))
 (type $FUNCSIG$v (func))
 (import "env" "getchar" (func $getchar (result i32)))
 (import "env" "memory" (memory $0 1))
 (table 5 5 anyfunc)
 (elem (i32.const 0) $__wasm_nullptr $c $b $d $a)
 (data (i32.const 16) "\04\00\00\00\02\00\00\00\01\00\00\00\03\00\00\00")
 (export "stackSave" (func $stackSave))
 (export "stackAlloc" (func $stackAlloc))
 (export "stackRestore" (func $stackRestore))
 (export "main" (func $main))
 (export "dynCall_i" (func $dynCall_i))
 (func $a (type $FUNCSIG$i) (result i32)
  (i32.const 0)
 )
 (func $b (type $FUNCSIG$i) (result i32)
  (i32.const 1)
 )
 (func $c (type $FUNCSIG$i) (result i32)
  (i32.const 2)
 )
 (func $d (type $FUNCSIG$i) (result i32)
  (i32.const 3)
 )
 (func $main (param $0 i32) (param $1 i32) (result i32)
  (local $2 i32)
  (block $label$0
   (br_if $label$0
    (i32.ge_u
     (tee_local $2
      (i32.load
       (i32.add
        (i32.shl
         (call $getchar)
         (i32.const 2)
        )
        (i32.const -176)
       )
      )
     )
     (i32.const 4)
    )
   )
   (return
    (call_indirect $FUNCSIG$i
     (get_local $2)
    )
   )
  )
  (unreachable)
  (unreachable)
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
 (func $__wasm_nullptr (type $FUNCSIG$v)
  (unreachable)
 )
 (func $dynCall_i (param $fptr i32) (result i32)
  (call_indirect $FUNCSIG$i
   (get_local $fptr)
  )
 )
)
;; METADATA: { "asmConsts": {},"staticBump": 32, "initializers": [] }
