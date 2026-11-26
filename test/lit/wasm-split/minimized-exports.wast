;; RUN: wasm-split %s --keep-funcs=foo,bar --export-prefix='%' -o1 %t.1.wasm -o2 %t.2.wasm --no-placeholders
;; RUN: wasm-dis %t.1.wasm | filecheck %s --check-prefix PRIMARY
;; RUN: wasm-dis %t.2.wasm | filecheck %s --check-prefix SECONDARY

;; PRIMARY:      (module
;; PRIMARY-NEXT:   (type $0 (func))
;; PRIMARY-NEXT:   (table $%c 1 funcref)
;; PRIMARY-NEXT:   (elem $0 (i32.const 0) $3)
;; PRIMARY-NEXT:   (export "baz" (func $baz))
;; PRIMARY-NEXT:   (export "%a" (func $%a))
;; PRIMARY-NEXT:   (export "%b" (func $%b))
;; PRIMARY-NEXT:   (export "%c" (table $%c))
;; PRIMARY-NEXT:   (func $%b
;; PRIMARY-NEXT:     (nop)
;; PRIMARY-NEXT:   )
;; PRIMARY-NEXT:   (func $%a
;; PRIMARY-NEXT:     (nop)
;; PRIMARY-NEXT:   )
;; PRIMARY-NEXT:   (func $baz
;; PRIMARY-NEXT:     (call_indirect (type $0)
;; PRIMARY-NEXT:       (i32.const 0)
;; PRIMARY-NEXT:     )
;; PRIMARY-NEXT:   )
;; PRIMARY-NEXT:   (func $3
;; PRIMARY-NEXT:     (unreachable)
;; PRIMARY-NEXT:   )
;; PRIMARY-NEXT: )

;; SECONDARY:      (module
;; SECONDARY-NEXT:   (type $0 (func))
;; SECONDARY-NEXT:   (import "primary" "%c" (table $%c 1 funcref))
;; SECONDARY-NEXT:   (import "primary" "%a" (func $%a))
;; SECONDARY-NEXT:   (import "primary" "%b" (func $%b))
;; SECONDARY-NEXT:   (elem $0 (i32.const 0) $0)
;; SECONDARY-NEXT:   (func $0
;; SECONDARY-NEXT:     (call $%b)
;; SECONDARY-NEXT:     (call $%a)
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
