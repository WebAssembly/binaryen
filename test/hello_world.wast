(module
  (memory 256 256)
  (export "add" $add)
  (func $add (param $x i32) (param $y i32) (result i32)
    (i32.add
      (get_local $x)
      (get_local $y)
    )
  )
)
