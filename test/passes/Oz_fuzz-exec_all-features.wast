(module
 (type $struct (struct i32))
 (type $bytes (array (mut i8)))
 (import "fuzzing-support" "log-i32" (func $log (param i32)))
 (func "structs"
  (local $x (ref null $struct))
  (local $y (ref null $struct))
  (local.set $x
   (struct.new_default_with_rtt $struct
    (rtt.canon $struct)
   )
  )
  ;; The value is initialized to 0
  ;; Note: -Oz will optimize all these to constants thanks to Precompute
  (call $log
   (struct.get $struct 0 (local.get $x))
  )
  ;; Assigning a value works
  (struct.set $struct 0
   (local.get $x)
   (i32.const 42)
  )
  (call $log
   (struct.get $struct 0 (local.get $x))
  )
  ;; References are references, so writing to one's value affects the other's
  (local.set $y (local.get $x))
  (struct.set $struct 0
   (local.get $y)
   (i32.const 100)
  )
  (call $log
   (struct.get $struct 0 (local.get $x))
  )
  (call $log
   (struct.get $struct 0 (local.get $y))
  )
 )
 (func "arrays"
  (local $x (ref null $bytes))
  (local.set $x
   (array.new_with_rtt $bytes
    (rtt.canon $bytes)
    (i32.const 50) ;; size
    (i32.const 42) ;; value to splat into the array
   )
  )
  ;; The length should be 50
  (call $log
   (array.len $bytes (local.get $x))
  )
  ;; The value should be 42
  (call $log
   (array.get_u $bytes (local.get $x) (i32.const 10))
  )
  ;; Write a value that will be truncated into an i8
  (array.set $bytes (local.get $x) (i32.const 10) (i32.const 0xff80))
  ;; The value should be 0x80 (-128 or 128 depending on signed/unsigned)
  (call $log
   (array.get_u $bytes (local.get $x) (i32.const 10))
  )
  (call $log
   (array.get_s $bytes (local.get $x) (i32.const 10))
  )
  ;; Other items than the one at index 10 are unaffected.
  (call $log
   (array.get_s $bytes (local.get $x) (i32.const 20))
  )
 )
)
