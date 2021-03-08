(module
  (memory 1 2)
  (import "env" "import" (func $import))
  (func $calls-import
    (call $import)
  )
  (func $calls-calls-import
    (call $calls-import)
  )
  (func $calls-calls-calls-import
    (call $calls-calls-import)
  )
  (func $nothing
    (nop)
  )
)

