;; Test that shared basic heap types require shared-everything threads

;; RUN: not wasm-opt %s 2>&1 | filecheck %s --check-prefix NO-SHARED
;; RUN: wasm-opt %s --enable-reference-types --enable-gc --enable-shared-everything -o - -S | filecheck %s --check-prefix SHARED

;; NO-SHARED: global type requires additional features [--enable-reference-types --enable-gc --enable-shared-everything]
;; SHARED: (import "" "" (global $gimport$0 (ref null (shared any))))

(module
  (global (import "" "") (ref null (shared any)))
)
