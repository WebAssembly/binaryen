;; RUN: wasm-opt %s --inlining -o %t.wasm -osm %t.map -g -q
;; RUN: cat %t.map | filecheck %s --check-prefix MAP
;; RUN: wasm-opt %t.wasm -ism %t.map -o %t2.wasm -osm %t2.map -g -q
;; RUN: cat %t2.map | filecheck %s --check-prefix MAP
;; RUN: wasm-opt %t2.wasm -ism %t2.map -S -o %t.wat -q
;; RUN: cat %t.wat | filecheck %s --check-prefix WAT
;; RUN: wasm-opt %t.wat -o %t3.wasm -osm %t3.map -g -q
;; RUN: cat %t3.map | filecheck %s --check-prefix MAP
;; RUN: wasm-opt %t3.wasm -ism %t3.map -S -o - -q | filecheck %s --check-prefix WAT

;; Verify that inlining a call with debug locations emits "scopes" and "ranges"
;; (including the 'I' CallSite record at caller.cpp:10:5 -> I, src=0 ('A'),
;; 0-based line=9 ('J'), col=5 ('F') => "IAJF"), and preserves them across both
;; binary + source map and WAT text roundtrips.

;; MAP: "sources":["caller.cpp","callee.cpp"]
;; MAP-SAME: "names":["CallerFunc","CalleeFunc"]
;; MAP-SAME: "scopes":["BFJFA,CAA","BFBDC,CAA"]
;; MAP-SAME: "ranges":["EGjBAA,ECACA,IAJF,FB,FA"]

;; WAT:      (export "caller" (func $caller))

;; WAT:      (func $caller
;; WAT-NEXT:  ;;@ caller.cpp:10:5:CallerFunc
;; WAT-NEXT:  ;;@ callee.cpp:2:3:CalleeFunc
;; WAT-NEXT:  (nop)
;; WAT-NEXT: )

(module
  (export "caller" (func $caller))

  (func $caller
    ;;@ caller.cpp:10:5:CallerFunc
    (call $callee)
  )

  (func $callee
    ;;@ callee.cpp:2:3:CalleeFunc
    (nop)
  )
)
