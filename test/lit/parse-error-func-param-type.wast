;; This function's type does not match the param we define for it.

;; RUN: not wasm-opt %s 2>&1 | filecheck %s
;; CHECK: Fatal: {{.*}}:9:10: error: type does not match provided signature

(module
 (type $0 (func))

 (func $0 (type $0) (param $var$0 i32))
)
