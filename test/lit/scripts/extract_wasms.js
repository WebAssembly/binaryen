;; Test extracting wasm files from JS.

foo(new Uint8Array([0x00, 0x61, 0x73, 0x6D, 0x01]));

;; RUN: python %S/../../../scripts/clusterfuzz/extract_wasms.py %s %t
;; RUN: cat %t.js | filecheck %s
;;
;; CHECK: foo(undefined /* extracted wasm */)

