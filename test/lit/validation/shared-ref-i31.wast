;; Test that ref.i31_shared requires shared-everything threads

;; RUN: not wasm-opt %s -all --disable-shared-everything 2>&1 | filecheck %s --check-prefix NO-SHARED
;; RUN: wasm-opt %s --enable-reference-types --enable-gc --enable-shared-everything -o - -S | filecheck %s --check-prefix SHARED

;; NO-SHARED: ref.i31_shared requires shared-everything [--enable-shared-everything]
;; SHARED: (ref.i31_shared
;; SHARED-NEXT: (i32.const 0)

(module
  (func (drop (ref.i31_shared (i32.const 0))))
)
