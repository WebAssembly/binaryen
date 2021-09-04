;; =====================
;; Instrument the binary
;; =====================

;; RUN: wasm-split -all --instrument %s -o %t.instrumented.wasm

;; Create profiles

;; RUN: node --experimental-wasm-threads %S/call_exports.mjs %t.instrumented.wasm %t.foo.prof foo
;; RUN: node --experimental-wasm-threads %S/call_exports.mjs %t.instrumented.wasm %t.bar.prof bar
;; RUN: node --experimental-wasm-threads %S/call_exports.mjs %t.instrumented.wasm %t.both.prof foo bar
;; RUN: node --experimental-wasm-threads %S/call_exports.mjs %t.instrumented.wasm %t.none.prof

;; Create profile-guided splits

;; RUN: wasm-split -all %s --profile=%t.foo.prof -v -o1 %t.foo.1.wasm -o2 %t.foo.2.wasm \
;; RUN:   | filecheck %s --check-prefix FOO

;; RUN: wasm-split -all %s --profile=%t.bar.prof -v -o1 %t.bar.1.wasm -o2 %t.bar.2.wasm \
;; RUN:   | filecheck %s --check-prefix BAR

;; RUN: wasm-split -all %s --profile=%t.both.prof -v -o1 %t.both.1.wasm -o2 %t.both.2.wasm \
;; RUN:   | filecheck %s --check-prefix BOTH

;; RUN: wasm-split -all %s --profile=%t.none.prof -v -o1 %t.none.1.wasm -o2 %t.none.2.wasm \
;; RUN:   | filecheck %s --check-prefix NONE

;; =================================
;; Do it all again using --in-memory
;; =================================

;; RUN: wasm-split -all --instrument --in-memory %s -o %t.instrumented.wasm

;; Create profiles

;; RUN: node --experimental-wasm-threads %S/call_exports.mjs %t.instrumented.wasm %t.foo.prof foo
;; RUN: node --experimental-wasm-threads %S/call_exports.mjs %t.instrumented.wasm %t.bar.prof bar
;; RUN: node --experimental-wasm-threads %S/call_exports.mjs %t.instrumented.wasm %t.both.prof foo bar
;; RUN: node --experimental-wasm-threads %S/call_exports.mjs %t.instrumented.wasm %t.none.prof

;; Create profile-guided splits

;; RUN: wasm-split -all %s --profile=%t.foo.prof -v -o1 %t.foo.1.wasm -o2 %t.foo.2.wasm \
;; RUN:   | filecheck %s --check-prefix FOO

;; RUN: wasm-split -all %s --profile=%t.bar.prof -v -o1 %t.bar.1.wasm -o2 %t.bar.2.wasm \
;; RUN:   | filecheck %s --check-prefix BAR

;; RUN: wasm-split -all %s --profile=%t.both.prof -v -o1 %t.both.1.wasm -o2 %t.both.2.wasm \
;; RUN:   | filecheck %s --check-prefix BOTH

;; RUN: wasm-split -all %s --profile=%t.none.prof -v -o1 %t.none.1.wasm -o2 %t.none.2.wasm \
;; RUN:   | filecheck %s --check-prefix NONE

;; =======
;; Results
;; =======

;; FOO: Keeping functions: deep_foo_callee, foo, foo_callee, shared_callee
;; FOO: Splitting out functions: bar, bar_callee, uncalled

;; BAR: Keeping functions: bar, bar_callee, shared_callee
;; BAR: Splitting out functions: deep_foo_callee, foo, foo_callee, uncalled

;; BOTH: Keeping functions: bar, bar_callee, deep_foo_callee, foo, foo_callee, shared_callee
;; BOTH: Splitting out functions: uncalled

;; NONE: Keeping functions:
;; NONE: Splitting out functions: bar, bar_callee, deep_foo_callee, foo, foo_callee, shared_callee, uncalled

(module
  (memory $mem (shared 1 1))
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
