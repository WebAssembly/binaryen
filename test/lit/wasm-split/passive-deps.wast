;; RUN: wasm-split %s -all -g -o1 %t.1.wasm -o2 %t.2.wasm --split-funcs=split
;; RUN: wasm-dis -all %t.1.wasm | filecheck %s --check-prefix PRIMARY
;; RUN: wasm-dis -all %t.2.wasm | filecheck %s --check-prefix SECONDARY

(module
 (global $g funcref (ref.null nofunc))

 ;; We should scan this passive element segment's data and correctly mark $g as
 ;; used in the primary module.
 (elem $passive-elem funcref (item (global.get $g)))

 (func $keep
  (elem.drop $passive-elem)
 )

 (func $split
  (drop (global.get $g))
 )
)

;; PRIMARY:      (module
;; PRIMARY-NEXT:  (type $0 (func))
;; PRIMARY-NEXT:  (global $g funcref (ref.null nofunc))
;; PRIMARY-NEXT:  (elem $passive-elem funcref (item (global.get $g)))
;; PRIMARY-NEXT:  (export "global" (global $g))
;; PRIMARY-NEXT:  (func $keep (type $0)
;; PRIMARY-NEXT:   (elem.drop $passive-elem)
;; PRIMARY-NEXT:  )
;; PRIMARY-NEXT: )

;; SECONDARY:      (module
;; SECONDARY-NEXT:  (type $0 (func))
;; SECONDARY-NEXT:  (import "primary" "global" (global $g funcref))
;; SECONDARY-NEXT:  (func $split (type $0)
;; SECONDARY-NEXT:   (drop
;; SECONDARY-NEXT:    (global.get $g)
;; SECONDARY-NEXT:   )
;; SECONDARY-NEXT:  )
;; SECONDARY-NEXT: )
