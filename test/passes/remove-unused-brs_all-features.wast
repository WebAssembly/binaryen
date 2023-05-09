(module
 (type $vector (array (mut i32)))
 (type $struct (struct (field (ref null $vector))))
 (import "out" "log" (func $log (param i32)))
 (func $foo (result (ref null $struct))
  (if (result (ref null $struct))
   (i32.const 1)
   (struct.new $struct
    ;; regression test for computing the cost of an array.new_default, which
    ;; lacks the optional field "init"
    (array.new_default $vector
     (i32.const 1)
    )
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
   (block $i31 (result i31ref)
    ;; a non-null i31 reference means we always take the br
    (drop
     (br_on_i31 $i31
      (i31.new (i32.const 42))
     )
    )
    (call $log (i32.const 5))
    (i31.new (i32.const 1337))
   )
  )
  (call $log (i32.const 6))
  (drop
   (block $non-null (result (ref func))
    ;; a non-null reference is not null, and the br is always taken
    (br_on_non_null $non-null (ref.func $br_on-to-br))
    (call $log (i32.const 7))
    (ref.func $br_on-to-br)
   )
  )
 )
)