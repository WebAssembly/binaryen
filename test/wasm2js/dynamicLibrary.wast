(module
 (type $FUNCSIG$vi (func (param i32)))
 (type $FUNCSIG$ii (func (param i32) (result i32)))

 (import "env" "memory" (memory $import$memory 256 256))
 (import "env" "memoryBase" (global $import$memoryBase i32))
 (data (global.get $import$memoryBase) "dynamic data")

 (import "env" "table" (table $import$table 10 anyref))
 (import "env" "tableBase" (global $import$tableBase i32))
 (elem (global.get $import$tableBase) $foo $bar)

 (export "baz" (func $baz))

 (func $foo)
 (func $bar)
 (func $baz)
)
