;; RUN: not wasm-opt %s -all 2>&1 | filecheck %s

;; Check we error properly when a block has no value, but a br_on with a value
;; targets it.

(module
  ;; CHECK: 10:7: error: br_on target does not expect a value
  (func $f
    (block $foo
      (br_on_cast $foo (ref eq) (ref eq)
        (ref.i31
          (i32.const 0)
        )
      )
    )
  )
)
