(module
  (memory 256 256)
  (func $b0 (param $i1 i32) (result i32)
    (block $topmost
      (i32.const 0)
    )
  )
  (func $loops
    (loop $out $in
      (br $out)
      (br $in)
    )
    (loop $out $in
      (br $out)
    )
    (loop $out $in
      (br $in)
    )
    (loop $out $in
      (nop)
    )
    (loop $out $in
      (loop $out $in
        (br $out)
        (br $in)
      )
    )
    (block $out
      (loop $out $in
        (br $out)
        (br $in)
      )
    )
    (loop $out $in
      (block $out
        (br $out)
        (br $in)
      )
    )
  )
)

