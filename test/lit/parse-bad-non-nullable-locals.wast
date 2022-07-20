;; Test that an invalid supertype results in a useful error message

;; RUN: foreach %s %t not wasm-opt -all -S -o - | filecheck %s

;; CHECK: Fatal: Invalid type: waka
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
)

