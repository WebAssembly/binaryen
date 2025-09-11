;; RUN: wasm-split %s --keep-funcs=bar -o1 %t.1.wasm -o2 %t.2.wasm --symbolmap
;; RUN: filecheck %s --check-prefix PRIMARY-MAP < %t.1.wasm.symbols
;; RUN: filecheck %s --check-prefix SECONDARY-MAP < %t.2.wasm.symbols
;; RUN: wasm-dis %t.1.wasm | filecheck %s --check-prefix PRIMARY

;; PRIMARY-MAP: 0:placeholder_0
;; PRIMARY-MAP: 1:placeholder_2
;; PRIMARY-MAP: 2:bar

;; SECONDARY-MAP: 0:baz
;; SECONDARY-MAP: 1:foo

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
