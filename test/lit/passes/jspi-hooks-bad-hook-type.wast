;; RUN: not wasm-opt %s --enable-reference-types --jspi-hooks --pass-arg=jspi-exports@main 2>&1 | filecheck %s

;; CHECK: jspi-hooks: export __jspi_exit has type (func (param i32 i32)) but (func (param i64 i32)) is required

(module
  (func (export "__jspi_enter") (result i64) (i64.const 0))
  (func (export "__jspi_exit") (param i32 i32))
  (func (export "main"))
)
