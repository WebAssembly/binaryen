(module
  (memory 100 100)
  (func $basics (export "localcse") (param $x i32) ($param $y i32) (result i32) ;; -O3 does localcse
    (local $x2 i32)
    (local $y2 i32)
    (set_local $x2
      (i32.add (get_local $x) (get_local $y))
    )
    (set_local $y2
      (i32.add (get_local $x) (get_local $y))
    )
    (i32.add (get_local $x2) (get_local $y2))
  )
)
