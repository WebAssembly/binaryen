;; Test that incorrect nominal types result in the expected parse errors

;; RUN: foreach %s %t not wasm-opt -all 2>&1 | filecheck %s

;; CHECK: [parse exception: unknown supertype (at 2:24)]
(module
  (type $bad-func (sub $bad (func)))
)

;; CHECK: [parse exception: unknown supertype (at 2:26)]
(module
  (type $bad-struct (sub $bad (struct)))
)

;; CHECK: [parse exception: unknown supertype (at 2:25)]
(module
  (type $bad-array (sub $bad (array i32)))
)
