(module
  ;; Two imports, one which will be reffed.
  (import "module" "base" (func $import (param i32 f64) (result f32)))
  (import "module" "base" (func $import-reffed (param i32 f64) (result f32)))

  ;; Two exports, one which will be reffed.

  (func $export (export "export") (param $0 i32) (param $1 f64) (result f32)
    (drop
      (ref.func $import-reffed)
    )
    (drop
      (ref.func $export-reffed)
    )
    (f32.const 3.14159)
  )

  (func $export-reffed (export "export-reffed") (param $0 i32) (param $1 f64) (result f32)
    ;; Use the GC types.
    (f32.const 99.123)
  )
)
