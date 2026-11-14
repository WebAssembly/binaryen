;; Test that string casts without strings is a validation error.

;; RUN: not wasm-opt %s --enable-reference-types --disable-strings --disable-gc 2>&1 | filecheck %s

;; CHECK: [wasm-validator error in function cast] unexpected false: ref.cast requires gc [--enable-gc]
;; CHECK: [wasm-validator error in function cast-nullexternref] unexpected false: ref.cast requires gc [--enable-gc]
;; CHECK: [wasm-validator error in function cast-unreachable] unexpected false: ref.cast requires gc [--enable-gc]

(module
  (func $cast (param $x externref) (result stringref)
    (ref.cast stringref
      (local.get $x)
    )
  )

  (func $cast-nullexternref (param $x externref) (result nullexternref)
    (ref.cast nullexternref
      (local.get $x)
    )
  )

  (func $cast-unreachable (result stringref)
    (ref.cast stringref
      (unreachable)
    )
  )
)
