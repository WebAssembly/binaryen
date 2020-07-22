(module
  (memory 1 2)
  (import "env" "import" (func $import))
  (func $foo ;; doesn't look like it needs instrumentation, but in add list
    (call $nothing)
  )
  (func $bar ;; doesn't look like it needs instrumentation, and not in add list
    (call $nothing)
  )
  (func $nothing
  )
)

