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

  (func $table.grow (export "table.grow") (result i32)
    (table.grow $table
      (ref.func $table.grow)
      (i32.const 42)
    )
  )

  (func $table.fill (export "table.fill") (param $dest i32) (param $value funcref) (param $size i32)
    (table.fill $table
      (local.get $dest)
      (local.get $value)
      (local.get $size)
    )
  )

  (func $table.copy (export "table.copy") (param $dest i32) (param $source i32) (param $size i32)
    (table.copy $table $table
      (local.get $dest)
      (local.get $source)
      (local.get $size)
    )
  )
)

