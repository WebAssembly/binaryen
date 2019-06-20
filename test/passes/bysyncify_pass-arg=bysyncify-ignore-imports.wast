(module
  (memory 1 2)
  (import "env" "import" (func $import))
  (import "env" "import2" (func $import2 (result i32)))
  (import "env" "import3" (func $import3 (param i32)))
  (func $calls-import
    (call $import)
  )
  (func $calls-import2-drop
    (drop (call $import2))
  )
  (func $calls-import2-if-else (param $x i32)
    (if (local.get $x)
      (call $import3 (i32.const 1))
      (call $import3 (i32.const 2))
    )
  )
)

