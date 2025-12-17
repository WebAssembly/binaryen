(module
 (import "import" "tag" (tag $tag))
 (import "import" "func" (func $logi64 (param i64)))
 (import "import" "memory" (memory $memory 1 1))
 ;; TODO: Fix importing for these two remaining types
 ;; (import "import" "global" (global $global i32))
 ;; (import "import" "table" (table $table 1 1 anyref))

 (global $non-imported-global (export "g") (mut i32) (i32.const 0))
 (func $foo (result i32)
  (nop)
  (drop (global.get $non-imported-global))
  (global.set $non-imported-global (i32.const 1))
  (global.get $non-imported-global)
 )
 (export "foo" (func $foo))
) 
