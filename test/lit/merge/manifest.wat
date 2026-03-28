;; RUN: wasm-merge %s first %s.second second %s.third third --output-manifest %t.manifest -S -o %t.wasm
;; RUN: cat %t.manifest | filecheck %s

;; The first module is the primary module and does not appear in the manifest.
;; CHECK-NOT:  first
;; CHECK-NOT:  foo
;; CHECK-NOT:  bar

;; CHECK:      second
;; CHECK-NEXT: baz
;; CHECK-NEXT:
;; CHECK-NEXT: third
;; CHECK-NEXT: qux

(module
  (import "env" "imported_first" (func $imported_first))
  (func $foo (export "foo")
    (call $imported_first)
  )
  (func $bar (export "bar")
    nop
  )
)
