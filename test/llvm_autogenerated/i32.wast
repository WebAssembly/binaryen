(module
 (import "env" "memory" (memory $0 1))
 (table 0 anyfunc)
 (data (i32.const 4) "\10\04\00\00")
 (export "stackSave" (func $stackSave))
 (export "stackAlloc" (func $stackAlloc))
 (export "stackRestore" (func $stackRestore))
 (export "add32" (func $add32))
 (export "sub32" (func $sub32))
 (export "mul32" (func $mul32))
 (export "sdiv32" (func $sdiv32))
 (export "udiv32" (func $udiv32))
 (export "srem32" (func $srem32))
 (export "urem32" (func $urem32))
 (export "and32" (func $and32))
 (export "or32" (func $or32))
 (export "xor32" (func $xor32))
 (export "shl32" (func $shl32))
 (export "shr32" (func $shr32))
 (export "sar32" (func $sar32))
 (export "clz32" (func $clz32))
 (export "clz32_zero_undef" (func $clz32_zero_undef))
 (export "ctz32" (func $ctz32))
 (export "ctz32_zero_undef" (func $ctz32_zero_undef))
 (export "popcnt32" (func $popcnt32))
 (export "eqz32" (func $eqz32))
 (export "rotl" (func $rotl))
 (export "masked_rotl" (func $masked_rotl))
 (export "rotr" (func $rotr))
 (export "masked_rotr" (func $masked_rotr))
 (func $add32 (param $0 i32) (param $1 i32) (result i32)
  (return
   (i32.add
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $sub32 (param $0 i32) (param $1 i32) (result i32)
  (return
   (i32.sub
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $mul32 (param $0 i32) (param $1 i32) (result i32)
  (return
   (i32.mul
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $sdiv32 (param $0 i32) (param $1 i32) (result i32)
  (return
   (i32.div_s
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $udiv32 (param $0 i32) (param $1 i32) (result i32)
  (return
   (i32.div_u
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $srem32 (param $0 i32) (param $1 i32) (result i32)
  (return
   (i32.rem_s
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $urem32 (param $0 i32) (param $1 i32) (result i32)
  (return
   (i32.rem_u
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $and32 (param $0 i32) (param $1 i32) (result i32)
  (return
   (i32.and
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $or32 (param $0 i32) (param $1 i32) (result i32)
  (return
   (i32.or
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $xor32 (param $0 i32) (param $1 i32) (result i32)
  (return
   (i32.xor
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $shl32 (param $0 i32) (param $1 i32) (result i32)
  (return
   (i32.shl
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $shr32 (param $0 i32) (param $1 i32) (result i32)
  (return
   (i32.shr_u
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $sar32 (param $0 i32) (param $1 i32) (result i32)
  (return
   (i32.shr_s
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $clz32 (param $0 i32) (result i32)
  (return
   (i32.clz
    (get_local $0)
   )
  )
 )
 (func $clz32_zero_undef (param $0 i32) (result i32)
  (return
   (i32.clz
    (get_local $0)
   )
  )
 )
 (func $ctz32 (param $0 i32) (result i32)
  (return
   (i32.ctz
    (get_local $0)
   )
  )
 )
 (func $ctz32_zero_undef (param $0 i32) (result i32)
  (return
   (i32.ctz
    (get_local $0)
   )
  )
 )
 (func $popcnt32 (param $0 i32) (result i32)
  (return
   (i32.popcnt
    (get_local $0)
   )
  )
 )
 (func $eqz32 (param $0 i32) (result i32)
  (return
   (i32.eqz
    (get_local $0)
   )
  )
 )
 (func $rotl (param $0 i32) (param $1 i32) (result i32)
  (return
   (i32.rotl
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $masked_rotl (param $0 i32) (param $1 i32) (result i32)
  (return
   (i32.rotl
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $rotr (param $0 i32) (param $1 i32) (result i32)
  (return
   (i32.rotr
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $masked_rotr (param $0 i32) (param $1 i32) (result i32)
  (return
   (i32.rotr
    (get_local $0)
    (get_local $1)
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
