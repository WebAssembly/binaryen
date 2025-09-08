;; We should error properly on a return in a non-function scope

;; RUN: not wasm-opt %s 2>&1 | filecheck %s
;; CHECK: Fatal: {{.*}}:8:5: error: return is only valid in a function context

(module
  (elem
    (return)
  )
)
