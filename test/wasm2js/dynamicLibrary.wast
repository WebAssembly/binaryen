(module
 (type $FUNCSIG$vi (func (param i32)))
 (type $FUNCSIG$ii (func (param i32) (result i32)))

 (import "env" "memory" (memory $memory 256 256))
 (import "env" "memoryBase" (global $memoryBase i32))
 (data (global.get $memoryBase) "dynamic data")

 (import "env" "table" (table $table 10 anyref))
 (import "env" "tableBase" (global $tableBase i32))
 (elem (global.get $tableBase) $foo $bar)

 (export "baz" (func $baz))

 (func $foo)
 (func $bar)
 (func $baz)
)
