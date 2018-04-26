(module
 (import "env" "memory" (memory $0 1))
 (table 0 anyfunc)
 (data (i32.const 4) "\10\04\00\00")
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
 (export "stackSave" (func $stackSave))
 (export "stackAlloc" (func $stackAlloc))
 (export "stackRestore" (func $stackRestore))
 (func $add64 (; 0 ;) (param $0 i64) (param $1 i64) (result i64)
  (return
   (i64.add
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $sub64 (; 1 ;) (param $0 i64) (param $1 i64) (result i64)
  (return
   (i64.sub
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $mul64 (; 2 ;) (param $0 i64) (param $1 i64) (result i64)
  (return
   (i64.mul
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $sdiv64 (; 3 ;) (param $0 i64) (param $1 i64) (result i64)
  (return
   (i64.div_s
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $udiv64 (; 4 ;) (param $0 i64) (param $1 i64) (result i64)
  (return
   (i64.div_u
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $srem64 (; 5 ;) (param $0 i64) (param $1 i64) (result i64)
  (return
   (i64.rem_s
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $urem64 (; 6 ;) (param $0 i64) (param $1 i64) (result i64)
  (return
   (i64.rem_u
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $and64 (; 7 ;) (param $0 i64) (param $1 i64) (result i64)
  (return
   (i64.and
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $or64 (; 8 ;) (param $0 i64) (param $1 i64) (result i64)
  (return
   (i64.or
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $xor64 (; 9 ;) (param $0 i64) (param $1 i64) (result i64)
  (return
   (i64.xor
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $shl64 (; 10 ;) (param $0 i64) (param $1 i64) (result i64)
  (return
   (i64.shl
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $shr64 (; 11 ;) (param $0 i64) (param $1 i64) (result i64)
  (return
   (i64.shr_u
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $sar64 (; 12 ;) (param $0 i64) (param $1 i64) (result i64)
  (return
   (i64.shr_s
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $clz64 (; 13 ;) (param $0 i64) (result i64)
  (return
   (i64.clz
    (get_local $0)
   )
  )
 )
 (func $clz64_zero_undef (; 14 ;) (param $0 i64) (result i64)
  (return
   (i64.clz
    (get_local $0)
   )
  )
 )
 (func $ctz64 (; 15 ;) (param $0 i64) (result i64)
  (return
   (i64.ctz
    (get_local $0)
   )
  )
 )
 (func $ctz64_zero_undef (; 16 ;) (param $0 i64) (result i64)
  (return
   (i64.ctz
    (get_local $0)
   )
  )
 )
 (func $popcnt64 (; 17 ;) (param $0 i64) (result i64)
  (return
   (i64.popcnt
    (get_local $0)
   )
  )
 )
 (func $eqz64 (; 18 ;) (param $0 i64) (result i32)
  (return
   (i64.eqz
    (get_local $0)
   )
  )
 )
 (func $rotl (; 19 ;) (param $0 i64) (param $1 i64) (result i64)
  (return
   (i64.rotl
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $masked_rotl (; 20 ;) (param $0 i64) (param $1 i64) (result i64)
  (return
   (i64.rotl
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $rotr (; 21 ;) (param $0 i64) (param $1 i64) (result i64)
  (return
   (i64.rotr
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $masked_rotr (; 22 ;) (param $0 i64) (param $1 i64) (result i64)
  (return
   (i64.rotr
    (get_local $0)
    (get_local $1)
   )
  )
 )
 (func $stackSave (; 23 ;) (result i32)
  (i32.load offset=4
   (i32.const 0)
  )
 )
 (func $stackAlloc (; 24 ;) (param $0 i32) (result i32)
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
 (func $stackRestore (; 25 ;) (param $0 i32)
  (i32.store offset=4
   (i32.const 0)
   (get_local $0)
  )
 )
)
;; METADATA: { "asmConsts": {},"staticBump": 1040, "initializers": [], "declares": [], "externs": [], "implementedFunctions": ["_add64","_sub64","_mul64","_sdiv64","_udiv64","_srem64","_urem64","_and64","_or64","_xor64","_shl64","_shr64","_sar64","_clz64","_clz64_zero_undef","_ctz64","_ctz64_zero_undef","_popcnt64","_eqz64","_rotl","_masked_rotl","_rotr","_masked_rotr","_stackSave","_stackAlloc","_stackRestore"], "exports": ["add64","sub64","mul64","sdiv64","udiv64","srem64","urem64","and64","or64","xor64","shl64","shr64","sar64","clz64","clz64_zero_undef","ctz64","ctz64_zero_undef","popcnt64","eqz64","rotl","masked_rotl","rotr","masked_rotr","stackSave","stackAlloc","stackRestore"], "invokeFuncs": [] }
