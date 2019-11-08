;; Test events

(module
  (event (attr 0) (param i32))
  (event $e (attr 0) (param i32 f32))

  (event $e-params0 (attr 0) (param i32 f32))
  (event $e-params1 (attr 0) (param i32) (param f32))

  (event $e-export (export "ex0") (attr 0) (param i32))
  (event $e-import (import "env" "im0") (attr 0) (param i32))

  (import "env" "im1" (event (attr 0) (param i32 f32)))
  (export "ex1" (event $e))
)

(assert_invalid
  (module (event $e (attr 0) (param i32) (result i32)))
  "Event type's result type should be none"
)

(assert_invalid
  (module (event $e (attr 1) (param i32)))
  "Currently only attribute 0 is supported"
)

(assert_invalid
  (module (event $e (attr 0) (param exnref)))
  "Values in an event should have integer or float type"
)

(assert_invalid
  (module
    (type $t (param i32))
    (event $e (attr 0) (type $t) (param i32 f32))
  )
  "type and param don't match"
)
