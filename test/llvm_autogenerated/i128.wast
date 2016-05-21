(module
  (memory 1
    (segment 4 "\10\04\00\00")
  )
  (export "memory" memory)
  (type $FUNCSIG$vijji (func (param i32 i64 i64 i32)))
  (type $FUNCSIG$vijjjj (func (param i32 i64 i64 i64 i64)))
  (import $__ashlti3 "env" "__ashlti3" (param i32 i64 i64 i32))
  (import $__ashrti3 "env" "__ashrti3" (param i32 i64 i64 i32))
  (import $__divti3 "env" "__divti3" (param i32 i64 i64 i64 i64))
  (import $__lshrti3 "env" "__lshrti3" (param i32 i64 i64 i32))
  (import $__modti3 "env" "__modti3" (param i32 i64 i64 i64 i64))
  (import $__multi3 "env" "__multi3" (param i32 i64 i64 i64 i64))
  (import $__udivti3 "env" "__udivti3" (param i32 i64 i64 i64 i64))
  (import $__umodti3 "env" "__umodti3" (param i32 i64 i64 i64 i64))
  (export "add128" $add128)
  (export "sub128" $sub128)
  (export "mul128" $mul128)
  (export "sdiv128" $sdiv128)
  (export "udiv128" $udiv128)
  (export "srem128" $srem128)
  (export "urem128" $urem128)
  (export "and128" $and128)
  (export "or128" $or128)
  (export "xor128" $xor128)
  (export "shl128" $shl128)
  (export "shr128" $shr128)
  (export "sar128" $sar128)
  (export "clz128" $clz128)
  (export "clz128_zero_undef" $clz128_zero_undef)
  (export "ctz128" $ctz128)
  (export "ctz128_zero_undef" $ctz128_zero_undef)
  (export "popcnt128" $popcnt128)
  (export "eqz128" $eqz128)
  (export "rotl" $rotl)
  (export "masked_rotl" $masked_rotl)
  (export "rotr" $rotr)
  (export "masked_rotr" $masked_rotr)
  (func $add128 (param $0 i32) (param $1 i64) (param $2 i64) (param $3 i64) (param $4 i64)
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
              (set_local $2
                (i64.store
                  (get_local $0)
                  (i64.add
                    (get_local $1)
                    (get_local $3)
                  )
                )
              )
              (get_local $1)
            )
          )
          (i64.lt_u
            (get_local $2)
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
    (call_import $__multi3
      (set_local $5
        (i32.store
          (i32.const 4)
          (i32.sub
            (i32.load
              (i32.const 4)
            )
            (i32.const 16)
          )
        )
      )
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
    (i32.store
      (i32.const 4)
      (i32.add
        (get_local $5)
        (i32.const 16)
      )
    )
    (return)
  )
  (func $sdiv128 (param $0 i32) (param $1 i64) (param $2 i64) (param $3 i64) (param $4 i64)
    (local $5 i32)
    (call_import $__divti3
      (set_local $5
        (i32.store
          (i32.const 4)
          (i32.sub
            (i32.load
              (i32.const 4)
            )
            (i32.const 16)
          )
        )
      )
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
    (i32.store
      (i32.const 4)
      (i32.add
        (get_local $5)
        (i32.const 16)
      )
    )
    (return)
  )
  (func $udiv128 (param $0 i32) (param $1 i64) (param $2 i64) (param $3 i64) (param $4 i64)
    (local $5 i32)
    (call_import $__udivti3
      (set_local $5
        (i32.store
          (i32.const 4)
          (i32.sub
            (i32.load
              (i32.const 4)
            )
            (i32.const 16)
          )
        )
      )
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
    (i32.store
      (i32.const 4)
      (i32.add
        (get_local $5)
        (i32.const 16)
      )
    )
    (return)
  )
  (func $srem128 (param $0 i32) (param $1 i64) (param $2 i64) (param $3 i64) (param $4 i64)
    (local $5 i32)
    (call_import $__modti3
      (set_local $5
        (i32.store
          (i32.const 4)
          (i32.sub
            (i32.load
              (i32.const 4)
            )
            (i32.const 16)
          )
        )
      )
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
    (i32.store
      (i32.const 4)
      (i32.add
        (get_local $5)
        (i32.const 16)
      )
    )
    (return)
  )
  (func $urem128 (param $0 i32) (param $1 i64) (param $2 i64) (param $3 i64) (param $4 i64)
    (local $5 i32)
    (call_import $__umodti3
      (set_local $5
        (i32.store
          (i32.const 4)
          (i32.sub
            (i32.load
              (i32.const 4)
            )
            (i32.const 16)
          )
        )
      )
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
    (i32.store
      (i32.const 4)
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
    (call_import $__ashlti3
      (set_local $5
        (i32.store
          (i32.const 4)
          (i32.sub
            (i32.load
              (i32.const 4)
            )
            (i32.const 16)
          )
        )
      )
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
    (i32.store
      (i32.const 4)
      (i32.add
        (get_local $5)
        (i32.const 16)
      )
    )
    (return)
  )
  (func $shr128 (param $0 i32) (param $1 i64) (param $2 i64) (param $3 i64) (param $4 i64)
    (local $5 i32)
    (call_import $__lshrti3
      (set_local $5
        (i32.store
          (i32.const 4)
          (i32.sub
            (i32.load
              (i32.const 4)
            )
            (i32.const 16)
          )
        )
      )
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
    (i32.store
      (i32.const 4)
      (i32.add
        (get_local $5)
        (i32.const 16)
      )
    )
    (return)
  )
  (func $sar128 (param $0 i32) (param $1 i64) (param $2 i64) (param $3 i64) (param $4 i64)
    (local $5 i32)
    (call_import $__ashrti3
      (set_local $5
        (i32.store
          (i32.const 4)
          (i32.sub
            (i32.load
              (i32.const 4)
            )
            (i32.const 16)
          )
        )
      )
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
    (i32.store
      (i32.const 4)
      (i32.add
        (get_local $5)
        (i32.const 16)
      )
    )
    (return)
  )
  (func $clz128 (param $0 i32) (param $1 i64) (param $2 i64)
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
          (i64.store
            (i32.add
              (get_local $0)
              (i32.const 8)
            )
            (i64.const 0)
          )
        )
      )
    )
    (return)
  )
  (func $clz128_zero_undef (param $0 i32) (param $1 i64) (param $2 i64)
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
          (i64.store
            (i32.add
              (get_local $0)
              (i32.const 8)
            )
            (i64.const 0)
          )
        )
      )
    )
    (return)
  )
  (func $ctz128 (param $0 i32) (param $1 i64) (param $2 i64)
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
          (i64.store
            (i32.add
              (get_local $0)
              (i32.const 8)
            )
            (i64.const 0)
          )
        )
      )
    )
    (return)
  )
  (func $ctz128_zero_undef (param $0 i32) (param $1 i64) (param $2 i64)
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
          (i64.store
            (i32.add
              (get_local $0)
              (i32.const 8)
            )
            (i64.const 0)
          )
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
    (call_import $__ashlti3
      (i32.add
        (set_local $5
          (i32.store
            (i32.const 4)
            (i32.sub
              (i32.load
                (i32.const 4)
              )
              (i32.const 32)
            )
          )
        )
        (i32.const 16)
      )
      (get_local $1)
      (get_local $2)
      (i32.wrap/i64
        (get_local $3)
      )
    )
    (call_import $__lshrti3
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
    (i32.store
      (i32.const 4)
      (i32.add
        (get_local $5)
        (i32.const 32)
      )
    )
    (return)
  )
  (func $masked_rotl (param $0 i32) (param $1 i64) (param $2 i64) (param $3 i64) (param $4 i64)
    (local $5 i32)
    (call_import $__ashlti3
      (i32.add
        (set_local $5
          (i32.store
            (i32.const 4)
            (i32.sub
              (i32.load
                (i32.const 4)
              )
              (i32.const 32)
            )
          )
        )
        (i32.const 16)
      )
      (get_local $1)
      (get_local $2)
      (i32.wrap/i64
        (set_local $3
          (i64.and
            (get_local $3)
            (i64.const 127)
          )
        )
      )
    )
    (call_import $__lshrti3
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
    (i32.store
      (i32.const 4)
      (i32.add
        (get_local $5)
        (i32.const 32)
      )
    )
    (return)
  )
  (func $rotr (param $0 i32) (param $1 i64) (param $2 i64) (param $3 i64) (param $4 i64)
    (local $5 i32)
    (call_import $__lshrti3
      (i32.add
        (set_local $5
          (i32.store
            (i32.const 4)
            (i32.sub
              (i32.load
                (i32.const 4)
              )
              (i32.const 32)
            )
          )
        )
        (i32.const 16)
      )
      (get_local $1)
      (get_local $2)
      (i32.wrap/i64
        (get_local $3)
      )
    )
    (call_import $__ashlti3
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
    (i32.store
      (i32.const 4)
      (i32.add
        (get_local $5)
        (i32.const 32)
      )
    )
    (return)
  )
  (func $masked_rotr (param $0 i32) (param $1 i64) (param $2 i64) (param $3 i64) (param $4 i64)
    (local $5 i32)
    (call_import $__lshrti3
      (i32.add
        (set_local $5
          (i32.store
            (i32.const 4)
            (i32.sub
              (i32.load
                (i32.const 4)
              )
              (i32.const 32)
            )
          )
        )
        (i32.const 16)
      )
      (get_local $1)
      (get_local $2)
      (i32.wrap/i64
        (set_local $3
          (i64.and
            (get_local $3)
            (i64.const 127)
          )
        )
      )
    )
    (call_import $__ashlti3
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
    (i32.store
      (i32.const 4)
      (i32.add
        (get_local $5)
        (i32.const 32)
      )
    )
    (return)
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 1040, "initializers": [] }
