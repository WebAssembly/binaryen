(module
 (type $vector (array (mut i32)))
 (type $struct (struct (field (ref null $vector))))
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
)
