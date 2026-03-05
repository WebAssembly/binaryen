;; RUN: wasm-split %s -all -g -o1 %t.1.wasm -o2 %t.2.wasm --keep-funcs=keep
;; RUN: wasm-dis %t.1.wasm | filecheck %s --check-prefix PRIMARY
;; RUN: wasm-dis %t.2.wasm | filecheck %s --check-prefix SECONDARY

;; When a split global ($a here)'s initializer contains a ref.func of a split
;; function, currently we create its trampoline in the primary module and export
;; it.
;; TODO Use $split in the secondary module directly in the split global

(module
  ;; PRIMARY:      (func $keep
  ;; PRIMARY-NEXT: )
  (func $keep)

  ;; SECONDARY:      (global $a funcref (ref.func $split))
  (global $a funcref (ref.func $split))

  ;; SECONDARY:      (func $split
  ;; SECONDARY-NEXT:  (drop
  ;; SECONDARY-NEXT:   (global.get $a)
  ;; SECONDARY-NEXT:  )
  ;; SECONDARY-NEXT: )
  (func $split
    (drop
      (global.get $a)
    )
  )
)
