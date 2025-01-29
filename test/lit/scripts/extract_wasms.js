;; Test extracting wasm files from JS.

const v101 = new WebAssembly.Instance(new WebAssembly.Module(new Uint8Array([
    0x00, 0x61, 0x73, 0x6D, 0x01, 0x00, 0x00, 0x00, 0x01, 0x25,

;; RUN: python %S/../../../scripts/clusterfuzz/extract_wasms.py %s %t
;; RUN: cat %t.js | filecheck %s
;;
;; CHECK: AAAAAAAAAAAAaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa

