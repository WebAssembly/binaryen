;; Test that shared abstract heap types require shared-everything threads

;; RUN: not wasm-opt %s 2>&1 | filecheck %s --check-prefix NO-SHARED
;; RUN: wasm-opt %s --enable-reference-types --enable-gc --enable-shared-everything -o - -S | filecheck %s --check-prefix SHARED

;; NO-SHARED: invalid type: Shared types require shared-everything
;; SHARED: (type $t (struct (field (ref null (shared any)))))

(module
  (type $t (struct (field (ref null (shared any)))))
  (global (ref null $t) (ref.null none))
)
