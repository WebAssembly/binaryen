(module
  (memory 1024 1024)
  (type $FUNCSIG$v (func))
  (type $FUNCSIG$i (func (result i32)))
  (type $FUNCSIG$d (func (result f64)))
  (import $waka "somewhere" "waka")
  (import $waka-ret "somewhere" "waka-ret" (result i32))
  (import $waka-ret-d "somewhere" "waka-ret-d" (result f64))
  (func $nada (type $FUNCSIG$v)
    (call_import $waka)
    (drop
      (call_import $waka-ret)
    )
    (drop
      (call_import $waka-ret-d)
    )
  )
)
