(module
  (type $FUNCSIG$vijji (func (param i32 i64 i64 i32)))
  (type $FUNCSIG$vijjjj (func (param i32 i64 i64 i64 i64)))
  (import "env" "__ashlti3" (func $__ashlti3 (param i32 i64 i64 i32)))
  (import "env" "__ashrti3" (func $__ashrti3 (param i32 i64 i64 i32)))
  (import "env" "__divti3" (func $__divti3 (param i32 i64 i64 i64 i64)))
  (import "env" "__lshrti3" (func $__lshrti3 (param i32 i64 i64 i32)))
  (import "env" "__modti3" (func $__modti3 (param i32 i64 i64 i64 i64)))
  (import "env" "__multi3" (func $__multi3 (param i32 i64 i64 i64 i64)))
  (import "env" "__udivti3" (func $__udivti3 (param i32 i64 i64 i64 i64)))
  (import "env" "__umodti3" (func $__umodti3 (param i32 i64 i64 i64 i64)))
  (import "env" "memory" (memory $0 1))
  (table 0 anyfunc)
  (data (i32.const 4) "\10\04\00\00")
  (export "add128" (func $add128))
  (export "sub128" (func $sub128))
  (export "mul128" (func $mul128))
  (export "sdiv128" (func $sdiv128))
  (export "udiv128" (func $udiv128))
  (export "srem128" (func $srem128))
  (export "urem128" (func $urem128))
  (export "and128" (func $and128))
  (export "or128" (func $or128))
  (export "xor128" (func $xor128))
  (export "shl128" (func $shl128))
  (export "shr128" (func $shr128))
  (export "sar128" (func $sar128))
  (export "clz128" (func $clz128))
  (export "clz128_zero_undef" (func $clz128_zero_undef))
  (export "ctz128" (func $ctz128))
  (export "ctz128_zero_undef" (func $ctz128_zero_undef))
  (export "popcnt128" (func $popcnt128))
  (export "eqz128" (func $eqz128))
  (export "rotl" (func $rotl))
  (export "masked_rotl" (func $masked_rotl))
  (export "rotr" (func $rotr))
  (export "masked_rotr" (func $masked_rotr))
  (func $add128 (param $0 i32) (param $1 i64) (param $2 i64) (param $3 i64) (param $4 i64)
    (local $5 i64)
    (i64.store
      (get_local $0)
      (tee_local $5
        (i64.add
          (get_local $1)
          (get_local $3)
        )
      )
    )
    (i64.store
      (i32.add
        (get_local $0)
        (i32.const 8)
      )
      (i64.add
        (i64.add
          (get_local $2)
          (get_local $4)
        )
        (select
          (i64.const 1)
          (i64.extend_u/i32
            (i64.lt_u
              (get_local $5)
              (get_local $1)
            )
          )
          (i64.lt_u
            (get_local $5)
            (get_local $3)
          )
        )
      )
    )
    (return)
  )
  (func $sub128 (param $0 i32) (param $1 i64) (param $2 i64) (param $3 i64) (param $4 i64)
    (i64.store
      (get_local $0)
      (i64.sub
        (get_local $1)
        (get_local $3)
      )
    )
    (i64.store
      (i32.add
        (get_local $0)
        (i32.const 8)
      )
      (i64.sub
        (i64.sub
          (get_local $2)
          (get_local $4)
        )
        (i64.extend_u/i32
          (i64.lt_u
            (get_local $1)
            (get_local $3)
          )
        )
      )
    )
    (return)
  )
  (func $mul128 (param $0 i32) (param $1 i64) (param $2 i64) (param $3 i64) (param $4 i64)
    (local $5 i32)
    (i32.store offset=4
      (i32.const 0)
      (tee_local $5
        (i32.sub
          (i32.load offset=4
            (i32.const 0)
          )
          (i32.const 16)
        )
      )
    )
    (call $__multi3
      (get_local $5)
      (get_local $1)
      (get_local $2)
      (get_local $3)
      (get_local $4)
    )
    (i64.store
      (i32.add
        (get_local $0)
        (i32.const 8)
      )
      (i64.load
        (i32.add
          (get_local $5)
          (i32.const 8)
        )
      )
    )
    (i64.store
      (get_local $0)
      (i64.load
        (get_local $5)
      )
    )
    (i32.store offset=4
      (i32.const 0)
      (i32.add
        (get_local $5)
        (i32.const 16)
      )
    )
    (return)
  )
  (func $sdiv128 (param $0 i32) (param $1 i64) (param $2 i64) (param $3 i64) (param $4 i64)
    (local $5 i32)
    (i32.store offset=4
      (i32.const 0)
      (tee_local $5
        (i32.sub
          (i32.load offset=4
            (i32.const 0)
          )
          (i32.const 16)
        )
      )
    )
    (call $__divti3
      (get_local $5)
      (get_local $1)
      (get_local $2)
      (get_local $3)
      (get_local $4)
    )
    (i64.store
      (i32.add
        (get_local $0)
        (i32.const 8)
      )
      (i64.load
        (i32.add
          (get_local $5)
          (i32.const 8)
        )
      )
    )
    (i64.store
      (get_local $0)
      (i64.load
        (get_local $5)
      )
    )
    (i32.store offset=4
      (i32.const 0)
      (i32.add
        (get_local $5)
        (i32.const 16)
      )
    )
    (return)
  )
  (func $udiv128 (param $0 i32) (param $1 i64) (param $2 i64) (param $3 i64) (param $4 i64)
    (local $5 i32)
    (i32.store offset=4
      (i32.const 0)
      (tee_local $5
        (i32.sub
          (i32.load offset=4
            (i32.const 0)
          )
          (i32.const 16)
        )
      )
    )
    (call $__udivti3
      (get_local $5)
      (get_local $1)
      (get_local $2)
      (get_local $3)
      (get_local $4)
    )
    (i64.store
      (i32.add
        (get_local $0)
        (i32.const 8)
      )
      (i64.load
        (i32.add
          (get_local $5)
          (i32.const 8)
        )
      )
    )
    (i64.store
      (get_local $0)
      (i64.load
        (get_local $5)
      )
    )
    (i32.store offset=4
      (i32.const 0)
      (i32.add
        (get_local $5)
        (i32.const 16)
      )
    )
    (return)
  )
  (func $srem128 (param $0 i32) (param $1 i64) (param $2 i64) (param $3 i64) (param $4 i64)
    (local $5 i32)
    (i32.store offset=4
      (i32.const 0)
      (tee_local $5
        (i32.sub
          (i32.load offset=4
            (i32.const 0)
          )
          (i32.const 16)
        )
      )
    )
    (call $__modti3
      (get_local $5)
      (get_local $1)
      (get_local $2)
      (get_local $3)
      (get_local $4)
    )
    (i64.store
      (i32.add
        (get_local $0)
        (i32.const 8)
      )
      (i64.load
        (i32.add
          (get_local $5)
          (i32.const 8)
        )
      )
    )
    (i64.store
      (get_local $0)
      (i64.load
        (get_local $5)
      )
    )
    (i32.store offset=4
      (i32.const 0)
      (i32.add
        (get_local $5)
        (i32.const 16)
      )
    )
    (return)
  )
  (func $urem128 (param $0 i32) (param $1 i64) (param $2 i64) (param $3 i64) (param $4 i64)
    (local $5 i32)
    (i32.store offset=4
      (i32.const 0)
      (tee_local $5
        (i32.sub
          (i32.load offset=4
            (i32.const 0)
          )
          (i32.const 16)
        )
      )
    )
    (call $__umodti3
      (get_local $5)
      (get_local $1)
      (get_local $2)
      (get_local $3)
      (get_local $4)
    )
    (i64.store
      (i32.add
        (get_local $0)
        (i32.const 8)
      )
      (i64.load
        (i32.add
          (get_local $5)
          (i32.const 8)
        )
      )
    )
    (i64.store
      (get_local $0)
      (i64.load
        (get_local $5)
      )
    )
    (i32.store offset=4
      (i32.const 0)
      (i32.add
        (get_local $5)
        (i32.const 16)
      )
    )
    (return)
  )
  (func $and128 (param $0 i32) (param $1 i64) (param $2 i64) (param $3 i64) (param $4 i64)
    (i64.store
      (i32.add
        (get_local $0)
        (i32.const 8)
      )
      (i64.and
        (get_local $2)
        (get_local $4)
      )
    )
    (i64.store
      (get_local $0)
      (i64.and
        (get_local $1)
        (get_local $3)
      )
    )
    (return)
  )
  (func $or128 (param $0 i32) (param $1 i64) (param $2 i64) (param $3 i64) (param $4 i64)
    (i64.store
      (i32.add
        (get_local $0)
        (i32.const 8)
      )
      (i64.or
        (get_local $2)
        (get_local $4)
      )
    )
    (i64.store
      (get_local $0)
      (i64.or
        (get_local $1)
        (get_local $3)
      )
    )
    (return)
  )
  (func $xor128 (param $0 i32) (param $1 i64) (param $2 i64) (param $3 i64) (param $4 i64)
    (i64.store
      (i32.add
        (get_local $0)
        (i32.const 8)
      )
      (i64.xor
        (get_local $2)
        (get_local $4)
      )
    )
    (i64.store
      (get_local $0)
      (i64.xor
        (get_local $1)
        (get_local $3)
      )
    )
    (return)
  )
  (func $shl128 (param $0 i32) (param $1 i64) (param $2 i64) (param $3 i64) (param $4 i64)
    (local $5 i32)
    (i32.store offset=4
      (i32.const 0)
      (tee_local $5
        (i32.sub
          (i32.load offset=4
            (i32.const 0)
          )
          (i32.const 16)
        )
      )
    )
    (call $__ashlti3
      (get_local $5)
      (get_local $1)
      (get_local $2)
      (i32.wrap/i64
        (get_local $3)
      )
    )
    (i64.store
      (i32.add
        (get_local $0)
        (i32.const 8)
      )
      (i64.load
        (i32.add
          (get_local $5)
          (i32.const 8)
        )
      )
    )
    (i64.store
      (get_local $0)
      (i64.load
        (get_local $5)
      )
    )
    (i32.store offset=4
      (i32.const 0)
      (i32.add
        (get_local $5)
        (i32.const 16)
      )
    )
    (return)
  )
  (func $shr128 (param $0 i32) (param $1 i64) (param $2 i64) (param $3 i64) (param $4 i64)
    (local $5 i32)
    (i32.store offset=4
      (i32.const 0)
      (tee_local $5
        (i32.sub
          (i32.load offset=4
            (i32.const 0)
          )
          (i32.const 16)
        )
      )
    )
    (call $__lshrti3
      (get_local $5)
      (get_local $1)
      (get_local $2)
      (i32.wrap/i64
        (get_local $3)
      )
    )
    (i64.store
      (i32.add
        (get_local $0)
        (i32.const 8)
      )
      (i64.load
        (i32.add
          (get_local $5)
          (i32.const 8)
        )
      )
    )
    (i64.store
      (get_local $0)
      (i64.load
        (get_local $5)
      )
    )
    (i32.store offset=4
      (i32.const 0)
      (i32.add
        (get_local $5)
        (i32.const 16)
      )
    )
    (return)
  )
  (func $sar128 (param $0 i32) (param $1 i64) (param $2 i64) (param $3 i64) (param $4 i64)
    (local $5 i32)
    (i32.store offset=4
      (i32.const 0)
      (tee_local $5
        (i32.sub
          (i32.load offset=4
            (i32.const 0)
          )
          (i32.const 16)
        )
      )
    )
    (call $__ashrti3
      (get_local $5)
      (get_local $1)
      (get_local $2)
      (i32.wrap/i64
        (get_local $3)
      )
    )
    (i64.store
      (i32.add
        (get_local $0)
        (i32.const 8)
      )
      (i64.load
        (i32.add
          (get_local $5)
          (i32.const 8)
        )
      )
    )
    (i64.store
      (get_local $0)
      (i64.load
        (get_local $5)
      )
    )
    (i32.store offset=4
      (i32.const 0)
      (i32.add
        (get_local $5)
        (i32.const 16)
      )
    )
    (return)
  )
  (func $clz128 (param $0 i32) (param $1 i64) (param $2 i64)
    (i64.store
      (i32.add
        (get_local $0)
        (i32.const 8)
      )
      (i64.const 0)
    )
    (i64.store
      (get_local $0)
      (select
        (i64.clz
          (get_local $2)
        )
        (i64.add
          (i64.clz
            (get_local $1)
          )
          (i64.const 64)
        )
        (i64.ne
          (get_local $2)
          (i64.const 0)
        )
      )
    )
    (return)
  )
  (func $clz128_zero_undef (param $0 i32) (param $1 i64) (param $2 i64)
    (i64.store
      (i32.add
        (get_local $0)
        (i32.const 8)
      )
      (i64.const 0)
    )
    (i64.store
      (get_local $0)
      (select
        (i64.clz
          (get_local $2)
        )
        (i64.add
          (i64.clz
            (get_local $1)
          )
          (i64.const 64)
        )
        (i64.ne
          (get_local $2)
          (i64.const 0)
        )
      )
    )
    (return)
  )
  (func $ctz128 (param $0 i32) (param $1 i64) (param $2 i64)
    (i64.store
      (i32.add
        (get_local $0)
        (i32.const 8)
      )
      (i64.const 0)
    )
    (i64.store
      (get_local $0)
      (select
        (i64.ctz
          (get_local $1)
        )
        (i64.add
          (i64.ctz
            (get_local $2)
          )
          (i64.const 64)
        )
        (i64.ne
          (get_local $1)
          (i64.const 0)
        )
      )
    )
    (return)
  )
  (func $ctz128_zero_undef (param $0 i32) (param $1 i64) (param $2 i64)
    (i64.store
      (i32.add
        (get_local $0)
        (i32.const 8)
      )
      (i64.const 0)
    )
    (i64.store
      (get_local $0)
      (select
        (i64.ctz
          (get_local $1)
        )
        (i64.add
          (i64.ctz
            (get_local $2)
          )
          (i64.const 64)
        )
        (i64.ne
          (get_local $1)
          (i64.const 0)
        )
      )
    )
    (return)
  )
  (func $popcnt128 (param $0 i32) (param $1 i64) (param $2 i64)
    (i64.store
      (i32.add
        (get_local $0)
        (i32.const 8)
      )
      (i64.const 0)
    )
    (i64.store
      (get_local $0)
      (i64.add
        (i64.popcnt
          (get_local $1)
        )
        (i64.popcnt
          (get_local $2)
        )
      )
    )
    (return)
  )
  (func $eqz128 (param $0 i64) (param $1 i64) (result i32)
    (return
      (i64.eqz
        (i64.or
          (get_local $0)
          (get_local $1)
        )
      )
    )
  )
  (func $rotl (param $0 i32) (param $1 i64) (param $2 i64) (param $3 i64) (param $4 i64)
    (local $5 i32)
    (i32.store offset=4
      (i32.const 0)
      (tee_local $5
        (i32.sub
          (i32.load offset=4
            (i32.const 0)
          )
          (i32.const 32)
        )
      )
    )
    (call $__ashlti3
      (i32.add
        (get_local $5)
        (i32.const 16)
      )
      (get_local $1)
      (get_local $2)
      (i32.wrap/i64
        (get_local $3)
      )
    )
    (call $__lshrti3
      (get_local $5)
      (get_local $1)
      (get_local $2)
      (i32.wrap/i64
        (i64.sub
          (i64.const 128)
          (get_local $3)
        )
      )
    )
    (i64.store
      (i32.add
        (get_local $0)
        (i32.const 8)
      )
      (i64.or
        (i64.load
          (i32.add
            (i32.add
              (get_local $5)
              (i32.const 16)
            )
            (i32.const 8)
          )
        )
        (i64.load
          (i32.add
            (get_local $5)
            (i32.const 8)
          )
        )
      )
    )
    (i64.store
      (get_local $0)
      (i64.or
        (i64.load offset=16
          (get_local $5)
        )
        (i64.load
          (get_local $5)
        )
      )
    )
    (i32.store offset=4
      (i32.const 0)
      (i32.add
        (get_local $5)
        (i32.const 32)
      )
    )
    (return)
  )
  (func $masked_rotl (param $0 i32) (param $1 i64) (param $2 i64) (param $3 i64) (param $4 i64)
    (local $5 i32)
    (i32.store offset=4
      (i32.const 0)
      (tee_local $5
        (i32.sub
          (i32.load offset=4
            (i32.const 0)
          )
          (i32.const 32)
        )
      )
    )
    (call $__ashlti3
      (i32.add
        (get_local $5)
        (i32.const 16)
      )
      (get_local $1)
      (get_local $2)
      (i32.wrap/i64
        (tee_local $3
          (i64.and
            (get_local $3)
            (i64.const 127)
          )
        )
      )
    )
    (call $__lshrti3
      (get_local $5)
      (get_local $1)
      (get_local $2)
      (i32.wrap/i64
        (i64.sub
          (i64.const 128)
          (get_local $3)
        )
      )
    )
    (i64.store
      (i32.add
        (get_local $0)
        (i32.const 8)
      )
      (i64.or
        (i64.load
          (i32.add
            (i32.add
              (get_local $5)
              (i32.const 16)
            )
            (i32.const 8)
          )
        )
        (i64.load
          (i32.add
            (get_local $5)
            (i32.const 8)
          )
        )
      )
    )
    (i64.store
      (get_local $0)
      (i64.or
        (i64.load offset=16
          (get_local $5)
        )
        (i64.load
          (get_local $5)
        )
      )
    )
    (i32.store offset=4
      (i32.const 0)
      (i32.add
        (get_local $5)
        (i32.const 32)
      )
    )
    (return)
  )
  (func $rotr (param $0 i32) (param $1 i64) (param $2 i64) (param $3 i64) (param $4 i64)
    (local $5 i32)
    (i32.store offset=4
      (i32.const 0)
      (tee_local $5
        (i32.sub
          (i32.load offset=4
            (i32.const 0)
          )
          (i32.const 32)
        )
      )
    )
    (call $__lshrti3
      (i32.add
        (get_local $5)
        (i32.const 16)
      )
      (get_local $1)
      (get_local $2)
      (i32.wrap/i64
        (get_local $3)
      )
    )
    (call $__ashlti3
      (get_local $5)
      (get_local $1)
      (get_local $2)
      (i32.wrap/i64
        (i64.sub
          (i64.const 128)
          (get_local $3)
        )
      )
    )
    (i64.store
      (i32.add
        (get_local $0)
        (i32.const 8)
      )
      (i64.or
        (i64.load
          (i32.add
            (i32.add
              (get_local $5)
              (i32.const 16)
            )
            (i32.const 8)
          )
        )
        (i64.load
          (i32.add
            (get_local $5)
            (i32.const 8)
          )
        )
      )
    )
    (i64.store
      (get_local $0)
      (i64.or
        (i64.load offset=16
          (get_local $5)
        )
        (i64.load
          (get_local $5)
        )
      )
    )
    (i32.store offset=4
      (i32.const 0)
      (i32.add
        (get_local $5)
        (i32.const 32)
      )
    )
    (return)
  )
  (func $masked_rotr (param $0 i32) (param $1 i64) (param $2 i64) (param $3 i64) (param $4 i64)
    (local $5 i32)
    (i32.store offset=4
      (i32.const 0)
      (tee_local $5
        (i32.sub
          (i32.load offset=4
            (i32.const 0)
          )
          (i32.const 32)
        )
      )
    )
    (call $__lshrti3
      (i32.add
        (get_local $5)
        (i32.const 16)
      )
      (get_local $1)
      (get_local $2)
      (i32.wrap/i64
        (tee_local $3
          (i64.and
            (get_local $3)
            (i64.const 127)
          )
        )
      )
    )
    (call $__ashlti3
      (get_local $5)
      (get_local $1)
      (get_local $2)
      (i32.wrap/i64
        (i64.sub
          (i64.const 128)
          (get_local $3)
        )
      )
    )
    (i64.store
      (i32.add
        (get_local $0)
        (i32.const 8)
      )
      (i64.or
        (i64.load
          (i32.add
            (i32.add
              (get_local $5)
              (i32.const 16)
            )
            (i32.const 8)
          )
        )
        (i64.load
          (i32.add
            (get_local $5)
            (i32.const 8)
          )
        )
      )
    )
    (i64.store
      (get_local $0)
      (i64.or
        (i64.load offset=16
          (get_local $5)
        )
        (i64.load
          (get_local $5)
        )
      )
    )
    (i32.store offset=4
      (i32.const 0)
      (i32.add
        (get_local $5)
        (i32.const 32)
      )
    )
    (return)
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 1040, "initializers": [] }
