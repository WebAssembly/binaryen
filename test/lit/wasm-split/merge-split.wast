;; RUN: wasm-merge %s first %s.second second %s.third third --output-manifest %t.manifest -S -o %t.wasm
;; RUN: wasm-split %t.wasm --multi-split --manifest %t.manifest -g -o %t.primary.wasm --out-prefix %t.
;; RUN: wasm-dis %t.primary.wasm | filecheck %s --check-prefix PRIMARY
;; RUN: wasm-dis %t.second.wasm | filecheck %s --check-prefix SECOND
;; RUN: wasm-dis %t.third.wasm | filecheck %s --check-prefix THIRD

;; PRIMARY:      (module
;; PRIMARY-NEXT:  (type $0 (func))
;; PRIMARY-NEXT:  (import "env" "imported_first" (func $imported_first))
;; PRIMARY-NEXT:  (import "env" "imported_second" (func $imported_second))
;; PRIMARY-NEXT:  (import "env" "imported_third" (func $imported_third))
;; PRIMARY-NEXT:  (import "placeholder.second" "0" (func $placeholder_0))
;; PRIMARY-NEXT:  (import "placeholder.third" "1" (func $placeholder_1))
;; PRIMARY-NEXT:  (table $0 2 funcref)
;; PRIMARY-NEXT:  (elem $0 (i32.const 0) $placeholder_0 $placeholder_1)
;; PRIMARY-NEXT:  (export "first_func" (func $first_func))
;; PRIMARY-NEXT:  (export "second_func" (func $trampoline_second_func))
;; PRIMARY-NEXT:  (export "third_func" (func $trampoline_third_func))
;; PRIMARY-NEXT:  (export "imported_second" (func $imported_second))
;; PRIMARY-NEXT:  (export "imported_third" (func $imported_third))
;; PRIMARY-NEXT:  (export "table" (table $0))
;; PRIMARY-NEXT:  (func $first_func
;; PRIMARY-NEXT:   (call $imported_first)
;; PRIMARY-NEXT:  )
;; PRIMARY-NEXT:  (func $trampoline_second_func
;; PRIMARY-NEXT:   (call_indirect (type $0)
;; PRIMARY-NEXT:    (i32.const 0)
;; PRIMARY-NEXT:   )
;; PRIMARY-NEXT:  )
;; PRIMARY-NEXT:  (func $trampoline_third_func
;; PRIMARY-NEXT:   (call_indirect (type $0)
;; PRIMARY-NEXT:    (i32.const 1)
;; PRIMARY-NEXT:   )
;; PRIMARY-NEXT:  )
;; PRIMARY-NEXT: )

;; SECOND:      (module
;; SECOND-NEXT:  (type $0 (func))
;; SECOND-NEXT:  (import "primary" "table" (table $timport$0 2 funcref))
;; SECOND-NEXT:  (import "primary" "imported_second" (func $imported_second))
;; SECOND-NEXT:  (elem $0 (i32.const 0) $second_func)
;; SECOND-NEXT:  (func $second_func
;; SECOND-NEXT:   (call $imported_second)
;; SECOND-NEXT:  )
;; SECOND-NEXT: )

;; THIRD:      (module
;; THIRD-NEXT:  (type $0 (func))
;; THIRD-NEXT:  (import "primary" "table" (table $timport$0 2 funcref))
;; THIRD-NEXT:  (import "primary" "imported_third" (func $imported_third))
;; THIRD-NEXT:  (elem $0 (i32.const 1) $third_func)
;; THIRD-NEXT:  (func $third_func
;; THIRD-NEXT:   (call $imported_third)
;; THIRD-NEXT:  )
;; THIRD-NEXT: )

(module
  (import "env" "imported_first" (func $imported_first))
  (func $first_func (export "first_func")
    (call $imported_first)
  )
)
