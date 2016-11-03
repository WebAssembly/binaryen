(module
  (func $ret (export "ret") (result i32)
    (block $out i32
      (drop (call $ret))
      (if (call $ret)
        (return
          (return
            (i32.const 1)
          )
        )
      )
      (drop (br_if $out (i32.const 999) (i32.const 1)))
      (unreachable)
    )
  )
)

