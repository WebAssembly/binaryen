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
)
