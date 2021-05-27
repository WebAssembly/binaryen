;; RUN: wasm-split %s --keep-funcs=foo,bar --export-prefix='%' -o1 %t.1.wasm -o2 %t.2.wasm
;; RUN: wasm-dis %t.1.wasm | filecheck %s --check-prefix PRIMARY
;; RUN: wasm-dis %t.2.wasm | filecheck %s --check-prefix SECONDARY

;; PRIMARY:      (module
;; PRIMARY-NEXT:   (type $none_=>_none (func))
;; PRIMARY-NEXT:   (export "%a" (func $1))
;; PRIMARY-NEXT:   (export "%b" (func $0))
;; PRIMARY-NEXT:   (func $0
;; PRIMARY-NEXT:     (nop)
;; PRIMARY-NEXT:   )
;; PRIMARY-NEXT:   (func $1
;; PRIMARY-NEXT:     (nop)
;; PRIMARY-NEXT:   )
;; PRIMARY-NEXT: )

;; SECONDARY:      (module
;; SECONDARY-NEXT:   (type $none_=>_none (func))
;; SECONDARY-NEXT:   (import "primary" "%a" (func $fimport$0))
;; SECONDARY-NEXT:   (import "primary" "%b" (func $fimport$1))
;; SECONDARY-NEXT:   (func $0
;; SECONDARY-NEXT:     (call $fimport$1)
;; SECONDARY-NEXT:     (call $fimport$0)
;; SECONDARY-NEXT:   )
;; SECONDARY-NEXT: )

(module
  (func $foo
    (nop)
  )
  (func $bar
    (nop)
  )
  (func $baz
    (call $foo)
    (call $bar)
  )
)
