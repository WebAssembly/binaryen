(module
  (import "env" "emscripten_get_sbrk_ptr" (func $internal(result i32)))
)
(module
)
(module
  (memory $0 10 10)
  (import "env" "emscripten_get_sbrk_ptr" (func $internal(result i32)))
)
(module
  (memory $0 10 10)
  (data (i32.const 0) "12345678901234567890")
  (import "env" "emscripten_get_sbrk_ptr" (func $internal(result i32)))
)
(module
  (memory $0 10 10)
  (data (i32.const 0) "1234567890")
  (import "env" "emscripten_get_sbrk_ptr" (func $internal(result i32)))
)
(module
  (memory $0 10 10)
  (data (i32.const 10) "12345678901234567890")
  (import "env" "emscripten_get_sbrk_ptr" (func $internal(result i32)))
)
(module
  (memory $0 10 10)
  (data (i32.const 10) "1234567890")
  (import "env" "emscripten_get_sbrk_ptr" (func $internal(result i32)))
)
(module
  (memory $0 10 10)
  (data (i32.const 24) "1234567890")
  (import "env" "emscripten_get_sbrk_ptr" (func $internal(result i32)))
)

