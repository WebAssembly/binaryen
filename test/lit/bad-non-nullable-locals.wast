;; Test that an invalid supertype results in a useful error message

;; RUN: foreach %s %t not wasm-opt -all 2>&1 | filecheck %s

;; CHECK: non-nullable local's sets must dominate gets
(module
  (func $inner-to-func
    ;; a set in an inner scope does *not* help a get validate.
    (local $x (ref func))
    (block $b
      (local.set $x
        (ref.func $helper)
      )
    )
    (drop
      (local.get $x)
    )
  )

  (func $helper)
)

