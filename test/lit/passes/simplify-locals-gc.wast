;; NOTE: Assertions have been generated by update_lit_checks.py and should not be edited.
;; RUN: wasm-opt %s --simplify-locals -all -S -o - \
;; RUN:   | filecheck %s
;; RUN: wasm-opt %s --simplify-locals -all --nominal -S -o - \
;; RUN:   | filecheck %s --check-prefix=NOMNL

(module
  ;; CHECK:      (type $struct (struct (field (mut i32))))
  ;; NOMNL:      (type $struct (struct_subtype (field (mut i32)) data))
  (type $struct (struct (field (mut i32))))

  ;; CHECK:      (type $struct-immutable (struct (field i32)))
  ;; NOMNL:      (type $struct-immutable (struct_subtype (field i32) data))
  (type $struct-immutable (struct (field i32)))

  ;; CHECK:      (type $B (struct (field (ref data))))

  ;; CHECK:      (type $A (struct (field dataref)))
  ;; NOMNL:      (type $A (struct_subtype (field dataref) data))
  (type $A (struct_subtype (field (ref null data)) data))

  ;; $B is a subtype of $A, and its field has a more refined type (it is non-
  ;; nullable).
  ;; NOMNL:      (type $B (struct_subtype (field (ref data)) $A))
  (type $B (struct_subtype (field (ref data)) $A))

  ;; Writes to heap objects cannot be reordered with reads.
  ;; CHECK:      (func $no-reorder-past-write (param $x (ref $struct)) (result i32)
  ;; CHECK-NEXT:  (local $temp i32)
  ;; CHECK-NEXT:  (local.set $temp
  ;; CHECK-NEXT:   (struct.get $struct 0
  ;; CHECK-NEXT:    (local.get $x)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (struct.set $struct 0
  ;; CHECK-NEXT:   (local.get $x)
  ;; CHECK-NEXT:   (i32.const 42)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (local.get $temp)
  ;; CHECK-NEXT: )
  ;; NOMNL:      (func $no-reorder-past-write (type $ref|$struct|_=>_i32) (param $x (ref $struct)) (result i32)
  ;; NOMNL-NEXT:  (local $temp i32)
  ;; NOMNL-NEXT:  (local.set $temp
  ;; NOMNL-NEXT:   (struct.get $struct 0
  ;; NOMNL-NEXT:    (local.get $x)
  ;; NOMNL-NEXT:   )
  ;; NOMNL-NEXT:  )
  ;; NOMNL-NEXT:  (struct.set $struct 0
  ;; NOMNL-NEXT:   (local.get $x)
  ;; NOMNL-NEXT:   (i32.const 42)
  ;; NOMNL-NEXT:  )
  ;; NOMNL-NEXT:  (local.get $temp)
  ;; NOMNL-NEXT: )
  (func $no-reorder-past-write (param $x (ref $struct)) (result i32)
    (local $temp i32)
    (local.set $temp
      (struct.get $struct 0
        (local.get $x)
      )
    )
    (struct.set $struct 0
      (local.get $x)
      (i32.const 42)
    )
    (local.get $temp)
  )

  ;; CHECK:      (func $reorder-past-write-if-immutable (param $x (ref $struct)) (param $y (ref $struct-immutable)) (result i32)
  ;; CHECK-NEXT:  (local $temp i32)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT:  (struct.set $struct 0
  ;; CHECK-NEXT:   (local.get $x)
  ;; CHECK-NEXT:   (i32.const 42)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (struct.get $struct-immutable 0
  ;; CHECK-NEXT:   (local.get $y)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  ;; NOMNL:      (func $reorder-past-write-if-immutable (type $ref|$struct|_ref|$struct-immutable|_=>_i32) (param $x (ref $struct)) (param $y (ref $struct-immutable)) (result i32)
  ;; NOMNL-NEXT:  (local $temp i32)
  ;; NOMNL-NEXT:  (nop)
  ;; NOMNL-NEXT:  (struct.set $struct 0
  ;; NOMNL-NEXT:   (local.get $x)
  ;; NOMNL-NEXT:   (i32.const 42)
  ;; NOMNL-NEXT:  )
  ;; NOMNL-NEXT:  (struct.get $struct-immutable 0
  ;; NOMNL-NEXT:   (local.get $y)
  ;; NOMNL-NEXT:  )
  ;; NOMNL-NEXT: )
  (func $reorder-past-write-if-immutable (param $x (ref $struct)) (param $y (ref $struct-immutable)) (result i32)
    (local $temp i32)
    (local.set $temp
      (struct.get $struct-immutable 0
        (local.get $y)
      )
    )
    (struct.set $struct 0
      (local.get $x)
      (i32.const 42)
    )
    (local.get $temp)
  )

  ;; CHECK:      (func $unreachable-struct.get (param $x (ref $struct)) (param $y (ref $struct-immutable)) (result i32)
  ;; CHECK-NEXT:  (local $temp i32)
  ;; CHECK-NEXT:  (local.tee $temp
  ;; CHECK-NEXT:   (block ;; (replaces something unreachable we can't emit)
  ;; CHECK-NEXT:    (drop
  ;; CHECK-NEXT:     (unreachable)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (struct.set $struct 0
  ;; CHECK-NEXT:   (local.get $x)
  ;; CHECK-NEXT:   (i32.const 42)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (local.get $temp)
  ;; CHECK-NEXT: )
  ;; NOMNL:      (func $unreachable-struct.get (type $ref|$struct|_ref|$struct-immutable|_=>_i32) (param $x (ref $struct)) (param $y (ref $struct-immutable)) (result i32)
  ;; NOMNL-NEXT:  (local $temp i32)
  ;; NOMNL-NEXT:  (local.tee $temp
  ;; NOMNL-NEXT:   (block ;; (replaces something unreachable we can't emit)
  ;; NOMNL-NEXT:    (drop
  ;; NOMNL-NEXT:     (unreachable)
  ;; NOMNL-NEXT:    )
  ;; NOMNL-NEXT:   )
  ;; NOMNL-NEXT:  )
  ;; NOMNL-NEXT:  (struct.set $struct 0
  ;; NOMNL-NEXT:   (local.get $x)
  ;; NOMNL-NEXT:   (i32.const 42)
  ;; NOMNL-NEXT:  )
  ;; NOMNL-NEXT:  (local.get $temp)
  ;; NOMNL-NEXT: )
  (func $unreachable-struct.get (param $x (ref $struct)) (param $y (ref $struct-immutable)) (result i32)
    (local $temp i32)
    ;; As above, but the get's ref is unreachable. This tests we do not hit an
    ;; assertion on the get's type not having a heap type (as we depend on
    ;; finding the heap type there in the reachable case).
    ;; We simply do not handle this case, leaving it for DCE.
    (local.set $temp
      (struct.get $struct-immutable 0
        (unreachable)
      )
    )
    (struct.set $struct 0
      (local.get $x)
      (i32.const 42)
    )
    (local.get $temp)
  )

  ;; CHECK:      (func $no-block-values-if-br_on
  ;; CHECK-NEXT:  (local $temp anyref)
  ;; CHECK-NEXT:  (block $block
  ;; CHECK-NEXT:   (drop
  ;; CHECK-NEXT:    (br_on_null $block
  ;; CHECK-NEXT:     (ref.null any)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (local.set $temp
  ;; CHECK-NEXT:    (ref.null any)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (br $block)
  ;; CHECK-NEXT:   (local.set $temp
  ;; CHECK-NEXT:    (ref.null any)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (ref.as_non_null
  ;; CHECK-NEXT:    (local.get $temp)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  ;; NOMNL:      (func $no-block-values-if-br_on (type $none_=>_none)
  ;; NOMNL-NEXT:  (local $temp anyref)
  ;; NOMNL-NEXT:  (block $block
  ;; NOMNL-NEXT:   (drop
  ;; NOMNL-NEXT:    (br_on_null $block
  ;; NOMNL-NEXT:     (ref.null any)
  ;; NOMNL-NEXT:    )
  ;; NOMNL-NEXT:   )
  ;; NOMNL-NEXT:   (local.set $temp
  ;; NOMNL-NEXT:    (ref.null any)
  ;; NOMNL-NEXT:   )
  ;; NOMNL-NEXT:   (br $block)
  ;; NOMNL-NEXT:   (local.set $temp
  ;; NOMNL-NEXT:    (ref.null any)
  ;; NOMNL-NEXT:   )
  ;; NOMNL-NEXT:  )
  ;; NOMNL-NEXT:  (drop
  ;; NOMNL-NEXT:   (ref.as_non_null
  ;; NOMNL-NEXT:    (local.get $temp)
  ;; NOMNL-NEXT:   )
  ;; NOMNL-NEXT:  )
  ;; NOMNL-NEXT: )
  (func $no-block-values-if-br_on
   (local $temp (ref null any))
   (block $block
    (drop
     ;; This br_on should inhibit trying to create a block return value for
     ;; this block. Aside from the br_on, it looks correct, i.e., we have a
     ;; break with a set before it, and a set before the end of the block. Due
     ;; to the br_on's presence, the pass should not do anything to this
     ;; function.
     ;;
     ;; TODO: support br_on in this optimization eventually, but the variable
     ;;       possible return values and sent values make that nontrivial.
     (br_on_null $block
      (ref.null any)
     )
    )
    (local.set $temp
     (ref.null any)
    )
    (br $block)
    (local.set $temp
     (ref.null any)
    )
   )
   ;; Attempt to use the local that the pass will try to move to a block return
   ;; value, to cause the optimization to try to run.
   (drop
    (ref.as_non_null
     (local.get $temp)
    )
   )
  )

  ;; CHECK:      (func $if-nnl
  ;; CHECK-NEXT:  (local $x (ref func))
  ;; CHECK-NEXT:  (if
  ;; CHECK-NEXT:   (i32.const 1)
  ;; CHECK-NEXT:   (local.set $x
  ;; CHECK-NEXT:    (ref.func $if-nnl)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (call $helper
  ;; CHECK-NEXT:   (local.tee $x
  ;; CHECK-NEXT:    (ref.func $if-nnl)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (call $helper
  ;; CHECK-NEXT:   (local.get $x)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  ;; NOMNL:      (func $if-nnl (type $none_=>_none)
  ;; NOMNL-NEXT:  (local $x (ref func))
  ;; NOMNL-NEXT:  (if
  ;; NOMNL-NEXT:   (i32.const 1)
  ;; NOMNL-NEXT:   (local.set $x
  ;; NOMNL-NEXT:    (ref.func $if-nnl)
  ;; NOMNL-NEXT:   )
  ;; NOMNL-NEXT:  )
  ;; NOMNL-NEXT:  (call $helper
  ;; NOMNL-NEXT:   (local.tee $x
  ;; NOMNL-NEXT:    (ref.func $if-nnl)
  ;; NOMNL-NEXT:   )
  ;; NOMNL-NEXT:  )
  ;; NOMNL-NEXT:  (call $helper
  ;; NOMNL-NEXT:   (local.get $x)
  ;; NOMNL-NEXT:  )
  ;; NOMNL-NEXT: )
  (func $if-nnl
   (local $x (ref func))
   ;; We want to turn this if into an if-else with a set on the outside:
   ;;
   ;;  (local.set $x
   ;;   (if
   ;;    (i32.const 1)
   ;;    (ref.func $if-nnl)
   ;;    (local.get $x)))
   ;;
   ;; That will not validate, however (no set dominates the get), so we'll get
   ;; fixed up by adding a ref.as_non_null. But that may be dangerous - if no
   ;; set exists before us, then that new instruction will trap, in fact. So we
   ;; do not optimize here.
   (if
    (i32.const 1)
    (local.set $x
     (ref.func $if-nnl)
    )
   )
   ;; An exta set + gets, just to avoid other optimizations kicking in
   ;; (without them, the function only has a set and nothing else, and will
   ;; remove the set entirely). Nothing should change here.
   (call $helper
    (local.tee $x
     (ref.func $if-nnl)
    )
   )
   (call $helper
    (local.get $x)
   )
  )

  ;; CHECK:      (func $if-nnl-previous-set
  ;; CHECK-NEXT:  (local $x (ref func))
  ;; CHECK-NEXT:  (local.set $x
  ;; CHECK-NEXT:   (ref.func $if-nnl)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (if
  ;; CHECK-NEXT:   (i32.const 1)
  ;; CHECK-NEXT:   (local.set $x
  ;; CHECK-NEXT:    (ref.func $if-nnl)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (call $helper
  ;; CHECK-NEXT:   (local.tee $x
  ;; CHECK-NEXT:    (ref.func $if-nnl)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (call $helper
  ;; CHECK-NEXT:   (local.get $x)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  ;; NOMNL:      (func $if-nnl-previous-set (type $none_=>_none)
  ;; NOMNL-NEXT:  (local $x (ref func))
  ;; NOMNL-NEXT:  (local.set $x
  ;; NOMNL-NEXT:   (ref.func $if-nnl)
  ;; NOMNL-NEXT:  )
  ;; NOMNL-NEXT:  (if
  ;; NOMNL-NEXT:   (i32.const 1)
  ;; NOMNL-NEXT:   (local.set $x
  ;; NOMNL-NEXT:    (ref.func $if-nnl)
  ;; NOMNL-NEXT:   )
  ;; NOMNL-NEXT:  )
  ;; NOMNL-NEXT:  (call $helper
  ;; NOMNL-NEXT:   (local.tee $x
  ;; NOMNL-NEXT:    (ref.func $if-nnl)
  ;; NOMNL-NEXT:   )
  ;; NOMNL-NEXT:  )
  ;; NOMNL-NEXT:  (call $helper
  ;; NOMNL-NEXT:   (local.get $x)
  ;; NOMNL-NEXT:  )
  ;; NOMNL-NEXT: )
  (func $if-nnl-previous-set
   (local $x (ref func))
   ;; As the above testcase, but now there is a set before the if. We could
   ;; optimize in this case, but don't atm. TODO
   (local.set $x
    (ref.func $if-nnl)
   )
   (if
    (i32.const 1)
    (local.set $x
     (ref.func $if-nnl)
    )
   )
   (call $helper
    (local.tee $x
     (ref.func $if-nnl)
    )
   )
   (call $helper
    (local.get $x)
   )
  )

  ;; CHECK:      (func $helper (param $ref (ref func))
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  ;; NOMNL:      (func $helper (type $ref|func|_=>_none) (param $ref (ref func))
  ;; NOMNL-NEXT:  (nop)
  ;; NOMNL-NEXT: )
  (func $helper (param $ref (ref func))
  )

  ;; CHECK:      (func $needs-refinalize (param $b (ref $B)) (result anyref)
  ;; CHECK-NEXT:  (local $a (ref null $A))
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT:  (struct.get $B 0
  ;; CHECK-NEXT:   (local.get $b)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  ;; NOMNL:      (func $needs-refinalize (type $ref|$B|_=>_anyref) (param $b (ref $B)) (result anyref)
  ;; NOMNL-NEXT:  (local $a (ref null $A))
  ;; NOMNL-NEXT:  (nop)
  ;; NOMNL-NEXT:  (struct.get $B 0
  ;; NOMNL-NEXT:   (local.get $b)
  ;; NOMNL-NEXT:  )
  ;; NOMNL-NEXT: )
  (func $needs-refinalize (param $b (ref $B)) (result anyref)
    (local $a (ref null $A))
    (local.set $a
      (local.get $b)
    )
    ;; This begins as a struct.get of $A, but after we move the set's value onto
    ;; the get, we'll be reading from $B. $B's field has a more refined type, so
    ;; we must update the type of the struct.get using refinalize.
    (struct.get $A 0
      (local.get $a)
    )
  )
)
