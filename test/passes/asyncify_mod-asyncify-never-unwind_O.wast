(module
  (memory 1 2)
  (import "env" "import" (func $import))
  (import "env" "import2" (func $import2 (result i32)))
  (import "env" "import3" (func $import3 (param i32)))
  (export "calls-import" (func $calls-import))
  (export "calls-import2" (func $calls-import))
  (export "calls-import2-drop" (func $calls-import))
  (export "calls-nothing" (func $calls-import))
  (func $calls-import
    (call $import)
  )
  (func $calls-import2 (result i32)
    (local $temp i32)
    (local.set $temp (call $import2))
    (return (local.get $temp))
  )
  (func $calls-import2-drop
    (drop (call $import2))
  )
  (func $calls-nothing
    (drop (i32.eqz (i32.const 17)))
  )
)
