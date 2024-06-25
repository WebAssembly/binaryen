;; Test that a traced function with a multi-value result type
;; results in a useful error message

;; RUN: not wasm-opt --enable-simd --enable-multivalue --trace-calls=multi_param_result %s 2>&1 | filecheck %s

;; CHECK: Fatal: Failed to instrument function 'multi_param_result': Multi-value result type is not supported
(module
  (import "env" "multi_param_result" (func $multi_param_result (result i32 i32)))
)
