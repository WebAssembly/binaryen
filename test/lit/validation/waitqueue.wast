;; RUN: not wasm-opt --enable-reference-types --enable-gc %s 2>&1 | filecheck %s

(module
  ;; CHECK:      invalid type: Shared types require shared-everything
  (type $t (struct (field waitqueue)))

  ;; use $t so wasm-opt doesn't drop the definition
  (global (ref null $t) (ref.null $t))
)
