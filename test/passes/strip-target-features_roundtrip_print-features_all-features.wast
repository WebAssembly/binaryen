;; Test that features survive a round trip even if the target features
;; section is stripped

(module
  (func $foo (result v128 anyref )
    (tuple.make
      (v128.const i32x4 0 0 0 0)
      (ref.null)
    )
  )
  (func $bar (result v128 anyref)
    (return_call $foo)
  )
)
