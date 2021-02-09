(module
 (type $struct (struct (mut i32)))
 (type $extendedstruct (struct i32 f64))
 (type $bytes (array (mut i8)))

 (type $void_func (func))
 (type $int_func (func (result i32)))

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
 (func "rtts"
  (local $any anyref)
  ;; Casting null returns null.
  (call $log (ref.is_null
   (ref.cast $struct (ref.null $struct) (rtt.canon $struct))
  ))
  ;; Testing null returns 0.
  (call $log
   (ref.test $struct (ref.null $struct) (rtt.canon $struct))
  )
  ;; Testing something completely wrong (struct vs array) returns 0.
  (call $log
   (ref.test $struct
    (array.new_with_rtt $bytes
     (rtt.canon $bytes)
     (i32.const 10)
     (i32.const 20)
    )
    (rtt.canon $struct)
   )
  )
  ;; Testing a thing with the same RTT returns 1.
  (call $log
   (ref.test $struct
    (struct.new_default_with_rtt $struct
     (rtt.canon $struct)
    )
    (rtt.canon $struct)
   )
  )
  ;; A bad downcast returns 0: we create a struct, which is not a extendedstruct.
  (call $log
   (ref.test $extendedstruct
    (struct.new_default_with_rtt $struct
     (rtt.canon $struct)
    )
    (rtt.canon $extendedstruct)
   )
  )
  ;; Create a extendedstruct with RTT y, and upcast statically to anyref.
  (local.set $any
   (struct.new_default_with_rtt $extendedstruct
    (rtt.sub $extendedstruct (rtt.canon $struct))
   )
  )
  ;; Casting to y, the exact same RTT, works.
  (call $log
   (ref.test $extendedstruct
    (local.get $any)
    (rtt.sub $extendedstruct (rtt.canon $struct))
   )
  )
  ;; Casting to z, another RTT of the same data type, fails.
  (call $log
   (ref.test $extendedstruct
    (local.get $any)
    (rtt.canon $extendedstruct)
   )
  )
  ;; Casting to x, the parent of y, works.
  (call $log
   (ref.test $struct
    (local.get $any)
    (rtt.canon $struct)
   )
  )
 )
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
       (br_on_cast $block
        ;; first, try to cast our simple $struct to an extended, which will fail
        (br_on_cast $extendedblock
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
  (drop
   (block $never (result (ref $extendedstruct))
    ;; an untaken br_on_cast, with unreachable rtt - so we cannot use the
    ;; RTT in binaryen IR to find the cast type.
    (br_on_cast $never (ref.null $struct) (unreachable))
    (unreachable)
   )
  )
 )
 (func "cast-null-anyref-to-gc"
  ;; a null anyref is a literal which is not even of GC data, as it's not an
  ;; array or a struct, so our casting code should not assume it is. it is ok
  ;; to try to cast it, and the result should be 0.
  (call $log
   (ref.test $struct
    (ref.null any)
    (rtt.canon $struct)
   )
  )
 )
 (func "br_on_data" (param $x anyref)
  (local $y anyref)
  (drop
   (block $data (result dataref)
    (local.set $y
     (br_on_data $data (local.get $x))
    )
    (call $log (i32.const 1))
    (ref.null data)
   )
  )
 )
 (func $a-void-func
  (call $log (i32.const 1337))
 )
 (func "$rtt-and-cast-on-func"
  (call $log (i32.const 0))
  (drop
   (rtt.canon $void_func)
  )
  (call $log (i32.const 1))
  (drop
   (rtt.canon $int_func)
  )
  (call $log (i32.const 2))
  ;; a valid cast
  (call_ref
   (ref.cast $void_func (ref.func $a-void-func) (rtt.canon $void_func))
  )
  (call $log (i32.const 3))
  ;; an invalid cast
  (drop (call_ref
   (ref.cast $int_func (ref.func $a-void-func) (rtt.canon $int_func))
  ))
  ;; will never be reached
  (call $log (i32.const 4))
 )
)
