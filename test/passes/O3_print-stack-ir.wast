(module
 (export "stacky-help" (func $stacky-help))
 (func $stacky-help (param $x i32) (result i32)
  (local $temp i32)
  (i32.add
   (call $stacky-help (i32.const 0))
   (i32.eqz
    (block (result i32) ;; after we use the stack instead of the local, we can remove this block
     (set_local $temp (call $stacky-help (i32.const 1)))
     (drop (call $stacky-help (i32.const 2)))
     (get_local $temp)
    )
   )
  )
 )
)
