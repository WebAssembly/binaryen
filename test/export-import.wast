(module
 (type $v (func))
 (import "env" "test1" (func $test1))
 (import "env" "test2" (global $test2 i32))
 (export "test1" (func $test1))
 (export "test2" (global $test2))
)

