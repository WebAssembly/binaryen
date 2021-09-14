;; RUN: wasm-split --instrument %s -all -S -o - | filecheck %s

;; Check that an imported memory is not exported as "profile-memory"

(module
  (import "env" "mem" (memory $mem 1 1))
)

;; CHECK: (import "env" "mem" (memory $mem 1 1))
;; CHECK: (export "__write_profile" (func $__write_profile))

;; CHECK-NOT: (export "profile-memory" (memory $mem))
