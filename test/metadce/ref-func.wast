(module
 (import "env" "f1" (func $f1))
 (import "env" "f2" (func $f2))

 (export "g" (global $g))
 (export "f" (func $f))

 (global $g funcref (ref.func $f1))

 (func $f (result funcref) (ref.func $f2))
)
