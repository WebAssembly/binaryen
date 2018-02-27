(module
 (type $FUNCSIG$dddd (func (param f64 f64 f64) (result f64)))
 (import "env" "fma" (func $fma (param f64 f64 f64) (result f64)))
 (import "env" "memory" (memory $0 1))
 (table 0 anyfunc)
 (data (i32.const 4) "\10\04\00\00")
 (export "fadd64" (func $fadd64))
 (export "fsub64" (func $fsub64))
 (export "fmul64" (func $fmul64))
 (export "fdiv64" (func $fdiv64))
 (export "fabs64" (func $fabs64))
 (export "fneg64" (func $fneg64))
 (export "copysign64" (func $copysign64))
 (export "sqrt64" (func $sqrt64))
 (export "ceil64" (func $ceil64))
 (export "floor64" (func $floor64))
 (export "trunc64" (func $trunc64))
 (export "nearest64" (func $nearest64))
 (export "nearest64_via_rint" (func $nearest64_via_rint))
 (export "fmin64" (func $fmin64))
 (export "fmax64" (func $fmax64))
 (export "fma64" (func $fma64))
 (export "stackSave" (func $stackSave))
 (export "stackAlloc" (func $stackAlloc))
 (export "stackRestore" (func $stackRestore))
 (func $fadd64 (; 1 ;) (param $0 f64) (param $1 f64) (result f64)
  (return
   (f64.add
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $fsub64 (; 2 ;) (param $0 f64) (param $1 f64) (result f64)
  (return
   (f64.sub
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $fmul64 (; 3 ;) (param $0 f64) (param $1 f64) (result f64)
  (return
   (f64.mul
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $fdiv64 (; 4 ;) (param $0 f64) (param $1 f64) (result f64)
  (return
   (f64.div
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $fabs64 (; 5 ;) (param $0 f64) (result f64)
  (return
   (f64.abs
    (get_local $0)
   )
  )
 )
 (func $fneg64 (; 6 ;) (param $0 f64) (result f64)
  (return
   (f64.neg
    (get_local $0)
   )
  )
 )
 (func $copysign64 (; 7 ;) (param $0 f64) (param $1 f64) (result f64)
  (return
   (f64.copysign
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $sqrt64 (; 8 ;) (param $0 f64) (result f64)
  (return
   (f64.sqrt
    (get_local $0)
   )
  )
 )
 (func $ceil64 (; 9 ;) (param $0 f64) (result f64)
  (return
   (f64.ceil
    (get_local $0)
   )
  )
 )
 (func $floor64 (; 10 ;) (param $0 f64) (result f64)
  (return
   (f64.floor
    (get_local $0)
   )
  )
 )
 (func $trunc64 (; 11 ;) (param $0 f64) (result f64)
  (return
   (f64.trunc
    (get_local $0)
   )
  )
 )
 (func $nearest64 (; 12 ;) (param $0 f64) (result f64)
  (return
   (f64.nearest
    (get_local $0)
   )
  )
 )
 (func $nearest64_via_rint (; 13 ;) (param $0 f64) (result f64)
  (return
   (f64.nearest
    (get_local $0)
   )
  )
 )
 (func $fmin64 (; 14 ;) (param $0 f64) (result f64)
  (return
   (f64.min
    (get_local $0)
    (f64.const 0)
   )
  )
 )
 (func $fmax64 (; 15 ;) (param $0 f64) (result f64)
  (return
   (f64.max
    (get_local $0)
    (f64.const 0)
   )
  )
 )
 (func $fma64 (; 16 ;) (param $0 f64) (param $1 f64) (param $2 f64) (result f64)
  (return
   (call $fma
    (get_local $0)
    (get_local $1)
    (get_local $2)
   )
  )
 )
 (func $stackSave (; 17 ;) (result i32)
  (i32.load offset=4
   (i32.const 0)
  )
 )
 (func $stackAlloc (; 18 ;) (param $0 i32) (result i32)
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
 (func $stackRestore (; 19 ;) (param $0 i32)
  (i32.store offset=4
   (i32.const 0)
   (get_local $0)
  )
 )
)
;; METADATA: { "asmConsts": {},"staticBump": 1040, "initializers": [], "declares": ["fma"], "externs": [], "implementedFunctions": ["_fadd64","_fsub64","_fmul64","_fdiv64","_fabs64","_fneg64","_copysign64","_sqrt64","_ceil64","_floor64","_trunc64","_nearest64","_nearest64_via_rint","_fmin64","_fmax64","_fma64","_stackSave","_stackAlloc","_stackRestore"], "exports": ["fadd64","fsub64","fmul64","fdiv64","fabs64","fneg64","copysign64","sqrt64","ceil64","floor64","trunc64","nearest64","nearest64_via_rint","fmin64","fmax64","fma64","stackSave","stackAlloc","stackRestore"], "invokeFuncs": [] }
