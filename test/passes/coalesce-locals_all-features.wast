(module
 (func $bar (result i32)
  (i32.const 1984)
 )
 (func "foo" (param $0 i32) (result i32)
  (local $1 i32)
  (try
   (do
    (local.set $1
     (call $bar) ;; the call may or may not throw, so we may reach the get of $1
    )
   )
   (catch_all
    (unreachable)
   )
  )
  (local.get $1)
 )
)
