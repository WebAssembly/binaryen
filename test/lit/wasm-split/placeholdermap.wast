;; RUN: wasm-split %s --keep-funcs=bar -o1 %t.1.wasm -o2 %t.2.wasm --placeholdermap
;; RUN: filecheck %s --check-prefix MAP < %t.1.wasm.placeholders
;; RUN: wasm-dis %t.1.wasm | filecheck %s --check-prefix PRIMARY

;; MAP:      0:foo
;; MAP-NEXT: 2:baz
;; MAP-NOT: bar

;; Check that the names have been stripped.
;; PRIMARY: (func $0

(module
  (table $table 3 3 funcref)
  (elem $table (i32.const 0) $foo $bar $baz)
  (func $foo
    (nop)
  )
  (func $bar
    (nop)
  )
  (func $baz
    (nop)
  )
)
