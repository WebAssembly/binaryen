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
      (string.const "needs\tescaping\00.'#%\"- .\r\n\\08\0C\0A\0D\09.ꙮ")
    )
    (drop
      (string.const "invalid WTF-8 leading byte \FF")
    )
    (drop
      (string.const "invalid trailing byte \C0\00")
    )
    (drop
      (string.const "unexpected end \C0")
    )
    (drop
      (string.const "invalid surrogate sequence \ED\A0\81\ED\B0\B7")
    )
  )
)

;; The custom section should contain foo and bar, and foo only once, and the
;; string with \t should be escaped.
;;
;; RUN: wasm-opt %s --string-lowering -all -S -o - | filecheck %s
;;
;; CHECK: custom section "string.consts", size 202, contents: "[\"bar\",\"foo\",\"invalid WTF-8 leading byte \\ufffd\",\"invalid surrogate sequence \\ud801\\udc37\",\"invalid trailing byte \\ufffd\",\"needs\\tescaping\\u0000.'#%\\\"- .\\r\\n\\\\08\\f\\n\\r\\t.\\ua66e\",\"unexpected end \\ufffd\"]"

;; The custom section should parse OK using JSON.parse from node.
;; (Note we run --remove-unused-module-elements to remove externref-using
;; imports, which require a newer version of node.)
;;
;; RUN: wasm-opt %s --string-lowering --remove-unused-module-elements -all -o %t.wasm
;; RUN: node %S/string-lowering.js %t.wasm | filecheck %s --check-prefix=CHECK-JS
;;
;; CHECK-JS: string: ["bar","foo","invalid WTF-8 leading byte \ufffd","invalid surrogate sequence \ud801\udc37","invalid trailing byte \ufffd","needs\tescaping\x00.'#%\"- .\r\n\\08\f\n\r\t.\ua66e","unexpected end \ufffd"]
;; CHECK-JS: JSON: ["bar","foo","invalid WTF-8 leading byte �","invalid surrogate sequence 𐐷","invalid trailing byte �","needs\tescaping\x00.'#%\"- .\r\n\\08\f\n\r\t.ꙮ","unexpected end �"]
