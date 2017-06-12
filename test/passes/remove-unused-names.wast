(module
  (memory 256 256)
  (type $0 (func (param i32) (result i32)))
  (type $1 (func))
  (func $b0 (type $0) (param $i1 i32) (result i32)
    (block $topmost (result i32)
      (i32.const 0)
    )
  )
  (func $loops (type $1)
    (block $out
      (loop $in
        (br $out)
        (br $in)
      )
    )
    (loop $in
      (br $in)
    )
    (loop $in
      (nop)
    )
    (block $out
      (loop $in
        (block $out
          (loop $in
            (br $out)
            (br $in)
          )
        )
      )
    )
    (block $out
      (loop $in
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
  (func $merges (type $1)
    (block $a
      (block $b
        (br $a)
        (br $b)
      )
    )
    (block $a
      (block $b
        (br_table $a $b
          (i32.const 3)
        )
      )
    )
    (block $a
      (block $b
        (br_table $b $a
          (i32.const 3)
        )
      )
    )
  )
)
