;; RUN: wasm-merge %s first %s second --rename-export-conflicts --output-manifest %t.manifest -o %t.wasm
;; RUN: cat %t.manifest | filecheck %s
;; RUN: wasm-dis %t.wasm -o - | filecheck %s --check-prefix MERGED

;; This tests if the internal names of empty function names are correctly
;; preserved in the name section so that they can match the names in the
;; manifest file.

;; CHECK:      second
;; CHECK-NEXT: 0_1
;; CHECK-NEXT:

;; MERGED:      (module
;; MERGED-NEXT:  (type $0 (func))
;; MERGED-NEXT:  (export "foo" (func $0))
;; MERGED-NEXT:  (export "foo_1" (func $0_1))
;; MERGED-NEXT:  (func $0
;; MERGED-NEXT:   (nop)
;; MERGED-NEXT:  )
;; MERGED-NEXT:  (func $0_1
;; MERGED-NEXT:   (nop)
;; MERGED-NEXT:  )
;; MERGED-NEXT: )

(module
  (func (export "foo")
    nop
  )
)
