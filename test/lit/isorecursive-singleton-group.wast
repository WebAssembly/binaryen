;; TODO: Autogenerate these checks! The current script cannot handle `rec`.

;; RUN: wasm-opt %s -all --hybrid -S -o - | filecheck %s
;; RUN: wasm-opt %s -all --hybrid --roundtrip -S -o - | filecheck %s

;; Check that everything works correctly when a recursion group has only a
;; single member. The rec group is implicit, so does not need to be printed.

(module

;; CHECK-NOT: rec
;; CHECK: (type $singleton (struct_subtype data))

 (rec
  (type $singleton (struct_subtype data))
 )

 ;; Use the type so it appears in the output.
 (global $g (ref null $singleton) (ref.null $singleton))
)
