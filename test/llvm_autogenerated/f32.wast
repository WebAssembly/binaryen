(module
 (type $FUNCSIG$ffff (func (param f32 f32 f32) (result f32)))
 (import "env" "fmaf" (func $fmaf (param f32 f32 f32) (result f32)))
 (import "env" "memory" (memory $0 1))
 (table 0 anyfunc)
 (data (i32.const 4) "\10\04\00\00")
 (export "fadd32" (func $fadd32))
 (export "fsub32" (func $fsub32))
 (export "fmul32" (func $fmul32))
 (export "fdiv32" (func $fdiv32))
 (export "fabs32" (func $fabs32))
 (export "fneg32" (func $fneg32))
 (export "copysign32" (func $copysign32))
 (export "sqrt32" (func $sqrt32))
 (export "ceil32" (func $ceil32))
 (export "floor32" (func $floor32))
 (export "trunc32" (func $trunc32))
 (export "nearest32" (func $nearest32))
 (export "nearest32_via_rint" (func $nearest32_via_rint))
 (export "fmin32" (func $fmin32))
 (export "fmax32" (func $fmax32))
 (export "fma32" (func $fma32))
 (export "stackSave" (func $stackSave))
 (export "stackAlloc" (func $stackAlloc))
 (export "stackRestore" (func $stackRestore))
 (func $fadd32 (; 1 ;) (param $0 f32) (param $1 f32) (result f32)
  (return
   (f32.add
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $fsub32 (; 2 ;) (param $0 f32) (param $1 f32) (result f32)
  (return
   (f32.sub
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $fmul32 (; 3 ;) (param $0 f32) (param $1 f32) (result f32)
  (return
   (f32.mul
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $fdiv32 (; 4 ;) (param $0 f32) (param $1 f32) (result f32)
  (return
   (f32.div
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $fabs32 (; 5 ;) (param $0 f32) (result f32)
  (return
   (f32.abs
    (get_local $0)
   )
  )
 )
 (func $fneg32 (; 6 ;) (param $0 f32) (result f32)
  (return
   (f32.neg
    (get_local $0)
   )
  )
 )
 (func $copysign32 (; 7 ;) (param $0 f32) (param $1 f32) (result f32)
  (return
   (f32.copysign
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $sqrt32 (; 8 ;) (param $0 f32) (result f32)
  (return
   (f32.sqrt
    (get_local $0)
   )
  )
 )
 (func $ceil32 (; 9 ;) (param $0 f32) (result f32)
  (return
   (f32.ceil
    (get_local $0)
   )
  )
 )
 (func $floor32 (; 10 ;) (param $0 f32) (result f32)
  (return
   (f32.floor
    (get_local $0)
   )
  )
 )
 (func $trunc32 (; 11 ;) (param $0 f32) (result f32)
  (return
   (f32.trunc
    (get_local $0)
   )
  )
 )
 (func $nearest32 (; 12 ;) (param $0 f32) (result f32)
  (return
   (f32.nearest
    (get_local $0)
   )
  )
 )
 (func $nearest32_via_rint (; 13 ;) (param $0 f32) (result f32)
  (return
   (f32.nearest
    (get_local $0)
   )
  )
 )
 (func $fmin32 (; 14 ;) (param $0 f32) (result f32)
  (return
   (f32.min
    (get_local $0)
    (f32.const 0)
   )
  )
 )
 (func $fmax32 (; 15 ;) (param $0 f32) (result f32)
  (return
   (f32.max
    (get_local $0)
    (f32.const 0)
   )
  )
 )
 (func $fma32 (; 16 ;) (param $0 f32) (param $1 f32) (param $2 f32) (result f32)
  (return
   (call $fmaf
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
;; METADATA: { "asmConsts": {},"staticBump": 1040, "initializers": [], "declares": ["fmaf"], "externs": [], "implementedFunctions": ["_fadd32","_fsub32","_fmul32","_fdiv32","_fabs32","_fneg32","_copysign32","_sqrt32","_ceil32","_floor32","_trunc32","_nearest32","_nearest32_via_rint","_fmin32","_fmax32","_fma32","_stackSave","_stackAlloc","_stackRestore"], "exports": ["fadd32","fsub32","fmul32","fdiv32","fabs32","fneg32","copysign32","sqrt32","ceil32","floor32","trunc32","nearest32","nearest32_via_rint","fmin32","fmax32","fma32","stackSave","stackAlloc","stackRestore"], "invokeFuncs": [] }
