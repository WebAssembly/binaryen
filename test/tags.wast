;; Test tags

(module
  (tag (param i32))
  (tag $e (param i32 f32))
  (tag $empty)

  (tag $e-params0 (param i32 f32))
  (tag $e-params1 (param i32) (param f32))

  (tag $e-export (export "ex0") (param i32))
  (tag $e-import (import "env" "im0") (param i32))

  (import "env" "im1" (tag (param i32 f32)))
  (export "ex1" (tag $e))
)
