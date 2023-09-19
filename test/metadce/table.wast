(module
 (table $table 10 funcref)
 (elem $elem (i32.const 0))

 (func $func (export "test")
  (table.fill $table
   (i32.const 0)
   (ref.func $func)
   (i32.const 0)
  )
 )
)

