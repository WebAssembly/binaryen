;; RUN: wasm-opt %s -g -o %t.wasm -osm %t.wasm.map
;; RUN: echo >> %t.wasm.map
;; RUN: cat %t.wasm.map | filecheck %s

;; Check that the debug locations do not smear beyond a function
;; epilogue to the next function. The encoded segment 'C' means that
;; the previous segment is indeed one-byte long.
;; CHECK: {"version":3,"sources":["foo"],"names":[],"mappings":"yBAAC,C,GACC"}
(module
  (func $0
    ;;@ foo:1:1
  )
  (func $1
    ;;@ foo:2:2
  )
)
