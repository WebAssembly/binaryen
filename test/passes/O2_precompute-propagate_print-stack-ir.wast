(module
 (func "func" (param $var$0 i32) (param $var$1 i32) (param $var$2 i32) (param $var$3 i64) (result i64)
  (local $var$4 i32)
  (block $label$1
   (set_local $var$3
    (i64.const 2147483647)
   )
   (br_if $label$1
    (get_local $var$4) ;; precompute-propagate will optimize this into 0, then the br_if is nopped
                       ;; in place. if stack ir is not regenerated, that means we have the get
                       ;; on the stack from before, and the br_if is now a nop, which means no one
                       ;; pops the get
   )
  )
  (get_local $var$3)
 )
)

