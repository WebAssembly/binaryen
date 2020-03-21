(module
  (export "ref_func_test" (func $ref_func_test))
  ;; $foo should not be removed after being inlined, because there is 'ref.func'
  ;; instruction that refers to it
  (func $foo)
  (func $ref_func_test (result funcref)
    (call $foo)
    (ref.func $foo)
  )

  ;; Tests if UniqueNameMapper works correctly for br_on_exn labels.
  ;; We have $l in br_on_exns in both $func_inner and $br_on_name_uniquify_test,
  ;; which should become unique names respectively after inlining.
  (event $e (attr 0) (param i32))
  (func $func_inner
    (local $exn exnref)
    (drop
      (block $l (result i32)
        (drop
          (br_on_exn $l $e (local.get $exn))
        )
        (i32.const 0)
      )
    )
  )
  (func $br_on_exn_name_uniquify_test
    (local $exn exnref)
    (drop
      (block $l (result i32)
        (call $func_inner)
        (drop
          (br_on_exn $l $e (local.get $exn))
        )
        (i32.const 0)
      )
    )
  )
)
