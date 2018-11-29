(module
  (table $t (export "table") 2 anyfunc)
  (elem $t (i32.const 0) $f $f)
  (func $f (nop))
  (func (export "fn")
    i32.const 1
    call_indirect
  )
)
