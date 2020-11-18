;; Test that the --bigint option prevents i64s from being split up

;; Run without --bigint to get a baseline
;; RUN: wasm-emscripten-finalize %s -S | filecheck %s --check-prefix MVP

;; Then run with --bigint to see the difference
;; RUN: wasm-emscripten-finalize %s -S --bigint | filecheck %s --check-prefix BIGINT

;; MVP: (export "dynCall_jj" (func $legalstub$dynCall_jj))
;; MVP: (func $legalstub$dynCall_jj (param $0 i32) (param $1 i32) (param $2 i32) (result i32)

;; BIGINT-NOT: legalstub
;; BIGINT: (export "dynCall_jj" (func $dynCall_jj))
;; BIGINT: (func $dynCall_jj (param $fptr i32) (param $0 i64) (result i64)

(module
 (table $0 1 1 funcref)
 (elem (i32.const 1) $foo)
 (func $foo (param i64) (result i64)
  (unreachable)
 )
)
