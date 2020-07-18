(module
  (import "env" "atexit" (func $fimport$0 (param i32 i32) (result i32)))
  (import "env" "__cxa_atexit" (func $fimport$1 (param i32 i32) (result i32)))
  (import "env" "_atexit" (func $fimport$2 (param i32 i32) (result i32)))
  (import "env" "___cxa_atexit" (func $fimport$3 (param i32 i32) (result i32)))
  (import "env" "other" (func $fimport$4 (param i32 i32) (result i32)))
  (func $caller
    (drop (call $fimport$0 (i32.const 0) (i32.const 1)))
    (drop (call $fimport$1 (i32.const 0) (i32.const 1)))
    (drop (call $fimport$2 (i32.const 0) (i32.const 1)))
    (drop (call $fimport$3 (i32.const 0) (i32.const 1)))
    (drop (call $fimport$4 (i32.const 0) (i32.const 1)))
    (drop (call $fimport$0 (unreachable) (i32.const 1)))
  )
  (func $side-effects (result i32)
    (local $x i32)
    (drop (call $fimport$0
      (local.tee $x (i32.const 1))
      (i32.const 2)
    ))
    (drop (call $fimport$0
      (i32.const 3)
      (local.tee $x (i32.const 4))
    ))
    (drop (call $fimport$0
      (local.tee $x (i32.const 5))
      (local.tee $x (i32.const 6))
    ))
    (drop (call $fimport$0
      (unreachable)
      (local.tee $x (i32.const 7))
    ))
    (drop (call $fimport$0
      (local.tee $x (i32.const 8))
      (unreachable)
    ))
    (drop (call $fimport$0
      (unreachable)
      (i32.const 9)
    ))
    (drop (call $fimport$0
      (i32.const 10)
      (unreachable)
    ))
    (local.get $x)
  )
)
