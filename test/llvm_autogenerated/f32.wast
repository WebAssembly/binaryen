(module
 (type $FUNCSIG$ffff (func (param f32 f32 f32) (result f32)))
 (import "env" "fmaf" (func $fmaf (param f32 f32 f32) (result f32)))
 (import "env" "memory" (memory $0 1))
 (table 0 anyfunc)
 (data (i32.const 4) "\10\04\00\00")
 (export "stackSave" (func $stackSave))
 (export "stackAlloc" (func $stackAlloc))
 (export "stackRestore" (func $stackRestore))
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
 (func $fadd32 (param $0 f32) (param $1 f32) (result f32)
  (return
   (f32.add
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $fsub32 (param $0 f32) (param $1 f32) (result f32)
  (return
   (f32.sub
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $fmul32 (param $0 f32) (param $1 f32) (result f32)
  (return
   (f32.mul
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $fdiv32 (param $0 f32) (param $1 f32) (result f32)
  (return
   (f32.div
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $fabs32 (param $0 f32) (result f32)
  (return
   (f32.abs
    (get_local $0)
   )
  )
 )
 (func $fneg32 (param $0 f32) (result f32)
  (return
   (f32.neg
    (get_local $0)
   )
  )
 )
 (func $copysign32 (param $0 f32) (param $1 f32) (result f32)
  (return
   (f32.copysign
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $sqrt32 (param $0 f32) (result f32)
  (return
   (f32.sqrt
    (get_local $0)
   )
  )
 )
 (func $ceil32 (param $0 f32) (result f32)
  (return
   (f32.ceil
    (get_local $0)
   )
  )
 )
 (func $floor32 (param $0 f32) (result f32)
  (return
   (f32.floor
    (get_local $0)
   )
  )
 )
 (func $trunc32 (param $0 f32) (result f32)
  (return
   (f32.trunc
    (get_local $0)
   )
  )
 )
 (func $nearest32 (param $0 f32) (result f32)
  (return
   (f32.nearest
    (get_local $0)
   )
  )
 )
 (func $nearest32_via_rint (param $0 f32) (result f32)
  (return
   (f32.nearest
    (get_local $0)
   )
  )
 )
 (func $fmin32 (param $0 f32) (result f32)
  (return
   (f32.min
    (get_local $0)
    (f32.const 0)
   )
  )
 )
 (func $fmax32 (param $0 f32) (result f32)
  (return
   (f32.max
    (get_local $0)
    (f32.const 0)
   )
  )
 )
 (func $fma32 (param $0 f32) (param $1 f32) (param $2 f32) (result f32)
  (return
   (call $fmaf
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
