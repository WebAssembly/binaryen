;; Test that the features required by table types are checked

;; RUN: not wasm-opt %s -all --disable-shared-everything 2>&1 | filecheck %s --check-prefix NO-SHARED
;; RUN: wasm-opt %s -all -S -o - | filecheck %s --check-prefix SHARED

;; NO-SHARED: table type requires additional features
;; NO-SHARED: [--enable-shared-everything]
;; SHARED: (table $t 0 0 (ref null (shared func)))

(module
  (table $t 0 0 (ref null (shared func)))
)
