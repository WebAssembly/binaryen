;; RUN: not wasm-opt --enable-reference-types --enable-gc %s 2>&1 | filecheck %s

(module
  ;; CHECK:      [wasm-validator error in module] Waitqueues require shared-everything [--enable-shared-everything], on
  ;; CHECK-NEXT: (type $struct.0 (struct (field waitqueue)))
  (type $t (struct (field waitqueue)))

  ;; use $t so wasm-opt doesn't drop the definition
  (global (ref null $t) (ref.null $t))
)
