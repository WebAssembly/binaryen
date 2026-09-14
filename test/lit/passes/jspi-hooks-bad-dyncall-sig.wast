;; RUN: not wasm-opt %s --enable-reference-types --jspi-hooks --pass-arg=jspi-dyncalls --pass-arg=jspi-dyncall-sigs@ix 2>&1 | filecheck %s

;; CHECK: jspi-hooks: invalid signature character 'x'

(module
  (table $t 1 funcref)
  (func $enter (export "__jspi_enter") (result i64) (i64.const 0))
  (func $exit (export "__jspi_exit") (param i64 i32))
  (func $suspend (export "__jspi_suspend") (result i64) (i64.const 0))
  (func $resume (export "__jspi_resume") (param i64 i32))
)
