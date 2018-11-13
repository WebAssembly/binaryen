(module
  (func $func (param $x i32)
    (block $out
      (loop $loop
        (br_if $out
          (get_local $x)
        )
        (nop)
        (br $loop)
      )
    )
  )
)

