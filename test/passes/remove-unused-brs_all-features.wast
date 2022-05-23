(module
 (type $vector (array (mut i32)))
 (type $struct (struct (field (ref null $vector))))
 (import "out" "log" (func $log (param i32)))
 (func $foo (result (ref null $struct))
  (if (result (ref null $struct))
   (i32.const 1)
   (struct.new_with_rtt $struct
    ;; regression test for computing the cost of an array.new_default, which
    ;; lacks the optional field "init"
    (array.new_default_with_rtt $vector
     (i32.const 1)
     (rtt.canon $vector)
    )
    (rtt.canon $struct)
   )
   (ref.null $struct)
  )
 )

 (func $test-prefinalize (result f64)
  (loop $loop (result f64)
   (block $block (result f64)
    (drop
     (br_if $block
      (f64.const 0)
      (i32.const 1)
     )
    )
    (if
     (i32.const 0)
     (unreachable)
    )
    ;; this will be moved from $block into the if right before it. we must be
    ;; careful to properly finalize() things, as if we finalize the block too
    ;; early - before the if - then the block ends in a none type, which is
    ;; invalid.
    (br $loop)
   )
  )
 )

 (func $none_=>_i32 (result i32)
  (unreachable)
 )
 (func $i32_=>_none (param i32)
 )
 (func $selectify (param $x i32) (result funcref)
  ;; this if has arms with different function types, for which funcref is the
  ;; LUB
  (if (result funcref)
   (local.get $x)
   (ref.func $none_=>_i32)
   (ref.func $i32_=>_none)
  )
 )

 (func $br_on-to-br (param $func (ref func))
  (call $log (i32.const 0))
  (block $null
   ;; a non-null reference is not null, and the br is never taken
   (drop
    (br_on_null $null (ref.func $br_on-to-br))
   )
   (call $log (i32.const 1))
  )
  (call $log (i32.const 2))
  (drop
   (block $func (result funcref)
    ;; a non-null function reference means we always take the br
    (drop
     (br_on_func $func (ref.func $br_on-to-br))
    )
    (call $log (i32.const 3))
    (ref.func $br_on-to-br)
   )
  )
  (call $log (i32.const 4))
  (drop
   (block $data (result dataref)
    ;; a non-null data reference means we always take the br
    (drop
     (br_on_data $data
      (array.new_default_with_rtt $vector
       (i32.const 1)
       (rtt.canon $vector)
      )
     )
    )
    (call $log (i32.const 5))
    (array.new_default_with_rtt $vector
     (i32.const 2)
     (rtt.canon $vector)
    )
   )
  )
  (call $log (i32.const 6))
  (drop
   (block $i31 (result i31ref)
    ;; a non-null i31 reference means we always take the br
    (drop
     (br_on_i31 $i31
      (i31.new (i32.const 42))
     )
    )
    (call $log (i32.const 7))
    (i31.new (i32.const 1337))
   )
  )
  (call $log (i32.const 8))
  (drop
   (block $non-null (result (ref func))
    ;; a non-null reference is not null, and the br is always taken
    (br_on_non_null $non-null (ref.func $br_on-to-br))
    (call $log (i32.const 9))
    (ref.func $br_on-to-br)
   )
  )
 )

 ;; a br_on of the obviously incorrect kind can just flow out the value as the
 ;; break is never taken
 (func $br_on-to-flow
  ;; brs to data
  (drop
   (block $data (result (ref null data))
    (drop
     (br_on_data $data
      (ref.func $br_on-to-flow)
     )
    )
    (ref.null data)
   )
  )
  (drop
   (block $datab (result (ref null data))
    (drop
     (br_on_data $datab
      (i31.new (i32.const 1337))
     )
    )
    (ref.null data)
   )
  )
  ;; brs to func
  (drop
   (block $func (result (ref null func))
    (drop
     (br_on_func $func
      (array.new_default_with_rtt $vector
       (i32.const 2)
       (rtt.canon $vector)
      )
     )
    )
    (ref.null func)
   )
  )
  (drop
   (block $funcb (result (ref null func))
    (drop
     (br_on_func $funcb
      (i31.new (i32.const 1337))
     )
    )
    (ref.null func)
   )
  )
  ;; brs to i31
  (drop
   (block $i31 (result (ref null i31))
    (drop
     (br_on_i31 $i31
      (array.new_default_with_rtt $vector
       (i32.const 2)
       (rtt.canon $vector)
      )
     )
    )
    (ref.null i31)
   )
  )
  (drop
   (block $i31b (result (ref null i31))
    (drop
     (br_on_i31 $i31b
      (ref.func $br_on-to-flow)
     )
    )
    (ref.null i31)
   )
  )
 )
)
