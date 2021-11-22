(module
 (global $global$0 (mut funcref) (ref.null func))
 (func $0 (param $0 f32) (param $1 i31ref) (param $2 i64) (param $3 f64) (param $4 funcref)
  (nop)
 )
 (func "export" (result funcref)
  ;; this set's value will be applied to the get right after it. we should carry
  ;; over the specific typed function reference type properly while doing so.
  (global.set $global$0
   (ref.func $0)
  )
  (global.get $global$0)
 )
)
