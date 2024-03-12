;; Test that incorrect nominal types result in the expected parse errors

;; RUN: foreach %s %t not wasm-opt -all 2>&1 | filecheck %s

;; CHECK: 2:28: error: unknown type identifier
(module
  (type $bad-func (sub $bad (func)))
)

;; CHECK: 2:30: error: unknown type identifier
(module
  (type $bad-struct (sub $bad (struct)))
)

;; CHECK: 2:29: error: unknown type identifier
(module
  (type $bad-array (sub $bad (array i32)))
)
