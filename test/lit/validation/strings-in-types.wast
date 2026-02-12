;; Test that string heap types require strings to be enabled.

;; RUN: not wasm-opt %s 2>&1 | filecheck %s --check-prefix NO-STRINGS
;; RUN: wasm-opt %s --enable-reference-types --enable-strings -o - -S | filecheck %s --check-prefix STRINGS

;; NO-STRINGS: invalid type: String types require strings feature
;; STRINGS: (type $s (func (param stringref)))

(module
  (type $s (func (param stringref)))
  (global $g (ref null $s) (ref.null nofunc))
)
