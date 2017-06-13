(module
 (func $nested-br_if-value (param $var$0 i32) (result i32)
  (local $1 i32)
  (local $2 i32)
  (loop $label$0 (result i32)
   (drop
    (i32.const 2)
   )
   (block (result i32)
    (set_local $2
     (i32.const 4)
    )
    (br_if $label$0 ;; precomputing this into a br must change the type
     (i32.const 1)
    )
    (get_local $2)
   )
  )
 )
)
