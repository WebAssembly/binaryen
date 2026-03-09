;; RUN: wasm-split %s --keep-funcs=foo -o1 %t.1.wasm -o2 %t.2.wasm -g --strip-debug
;; RUN: wasm-dis %t.1.wasm | filecheck %s --check-prefix=PRIMARY
;; RUN: wasm-dis %t.2.wasm | filecheck %s --check-prefix=SECONDARY

;; Check that names are stripped from the output.
;; PRIMARY-NOT: $foo
;; SECONDARY-NOT: $bar

;; PRIMARY:      (module
;; PRIMARY-NEXT:  (type $0 (func))
;; PRIMARY-NEXT:  (import "placeholder.deferred" "0" (func $fimport$0))
;; PRIMARY-NEXT:  (table $0 1 funcref)
;; PRIMARY-NEXT:  (elem $0 (i32.const 0) $fimport$0)
;; PRIMARY-NEXT:  (export "table" (table $0))
;; PRIMARY-NEXT:  (func $0
;; PRIMARY-NEXT:   (call_indirect (type $0)
;; PRIMARY-NEXT:    (i32.const 0)
;; PRIMARY-NEXT:   )
;; PRIMARY-NEXT:  )
;; PRIMARY-NEXT: )

;; SECONDARY:      (module
;; SECONDARY-NEXT:  (type $0 (func))
;; SECONDARY-NEXT:  (import "primary" "table" (table $timport$0 1 funcref))
;; SECONDARY-NEXT:  (elem $0 (i32.const 0) $0)
;; SECONDARY-NEXT:  (func $0
;; SECONDARY-NEXT:   (nop)
;; SECONDARY-NEXT:  )
;; SECONDARY-NEXT: )

(module
  (func $foo
    (call $bar)
  )
  (func $bar
    (nop)
  )
)
