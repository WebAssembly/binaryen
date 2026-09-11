;; RUN: wasm-opt %s --enable-reference-types --print-features --print --jspi-hooks --pass-arg=jspi-exports@main --print-features | filecheck %s

;; The pass enables exception handling and reference types (for the exnref
;; local in the wrappers).

;; CHECK: --enable-reference-types
;; CHECK-NOT: --enable-exception-handling
;; CHECK: (module
;; CHECK: --enable-exception-handling
;; CHECK: --enable-reference-types

(module
  (func (export "__jspi_enter") (result i64) (i64.const 0))
  (func (export "__jspi_exit") (param i64 i32))
  (func (export "__jspi_suspend") (result i64) (i64.const 0))
  (func (export "__jspi_resume") (param i64 i32))
  (func (export "main"))
)
