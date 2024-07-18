;; Test that the features required by element segment types are checked

;; RUN: not wasm-opt %s -all --disable-shared-everything 2>&1 | filecheck %s --check-prefix NO-SHARED
;; RUN: wasm-opt %s -all -S -o - | filecheck %s --check-prefix SHARED

;; NO-SHARED: element segment type requires additional features
;; NO-SHARED: [--enable-shared-everything]
;; SHARED: (elem $e (ref null (shared func)))

(module
  (elem $e (ref null (shared func)))
)
