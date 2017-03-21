(module
 (import "env" "memory" (memory $0 1))
 (table 0 anyfunc)
 (export "foo" (func $foo))
 (export "bar" (func $bar))
 (export "qux" (func $qux))
 (func $foo
  (return)
 )
 (func $bar
  (return)
 )
 (func $qux
  (return)
 )
)
;; METADATA: { "asmConsts": {},"staticBump": 12, "initializers": [] }
