(module
 (import "env" "out" (func $out (param i32)))
 (func $each-pass-must-clear (param $var$0 i32)
  (call $out
   (i32.eqz
    (get_local $var$0)
   )
  )
  (call $out
   (i32.eqz
    (get_local $var$0)
   )
  )
 )
)

