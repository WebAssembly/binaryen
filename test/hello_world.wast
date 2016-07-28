(module
  (memory 256 256)
  (type $0 (func (param i32 i32) (result i32)))
  (export "add" $add)
  (func $add (type $0) (param $x i32) (param $y i32) (result i32)
    (i32.add
      (get_local $x)
      (get_local $y)
    )
  )
)
