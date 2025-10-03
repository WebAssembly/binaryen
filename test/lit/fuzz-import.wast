;; Test the flag to import from a given module in fuzzer generation.

;; Generate fuzz output using this wat as initial contents, and with the flag to
;; preserve imports and exports. There should be no new imports or exports, and
;; old ones must stay the same.

;; RUN: wasm-opt %s.ttf --initial-fuzz=%s -all -ttf --fuzz-import=%s.import.wast \
;; RUN:          -S -o - | filecheck %s

(module
  ;; This existing import will be made a non-import, but the ones from the
  ;; imported module will be ok.
  (import "a" "b" (func $import))
)

;; We must see an import from the primary module
;; XXX This does depend on random choices in the fuzzer. We do have many chances
;;     to emit one such import, but if this turns out to be too unlikely, we
;;     can remove this test and depend on the fuzzer.
;; CHECK:      (import "primary" 

