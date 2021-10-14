;; Test that --verbose mode correctly prints the kept and split funcs

;; RUN: wasm-split %s --keep-funcs=foo,bar --verbose \
;; RUN:   -o1 %t1.wasm -o2 %t2.wasm | filecheck %s

;; CHECK: Keeping functions: bar, foo{{$}}
;; CHECK: Splitting out functions: baz, quux{{$}}

(module
  (func $foo)
  (func $bar)
  (func $baz)
  (func $quux)
)
