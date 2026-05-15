;; RUN: wasm-split %s -all -g -o1 %t.1.wasm -o2 %t.2.wasm --split-funcs=split
;; RUN: wasm-dis %t.1.wasm | filecheck %s --check-prefix PRIMARY
;; RUN: wasm-dis %t.2.wasm | filecheck %s --check-prefix SECONDARY

;; Regression test for a bug when an existing table, which is to be split to the
;; secondary module, has the name '0'. The newly created active table should
;; have a different name.

(module
 (table $0 0 externref)
 (export "split" (func $split))
 (func $split
  (table.set $0
   (i32.const 0)
   (ref.null extern)
  )
 )
)

;; PRIMARY:      (module
;; PRIMARY-NEXT:  (type $0 (func))
;; PRIMARY-NEXT:  (import "placeholder.deferred" "0" (func $placeholder_0))
;; PRIMARY-NEXT:  (table $0 1 funcref)
;; PRIMARY-NEXT:  (elem $0 (i32.const 0) $placeholder_0)
;; PRIMARY-NEXT:  (export "split" (func $trampoline_split))
;; PRIMARY-NEXT:  (export "table" (table $0))
;; PRIMARY-NEXT:  (func $trampoline_split
;; PRIMARY-NEXT:   (call_indirect (type $0)
;; PRIMARY-NEXT:    (i32.const 0)
;; PRIMARY-NEXT:   )
;; PRIMARY-NEXT:  )
;; PRIMARY-NEXT: )

;; SECONDARY:      (module
;; SECONDARY-NEXT:  (type $0 (func))
;; SECONDARY-NEXT:  (import "primary" "table" (table $timport$0 1 funcref))
;; SECONDARY-NEXT:  (table $0 0 externref)
;; SECONDARY-NEXT:  (elem $0 (table $timport$0) (i32.const 0) func $split)
;; SECONDARY-NEXT:  (func $split
;; SECONDARY-NEXT:   (table.set $0
;; SECONDARY-NEXT:    (i32.const 0)
;; SECONDARY-NEXT:    (ref.null noextern)
;; SECONDARY-NEXT:   )
;; SECONDARY-NEXT:  )
;; SECONDARY-NEXT: )
