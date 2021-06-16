;; Test tags

(module
  (tag (attr 0) (param i32))
  (tag $e (attr 0) (param i32 f32))

  (tag $e-params0 (attr 0) (param i32 f32))
  (tag $e-params1 (attr 0) (param i32) (param f32))

  (tag $e-export (export "ex0") (attr 0) (param i32))
  (tag $e-import (import "env" "im0") (attr 0) (param i32))

  (import "env" "im1" (tag (attr 0) (param i32 f32)))
  (export "ex1" (tag $e))
)

(assert_invalid
  (module (tag $e (attr 0) (param i32) (result i32)))
  "Tag type's result type should be none"
)

(assert_invalid
  (module (tag $e (attr 1) (param i32)))
  "Currently only attribute 0 is supported"
)

(assert_invalid
  (module
    (type $t (param i32))
    (tag $e (attr 0) (type $t) (param i32 f32))
  )
  "type and param don't match"
)
