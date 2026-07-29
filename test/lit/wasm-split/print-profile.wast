;; Instrument the module
;; RUN: wasm-split --instrument %s -o %t.instrumented.wasm -g

;; Generate profile
;; RUN: node %S/call_exports.mjs %t.instrumented.wasm %t.foo.prof foo

;; Print profile
;; RUN: wasm-split %s --print-profile=%t.foo.prof | filecheck %s

;; CHECK: - bar(double[3])

(module
  (memory $m 0 0)
  (export "memory" (memory $m))
  (export "foo" (func $foo))
  (export "bar" (func $"bar\28double\5b3\5d\29"))
  (func $foo
    (nop)
  )
  (func $"bar\28double\5b3\5d\29"
    (nop)
  )
)
