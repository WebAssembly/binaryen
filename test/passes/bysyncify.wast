(module
  (memory 1 2)
  (import "env" "import" (func $import))
  (func $calls-import
    (call $import)
  )
  (func $calls-nothing
    (drop (i32.eqz (i32.const 17)))
  )
)

