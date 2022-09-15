(module
 (func "exp1"
  (block $block
   ;; An infinite loop. When optimizing, wasm2js enables ignore-implicit-traps
   ;; and so it can simplify this.
   (loop $loop
    (br_table $block $loop $block (i32.const 1))
   )
  )
 )
 (func "exp2"
  (block $block
   ;; A loop that never executes. This can be optimized into a nop.
   (loop $loop
    (br_table $loop $block $loop (i32.const 1))
   )
  )
 )
)
