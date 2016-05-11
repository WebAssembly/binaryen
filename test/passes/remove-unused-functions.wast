(module
  (export "exported" $exported)
  (start $start)
  (table $called_indirect)
  (func $start
    (call $called0)
  )
  (func $called0
    (call $called1)
  )
  (func $called1
    (nop)
  )
  (func $called_indirect
    (nop)
  )
  (func $exported
    (nop)
  )
  (func $remove0
    (call $remove1)
  )
  (func $remove1
    (nop)
  )
)

