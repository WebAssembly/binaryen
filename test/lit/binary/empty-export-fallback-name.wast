;; RUN: wasm-as %s -o %t.wasm
;; RUN: wasm-dis %t.wasm -o %t.wat
;; RUN: filecheck %s < %t.wat
;; RUN: wasm-as %t.wat -o %t.roundtrip.wasm
;; RUN: wasm-dis %t.roundtrip.wasm -o - | filecheck %s

;; An empty export name must not replace the generated internal name.
(module
 (func (export "") (result i32)
  (i32.const 42)
 )
)

;; CHECK:      (export "" (func $0))
;; CHECK-NEXT: (func $0 (result i32)
;; CHECK-NEXT:  (i32.const 42)
