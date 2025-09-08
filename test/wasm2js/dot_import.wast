(module
 (import "mod.ule" "ba.se" (func $base))
 (func $exported (export "exported")
  (call $base)
 )
)
