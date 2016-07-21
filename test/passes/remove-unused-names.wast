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
    (loop $in
      (block $out
        (br $out)
        (br $in)
      )
    )
    (block $out
      (loop $in
        (br $out)
        (br $in)
      )
    )
  )
  (func $merges
    (block $a
      (block $b
        (br $a)
        (br $b)
      )
    )
    (block $a
      (block $b
        (br_table $a $b (i32.const 3))
      )
    )
    (block $a
      (block $b
        (br_table $b $a (i32.const 3))
      )
    )
  )
)

