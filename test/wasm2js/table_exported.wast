(module
  (table $t (export "table") 2 anyfunc)
  (elem $t (i32.const 0) $f $f)
  (func $f (nop))
  (func (export "fn")
    (call_indirect
      (i32.const 1)
    )
  )
)
