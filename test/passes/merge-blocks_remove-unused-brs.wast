(module
  (func $func (param $x i32)
    (block $out
      (loop $loop
        (br_if $out
          (local.get $x)
        )
        (nop)
        (br $loop)
      )
    )
  )
)

