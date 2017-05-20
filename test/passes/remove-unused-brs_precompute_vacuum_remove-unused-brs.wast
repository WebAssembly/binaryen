(module
 (global $global$3 (mut f64) (f64.const 0))
 (func $1 (param $x i32) (result f64)
  (local $var$0 f64)
  (block $label$0
   (set_local $var$0
    (f64.const 0)
   )
   (if
    (i32.gt_s
     (i32.const 9)
     (i32.const 0)
    )
    (return
     (f64.const -3.4)
    )
   )
   (if
    (get_local $x)
    (return
     (f64.const 5.6)
    )
   )
   (return
    (f64.const 1.2)
   )
  )
 )
)
