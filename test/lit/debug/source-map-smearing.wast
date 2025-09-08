;; RUN: wasm-opt %s -g -o %t.wasm -osm %t.wasm.map
;; RUN: echo >> %t.wasm.map
;; RUN: cat %t.wasm.map | filecheck %s

;; Also test with StackIR, which should have identical results.
;;
;; RUN: wasm-opt %s --generate-stack-ir -o %t.wasm -osm %t.map -g -q
;; RUN: echo >> %t.wasm.map
;; RUN: cat %t.wasm.map | filecheck %s

;; Check that the debug locations do not smear beyond a function
;; epilogue to the next function. The encoded segment 'C' means that
;; the previous segment is indeed one-byte long.
;; CHECK: {"version":3,"sources":["foo"],"names":[],"mappings":"wBAAC,C,EACC"}
(module
  (func $0
    ;;@ foo:1:1
  )
  (func $1
    ;;@ foo:2:2
  )
)
