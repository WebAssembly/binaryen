(module
 (type $0 (func))
 (import "env" "memory" (memory $1 256 256))
 (import "env" "STACKTOP" (global $gimport$0 i32))
 (global $global$0 (mut i32) (global.get $gimport$0))
 (export "__post_instantiate" (func $0))
 ;; if the stack goes **down**, this may seem to write to memory we care about
 (func $0 (; 0 ;) (type $0)
  (local $0 i32)
  (i32.store offset=12
   (local.tee $0
    (i32.sub
     (global.get $global$0)
     (i32.const 16)
    )
   )
   (i32.const 10)
  )
  (i32.store offset=12
   (local.get $0)
   (i32.add
    (i32.load offset=12
     (local.get $0)
    )
    (i32.const 1)
   )
  )
 )
)

