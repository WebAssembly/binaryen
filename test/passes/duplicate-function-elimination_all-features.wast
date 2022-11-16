;; --duplicate-function-elimination should not remove functions used in ref.func.
(module
  (func $0 (result i32)
    (i32.const 0)
  )
  (func $1 (result i32)
    (i32.const 0)
  )
  (func $test (result funcref)
    (ref.func $1)
  )
)
;; renaming after deduplication must only affect functions
(module
 (memory $foo 16 16)
 (global $bar i32 (i32.const 0))
 (export "memory" (memory $foo))
 (export "global" (global $bar))
 (func $bar ;; happens to share a name with the global
 )
 (func $foo ;; happens to share a name with the memory
 )
)
;; renaming after deduplication must update ref.funcs in globals
(module
 (type $func (func (result i32)))
 (global $global$0 (ref $func) (ref.func $bar))
 ;; These two identical functions can be merged. The ref.func in the global must
 ;; be updated accordingly.
 (func $foo (result i32)
  (unreachable)
 )
 (func $bar (result i32)
  (unreachable)
 )
 (func "export" (result i32)
  (call_ref $func
   (global.get $global$0)
  )
 )
)
