;; This makes sure --flatten is skipped on this module, because this module
;; enables exception handling.
(module
 (func $a1
  (drop (i32.add (i32.const 0) (i32.const 1)))
 )
)
