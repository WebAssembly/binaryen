;; Test that features enabled on the IR Module survive a round trip
;; even if the target features section is stripped first

(module
  (func $foo (result v128 externref )
    (tuple.make
      (v128.const i32x4 0 0 0 0)
      (ref.null extern)
    )
  )
  (func $bar (result v128 externref)
    (return_call $foo)
  )
)
