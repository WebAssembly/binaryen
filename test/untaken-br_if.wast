(module
 (func $binaryify-untaken-br_if (result f32)
  (if (result f32)
   (i32.const 1)
   (unreachable)
   (block $label$1 (result f32)
    (br_if $label$1
     (f32.const 1)
     (unreachable)
    )
   )
  )
 )
)
