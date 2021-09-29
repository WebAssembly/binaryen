(module
  (table $table-1 funcref
    (elem $foo)
  )

  (table $table-2 funcref
    (elem $bar $bar $bar)
  )

  (func $foo
    (nop)
  )
  (func $bar
    (drop
      (table.get $table-1
        (i32.const 0)
      )
    )
    (drop
      (table.get $table-2
        (i32.const 100)
      )
    )
  )
)
