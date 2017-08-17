(module
  (memory 1024 1024)
  (type $FUNCSIG$v (func))
  (type $FUNCSIG$i (func (result i32)))
  (type $FUNCSIG$d (func (result f64)))
  (import $waka "somewhere" "waka")
  (import $waka-ret "somewhere" "waka-ret" (result i32))
  (import $waka-ret-d "somewhere" "waka-ret-d" (result f64))
  (import "env" "memBase" (global i32))
  (func $nada (type $FUNCSIG$v)
    (call $waka)
    (drop
      (call $waka-ret)
    )
    (drop
      (call $waka-ret-d)
    )
  )
)
