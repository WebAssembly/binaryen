(module
  (memory 1 1)
)
(module
  (memory 1 1)
  (import "env" "emscripten_get_sbrk_ptr" (func $foo (result i32)))
)
(module
  (memory 1 1)
  (export "emscripten_get_sbrk_ptr" (func $foo))
  (func $foo (result i32)
   (drop (i32.load (i32.const 0))) ;; should not be modified!
   (i32.const 1234)
  )
)
