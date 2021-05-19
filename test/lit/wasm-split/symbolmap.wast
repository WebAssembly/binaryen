;; RUN: wasm-split %s --keep-funcs=bar -o1 %t.1.wasm -o2 %t.2.wasm --symbolmap
;; RUN: filecheck %s --check-prefix PRIMARY < %t.1.wasm.symbolmap
;; RUN: filecheck %s --check-prefix SECONDARY < %t.2.wasm.symbolmap

;; PRIMARY: 0:bar

;; SECONDARY: 0:baz
;; SECONDARY: 1:foo

(module
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
