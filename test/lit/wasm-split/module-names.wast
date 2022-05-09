;; Check that --emit-module-names without -g strips function names but generates
;; and keeps the module names.

;; RUN: wasm-split %s --keep-funcs=foo -o1 %t.primary.wasm -o2 %t.secondary.wasm --emit-module-names

;; RUN: wasm-dis %t.primary.wasm -o - | filecheck %s --check-prefix=PRIMARY
;; RUN: wasm-dis %t.secondary.wasm -o - | filecheck %s --check-prefix=SECONDARY

;; PRIMARY: (module $module-names.wast.tmp.primary.wasm
;; PRIMARY:   (func $0
;; PRIMARY-NOT: $foo

;; SECONDARY: (module $module-names.wast.tmp.secondary.wasm
;; SECONDARY:   (func $0
;; SECONDARY-NOT: $bar

(module
  (func $foo
    (nop)
  )
  (func $bar
    (nop)
  )
)
