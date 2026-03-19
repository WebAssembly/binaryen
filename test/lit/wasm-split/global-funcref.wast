;; RUN: wasm-split %s -all -g -o1 %t.1.wasm -o2 %t.2.wasm --keep-funcs=keep
;; RUN: wasm-dis %t.1.wasm | filecheck %s --check-prefix PRIMARY
;; RUN: wasm-dis %t.2.wasm | filecheck %s --check-prefix SECONDARY

;; When a split global ($a here)'s initializer contains a ref.func of a split
;; function, we should NOT create any trampolines, and the split global should
;; direclty refer to the function.

(module
  (global $a funcref (ref.func $split))
  (global $b funcref (ref.func $keep))

  ;; PRIMARY:      (export "keep" (func $keep))

  ;; PRIMARY-NOT:  (export "trampoline_split"
  ;; PRIMARY-NOT:  (func $trampoline_split

  ;; SECONDARY:      (import "primary" "keep" (func $keep (exact)))

  ;; SECONDARY:      (global $a funcref (ref.func $split))
  ;; SECONDARY:      (global $b funcref (ref.func $keep))

  ;; PRIMARY:      (func $keep
  ;; PRIMARY-NEXT: )
  (func $keep)

  ;; SECONDARY:      (func $split
  ;; SECONDARY-NEXT:  (drop
  ;; SECONDARY-NEXT:   (global.get $a)
  ;; SECONDARY-NEXT:  )
  ;; SECONDARY-NEXT:  (drop
  ;; SECONDARY-NEXT:   (global.get $b)
  ;; SECONDARY-NEXT:  )
  ;; SECONDARY-NEXT: )
  (func $split
    (drop
      (global.get $a)
    )
    (drop
      (global.get $b)
    )
  )
)
