(module
 (import "import" "log" (func $logi32 (param i32)))
 (import "import" "log" (func $logi64 (param i64)))
 (export "foo" (func $0))
 (func $0 (param $0 i32)
   (local.get $0)
   (call $logi32)
 )
)
