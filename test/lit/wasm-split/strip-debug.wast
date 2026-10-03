;; RUN: wasm-split %s --keep-funcs=foo -o1 %t.1.wasm -o2 %t.2.wasm -g --strip-debug
;; RUN: wasm-dis %t.1.wasm | filecheck %s --check-prefix=PRIMARY
;; RUN: wasm-dis %t.2.wasm | filecheck %s --check-prefix=SECONDARY

;; Check that names are stripped from the output.
;; PRIMARY-NOT: $foo
;; SECONDARY-NOT: $bar

;; PRIMARY:      (module
;; PRIMARY-NEXT:  (type $0 (func))
;; PRIMARY-NEXT:  (import "placeholder.deferred" "0" (func $0))
;; PRIMARY-NEXT:  (table $table 1 funcref)
;; PRIMARY-NEXT:  (elem $0 (i32.const 0) $0)
;; PRIMARY-NEXT:  (export "table" (table $table))
;; PRIMARY-NEXT:  (func $0_1
;; PRIMARY-NEXT:   (call_indirect (type $0)
;; PRIMARY-NEXT:    (i32.const 0)
;; PRIMARY-NEXT:   )
;; PRIMARY-NEXT:  )
;; PRIMARY-NEXT: )

;; SECONDARY:      (module
;; SECONDARY-NEXT:  (type $0 (func))
;; SECONDARY-NEXT:  (import "primary" "table" (table $table 1 funcref))
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
