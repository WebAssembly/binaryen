(module
 (import "mod'ule\"x" "ba\\se'" (func $base))
 (func $exported (export "exported")
  (call $base)
 )
)
