;; Instrument the module
;; RUN: wasm-split --instrument %s -o %t.instrumented.wasm -g

;; Generate profiles
;; RUN: node %S/call_exports.mjs %t.instrumented.wasm %t.foo.prof foo
;; RUN: node %S/call_exports.mjs %t.instrumented.wasm %t.foo.bar.prof foo bar
;; RUN: node %S/call_exports.mjs %t.instrumented.wasm %t.bar.baz.prof bar baz

;; Merge profiles
;; RUN: wasm-split --merge-profiles -v %t.foo.prof %t.foo.bar.prof %t.bar.baz.prof -o %t.merged.prof 2>&1 \
;; RUN:   | filecheck %s --check-prefix MERGE

;; Split the module
;; RUN: wasm-split %s --profile %t.merged.prof -o1 %t.1.wasm -o2 %t.2.wasm -g -v \
;; RUN:   | filecheck %s --check-prefix SPLIT

;; MERGE: Profile {{.*}}foo.prof only includes functions included in other profiles.
;; MERGE: Profile {{.*}}foo.bar.prof only includes functions included in other profiles.
;; MERGE-NOT: Profile {{.*}}bar.baz.prof only includes functions included in other profiles.

;; SPLIT: Keeping functions: bar, baz, foo{{$}}
;; SPLIT-NEXT: Splitting out functions: qux{{$}}

(module
  (memory 0 0)
  (export "memory" (memory 0 0))
  (export "foo" (func $foo))
  (export "bar" (func $bar))
  (export "baz" (func $baz))
  (export "qux" (func $qux))
  (func $foo
    (nop)
  )
  (func $bar
    (nop)
  )
  (func $baz
    (nop)
  )
  (func $qux
    (nop)
  )
)
