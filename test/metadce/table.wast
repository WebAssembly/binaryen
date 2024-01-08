(module
 (type $array (array (mut funcref)))

 (table $table-used 10 funcref)

 (table $table-unused 10 funcref)

 ;; An active element segment, which is always used.
 (elem $elem (table $table-used) (i32.const 0) func $func)

 (elem $passive-elem-used $func)

 (elem $passive-elem-unused $func)

 (func $func (export "test")
  ;; Use the used table and passive element segment.
  (table.fill $table-used
   (i32.const 0)
   (ref.func $func)
   (i32.const 0)
  )
  (drop
   (array.new_elem $array $passive-elem-used
    (i32.const 0)
    (i32.const 1)
   )
  )
 )
)
