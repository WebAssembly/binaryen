(module
 (type $0 (func))
 (import "env" "memory" (memory $0 256 1024))
 (data (i32.const 1600) "abc")
 (export "memory" (memory $0))
 (func (export "get_size") (result i32) (memory.size))
)

