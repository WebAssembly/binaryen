;; FinalizeARC part of assemblyscript/tests/compiler/rc/optimize
(module
 (import "rt" "retain" (func $~lib/rt/pure/__retain (param i32) (result i32)))
 (import "rt" "release" (func $~lib/rt/pure/__release (param i32)))
 (import "rt" "alloc" (func $~lib/rt/tlsf/__alloc (param i32) (param i32) (result i32)))
 (func $eliminates.unnecessaryAllocation
  (call $~lib/rt/pure/__release
   (call $~lib/rt/pure/__retain
    (call $~lib/rt/tlsf/__alloc
     (i32.const 1)
     (i32.const 0)
    )
   )
  )
 )
 (func $eliminates.unnecessaryPair (param $0 i32)
  (call $~lib/rt/pure/__release
   (call $~lib/rt/pure/__retain
    (local.get $0)
   )
  )
 )
 (func $eliminates.unnecessaryStaticPair
  (call $~lib/rt/pure/__release
   (call $~lib/rt/pure/__retain
    (i32.const 272)
   )
  )
 )
 (func $eliminates.unnecessaryStaticRetain
  (drop
   (call $~lib/rt/pure/__retain
    (i32.const 272)
   )
  )
 )
 (func $eliminates.unnecessaryStaticRelease
  (call $~lib/rt/pure/__release
   (i32.const 272)
  )
 )
 (func $keeps.dynamicRetain (param $0 i32)
  (local.set $0
   (call $~lib/rt/pure/__retain
    (local.get $0)
   )
  )
 )
 (func $keeps.dynamicRelease (param $0 i32)
  (call $~lib/rt/pure/__release
   (local.get $0)
  )
 )
)
