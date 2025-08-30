;; RUN: wasm-split %s --keep-funcs=foo,bar --export-prefix='%' -o1 %t.1.wasm -o2 %t.2.wasm --no-placeholders
;; RUN: wasm-dis %t.1.wasm | filecheck %s --check-prefix PRIMARY
;; RUN: wasm-dis %t.2.wasm | filecheck %s --check-prefix SECONDARY

;; PRIMARY:      (module
;; PRIMARY-NEXT:   (type $0 (func))
;; PRIMARY-NEXT:   (table $0 1 funcref)
;; PRIMARY-NEXT:   (elem $0 (table $0) (i32.const 0) funcref (item (ref.null nofunc)))
;; PRIMARY-NEXT:   (export "baz" (func $2)
;; PRIMARY-NEXT:   (export "%a" (func $1))
;; PRIMARY-NEXT:   (export "%b" (func $0))
;; PRIMARY-NEXT:   (export "%c" (table $0))
;; PRIMARY-NEXT:   (func $0
;; PRIMARY-NEXT:     (nop)
;; PRIMARY-NEXT:   )
;; PRIMARY-NEXT:   (func $1
;; PRIMARY-NEXT:     (nop)
;; PRIMARY-NEXT:   )
;; PRIMARY-NEXT:   (func $2
;; PRIMARY-NEXT:     (call_indirect (type $0)
;; PRIMARY-NEXT:       (i32.const 0)
;; PRIMARY-NEXT:     )
;; PRIMARY-NEXT:   )
;; PRIMARY-NEXT: )

;; SECONDARY:      (module
;; SECONDARY-NEXT:   (type $0 (func))
;; SECONDARY-NEXT:   (import "primary" "%c" (table $timport$0 1 funcref))
;; SECONDARY-NEXT:   (import "primary" "%a" (func $fimport$0))
;; SECONDARY-NEXT:   (import "primary" "%b" (func $fimport$1))
;; SECONDARY-NEXT:   (elem $0 (i32.const 0) $0)
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
  (func $baz (export "baz")
    (call $foo)
    (call $bar)
  )
)
