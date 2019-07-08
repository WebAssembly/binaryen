(module
 (type $void (func))
 (table 1 1 funcref)
 (elem (i32.const 0) $foo)
 (func $foo
  (return_call $bar)
 )
 (func $bar
  (return_call_indirect (type $void) (i32.const 0))
 )
)