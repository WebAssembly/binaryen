;; RUN: wasm-opt %s --jspi-hooks --pass-arg=jspi-imports@@%S/jspi-hooks-response-file.txt --enable-reference-types --enable-exception-handling -S -o - | filecheck %s

;; Newline-separated list read from a response file.

;; CHECK: (import "env" "c" (func $c))
;; CHECK: (import "env" "a" (func $byn$jspi-hooks$import$a))
;; CHECK: (import "env" "b" (func $byn$jspi-hooks$import$b))
;; CHECK: (func $a
;; CHECK: (func $b
;; CHECK-NOT: (func $c

(module
  (import "env" "a" (func $a))
  (import "env" "b" (func $b))
  (import "env" "c" (func $c))
  (func (export "__jspi_enter") (result i64) (i64.const 0))
  (func (export "__jspi_exit") (param i64 i32))
  (func (export "__jspi_suspend") (result i64) (i64.const 0))
  (func (export "__jspi_resume") (param i64 i32))
  (func (export "use") (call $a) (call $b) (call $c))
)
