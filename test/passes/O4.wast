(module
 (type $0 (func))
 (global $global$0 (mut i32) (i32.const 10))
 (export "func_59_invoker" (func $0))
 (func $0 (; 0 ;) (type $0)
  (if
   (block $label$1 (result i32)
    (global.set $global$0
     (i32.const 0)
    )
    (i32.const 127)
   )
   (unreachable)
  )
  (global.set $global$0
   (i32.const -1)
  )
  (if
   (global.get $global$0)
   (unreachable)
  )
  (unreachable)
 )
)

