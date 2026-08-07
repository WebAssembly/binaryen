;; RUN: wasm-as %s -o /dev/null
;; RUN: wasm-opt %s -o /dev/null

;; Void unreachable block at the end of a concretely typed function must
;; remain parseable without leaving a spurious value on the Wasm stack.

(module
  (func (result i32)
    (block
      (unreachable)
    )
  )
)
