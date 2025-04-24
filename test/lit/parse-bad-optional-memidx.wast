;; Regression test for a parser bug where the invalid memory index followed by
;; another immediate caused an assertion failure.

;; RUN: not wasm-opt -all %s 2>&1 | filecheck %s

;; CHECK: Fatal: {{.*}}:12:22: error: expected end of instruction

(module
 (memory 1 1)

 (func $v128.load16_lane1 (param $0 i32) (param $1 v128) (result v128)
  (v128.load16_lane 1 0 ;; invalid memory index
   (local.get $0)
   (local.get $1)
  )
 )
)