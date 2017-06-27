(module
 (type $FUNCSIG$fd (func (param f64) (result f32)))
 (type $FUNCSIG$vj (func (param i64)))
 (type $FUNCSIG$v (func))
 (type $FUNCSIG$ijidf (func (param i64 i32 f64 f32) (result i32)))
 (type $FUNCSIG$vi (func (param i32)))
 (type $FUNCSIG$vij (func (param i32 i64)))
 (import "env" "extern_ijidf" (func $extern_ijidf (param i64 i32 f64 f32) (result i32)))
 (import "env" "extern_v" (func $extern_v))
 (import "env" "extern_vj" (func $extern_vj (param i64)))
 (import "env" "memory" (memory $0 1))
 (import "env" "extern_fd" (func $extern_fd (param f64) (result f32)))
 (import "env" "extern_struct" (func $extern_struct (param i32)))
 (import "env" "extern_sret" (func $extern_sret (param i32)))
 (table 7 7 anyfunc)
 (elem (i32.const 0) $__wasm_nullptr $__importThunk_extern_fd $__importThunk_extern_vj $__importThunk_extern_v $__importThunk_extern_ijidf $__importThunk_extern_struct $__importThunk_extern_sret)
 (data (i32.const 4) "\10\04\00\00")
 (export "stackSave" (func $stackSave))
 (export "stackAlloc" (func $stackAlloc))
 (export "stackRestore" (func $stackRestore))
 (export "bar" (func $bar))
 (export "dynCall_fd" (func $dynCall_fd))
 (export "dynCall_v" (func $dynCall_v))
 (export "dynCall_vi" (func $dynCall_vi))
 (func $bar (result i32)
  (local $0 i32)
  (local $1 i32)
  (i32.store offset=4
   (i32.const 0)
   (tee_local $1
    (i32.sub
     (i32.load offset=4
      (i32.const 0)
     )
     (i32.const 32)
    )
   )
  )
  (i32.store offset=28
   (get_local $1)
   (i32.const 1)
  )
  (i32.store offset=24
   (get_local $1)
   (i32.const 2)
  )
  (call $extern_vj
   (i64.const 1)
  )
  (i32.store offset=20
   (get_local $1)
   (i32.const 3)
  )
  (call $extern_v)
  (i32.store offset=16
   (get_local $1)
   (i32.const 4)
  )
  (drop
   (call $extern_ijidf
    (i64.const 1)
    (i32.const 2)
    (f64.const 3)
    (f32.const 4)
   )
  )
  (i32.store offset=12
   (get_local $1)
   (i32.const 5)
  )
  (i32.store offset=8
   (get_local $1)
   (i32.const 6)
  )
  (set_local $0
   (i32.load offset=28
    (get_local $1)
   )
  )
  (i32.store offset=4
   (i32.const 0)
   (i32.add
    (get_local $1)
    (i32.const 32)
   )
  )
  (return
   (get_local $0)
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
 (func $__wasm_nullptr (type $FUNCSIG$v)
  (unreachable)
 )
 (func $__importThunk_extern_fd (type $FUNCSIG$fd) (param $0 f64) (result f32)
  (call $extern_fd
   (get_local $0)
  )
 )
 (func $__importThunk_extern_vj (type $FUNCSIG$vj) (param $0 i64)
  (call $extern_vj
   (get_local $0)
  )
 )
 (func $__importThunk_extern_v (type $FUNCSIG$v)
  (call $extern_v)
 )
 (func $__importThunk_extern_ijidf (type $FUNCSIG$ijidf) (param $0 i64) (param $1 i32) (param $2 f64) (param $3 f32) (result i32)
  (call $extern_ijidf
   (get_local $0)
   (get_local $1)
   (get_local $2)
   (get_local $3)
  )
 )
 (func $__importThunk_extern_struct (type $FUNCSIG$vi) (param $0 i32)
  (call $extern_struct
   (get_local $0)
  )
 )
 (func $__importThunk_extern_sret (type $FUNCSIG$vi) (param $0 i32)
  (call $extern_sret
   (get_local $0)
  )
 )
 (func $dynCall_fd (param $fptr i32) (param $0 f64) (result f32)
  (call_indirect $FUNCSIG$fd
   (get_local $0)
   (get_local $fptr)
  )
 )
 (func $dynCall_v (param $fptr i32)
  (call_indirect $FUNCSIG$v
   (get_local $fptr)
  )
 )
 (func $dynCall_vi (param $fptr i32) (param $0 i32)
  (call_indirect $FUNCSIG$vi
   (get_local $0)
   (get_local $fptr)
  )
 )
)
;; METADATA: { "asmConsts": {},"staticBump": 1040, "initializers": [] }
