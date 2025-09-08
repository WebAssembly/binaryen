;; Test that casting to exact types without custom descriptors is a validation
;; error.

;; RUN: not wasm-opt %s -all --disable-custom-descriptors 2>&1 | filecheck %s

;; CHECK: [wasm-validator error in function ref.cast] unexpected false: ref.cast to exact type requires custom descriptors [--enable-custom-descriptors],

;; CHECK: [wasm-validator error in function ref.test] unexpected false: ref.test of exact type requires custom descriptors [--enable-custom-descriptors],

;; CHECK: [wasm-validator error in function br_on_cast] unexpected false: br_on_cast* to exact type requires custom descriptors [--enable-custom-descriptors],

;; CHECK: [wasm-validator error in function br_on_cast_fail] unexpected false: br_on_cast* to exact type requires custom descriptors [--enable-custom-descriptors],

(module
  (type $foo (struct))

  (func $ref.cast (param anyref)
    (drop
      (ref.cast (ref null (exact $foo))
        (local.get 0)
      )
    )
  )

  (func $ref.test (param anyref)
    (drop
      (ref.test (ref (exact $foo))
        (local.get 0)
      )
    )
  )

  (func $br_on_cast (param anyref)
    (drop
      (block (result anyref)
        (br_on_cast 0 anyref (ref null (exact $foo))
          (local.get 0)
        )
      )
    )
  )

  (func $br_on_cast_fail (param anyref)
    (drop
      (block (result anyref)
        (br_on_cast_fail 0 anyref (ref (exact $foo))
          (local.get 0)
        )
      )
    )
  )
)
