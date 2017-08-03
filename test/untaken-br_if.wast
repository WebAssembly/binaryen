(module
 (func $binaryify-untaken-br_if (result f32)
  (if
   (i32.const 1)
   (unreachable)
   (block $label$1
    (br_if $label$1
     (i32.const 1)
     (unreachable)
    )
   )
  )
 )
)
