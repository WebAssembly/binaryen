(module
  (import "env" "table" (table $table 7 funcref))

  (elem (i32.const 1) $table.get)

  (func $table.get (export "table.get") (result funcref)
    (table.get $table
      (i32.const 1)
    )
  )

  (func $table.set (export "table.set")
    (table.set $table
      (i32.const 1)
      (ref.func $table.set)
    )
  )

  (func $table.size (export "table.size") (result i32)
    (table.size $table)
  )
)
