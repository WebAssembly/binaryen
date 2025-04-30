;; Test that exact references in public types are disallowed without custom descriptors

;; RUN: not wasm-opt %s -all --disable-custom-descriptors 2>&1 | filecheck %s
;; RUN: wasm-opt %s -all -S -o - | filecheck %s --check-prefix=NOERR

;; CHECK:      [wasm-validator error in module] Exact reference in public type not allowed without custom descriptors [--enable-custom-descriptors], on
;; CHECK-NEXT: $struct
;; CHECK-NEXT: [wasm-validator error in module] Exact reference in public type not allowed without custom descriptors [--enable-custom-descriptors], on
;; CHECK-NEXT: $array
;; CHECK-NEXT: [wasm-validator error in module] Exact reference in public type not allowed without custom descriptors [--enable-custom-descriptors], on
;; CHECK-NEXT: $func

;; NOERR: (module

(module
  (type $struct (struct (field (ref null (exact $struct)))))
  (type $array (array (field (ref (exact $struct)))))
  (type $func (func (param (ref null (exact $struct))) (result (ref (exact $array)))))

  (import "" "struct" (global $struct (ref $struct)))
  (import "" "array" (global $array (ref $array)))
  (import "" "func" (global $func (ref $func)))
)
