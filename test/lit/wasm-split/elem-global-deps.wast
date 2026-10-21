;; RUN: wasm-split -all -g %s --keep-funcs=keep -o1 %t.1.wasm -o2 %t.2.wasm
;; RUN: wasm-dis %t.1.wasm | filecheck %s --check-prefix PRIMARY
;; RUN: wasm-dis %t.2.wasm | filecheck %s --check-prefix SECONDARY

(module
  (global $g i32 (i32.const 42))
  (table $t 1 1 funcref)

  ;; This elem $e stays in the primary module because table $t is used both in
  ;; the primary and secondary modules. So, this elem should be marked as "used"
  ;; in the secondary module, and global $g should not be exported / imported.
  (elem $e (table $t) (global.get $g) funcref (item (ref.null nofunc)))

  (func $keep
    (drop
      (table.get $t
        (i32.const 0)
      )
    )
  )
  (func $split
    (drop
      (table.get $t
        (i32.const 0)
      )
    )
  )
)

;; PRIMARY:      (module
;; PRIMARY-NEXT:  (type $0 (func))
;; PRIMARY-NEXT:  (global $g i32 (i32.const 42))
;; PRIMARY-NEXT:  (table $t 1 1 funcref)
;; PRIMARY-NEXT:  (elem $e (table $t) (global.get $g) funcref (item (ref.null nofunc)))
;; PRIMARY-NEXT:  (export "table" (table $t))
;; PRIMARY-NEXT:  (func $keep
;; PRIMARY-NEXT:   (drop
;; PRIMARY-NEXT:    (table.get $t
;; PRIMARY-NEXT:     (i32.const 0)
;; PRIMARY-NEXT:    )
;; PRIMARY-NEXT:   )
;; PRIMARY-NEXT:  )
;; PRIMARY-NEXT: )

;; SECONDARY:      (module
;; SECONDARY-NEXT:  (type $0 (func))
;; SECONDARY-NEXT:  (import "primary" "table" (table $t 1 1 funcref))
;; SECONDARY-NEXT:  (func $split
;; SECONDARY-NEXT:   (drop
;; SECONDARY-NEXT:    (table.get $t
;; SECONDARY-NEXT:     (i32.const 0)
;; SECONDARY-NEXT:    )
;; SECONDARY-NEXT:   )
;; SECONDARY-NEXT:  )
;; SECONDARY-NEXT: )
