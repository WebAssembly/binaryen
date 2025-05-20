;; RUN: not wasm-opt %s -S -o - 2>&1 | filecheck %s

;; CHECK: 10:7: error: expected type with descriptor

(module
  (type $no-descriptor (struct))

  (func $ref.get_desc-no-descriptor (param (ref null $no-descriptor))
    (drop
      (ref.get_desc $no-descriptor
        (local.get 0)
      )
    )
  )
)
