;; RUN: wasm-split %s -all -g -o1 %t.1.wasm -o2 %t.2.wasm --split-funcs=split
;; RUN: wasm-dis -all %t.1.wasm | filecheck %s --check-prefix PRIMARY
;; RUN: wasm-dis -all %t.2.wasm | filecheck %s --check-prefix SECONDARY

;; The dependence chain is $g4->$g3->$g2->$g1, and because $g4 is used in the
;; primary module, all four globals should end up in the primary module. Only
;; $g2 needs to be exported to the secondary module, not $g1.

(module
  (global $g1 i32 (i32.const 42))
  (global $g2 i32 (global.get $g1))
  (global $g3 i32 (global.get $g2))
  (global $g4 i32 (global.get $g3))

  (func $keep
    (drop (global.get $g4))
  )

  (func $split
    (drop (global.get $g2))
  )
)

;; PRIMARY:      (module
;; PRIMARY-NEXT:  (type $0 (func))
;; PRIMARY-NEXT:  (global $g1 i32 (i32.const 42))
;; PRIMARY-NEXT:  (global $g2 i32 (global.get $g1))
;; PRIMARY-NEXT:  (global $g3 i32 (global.get $g2))
;; PRIMARY-NEXT:  (global $g4 i32 (global.get $g3))
;; PRIMARY-NEXT:  (export "global" (global $g2))
;; PRIMARY-NEXT:  (func $keep (type $0)
;; PRIMARY-NEXT:   (drop
;; PRIMARY-NEXT:    (global.get $g4)
;; PRIMARY-NEXT:   )
;; PRIMARY-NEXT:  )
;; PRIMARY-NEXT: )

;; SECONDARY:      (module
;; SECONDARY-NEXT:  (type $0 (func))
;; SECONDARY-NEXT:  (import "primary" "global" (global $g2 i32))
;; SECONDARY-NEXT:  (func $split (type $0)
;; SECONDARY-NEXT:   (drop
;; SECONDARY-NEXT:    (global.get $g2)
;; SECONDARY-NEXT:   )
;; SECONDARY-NEXT:  )
;; SECONDARY-NEXT: )
