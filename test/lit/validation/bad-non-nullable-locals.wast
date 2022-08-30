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

;; CHECK: non-nullable local's sets must dominate gets
(module
  (func $get-without-set
    (local $x (ref func))
    (drop
      (local.get $x)
    )
  )

  (func $helper)
)

;; CHECK: non-nullable local's sets must dominate gets
(module
  (func $get-before-set
    (local $x (ref func))
    (local.set $x
      (local.get $x)
    )
  )

  (func $helper)
)

;; CHECK: non-nullable local's sets must dominate gets
(module
  (func $if-arms
    (local $x (ref func))
    (if
      (i32.const 1)
      ;; Superficially the order is right, but not really.
      (local.set $x
        (ref.func $helper)
      )
      (local.get $x)
    )
  )

  (func $helper)
)

