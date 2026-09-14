;; RUN: not wasm-opt %s --enable-reference-types --enable-exception-handling --jspi-hooks --pass-arg=jspi-exports@main 2>&1 | filecheck %s

;; CHECK: jspi-hooks: module mixes legacy and standardized exception handling; run --translate-to-exnref first

(module
  (tag $t)
  (func $enter (export "__jspi_enter") (result i64) (i64.const 0))
  (func $exit (export "__jspi_exit") (param i64 i32))
  (func $suspend (export "__jspi_suspend") (result i64) (i64.const 0))
  (func $resume (export "__jspi_resume") (param i64 i32))
  (func $legacy (try (do (nop)) (catch_all (nop))))
  (func $standard (block $b (try_table (catch_all $b) (nop))))
  (func $main (export "main"))
)
