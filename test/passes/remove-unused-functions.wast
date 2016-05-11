(module
  (start $start)
  (export "exported" $exported)
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
    (call $called2)
  )
  (func $called2
    (call $called2)
    (call $called3)
  )
  (func $called3
    (call $called4)
  )
  (func $called4
    (call $called3)
  )
  (func $remove0
    (call $remove1)
  )
  (func $remove1
    (nop)
  )
  (func $remove2
    (call $remove2)
  )
  (func $remove3
    (call $remove4)
  )
  (func $remove4
    (call $remove3)
  )
)

