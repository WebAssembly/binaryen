;; RUN: not wasm-opt %s --enable-reference-types --jspi-hooks --pass-arg=jspi-exports@main 2>&1 | filecheck %s

;; CHECK: jspi-hooks: module must export function __jspi_enter

(module
  (func (export "main"))
)
