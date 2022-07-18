;; TODO: Autogenerate these checks! The current script cannot handle `rec`.

;; RUN: wasm-opt %s -all --hybrid -S -o - | filecheck %s
;; RUN: wasm-opt %s -all --hybrid --roundtrip -S -o - | filecheck %s

;; Check that unused types are still included in the output when they are part
;; of a recursion group with used types.

(module

;; CHECK:      (rec
;; CHECK-NEXT:  (type $used (struct_subtype data))
;; CHECK-NEXT:  (type $unused (struct_subtype data))
;; CHECK-NEXT: )

 (rec
  (type $used (struct_subtype data))
  (type $unused (struct_subtype data))
 )

 (global $g (ref null $used) (ref.null $used))
)
