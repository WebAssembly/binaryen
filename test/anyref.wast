(module
 (memory 1 1)
 (import "env" "test1" (func $test1 (param anyref) (result anyref)))
 (import "env" "test2" (global $test2 anyref))
 (export "test1" (func $test1 (param anyref) (result anyref)))
 (export "test2" (global $test2))
 (func $anyref_test (param $0 anyref) (result anyref)
  (local $1 anyref)
  (local.set $1
   (call $test1
    (local.get $0)
   )
  )
  (return
   (local.get $1)
  )
 )
)
