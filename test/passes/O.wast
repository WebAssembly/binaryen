(module
  (func $ret (export "ret") (result i32)
    (block $out (result i32)
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
  (func $if-0-unreachable-to-none (export "waka") (param $var$0 i64)
   (local $var$1 i64)
   (local $var$2 i64)
   (block $label$1
    (if
     (i32.const 0)
     (br $label$1)
     (unreachable)
    )
   )
  )
)

