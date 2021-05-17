(module
  (func $foo
    (call $bar)
  )
  (func $bar
    (call $foo)
  )
  (func $other
    (drop (i32.const 1))
  )
)
(module
  ;; Use another function in the table, but the table is not used in the
  ;; extracted function
  (table $t 10 funcref)
  (elem $0 (table $t) (i32.const 0) func $other)
  (func $foo
  )
  (func $other
    (drop (i32.const 1))
  )
)
(module
  ;; Use another function in the table, and the table *is* used. As a result,
  ;; the table and its elements will remain. The called function, $other, will
  ;; remain as an import that is placed in the table.
  (type $none (func))
  (table $t 10 funcref)
  (elem $0 (table $t) (i32.const 0) func $other)
  (func $foo
   (call_indirect (type $none) (i32.const 10))
  )
  (func $other
    (drop (i32.const 1))
  )
)
