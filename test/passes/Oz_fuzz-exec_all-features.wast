(module
 (type $struct (struct (mut i32)))
 (type $extendedstruct (struct_subtype (mut i32) f64 $struct))
 (type $bytes (array (mut i8)))

 (type $void_func (func))
 (type $int_func (func (result i32)))

 (import "fuzzing-support" "log-i32" (func $log (param i32)))

 (func "structs"
  (local $x (ref null $struct))
  (local $y (ref null $struct))
  (local.set $x
   (struct.new_default $struct)
  )
  ;; The value is initialized to 0
  ;; Note: We cannot optimize these to constants without either immutability or
  ;; some kind of escape analysis (to verify that the GC data referred to is not
  ;; written to elsewhere).
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
   (array.new $bytes
    (i32.const 42) ;; value to splat into the array
    (i32.const 50) ;; size
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
 (func "br_on_cast"
  (local $any anyref)
  ;; create a simple $struct, store it in an anyref
  (local.set $any
   (struct.new_default $struct)
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
         (local.get $any)
        )
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
 (func "br_on_failed_cast-1"
  (local $any anyref)
  ;; create a simple $struct, store it in an anyref
  (local.set $any
   (struct.new_default $struct)
  )
  (drop
   (block $any (result (ref null any))
    (call $log (i32.const 1))
    (drop
     ;; try to cast our simple $struct to an extended, which will fail, and
     ;; so we will branch, skipping the next logging.
     (br_on_cast_fail $any $extendedstruct
      (local.get $any)
     )
    )
    (call $log (i32.const 999)) ;; we should skip this
    (ref.null any)
   )
  )
 )
 (func "br_on_failed_cast-2"
  (local $any anyref)
  ;; create an $extendedstruct, store it in an anyref
  (local.set $any
   (struct.new_default $extendedstruct)
  )
  (drop
   (block $any (result (ref null any))
    (call $log (i32.const 1))
    (drop
     ;; try to cast our simple $struct to an extended, which will succeed, and
     ;; so we will continue to the next logging.
     (br_on_cast_fail $any $extendedstruct
      (local.get $any)
     )
    )
    (call $log (i32.const 999))
    (ref.null any)
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
   )
  )
 )
 (func $get_struct (result structref)
  (struct.new_default $struct)
 )
 (func "br-on_non_null"
  (drop
   (block $non-null (result (ref any))
    (br_on_non_null $non-null (i31.new (i32.const 0)))
    ;; $x refers to an i31, which is not null, so we will branch, and not
    ;; log
    (call $log (i32.const 1))
    (unreachable)
   )
  )
 )
 (func "br-on_non_null-2"
  (drop
   (block $non-null (result (ref any))
    (br_on_non_null $non-null (ref.null any))
    ;; $x is null, and so we will not branch, and log and then trap
    (call $log (i32.const 1))
    (unreachable)
   )
  )
 )
 (func "ref-as-func-of-func"
  (drop
   (ref.as_func
    (ref.func $0)
   )
  )
 )
 (func $a-void-func
  (call $log (i32.const 1337))
 )
 (func "cast-on-func"
  (call $log (i32.const 0))
  ;; a valid cast
  (call_ref $void_func
   (ref.cast $void_func (ref.func $a-void-func))
  )
  (call $log (i32.const 1))
  ;; an invalid cast
  (drop (call_ref $int_func
   (ref.cast $int_func (ref.func $a-void-func))
  ))
  ;; will never be reached
  (call $log (i32.const 2))
 )
 (func "array-alloc-failure"
  (drop
   (array.new_default $bytes
    (i32.const -1) ;; un-allocatable size (4GB * sizeof(Literal))
   )
  )
 )
 (func "init-array-packed" (result i32)
  (local $x (ref null $bytes))
  (local.set $x
   (array.new $bytes
    (i32.const -43) ;; initialize the i8 values with a negative i32
    (i32.const 50)
   )
  )
  ;; read the value, which should be -43 & 255 ==> 213
  (array.get_u $bytes
   (local.get $x)
   (i32.const 10)
  )
 )
 (func $call-target (param $0 eqref)
  (nop)
 )
 (func "array-copy"
  (local $x (ref null $bytes))
  (local $y (ref null $bytes))
  ;; Create an array of 10's, of size 100.
  (local.set $x
   (array.new $bytes
    (i32.const 10)
    (i32.const 100)
   )
  )
  ;; Create an array of zeros of size 200, and also set one index there.
  (local.set $y
   (array.new_default $bytes
    (i32.const 200)
   )
  )
  (array.set $bytes
   (local.get $y)
   (i32.const 42)
   (i32.const 99)
  )
  ;; Log out a value from $x before.
  (call $log
   (array.get_u $bytes (local.get $x) (i32.const 10))
  )
  (array.copy $bytes $bytes
   (local.get $x)
   (i32.const 10)
   (local.get $y)
   (i32.const 42)
   (i32.const 2)
  )
  ;; Log out some value from $x after. Indexes 10 and 11 should be modified.
  (call $log
   (array.get_u $bytes (local.get $x) (i32.const 9))
  )
  (call $log
   (array.get_u $bytes (local.get $x) (i32.const 10))
  )
  (call $log
   (array.get_u $bytes (local.get $x) (i32.const 11))
  )
  (call $log
   (array.get_u $bytes (local.get $x) (i32.const 12))
  )
 )
 (func "array.init_static"
  (local $x (ref null $bytes))
  (local.set $x
   (array.init_static $bytes
    (i32.const 42) ;; first value
    (i32.const 50) ;; second value
   )
  )
  ;; The length should be 2
  (call $log
   (array.len $bytes (local.get $x))
  )
  ;; The first value should be 42
  (call $log
   (array.get_u $bytes (local.get $x) (i32.const 0))
  )
  ;; The second value should be 50
  (call $log
   (array.get_u $bytes (local.get $x) (i32.const 1))
  )
 )
 (func "array.init_static-packed"
  (local $x (ref null $bytes))
  (local.set $x
   (array.init_static $bytes
    (i32.const -11512)
   )
  )
  ;; The value should be be -11512 & 255 => 8
  (call $log
   (array.get_u $bytes (local.get $x) (i32.const 0))
  )
 )
 (func "static-casts"
  ;; Casting null returns null.
  (call $log (ref.is_null
   (ref.cast null $struct (ref.null $struct))
  ))
  ;; Testing null returns 0.
  (call $log
   (ref.test $struct (ref.null $struct))
  )
  ;; Testing something completely wrong (struct vs array) returns 0.
  (call $log
   (ref.test $struct
    (array.new $bytes
     (i32.const 20)
     (i32.const 10)
    )
   )
  )
  ;; Testing a thing with the same type returns 1.
  (call $log
   (ref.test $struct
    (struct.new_default $struct)
   )
  )
  ;; A bad downcast returns 0: we create a struct, which is not a extendedstruct.
  (call $log
   (ref.test $extendedstruct
    (struct.new_default $struct)
   )
  )
  ;; Casting to a supertype works.
  (call $log
   (ref.test $struct
    (struct.new_default $extendedstruct)
   )
  )
 )
 (func "static-br_on_cast"
  (local $any anyref)
  ;; create a simple $struct, store it in an anyref
  (local.set $any
   (struct.new_default $struct)
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
         (local.get $any)
        )
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
 (func "static-br_on_cast_fail"
  (local $any anyref)
  ;; create a simple $struct, store it in an anyref
  (local.set $any
   (struct.new_default $struct)
  )
  (drop
   (block $failblock (result anyref)
    (drop
      ;; try to cast our simple $struct to an extended, which will fail
     (br_on_cast_fail $failblock $extendedstruct
      (local.get $any)
     )
    )
    (call $log (i32.const -1)) ;; we should never get here
    (return)
   )
  )
  (call $log (i32.const -2)) ;; we should get here.
  (return)
 )
)
(module
 (type $[mut:i8] (array (mut i8)))
 (func "foo" (result i32)
  ;; before opts this will trap on failing to allocate -1 >>> 0 bytes. after
  ;; opts the unused value is removed so there is no trap, and a value is
  ;; returned, which should not confuse the fuzzer.
  (drop
   (array.new_default $[mut:i8]
    (i32.const -1)
   )
  )
  (i32.const 0)
 )
)
