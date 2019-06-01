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
