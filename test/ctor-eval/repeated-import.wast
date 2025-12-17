(module
 ;; We can import the same name with completely different types. This is
 ;; valid because the runtime may dynamically swap out the import name each time
 ;; it is read.
 (import "env" "log" (func $logi32 (param i32)))
 (import "env" "log" (func $logi64 (param i64)))
 (import "env" "log" (global $global i32))
 (func $foo (param $i32 i32) (param $i64 i64) (result i32)
   (local.get $i32)
   (call $logi32)
   (local.get $i64)
   (call $logi64)
   (global.get $global)
 )
 (export "foo" (func $foo))
)
