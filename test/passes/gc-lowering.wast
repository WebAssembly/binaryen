;; Contents are similar to Oz_fuzz_exec.wast, but focused to testing the
;; runtime behavior of --lower-gc, and simplified.
(module
 (type $struct (struct (mut i32)))
 (type $extendedstruct (struct (mut i32) f64))
 (type $bytes (array (mut i8)))

 (type $void_func (func))
 (type $int_func (func (result i32)))

 (import "fuzzing-support" "log-i32" (func $log (param i32)))

 ;; Test the basic RTT usage in globals. We must update the rtt.sub at runtime
 ;; as we allocate it only then.
 (global $rtt-0 (rtt 0 $struct) (rtt.canon $struct))
 (global $rtt-1 (rtt 1 $struct) (rtt.sub $struct
  (global.get $rtt-0)
 ))

 (func "structs"
  (local $x (ref null $struct))
  (local $y (ref null $struct))
  (local.set $x
   (struct.new_default_with_rtt $struct
    (rtt.canon $struct)
   )
  )
  ;; The value is initialized to 0
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
    (i32.const 42) ;; value to splat into the array
    (i32.const 50) ;; size
    (rtt.canon $bytes)
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
   (ref.cast (ref.null $struct) (rtt.canon $struct))
  ))
  ;; Testing null returns 0.
  (call $log
   (ref.test (ref.null $struct) (rtt.canon $struct))
  )
  ;; Testing something completely wrong (struct vs array) returns 0.
  (call $log
   (ref.test
    (array.new_with_rtt $bytes
     (i32.const 20)
     (i32.const 10)
     (rtt.canon $bytes)
    )
    (rtt.canon $struct)
   )
  )
  ;; Testing a thing with the same RTT returns 1.
  (call $log
   (ref.test
    (struct.new_default_with_rtt $struct
     (rtt.canon $struct)
    )
    (rtt.canon $struct)
   )
  )
  ;; A bad downcast returns 0: we create a struct, which is not a extendedstruct.
  (call $log
   (ref.test
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
   (ref.test
    (local.get $any)
    (rtt.sub $extendedstruct (rtt.canon $struct))
   )
  )
  ;; Casting to z, another RTT of the same data type, fails.
  (call $log
   (ref.test
    (local.get $any)
    (rtt.canon $extendedstruct)
   )
  )
  ;; Casting to x, the parent of y, works.
  (call $log
   (ref.test
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
 (func "br_on_failed_cast-1"
  (local $any anyref)
  ;; create a simple $struct, store it in an anyref
  (local.set $any
   (struct.new_default_with_rtt $struct (rtt.canon $struct))
  )
  (drop
   (block $any (result (ref null any))
    (call $log (i32.const 1))
    (drop
     ;; try to cast our simple $struct to an extended, which will fail, and
     ;; so we will branch, skipping the next logging.
     (br_on_cast_fail $any
      (local.get $any)
      (rtt.canon $extendedstruct)
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
   (struct.new_default_with_rtt $extendedstruct (rtt.canon $extendedstruct))
  )
  (drop
   (block $any (result (ref null any))
    (call $log (i32.const 1))
    (drop
     ;; try to cast our simple $struct to an extended, which will succeed, and
     ;; so we will continue to the next logging.
     (br_on_cast_fail $any
      (local.get $any)
      (rtt.canon $extendedstruct)
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
   (ref.test
    (ref.null any)
    (rtt.canon $struct)
   )
  )
 )
 (func $get_data (result dataref)
  (struct.new_default_with_rtt $struct
   (rtt.canon $struct)
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
    (call $get_data)
   )
  )
 )
 (func "br_on_non_data-null"
  (local $x anyref)
  (drop
   (block $any (result anyref)
    (drop
     (br_on_non_data $any (local.get $x))
    )
    ;; $x is a null, and so it is not data, and the branch will be taken, and no
    ;; logging will occur.
    (call $log (i32.const 1))
    (ref.null any)
   )
  )
 )
 (func "br_on_non_data-data"
  (local $x anyref)
  ;; set x to valid data
  (local.set $x
   (struct.new_default_with_rtt $struct
    (rtt.canon $struct)
   )
  )
  (drop
   (block $any (result anyref)
    (drop
     (br_on_non_data $any (local.get $x))
    )
    ;; $x refers to valid data, and so we will not branch, and will log.
    (call $log (i32.const 1))
    (ref.null any)
   )
  )
 )
 (func "br_on_non_data-other"
  (local $x anyref)
  ;; set x to something that is not null, but also not data
  (local.set $x
   (ref.func $a-void-func)
  )
  (drop
   (block $any (result anyref)
    (drop
     (br_on_non_data $any (local.get $x))
    )
    ;; $x refers to a function, so we will branch, and not log
    (call $log (i32.const 1))
    (ref.null any)
   )
  )
 )
 (func "br-on_non_null"
  (drop
   (block $non-null (result (ref any))
    (br_on_non_null $non-null (ref.func $a-void-func))
    ;; $x refers to a function, which is not null, so we will branch, and not
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
 (func $a-void-func
  (call $log (i32.const 1337))
 )
 (func "rtt-and-cast-on-func"
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
   (ref.cast (ref.func $a-void-func) (rtt.canon $void_func))
  )
  (call $log (i32.const 3))
  ;; an invalid cast
  (drop (call_ref
   (ref.cast (ref.func $a-void-func) (rtt.canon $int_func))
  ))
  ;; will never be reached
  (call $log (i32.const 4))
 )
 (func "init-array-packed" (result i32)
  (local $x (ref null $bytes))
  (local.set $x
   (array.new_with_rtt $bytes
    (i32.const -43) ;; initialize the i8 values with a negative i32
    (i32.const 50)
    (rtt.canon $bytes)
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
 (func "cast-func-to-struct"
  (drop
   ;; An impossible cast of a function to a struct, which should fail.
   (ref.cast
    (ref.func $call-target)
    (rtt.canon $struct)
   )
  )
 )
 (func "rtt-globals"
  (call $log
   (ref.test
    (struct.new_default_with_rtt $struct
     (global.get $rtt-1)
    )
    ;; rtt-1 is a sub-rtt of 0, so this works
    (global.get $rtt-0)
   )
  )
  (call $log
   (ref.test
    (struct.new_default_with_rtt $struct
     (global.get $rtt-0)
    )
    ;; rtt-0 is not a sub-rtt of 1, so this fails
    (global.get $rtt-1)
   )
  )
 )
)
(module
 ;; Note that this test must be separate as it "breaks" the malloc impl
 ;; which does not check for wrapping, causing later allocations to fail.
 ;; TODO fix the malloc, or replace it with a real one.
 (type $bytes (array (mut i8)))
 (func "array-alloc-failure"
  (drop
   (array.new_default_with_rtt $bytes
    (i32.const -1) ;; un-allocatable size (4GB * sizeof(Literal))
    (rtt.canon $bytes)
   )
  )
 )
)
