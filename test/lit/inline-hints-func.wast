;; RTODOUN: wasm-opt -all --roundtrip %s -S -o - | filecheck %s

(module
  (@metadata.code.inline "\12")
  (func $func-annotation
    ;; The annotation here is on the function.
    (drop
      (i32.const 0)
    )
  )
)

;; RUN: wasm-opt -all             %s -S -o - | filecheck %s

