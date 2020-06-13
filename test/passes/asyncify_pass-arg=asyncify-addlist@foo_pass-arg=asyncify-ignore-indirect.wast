(module
  (type $t (func))
  (memory 1 2)
  (table 1 funcref)
  (elem (i32.const 0))
  (import "env" "import" (func $import))
  (func $foo ;; doesn't look like it needs instrumentation, but in add list
    (call $nothing)
    (call_indirect (type $t) (i32.const 0))
  )
  (func $bar ;; doesn't look like it needs instrumentation, and not in add list
    (call $nothing)
    (call_indirect (type $t) (i32.const 0))
  )
  (func $nothing
  )
)

