(module
 (type $FUNCSIG$iiii (func (param i32 i32 i32) (result i32)))
 (import "env" "memcpy" (func $memcpy (param i32 i32 i32) (result i32)))
 (import "env" "memory" (memory $0 1))
 (table 0 anyfunc)
 (data (i32.const 4) "\b0\08\00\00")
 (data (i32.const 12) "9\05\00\00")
 (data (i32.const 28) "\01\00\00\00")
 (data (i32.const 32) "*\00\00\00")
 (data (i32.const 36) "\ff\ff\ff\ff")
 (data (i32.const 64) "\00\00\00\00\01\00\00\00")
 (data (i32.const 72) "\ff\ff\ff\ff\ff\ff\ff\ff")
 (data (i32.const 92) "\00\00\00\80")
 (data (i32.const 96) "\00\00\00@")
 (data (i32.const 128) "\00\00\00\00\00\00\00\80")
 (data (i32.const 136) "\00\00\00\00\00\00\00@")
 (data (i32.const 656) "\e0\00\00\00")
 (data (i32.const 1192) "\a4\04\00\00")
 (export "stackSave" (func $stackSave))
 (export "stackAlloc" (func $stackAlloc))
 (export "stackRestore" (func $stackRestore))
 (export "foo" (func $foo))
 (export "call_memcpy" (func $call_memcpy))
 (func $foo (result i32)
  (return
   (i32.load offset=32
    (i32.const 0)
   )
  )
 )
 (func $call_memcpy (param $0 i32) (param $1 i32) (param $2 i32) (result i32)
  (return
   (call $memcpy
    (get_local $0)
    (get_local $1)
    (get_local $2)
   )
  )
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
;; METADATA: { "asmConsts": {},"staticBump": 2224, "initializers": [] }
