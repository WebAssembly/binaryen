;; Test that parse errors have helpful messages

;; RUN: not wasm-opt %s 2>&1 | filecheck %s
;; CHECK: Fatal: {{.*}}:8:5: error: unrecognized instruction

(module
  (func $foo
    (abc)
  )
)
