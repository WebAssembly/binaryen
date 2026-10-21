;; RUN: wasm-split %s -all -g -o1 %t.1.wasm -o2 %t.2.wasm --keep-funcs=keep
;; RUN: wasm-dis %t.1.wasm | filecheck %s --check-prefix PRIMARY
;; RUN: wasm-dis %t.2.wasm | filecheck %s --check-prefix SECONDARY

(module
 (memory $unused-memory 1 1)
 (global $unused-global i32 (i32.const 20))
 (table $unused-table 1 1 funcref)
 (tag $unused-tag (param i32))

 (func $keep)
 (func $split)
)

;; PRIMARY:      (module
;; PRIMARY-NEXT:  (type $0 (func))
;; PRIMARY-NEXT:  (func $keep
;; PRIMARY-NEXT:  )
;; PRIMARY-NEXT: )

;; SECONDARY:      (module
;; SECONDARY-NEXT:  (type $0 (func))
;; SECONDARY-NEXT:  (func $split
;; SECONDARY-NEXT:  )
;; SECONDARY-NEXT: )
