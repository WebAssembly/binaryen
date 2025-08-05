;; Test that we reject descriptor types when custom descriptors are not enabled,
;; even if they are not directly used.

;; RUN: not wasm-opt -all --disable-custom-descriptors %s 2>&1 | filecheck %s

;; Check the binary parser, too.

;; RUN: wasm-opt -all %s -o %t.wasm
;; RUN: not wasm-opt -all --disable-custom-descriptors %t.wasm 2>&1 | filecheck %s

;; CHECK: invalid type: custom descriptors required but not enabled

(module
  (rec
    (type $struct (descriptor $desc (struct)))
    (type $desc (describes $struct (struct)))
    (type $used (struct))
  )

  (global $use (ref null $used) (ref.null none))
)
