(module
 (type $struct (struct i32))
 (type $extendedstruct (struct i32 f64))
 (type $bytes (array (mut i8)))
 (import "fuzzing-support" "log-i32" (func $log (param i32)))
 (func "br_on_cast"
  (local $any anyref)
  ;; create a simple $struct, store it in an anyref
  (local.set $any
   (struct.new_default_with_rtt $struct (rtt.canon $struct))
  )
  (drop
   (block $block (result ($ref $struct))
    (drop
     (block $extendedblock (result (ref $extendedstruct))
      (drop
       ;; second, try to cast our simple $struct to what it is, which will work
       (br_on_cast $block $struct
        ;; first, try to cast our simple $struct to an extended, which will fail
        (br_on_cast $extendedblock $extendedstruct
         (local.get $any) (rtt.canon $extendedstruct)
        )
        (rtt.canon $struct)
       )
      )
      (call $log (i32.const -1)) ;; we should never get here
      (return)
     )
    )
    (call $log (i32.const -2)) ;; we should never get here either
    (return)
   )
  )
  (call $log (i32.const 3)) ;; we should get here
 )
)
