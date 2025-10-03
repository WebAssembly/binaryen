;; Use lots of functions so we end up importing at least some.
(module
  (global $g i32 (i32.const 42))

  ;; A non-function export should not cause problems.
  (export "e-g" (global $g))

  (func $a (export "e-a") (param i32)
  )
  (func $a1 (export "e-a1") (param i32)
  )
  (func $a2 (export "e-a2") (param i32)
  )
  (func $a3 (export "e-a3") (param i32)
  )
  (func $a4 (export "e-a4") (param i32)
  )

  (func $b (export "e-b") (result i32)
   (i32.const 0)
  )
  (func $b1 (export "e-b1") (result i32)
   (i32.const 1)
  )
  (func $b2 (export "e-b2") (result i32)
   (i32.const 2)
  )
  (func $b3 (export "e-b3") (result i32)
   (i32.const 3)
  )
  (func $b4 (export "e-b4") (result i32)
   (i32.const 4)
  )

  ;; A non-exported function should not cause a problem.
  (func $c
  )
)

