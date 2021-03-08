;; Instrument the binary

;; RUN: wasm-split --instrument %s -o %t.instrumented.wasm

;; Create profiles

;; RUN: node %S/call_exports.mjs %t.instrumented.wasm %t.foo.prof foo
;; RUN: node %S/call_exports.mjs %t.instrumented.wasm %t.bar.prof bar
;; RUN: node %S/call_exports.mjs %t.instrumented.wasm %t.both.prof foo bar
;; RUN: node %S/call_exports.mjs %t.instrumented.wasm %t.none.prof

;; Create profile-guided splits

;; RUN: wasm-split %s --profile=%t.foo.prof -v -o1 %t.foo.1.wasm -o2 %t.foo.2.wasm \
;; RUN:   | filecheck %s --check-prefix FOO

;; FOO: Keeping functions: deep_foo_callee, foo, foo_callee, shared_callee
;; FOO: Splitting out functions: bar, bar_callee, uncalled

;; RUN: wasm-split %s --profile=%t.bar.prof -v -o1 %t.bar.1.wasm -o2 %t.bar.2.wasm \
;; RUN:   | filecheck %s --check-prefix BAR

;; BAR: Keeping functions: bar, bar_callee, shared_callee
;; BAR: Splitting out functions: deep_foo_callee, foo, foo_callee, uncalled

;; RUN: wasm-split %s --profile=%t.both.prof -v -o1 %t.both.1.wasm -o2 %t.both.2.wasm \
;; RUN:   | filecheck %s --check-prefix BOTH

;; BOTH: Keeping functions: bar, bar_callee, deep_foo_callee, foo, foo_callee, shared_callee
;; BOTH: Splitting out functions: uncalled

;; RUN: wasm-split %s --profile=%t.none.prof -v -o1 %t.none.1.wasm -o2 %t.none.2.wasm \
;; RUN:   | filecheck %s --check-prefix NONE

;; NONE: Keeping functions:
;; NONE: Splitting out functions: bar, bar_callee, deep_foo_callee, foo, foo_callee, shared_callee, uncalled


(module
  (memory $mem 1 1)
  (export "memory" (memory $mem))
  (export "foo" (func $foo))
  (export "bar" (func $bar))
  (export "uncalled" (func $uncalled))

  (func $foo
    (call $foo_callee)
    (call $shared_callee)
  )

  (func $bar
    (call $shared_callee)
    (call $bar_callee)
  )

  (func $uncalled)

  (func $foo_callee
    (call $deep_foo_callee)
  )

  (func $bar_callee)

  (func $shared_callee)

  (func $deep_foo_callee)
)
