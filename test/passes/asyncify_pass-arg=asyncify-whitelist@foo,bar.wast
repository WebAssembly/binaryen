(module
  (memory 1 2)
  (import "env" "import" (func $import))
  (func $foo
    (call $import)
  )
  (func $bar
    (call $import)
  )
  (func $baz
    (call $import)
  )
  (func $other1
    (call $foo) ;; even though we call foo, we are not in the whitelist, so do not instrument us
  )
  (func $other2
    (call $baz)
  )
)

