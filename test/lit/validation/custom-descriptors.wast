;; Test that custom descriptors instructions are validated correctly.

;; RUN: not wasm-opt %s -all 2>&1 | filecheck %s

;; CHECK: [wasm-validator error in function ref.get_desc-inexact] function body type must match, if function returns

(module
  (rec
    (type $described (descriptor $describing (struct)))
    (type $describing (describes $described (struct)))
  )

  (func $ref.get_desc-inexact (param (ref null $described)) (result (ref (exact $describing)))
    ;; The result should be inexact because the input is inexact.
    (ref.get_desc $described
      (local.get 0)
    )
  )
)
