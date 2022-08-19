;; Instrument the module
;; RUN: wasm-split --instrument %s -o %t.instrumented.wasm -g

;; Generate profile
;; RUN: node %S/call_exports.mjs %t.instrumented.wasm %t.foo.prof foo

;; Print profile
;; RUN: wasm-split %s --print-profile=%t.foo.prof | filecheck %s --check-prefix=ESCAPED

;; Print profile + unescape function names
;; RUN: wasm-split %s --print-profile=%t.foo.prof --unescape | filecheck %s --check-prefix=UNESCAPED

;; ESCAPED: - bar\28double\5b3\5d\29

;; UNESCAPED: - bar(double[3])

(module
  (memory 0 0)
  (export "memory" (memory 0 0))
  (export "foo" (func $foo))
  (export "bar" (func $bar\28double\5b3\5d\29))
  (func $foo
    (nop)
  )
  (func $bar\28double\5b3\5d\29
    (nop)
  )
)
