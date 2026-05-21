;; RUN: wasm-split %s --disable-reference-types --keep-funcs=keep --export-prefix='%' -o1 %t.1.wasm -o2 %t.2.wasm --no-placeholders -g
;; RUN: wasm-dis %t.1.wasm | filecheck %s --check-prefix PRIMARY

;; When --no-placeholder is given and reference-types is disabled, we cannot
;; fill the table with ref.nulls. Use a dummy function.

(module
  ;; PRIMARY:      (table $table 4 4 funcref)
  ;; PRIMARY:      (elem $0 (i32.const 0) $dummy $dummy $dummy $keep)
  (table $table 4 4 funcref)
  (elem (i32.const 0) $split1 $split2 $split3 $keep)

  ;; PRIMARY:      (func $dummy
  ;; PRIMARY-NEXT:  (unreachable)
  ;; PRIMARY-NEXT: )

  (func $keep
    (nop)
  )

  (func $split1
    (nop)
  )

  (func $split2 (param i32)
    (nop)
  )

  (func $split3 (param i32) (result i32)
    (i32.const 0)
  )
)
