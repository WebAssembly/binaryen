;; Test that shared nulls require shared-everything threads

;; RUN: not wasm-opt %s 2>&1 | filecheck %s --check-prefix NO-SHARED
;; RUN: wasm-opt %s --enable-reference-types --enable-gc --enable-shared-everything -o - -S | filecheck %s --check-prefix SHARED

;; NO-SHARED: ref.null requires additional features
;; NO-SHARED: [--enable-reference-types --enable-gc --enable-shared-everything]
;; SHARED: (ref.null (shared none))

(module
  (func (drop (ref.null (shared none))))
)
