;; RUN: wasm-merge %s first %s.second second --output-manifest %t.manifest -o %t.wasm
;; RUN: cat %t.manifest | filecheck %s

;; CHECK:      second
;; CHECK-NEXT: foo bar

(module
)
