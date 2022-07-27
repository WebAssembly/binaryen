;; Instrument the module
;; RUN: wasm-split --instrument %s -o %t.instrumented.wasm -g

;; Generate profile
;; RUN: node %S/call_exports.mjs %t.instrumented.wasm %t.foo.prof foo

;; Print profile
;; RUN: wasm-split %s --print-profile=%t.foo.prof | filecheck %s.check

;; Print profile + unescape function names
;; RUN: wasm-split %s --print-profile=%t.foo.prof --unescape | filecheck %s.unescape.check

(module
  (export "memory" (memory 0 0))
  (export "foo" (func $foo))
  (export "bar" (func $bar))
  (export "baz" (func $baz))
  (export "qux" (func $tt_text::process_text\28wchar_t\20const*\2c\20double*\2c\20int\2c\20bool\2c\20TextParams\20const*\2c\20Charset\2c\20DrawingMode\2c\20bool\2c\20void\20\28*\29\28wchar_t*\2c\20int\2c\20double*\2c\20TextParams\20const*\2c\20DrawingMode\2c\20double\20\28&\29\20\5b5\5d\5b3\5d\2c\20float*\2c\20bool\29\29))
  (func $foo
    (nop)
  )
  (func $bar
    (nop)
  )
  (func $baz
    (nop)
  )
  (func $tt_text::process_text\28wchar_t\20const*\2c\20double*\2c\20int\2c\20bool\2c\20TextParams\20const*\2c\20Charset\2c\20DrawingMode\2c\20bool\2c\20void\20\28*\29\28wchar_t*\2c\20int\2c\20double*\2c\20TextParams\20const*\2c\20DrawingMode\2c\20double\20\28&\29\20\5b5\5d\5b3\5d\2c\20float*\2c\20bool\29\29
    (nop)
  )
)
