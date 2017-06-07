(module
 (import "env" "memory" (memory $0 1))
 (table 0 anyfunc)
 (data (i32.const 4) "\10\04\00\00")
 (export "stackSave" (func $stackSave))
 (export "stackAlloc" (func $stackAlloc))
 (export "stackRestore" (func $stackRestore))
 (export "z2s_func" (func $z2s_func))
 (export "s2z_func" (func $s2z_func))
 (export "z2s_call" (func $z2s_call))
 (export "s2z_call" (func $s2z_call))
 (func $z2s_func (param $0 i32) (result i32)
  (return
   (i32.shr_s
    (i32.shl
     (get_local $0)
     (i32.const 24)
    )
    (i32.const 24)
   )
  )
 )
 (func $s2z_func (param $0 i32) (result i32)
  (return
   (i32.and
    (get_local $0)
    (i32.const 255)
   )
  )
 )
 (func $z2s_call (param $0 i32) (result i32)
  (return
   (call $z2s_func
    (i32.and
     (get_local $0)
     (i32.const 255)
    )
   )
  )
 )
 (func $s2z_call (param $0 i32) (result i32)
  (return
   (i32.shr_s
    (i32.shl
     (call $s2z_func
      (i32.shr_s
       (i32.shl
        (get_local $0)
        (i32.const 24)
       )
       (i32.const 24)
      )
     )
     (i32.const 24)
    )
    (i32.const 24)
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
;; METADATA: { "asmConsts": {},"staticBump": 1040, "initializers": [] }
