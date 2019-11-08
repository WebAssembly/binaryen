(module
 (func "exp1"
  (block $block
   (loop $loop
    (br_table $block $loop $block (i32.const 1))
   )
  )
 )
 (func "exp2"
  (block $block
   (loop $loop
    (br_table $loop $block $loop (i32.const 1))
   )
  )
 )
)
