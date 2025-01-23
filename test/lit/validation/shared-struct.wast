;; Test that shared structs require shared-everything threads

;; RUN: not wasm-opt %s 2>&1 | filecheck %s --check-prefix NO-SHARED
;; RUN: wasm-opt %s --enable-reference-types --enable-gc --enable-shared-everything -o - -S | filecheck %s --check-prefix SHARED

;; NO-SHARED: global type requires additional features [--enable-reference-types --enable-gc --enable-shared-everything]
;; SHARED: (type $t (shared (struct)))

(module
  (type $t (shared (struct)))
  (global (import "" "") (ref null $t))
)
