(module
 (type $0 (func))
 (memory $0 i64 16 17 shared)
 (export "func_259_invoker" (func $0))
 (func $0
  (drop
   (v128.load8x8_s offset=22 align=2
    (i64.const 0)
   )
  )
  (unreachable)
 )
)

