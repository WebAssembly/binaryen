;; RUN: wasm-opt %s -all -o /dev/null
;; RUN: wasm-as %s -all -o /dev/null

;; Parser accepts this IR (same as baseline). Wasm validation of the resulting
;; module is not checked here.

(module (func (block (unreachable)) (drop)))
