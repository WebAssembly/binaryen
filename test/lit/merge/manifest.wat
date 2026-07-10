;; RUN: wasm-merge %s first %s.second second %s.third third --output-manifest %t.manifest -o %t.wasm
;; RUN: cat %t.manifest | filecheck %s
;; RUN: wasm-dis %t.wasm -o - | filecheck %s --check-prefix MERGED

;; The first module is the primary module and does not appear in the manifest.
;; CHECK-NOT:  first
;; CHECK-NOT:  foo
;; CHECK-NOT:  bar

;; CHECK:      second
;; CHECK-NEXT: baz
;; CHECK-NEXT:
;; CHECK-NEXT: third
;; CHECK-NEXT: qux

;; The binary should contain the original function names.
;; MERGED:      (module
;; MERGED-NEXT:  (type $0 (func))
;; MERGED-NEXT:  (import "env" "imported_first" (func $imported_first))
;; MERGED-NEXT:  (import "env" "imported_second" (func $imported_second))
;; MERGED-NEXT:  (import "env" "imported_third" (func $imported_third))
;; MERGED-NEXT:  (export "foo" (func $foo))
;; MERGED-NEXT:  (export "bar" (func $bar))
;; MERGED-NEXT:  (export "baz" (func $baz))
;; MERGED-NEXT:  (export "qux" (func $qux))
;; MERGED-NEXT:  (func $foo
;; MERGED-NEXT:   (call $imported_first)
;; MERGED-NEXT:  )
;; MERGED-NEXT:  (func $bar
;; MERGED-NEXT:   (nop)
;; MERGED-NEXT:  )
;; MERGED-NEXT:  (func $baz
;; MERGED-NEXT:   (call $imported_second)
;; MERGED-NEXT:  )
;; MERGED-NEXT:  (func $qux
;; MERGED-NEXT:   (call $imported_third)
;; MERGED-NEXT:  )
;; MERGED-NEXT: )

(module
  (import "env" "imported_first" (func $imported_first))
  (func $foo (export "foo")
    (call $imported_first)
  )
  (func $bar (export "bar")
    nop
  )
)
