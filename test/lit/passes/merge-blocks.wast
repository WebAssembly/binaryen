;; NOTE: Assertions have been generated by update_lit_checks.py and should not be edited.
;; RUN: wasm-opt %s --remove-unused-names --merge-blocks -all -S -o - \
;; RUN:   | filecheck %s
;;
;; --remove-unused-names lets --merge-blocks assume blocks without names have no
;; branch targets.

(module
 (type $anyref_=>_none (func (param anyref)))

 ;; CHECK:      (type $array (array (mut i32)))

 ;; CHECK:      (type $struct (struct (field (mut i32))))
 (type $struct (struct (field (mut i32))))

 (type $array (array (mut i32)))

 ;; CHECK:      (func $br_on_to_drop (type $none_=>_none)
 ;; CHECK-NEXT:  (nop)
 ;; CHECK-NEXT:  (drop
 ;; CHECK-NEXT:   (block $label$1 (result i31ref)
 ;; CHECK-NEXT:    (drop
 ;; CHECK-NEXT:     (br_on_cast $label$1 i31ref (ref i31)
 ;; CHECK-NEXT:      (block (result i31ref)
 ;; CHECK-NEXT:       (ref.null none)
 ;; CHECK-NEXT:      )
 ;; CHECK-NEXT:     )
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:    (ref.null none)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $br_on_to_drop
  (nop) ;; ensure a block at the function level
  (drop
   (block $label$1 (result (ref null i31)) ;; this block type must stay, we
                                           ;; cannot remove it due to the br_on
    (drop
     (br_on_cast $label$1 anyref (ref i31)
      (ref.null any)
     )
    )
    (ref.null i31) ;; this must not end up dropped
   )
  )
 )

 ;; CHECK:      (func $struct.set (type $ref?|$struct|_=>_none) (param $struct (ref null $struct))
 ;; CHECK-NEXT:  (nop)
 ;; CHECK-NEXT:  (drop
 ;; CHECK-NEXT:   (i32.const 1234)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT:  (struct.set $struct 0
 ;; CHECK-NEXT:   (local.get $struct)
 ;; CHECK-NEXT:   (i32.const 5)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT:  (nop)
 ;; CHECK-NEXT: )
 (func $struct.set (param $struct (ref null $struct))
  (block
   (nop)
   (struct.set $struct 0
    (block (result (ref null $struct))
     (drop (i32.const 1234))
     (local.get $struct)
    )
    (i32.const 5)
   )
   (nop)
  )
 )

 ;; CHECK:      (func $struct.get (type $ref?|$struct|_=>_none) (param $struct (ref null $struct))
 ;; CHECK-NEXT:  (nop)
 ;; CHECK-NEXT:  (drop
 ;; CHECK-NEXT:   (i32.const 1234)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT:  (drop
 ;; CHECK-NEXT:   (struct.get $struct 0
 ;; CHECK-NEXT:    (local.get $struct)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT:  (nop)
 ;; CHECK-NEXT: )
 (func $struct.get (param $struct (ref null $struct))
  (block
   (nop)
   (drop
    (struct.get $struct 0
     (block (result (ref null $struct))
      (drop (i32.const 1234))
      (local.get $struct)
     )
    )
   )
   (nop)
  )
 )

 ;; CHECK:      (func $array.set (type $ref|$array|_=>_none) (param $foo (ref $array))
 ;; CHECK-NEXT:  (local $bar (ref null $array))
 ;; CHECK-NEXT:  (nop)
 ;; CHECK-NEXT:  (nop)
 ;; CHECK-NEXT:  (nop)
 ;; CHECK-NEXT:  (array.set $array
 ;; CHECK-NEXT:   (local.tee $bar
 ;; CHECK-NEXT:    (local.get $foo)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (i32.const 0)
 ;; CHECK-NEXT:   (i32.const 37)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $array.set (param $foo (ref $array))
  (local $bar (ref null $array))
  (array.set $array
   (block $block (result (ref null $array))
    (nop)
    (nop)
    (nop)
    ;; Side effects in the first item on the array.set do not prevent moving
    ;; the nops outside.
    (local.tee $bar
     (local.get $foo)
    )
   )
   (i32.const 0)
   (i32.const 37)
  )
 )

 ;; CHECK:      (func $array.set-no-1 (type $ref|$array|_=>_none) (param $foo (ref $array))
 ;; CHECK-NEXT:  (local $bar i32)
 ;; CHECK-NEXT:  (nop)
 ;; CHECK-NEXT:  (nop)
 ;; CHECK-NEXT:  (nop)
 ;; CHECK-NEXT:  (array.set $array
 ;; CHECK-NEXT:   (local.get $foo)
 ;; CHECK-NEXT:   (local.tee $bar
 ;; CHECK-NEXT:    (i32.const 0)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (i32.const 37)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $array.set-no-1 (param $foo (ref $array))
  (local $bar i32)
  (array.set $array
   (local.get $foo)
   (block $block (result i32)
    (nop)
    (nop)
    (nop)
    ;; Side effects in the second item do prevent optimizations, currently.
    (local.tee $bar
     (i32.const 0)
    )
   )
   (i32.const 37)
  )
 )

 ;; CHECK:      (func $array.set-no-2 (type $ref|$array|_=>_none) (param $foo (ref $array))
 ;; CHECK-NEXT:  (local $bar i32)
 ;; CHECK-NEXT:  (nop)
 ;; CHECK-NEXT:  (nop)
 ;; CHECK-NEXT:  (nop)
 ;; CHECK-NEXT:  (array.set $array
 ;; CHECK-NEXT:   (local.get $foo)
 ;; CHECK-NEXT:   (i32.const 0)
 ;; CHECK-NEXT:   (local.tee $bar
 ;; CHECK-NEXT:    (i32.const 37)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $array.set-no-2 (param $foo (ref $array))
  (local $bar i32)
  (array.set $array
   (local.get $foo)
   (i32.const 0)
   (block $block (result i32)
    (nop)
    (nop)
    (nop)
    ;; Side effects in the third item do prevent optimizations, currently.
    (local.tee $bar
     (i32.const 37)
    )
   )
  )
 )

 ;; CHECK:      (func $if-condition (type $none_=>_i32) (result i32)
 ;; CHECK-NEXT:  (drop
 ;; CHECK-NEXT:   (i32.const 0)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT:  (if (result i32)
 ;; CHECK-NEXT:   (i32.const 1)
 ;; CHECK-NEXT:   (block (result i32)
 ;; CHECK-NEXT:    (drop
 ;; CHECK-NEXT:     (i32.const 2)
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:    (i32.const 3)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (block (result i32)
 ;; CHECK-NEXT:    (drop
 ;; CHECK-NEXT:     (i32.const 4)
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:    (i32.const 5)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $if-condition (result i32)
  ;; Content can be moved out of an if condition, but not anywhere else.
  (if (result i32)
   (block (result i32)
    (drop (i32.const 0))
    (i32.const 1)
   )
   (block (result i32)
    (drop (i32.const 2))
    (i32.const 3)
   )
   (block (result i32)
    (drop (i32.const 4))
    (i32.const 5)
   )
  )
 )

 ;; CHECK:      (func $subsequent-children (type $i32_i32_i32_=>_i32) (param $x i32) (param $y i32) (param $z i32) (result i32)
 ;; CHECK-NEXT:  (drop
 ;; CHECK-NEXT:   (call $helper
 ;; CHECK-NEXT:    (i32.const 0)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT:  (drop
 ;; CHECK-NEXT:   (call $helper
 ;; CHECK-NEXT:    (i32.const 3)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT:  (call $subsequent-children
 ;; CHECK-NEXT:   (i32.const 1)
 ;; CHECK-NEXT:   (i32.const 2)
 ;; CHECK-NEXT:   (i32.const 4)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $subsequent-children (param $x i32) (param $y i32) (param $z i32) (result i32)
  ;; Both of the calls to helper can be moved outside. Those calls remain in
  ;; order after doing so, so there is no problem, and none of them are moved
  ;; across anything with side effects. This leaves only consts in the call to
  ;; $subsequent-children.
  (call $subsequent-children
   (block (result i32)
    (drop (call $helper (i32.const 0)))
    (i32.const 1)
   )
   (i32.const 2)
   (block (result i32)
    (drop (call $helper (i32.const 3)))
    (i32.const 4)
   )
  )
 )

 ;; CHECK:      (func $subsequent-children-1 (type $i32_i32_i32_=>_i32) (param $x i32) (param $y i32) (param $z i32) (result i32)
 ;; CHECK-NEXT:  (drop
 ;; CHECK-NEXT:   (call $helper
 ;; CHECK-NEXT:    (i32.const 0)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT:  (call $subsequent-children-1
 ;; CHECK-NEXT:   (call $helper
 ;; CHECK-NEXT:    (i32.const 1)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (i32.const 2)
 ;; CHECK-NEXT:   (block (result i32)
 ;; CHECK-NEXT:    (drop
 ;; CHECK-NEXT:     (call $helper
 ;; CHECK-NEXT:      (i32.const 3)
 ;; CHECK-NEXT:     )
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:    (i32.const 4)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $subsequent-children-1 (param $x i32) (param $y i32) (param $z i32) (result i32)
  (call $subsequent-children-1
   (block (result i32)
    (drop (call $helper (i32.const 0)))
    (call $helper (i32.const 1)) ;; Compared to before, this is now a call, so
                                 ;; it has side effects, and the call with arg
                                 ;; 3 cannot be moved past it.
   )
   (i32.const 2)
   (block (result i32)
    (drop (call $helper (i32.const 3)))
    (i32.const 4)
   )
  )
 )

 ;; CHECK:      (func $subsequent-children-2 (type $i32_i32_i32_=>_i32) (param $x i32) (param $y i32) (param $z i32) (result i32)
 ;; CHECK-NEXT:  (drop
 ;; CHECK-NEXT:   (call $helper
 ;; CHECK-NEXT:    (i32.const 0)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT:  (call $subsequent-children-2
 ;; CHECK-NEXT:   (call $helper
 ;; CHECK-NEXT:    (i32.const 1)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (block (result i32)
 ;; CHECK-NEXT:    (drop
 ;; CHECK-NEXT:     (call $helper
 ;; CHECK-NEXT:      (i32.const 3)
 ;; CHECK-NEXT:     )
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:    (i32.const 4)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (i32.const 2)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $subsequent-children-2 (param $x i32) (param $y i32) (param $z i32) (result i32)
  (call $subsequent-children-2
   (block (result i32)
    (drop (call $helper (i32.const 0)))
    (call $helper (i32.const 1))
   )
   ;; Similar to the above, but with the main call's last two arguments flipped.
   ;; This should not have an effect on the output: we still can't pull out the
   ;; call with arg 3.
   (block (result i32)
    (drop (call $helper (i32.const 3)))
    (i32.const 4)
   )
   (i32.const 2)
  )
 )

 ;; CHECK:      (func $subsequent-children-3 (type $i32_i32_i32_=>_i32) (param $x i32) (param $y i32) (param $z i32) (result i32)
 ;; CHECK-NEXT:  (drop
 ;; CHECK-NEXT:   (i32.const 0)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT:  (call $subsequent-children-3
 ;; CHECK-NEXT:   (call $helper
 ;; CHECK-NEXT:    (i32.const 1)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (block (result i32)
 ;; CHECK-NEXT:    (drop
 ;; CHECK-NEXT:     (call $helper
 ;; CHECK-NEXT:      (i32.const 3)
 ;; CHECK-NEXT:     )
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:    (i32.const 4)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (i32.const 2)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $subsequent-children-3 (param $x i32) (param $y i32) (param $z i32) (result i32)
  (call $subsequent-children-3
   (block (result i32)
    (drop (i32.const 0)) ;; Similar to the above, but this is just a const now
                         ;; and not a call. We still can't pull out the call
                         ;; with arg 3, due to the call with arg 1.
    (call $helper (i32.const 1))
   )
   (block (result i32)
    (drop (call $helper (i32.const 3)))
    (i32.const 4)
   )
   (i32.const 2)
  )
 )

 ;; CHECK:      (func $subsequent-children-4 (type $i32_i32_i32_=>_i32) (param $x i32) (param $y i32) (param $z i32) (result i32)
 ;; CHECK-NEXT:  (drop
 ;; CHECK-NEXT:   (i32.const 0)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT:  (drop
 ;; CHECK-NEXT:   (call $helper
 ;; CHECK-NEXT:    (i32.const 3)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT:  (call $subsequent-children-4
 ;; CHECK-NEXT:   (i32.const 1)
 ;; CHECK-NEXT:   (i32.const 4)
 ;; CHECK-NEXT:   (i32.const 2)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $subsequent-children-4 (param $x i32) (param $y i32) (param $z i32) (result i32)
  (call $subsequent-children-4
   (block (result i32)
    (drop (i32.const 0))
    ;; Similar to the above, but remove the call on arg 1 as well. Now we *can*
    ;; pull out the call with arg 3.
    (i32.const 1)
   )
   (block (result i32)
    (drop (call $helper (i32.const 3)))
    (i32.const 4)
   )
   (i32.const 2)
  )
 )

 ;; CHECK:      (func $helper (type $i32_=>_i32) (param $x i32) (result i32)
 ;; CHECK-NEXT:  (unreachable)
 ;; CHECK-NEXT: )
 (func $helper (param $x i32) (result i32)
  (unreachable)
 )
)
