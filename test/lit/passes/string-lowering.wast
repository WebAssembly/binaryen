;; This file checks the custom section that --string-lowering adds. The other
;; operations are tested in string-gathering.wast (which is auto-updated, unlike
;; this which is manual).

(module
  (func $consts
    (drop
      (string.const "foo")
    )
    (drop
      (string.const "bar")
    )
    (drop
      (string.const "foo")
    )
    (drop
      (string.const "needs\tescaping")
    )
  )
)

;; The custom section should contain foo and bar, and foo only once, and the
;; string with \t should be escaped.
;;
;; RUN: wasm-opt %s --string-lowering -all -S -o - | filecheck %s
;;
;; CHECK: custom section "string.consts", size 31, contents: "[\"bar\",\"foo\",\"needs\\tescaping\"]"

;; The custom section should parse OK using JSON.parse from node.
;; (Note we run --remove-unused-module-elements to remove externref-using
;; imports, which require a newer version of node.)
;;
;; RUN: wasm-opt %s --string-lowering --remove-unused-module-elements -all -o %t.wasm
;; RUN: node %S/string-lowering.js %t.wasm | filecheck %s --check-prefix=CHECK-JS
;;
;; CHECK-JS: JSON: ["bar","foo","needs\tescaping"]

