(module
 (import "env" "memory" (memory $0 1))
 (table 0 anyfunc)
 (data (i32.const 4) "\10\04\00\00")
 (export "stackSave" (func $stackSave))
 (export "stackAlloc" (func $stackAlloc))
 (export "stackRestore" (func $stackRestore))
 (export "add64" (func $add64))
 (export "sub64" (func $sub64))
 (export "mul64" (func $mul64))
 (export "sdiv64" (func $sdiv64))
 (export "udiv64" (func $udiv64))
 (export "srem64" (func $srem64))
 (export "urem64" (func $urem64))
 (export "and64" (func $and64))
 (export "or64" (func $or64))
 (export "xor64" (func $xor64))
 (export "shl64" (func $shl64))
 (export "shr64" (func $shr64))
 (export "sar64" (func $sar64))
 (export "clz64" (func $clz64))
 (export "clz64_zero_undef" (func $clz64_zero_undef))
 (export "ctz64" (func $ctz64))
 (export "ctz64_zero_undef" (func $ctz64_zero_undef))
 (export "popcnt64" (func $popcnt64))
 (export "eqz64" (func $eqz64))
 (export "rotl" (func $rotl))
 (export "masked_rotl" (func $masked_rotl))
 (export "rotr" (func $rotr))
 (export "masked_rotr" (func $masked_rotr))
 (func $add64 (param $0 i64) (param $1 i64) (result i64)
  (return
   (i64.add
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $sub64 (param $0 i64) (param $1 i64) (result i64)
  (return
   (i64.sub
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $mul64 (param $0 i64) (param $1 i64) (result i64)
  (return
   (i64.mul
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $sdiv64 (param $0 i64) (param $1 i64) (result i64)
  (return
   (i64.div_s
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $udiv64 (param $0 i64) (param $1 i64) (result i64)
  (return
   (i64.div_u
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $srem64 (param $0 i64) (param $1 i64) (result i64)
  (return
   (i64.rem_s
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $urem64 (param $0 i64) (param $1 i64) (result i64)
  (return
   (i64.rem_u
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $and64 (param $0 i64) (param $1 i64) (result i64)
  (return
   (i64.and
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $or64 (param $0 i64) (param $1 i64) (result i64)
  (return
   (i64.or
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $xor64 (param $0 i64) (param $1 i64) (result i64)
  (return
   (i64.xor
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $shl64 (param $0 i64) (param $1 i64) (result i64)
  (return
   (i64.shl
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $shr64 (param $0 i64) (param $1 i64) (result i64)
  (return
   (i64.shr_u
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $sar64 (param $0 i64) (param $1 i64) (result i64)
  (return
   (i64.shr_s
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $clz64 (param $0 i64) (result i64)
  (return
   (i64.clz
    (get_local $0)
   )
  )
 )
 (func $clz64_zero_undef (param $0 i64) (result i64)
  (return
   (i64.clz
    (get_local $0)
   )
  )
 )
 (func $ctz64 (param $0 i64) (result i64)
  (return
   (i64.ctz
    (get_local $0)
   )
  )
 )
 (func $ctz64_zero_undef (param $0 i64) (result i64)
  (return
   (i64.ctz
    (get_local $0)
   )
  )
 )
 (func $popcnt64 (param $0 i64) (result i64)
  (return
   (i64.popcnt
    (get_local $0)
   )
  )
 )
 (func $eqz64 (param $0 i64) (result i32)
  (return
   (i64.eqz
    (get_local $0)
   )
  )
 )
 (func $rotl (param $0 i64) (param $1 i64) (result i64)
  (return
   (i64.rotl
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $masked_rotl (param $0 i64) (param $1 i64) (result i64)
  (return
   (i64.rotl
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $rotr (param $0 i64) (param $1 i64) (result i64)
  (return
   (i64.rotr
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $masked_rotr (param $0 i64) (param $1 i64) (result i64)
  (return
   (i64.rotr
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
