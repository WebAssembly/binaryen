;; Test the flag to import from a given module in fuzzer generation.

;; Generate fuzz output using this wat as initial contents, and importing the
;; side file.
;; RUN: wasm-opt %s.dat --initial-fuzz=%s -all -ttf --fuzz-import=%s.import \
;; RUN:          -S -o - | filecheck %s

(module
  ;; This existing import will be made a non-import, but the ones from the
  ;; imported module will be ok.
  (import "existing" "foo" (func $import))
)

;; CHECK-NOT:      (import "existing"

;; We must see an import from the primary module.
;; XXX This does depend on random choices in the fuzzer. We do have many chances
;;     to emit one such import (see the large file on the side), but if this
;;     turns out to be too unlikely, we can remove this test in favor of a unit
;;     test or the fuzzer.
;; CHECK:      (import "primary"

