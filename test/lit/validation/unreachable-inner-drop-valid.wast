;; RUN: wasm-as %s -o /dev/null

(module (func (block (unreachable) (drop))))
