(module
 (type $FUNCSIG$dddd (func (param f64 f64 f64) (result f64)))
 (import "env" "fma" (func $fma (param f64 f64 f64) (result f64)))
 (import "env" "memory" (memory $0 1))
 (table 0 anyfunc)
 (data (i32.const 4) "\10\04\00\00")
 (export "stackSave" (func $stackSave))
 (export "stackAlloc" (func $stackAlloc))
 (export "stackRestore" (func $stackRestore))
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
 (func $fadd64 (param $0 f64) (param $1 f64) (result f64)
  (return
   (f64.add
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $fsub64 (param $0 f64) (param $1 f64) (result f64)
  (return
   (f64.sub
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $fmul64 (param $0 f64) (param $1 f64) (result f64)
  (return
   (f64.mul
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $fdiv64 (param $0 f64) (param $1 f64) (result f64)
  (return
   (f64.div
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $fabs64 (param $0 f64) (result f64)
  (return
   (f64.abs
    (get_local $0)
   )
  )
 )
 (func $fneg64 (param $0 f64) (result f64)
  (return
   (f64.neg
    (get_local $0)
   )
  )
 )
 (func $copysign64 (param $0 f64) (param $1 f64) (result f64)
  (return
   (f64.copysign
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $sqrt64 (param $0 f64) (result f64)
  (return
   (f64.sqrt
    (get_local $0)
   )
  )
 )
 (func $ceil64 (param $0 f64) (result f64)
  (return
   (f64.ceil
    (get_local $0)
   )
  )
 )
 (func $floor64 (param $0 f64) (result f64)
  (return
   (f64.floor
    (get_local $0)
   )
  )
 )
 (func $trunc64 (param $0 f64) (result f64)
  (return
   (f64.trunc
    (get_local $0)
   )
  )
 )
 (func $nearest64 (param $0 f64) (result f64)
  (return
   (f64.nearest
    (get_local $0)
   )
  )
 )
 (func $nearest64_via_rint (param $0 f64) (result f64)
  (return
   (f64.nearest
    (get_local $0)
   )
  )
 )
 (func $fmin64 (param $0 f64) (result f64)
  (return
   (f64.min
    (get_local $0)
    (f64.const 0)
   )
  )
 )
 (func $fmax64 (param $0 f64) (result f64)
  (return
   (f64.max
    (get_local $0)
    (f64.const 0)
   )
  )
 )
 (func $fma64 (param $0 f64) (param $1 f64) (param $2 f64) (result f64)
  (return
   (call $fma
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
;; METADATA: { "asmConsts": {},"staticBump": 1040, "initializers": [] }
