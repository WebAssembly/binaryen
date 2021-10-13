;; NOTE: Assertions have been generated by update_lit_checks.py and should not be edited.
;; RUN: wasm-opt %s --remove-unused-names --precompute-propagate --fuzz-exec -all -S -o - \
;; RUN:   | filecheck %s
;; RUN: wasm-opt %s --remove-unused-names --precompute-propagate --fuzz-exec -all --nominal -S -o - \
;; RUN:   | filecheck %s

(module
 ;; CHECK:      (type $struct (struct (field (mut i32))))
 (type $struct (struct (mut i32)))
 ;; CHECK:      (type $empty (struct ))
 (type $empty (struct))

 ;; two incompatible struct types
 (type $A (struct (field (mut f32))))
 ;; CHECK:      (type $B (struct (field (mut f64))))
 (type $B (struct (field (mut f64))))

 ;; CHECK:      (type $func-return-i32 (func (result i32)))
 (type $func-return-i32 (func (result i32)))

 ;; CHECK:      (import "fuzzing-support" "log-i32" (func $log (param i32)))
 (import "fuzzing-support" "log-i32" (func $log (param i32)))

 ;; CHECK:      (func $test-fallthrough (result i32)
 ;; CHECK-NEXT:  (local $x funcref)
 ;; CHECK-NEXT:  (local.set $x
 ;; CHECK-NEXT:   (block (result funcref)
 ;; CHECK-NEXT:    (drop
 ;; CHECK-NEXT:     (call $test-fallthrough)
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:    (ref.null func)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT:  (i32.const 1)
 ;; CHECK-NEXT: )
 (func $test-fallthrough (result i32)
  (local $x funcref)
  (local.set $x
   ;; the fallthrough value should be used. for that to be possible with a block
   ;; we need for it not to have a name, which is why --remove-unused-names is
   ;; run
   (block (result (funcref))
    ;; make a call so the block is not trivially removable
    (drop
     (call $test-fallthrough)
    )
    (ref.null func)
   )
  )
  ;; the null in the local should be propagated to here
  (ref.is_null
   (local.get $x)
  )
 )

 ;; CHECK:      (func $load-from-struct
 ;; CHECK-NEXT:  (local $x (ref null $struct))
 ;; CHECK-NEXT:  (local.set $x
 ;; CHECK-NEXT:   (struct.new_with_rtt $struct
 ;; CHECK-NEXT:    (i32.const 1)
 ;; CHECK-NEXT:    (rtt.canon $struct)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT:  (call $log
 ;; CHECK-NEXT:   (struct.get $struct 0
 ;; CHECK-NEXT:    (local.get $x)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT:  (local.set $x
 ;; CHECK-NEXT:   (struct.new_with_rtt $struct
 ;; CHECK-NEXT:    (i32.const 2)
 ;; CHECK-NEXT:    (rtt.canon $struct)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT:  (call $log
 ;; CHECK-NEXT:   (struct.get $struct 0
 ;; CHECK-NEXT:    (local.get $x)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT:  (struct.set $struct 0
 ;; CHECK-NEXT:   (local.get $x)
 ;; CHECK-NEXT:   (i32.const 3)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT:  (call $log
 ;; CHECK-NEXT:   (struct.get $struct 0
 ;; CHECK-NEXT:    (local.get $x)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $load-from-struct
  (local $x (ref null $struct))
  (local.set $x
   (struct.new_with_rtt $struct
    (i32.const 1)
    (rtt.canon $struct)
   )
  )
  ;; we don't precompute these, as we don't know if the GC data was modified
  ;; elsewhere (we'd need immutability or escape analysis)
  (call $log
   (struct.get $struct 0 (local.get $x))
  )
  ;; Assign a new struct
  (local.set $x
   (struct.new_with_rtt $struct
    (i32.const 2)
    (rtt.canon $struct)
   )
  )
  (call $log
   (struct.get $struct 0 (local.get $x))
  )
  ;; Assign a new value
  (struct.set $struct 0
   (local.get $x)
   (i32.const 3)
  )
  (call $log
   (struct.get $struct 0 (local.get $x))
  )
 )
 ;; CHECK:      (func $load-from-struct-bad-merge (param $i i32)
 ;; CHECK-NEXT:  (local $x (ref null $struct))
 ;; CHECK-NEXT:  (if
 ;; CHECK-NEXT:   (local.get $i)
 ;; CHECK-NEXT:   (local.set $x
 ;; CHECK-NEXT:    (struct.new_with_rtt $struct
 ;; CHECK-NEXT:     (i32.const 1)
 ;; CHECK-NEXT:     (rtt.canon $struct)
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (local.set $x
 ;; CHECK-NEXT:    (struct.new_with_rtt $struct
 ;; CHECK-NEXT:     (i32.const 2)
 ;; CHECK-NEXT:     (rtt.canon $struct)
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT:  (call $log
 ;; CHECK-NEXT:   (struct.get $struct 0
 ;; CHECK-NEXT:    (local.get $x)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $load-from-struct-bad-merge (param $i i32)
  (local $x (ref null $struct))
  ;; a merge of two different $x values cannot be precomputed
  (if
   (local.get $i)
   (local.set $x
    (struct.new_with_rtt $struct
     (i32.const 1)
     (rtt.canon $struct)
    )
   )
   (local.set $x
    (struct.new_with_rtt $struct
     (i32.const 2)
     (rtt.canon $struct)
    )
   )
  )
  (call $log
   (struct.get $struct 0 (local.get $x))
  )
 )
 ;; CHECK:      (func $modify-gc-heap (param $x (ref null $struct))
 ;; CHECK-NEXT:  (struct.set $struct 0
 ;; CHECK-NEXT:   (local.get $x)
 ;; CHECK-NEXT:   (i32.add
 ;; CHECK-NEXT:    (struct.get $struct 0
 ;; CHECK-NEXT:     (local.get $x)
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:    (i32.const 1)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $modify-gc-heap (param $x (ref null $struct))
  (struct.set $struct 0
   (local.get $x)
   (i32.add
    (struct.get $struct 0
     (local.get $x)
    )
    (i32.const 1)
   )
  )
 )
 ;; --fuzz-exec verifies the output of this function, checking that the change
 ;; makde in modify-gc-heap is not ignored
 ;; CHECK:      (func $load-from-struct-bad-escape
 ;; CHECK-NEXT:  (local $x (ref null $struct))
 ;; CHECK-NEXT:  (local.set $x
 ;; CHECK-NEXT:   (struct.new_with_rtt $struct
 ;; CHECK-NEXT:    (i32.const 1)
 ;; CHECK-NEXT:    (rtt.canon $struct)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT:  (call $modify-gc-heap
 ;; CHECK-NEXT:   (local.get $x)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT:  (call $log
 ;; CHECK-NEXT:   (struct.get $struct 0
 ;; CHECK-NEXT:    (local.get $x)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $load-from-struct-bad-escape (export "test")
  (local $x (ref null $struct))
  (local.set $x
   (struct.new_with_rtt $struct
    (i32.const 1)
    (rtt.canon $struct)
   )
  )
  (call $modify-gc-heap
   (local.get $x)
  )
  (call $log
   (struct.get $struct 0 (local.get $x))
  )
 )
 ;; CHECK:      (func $load-from-struct-bad-arrive (param $x (ref null $struct))
 ;; CHECK-NEXT:  (call $log
 ;; CHECK-NEXT:   (struct.get $struct 0
 ;; CHECK-NEXT:    (local.get $x)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $load-from-struct-bad-arrive (param $x (ref null $struct))
  ;; a parameter cannot be precomputed
  (call $log
   (struct.get $struct 0 (local.get $x))
  )
 )
 ;; CHECK:      (func $ref-comparisons (param $x (ref null $struct)) (param $y (ref null $struct))
 ;; CHECK-NEXT:  (local $z (ref null $struct))
 ;; CHECK-NEXT:  (local $w (ref null $struct))
 ;; CHECK-NEXT:  (call $log
 ;; CHECK-NEXT:   (ref.eq
 ;; CHECK-NEXT:    (local.get $x)
 ;; CHECK-NEXT:    (local.get $y)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT:  (call $log
 ;; CHECK-NEXT:   (ref.eq
 ;; CHECK-NEXT:    (local.get $x)
 ;; CHECK-NEXT:    (ref.null $struct)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT:  (call $log
 ;; CHECK-NEXT:   (ref.eq
 ;; CHECK-NEXT:    (local.get $x)
 ;; CHECK-NEXT:    (ref.null $struct)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT:  (call $log
 ;; CHECK-NEXT:   (i32.const 1)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $ref-comparisons
  (param $x (ref null $struct))
  (param $y (ref null $struct))
  (local $z (ref null $struct))
  (local $w (ref null $struct))
  ;; incoming parameters are unknown
  (call $log
   (ref.eq
    (local.get $x)
    (local.get $y)
   )
  )
  (call $log
   (ref.eq
    (local.get $x)
    ;; locals are ref.null which are known, and will be propagated
    (local.get $z)
   )
  )
  (call $log
   (ref.eq
    (local.get $x)
    (local.get $w)
   )
  )
  ;; null-initialized locals are known and can be compared
  (call $log
   (ref.eq
    (local.get $z)
    (local.get $w)
   )
  )
 )
 ;; CHECK:      (func $new-ref-comparisons (result i32)
 ;; CHECK-NEXT:  (local $x (ref null $struct))
 ;; CHECK-NEXT:  (local $y (ref null $struct))
 ;; CHECK-NEXT:  (local $tempresult i32)
 ;; CHECK-NEXT:  (local.set $x
 ;; CHECK-NEXT:   (struct.new_with_rtt $struct
 ;; CHECK-NEXT:    (i32.const 1)
 ;; CHECK-NEXT:    (rtt.canon $struct)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT:  (local.set $y
 ;; CHECK-NEXT:   (local.get $x)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT:  (local.set $tempresult
 ;; CHECK-NEXT:   (i32.const 1)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT:  (i32.const 1)
 ;; CHECK-NEXT: )
 (func $new-ref-comparisons (result i32)
  (local $x (ref null $struct))
  (local $y (ref null $struct))
  (local $tempresult i32)
  (local.set $x
   (struct.new_with_rtt $struct
    (i32.const 1)
    (rtt.canon $struct)
   )
  )
  (local.set $y
   (local.get $x)
  )
  ;; assign the result, so that propagate calculates the ref.eq. both $x and $y
  ;; must refer to the same data, so we can precompute a 1 here.
  (local.set $tempresult
   (ref.eq
    (local.get $x)
    (local.get $y)
   )
  )
  ;; and that 1 is propagated to here.
  (local.get $tempresult)
 )
 ;; CHECK:      (func $propagate-equal (result i32)
 ;; CHECK-NEXT:  (local $tempresult i32)
 ;; CHECK-NEXT:  (local $tempref (ref null $empty))
 ;; CHECK-NEXT:  (local.set $tempresult
 ;; CHECK-NEXT:   (ref.eq
 ;; CHECK-NEXT:    (local.tee $tempref
 ;; CHECK-NEXT:     (struct.new_default_with_rtt $empty
 ;; CHECK-NEXT:      (rtt.canon $empty)
 ;; CHECK-NEXT:     )
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:    (local.get $tempref)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT:  (i32.const 1)
 ;; CHECK-NEXT: )
 (func $propagate-equal (result i32)
  (local $tempresult i32)
  (local $tempref (ref null $empty))
  ;; assign the result, so that propagate calculates the ref.eq
  (local.set $tempresult
   (ref.eq
    ;; allocate one struct
    (local.tee $tempref
     (struct.new_with_rtt $empty
      (rtt.canon $empty)
     )
    )
    (local.get $tempref)
   )
  )
  ;; we can compute a 1 here as the ref.eq compares a struct to itself. note
  ;; that the ref.eq itself cannot be precomputed away (as it has side effects).
  (local.get $tempresult)
 )
 ;; CHECK:      (func $propagate-unequal (result i32)
 ;; CHECK-NEXT:  (local $tempresult i32)
 ;; CHECK-NEXT:  (local $tempref (ref null $empty))
 ;; CHECK-NEXT:  (local.set $tempresult
 ;; CHECK-NEXT:   (i32.const 0)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT:  (i32.const 0)
 ;; CHECK-NEXT: )
 (func $propagate-unequal (result i32)
  (local $tempresult i32)
  (local $tempref (ref null $empty))
  ;; assign the result, so that propagate calculates the ref.eq.
  ;; the structs are different, so we will precompute a 0 here, and as creating
  ;; heap data does not have side effects, we can in fact replace the ref.eq
  ;; with that value
  (local.set $tempresult
   ;; allocate two different structs
   (ref.eq
    (struct.new_with_rtt $empty
     (rtt.canon $empty)
    )
    (struct.new_with_rtt $empty
     (rtt.canon $empty)
    )
   )
  )
  (local.get $tempresult)
 )

 ;; CHECK:      (func $propagate-uncertain-param (param $input (ref $empty)) (result i32)
 ;; CHECK-NEXT:  (local $tempresult i32)
 ;; CHECK-NEXT:  (local $tempref (ref null $empty))
 ;; CHECK-NEXT:  (local.set $tempresult
 ;; CHECK-NEXT:   (ref.eq
 ;; CHECK-NEXT:    (struct.new_default_with_rtt $empty
 ;; CHECK-NEXT:     (rtt.canon $empty)
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:    (local.get $input)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT:  (local.get $tempresult)
 ;; CHECK-NEXT: )
 (func $propagate-uncertain-param (param $input (ref $empty)) (result i32)
  (local $tempresult i32)
  (local $tempref (ref null $empty))
  (local.set $tempresult
   ;; allocate a struct and compare it to a param, which we know nothing about,
   ;; so we can infer nothing here at all.
   (ref.eq
    (struct.new_with_rtt $empty
     (rtt.canon $empty)
    )
    (local.get $input)
   )
  )
  (local.get $tempresult)
 )

 ;; CHECK:      (func $propagate-uncertain-loop
 ;; CHECK-NEXT:  (local $tempresult i32)
 ;; CHECK-NEXT:  (local $tempref (ref null $empty))
 ;; CHECK-NEXT:  (local $stashedref (ref null $empty))
 ;; CHECK-NEXT:  (loop $loop
 ;; CHECK-NEXT:   (local.set $stashedref
 ;; CHECK-NEXT:    (local.get $tempref)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (if
 ;; CHECK-NEXT:    (call $helper
 ;; CHECK-NEXT:     (i32.const 0)
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:    (local.set $tempref
 ;; CHECK-NEXT:     (struct.new_default_with_rtt $empty
 ;; CHECK-NEXT:      (rtt.canon $empty)
 ;; CHECK-NEXT:     )
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (local.set $tempresult
 ;; CHECK-NEXT:    (ref.eq
 ;; CHECK-NEXT:     (local.get $tempref)
 ;; CHECK-NEXT:     (local.get $stashedref)
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (br_if $loop
 ;; CHECK-NEXT:    (call $helper
 ;; CHECK-NEXT:     (local.get $tempresult)
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $propagate-uncertain-loop
  (local $tempresult i32)
  (local $tempref (ref null $empty))
  (local $stashedref (ref null $empty))
  (loop $loop
   ;; Each iteration in this loop may allocate a different struct, so we cannot
   ;; precompute the ref.eq here.
   (local.set $stashedref
    (local.get $tempref)
   )
   (if
    (call $helper
     (i32.const 0)
    )
    (local.set $tempref
     (struct.new_with_rtt $empty
      (rtt.canon $empty)
     )
    )
   )
   (local.set $tempresult
    (ref.eq
     (local.get $tempref)
     (local.get $stashedref)
    )
   )
   (br_if $loop
    (call $helper
     (local.get $tempresult)
    )
   )
  )
 )

 ;; CHECK:      (func $propagate-certain-loop
 ;; CHECK-NEXT:  (local $tempresult i32)
 ;; CHECK-NEXT:  (local $tempref (ref null $empty))
 ;; CHECK-NEXT:  (local $stashedref (ref null $empty))
 ;; CHECK-NEXT:  (loop $loop
 ;; CHECK-NEXT:   (local.set $tempref
 ;; CHECK-NEXT:    (struct.new_default_with_rtt $empty
 ;; CHECK-NEXT:     (rtt.canon $empty)
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (local.set $stashedref
 ;; CHECK-NEXT:    (local.get $tempref)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (local.set $tempresult
 ;; CHECK-NEXT:    (i32.const 1)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (br_if $loop
 ;; CHECK-NEXT:    (call $helper
 ;; CHECK-NEXT:     (i32.const 1)
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $propagate-certain-loop
  (local $tempresult i32)
  (local $tempref (ref null $empty))
  (local $stashedref (ref null $empty))
  (loop $loop
   ;; As above, but remove the if and move the set of $stashedref below the
   ;; struct.new, so that each loop iteration does in fact have the ref locals
   ;; identical, and we can precompute.
   (local.set $tempref
    (struct.new_with_rtt $empty
     (rtt.canon $empty)
    )
   )
   (local.set $stashedref
    (local.get $tempref)
   )
   (local.set $tempresult
    (ref.eq
     (local.get $tempref)
     (local.get $stashedref)
    )
   )
   (br_if $loop
    (call $helper
     (local.get $tempresult)
    )
   )
  )
 )

 ;; CHECK:      (func $helper (param $0 i32) (result i32)
 ;; CHECK-NEXT:  (unreachable)
 ;; CHECK-NEXT: )
 (func $helper (param i32) (result i32)
  (unreachable)
 )

 ;; CHECK:      (func $odd-cast-and-get
 ;; CHECK-NEXT:  (local $temp (ref null $B))
 ;; CHECK-NEXT:  (local.set $temp
 ;; CHECK-NEXT:   (ref.null $B)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT:  (drop
 ;; CHECK-NEXT:   (struct.get $B 0
 ;; CHECK-NEXT:    (ref.null $B)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $odd-cast-and-get
  (local $temp (ref null $B))
  ;; Try to cast a null of A to B. While the types are incompatible, ref.cast
  ;; returns a null when given a null (and the null must have the type that the
  ;; ref.cast instruction has, that is, the value is a null of type $B). So this
  ;; is an odd cast that "works".
  (local.set $temp
   (ref.cast
    (ref.null $A)
    (rtt.canon $B)
   )
  )
  (drop
   ;; Read from the local, which precompute should set to a null with the proper
   ;; type.
   (struct.get $B 0
    (local.get $temp)
   )
  )
 )

 ;; CHECK:      (func $odd-cast-and-get-tuple
 ;; CHECK-NEXT:  (local $temp ((ref null $B) i32))
 ;; CHECK-NEXT:  (local.set $temp
 ;; CHECK-NEXT:   (tuple.make
 ;; CHECK-NEXT:    (ref.null $B)
 ;; CHECK-NEXT:    (i32.const 10)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT:  (drop
 ;; CHECK-NEXT:   (struct.get $B 0
 ;; CHECK-NEXT:    (ref.null $B)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $odd-cast-and-get-tuple
  (local $temp ((ref null $B) i32))
  ;; As above, but with a tuple.
  (local.set $temp
   (tuple.make
    (ref.cast
     (ref.null $A)
     (rtt.canon $B)
    )
    (i32.const 10)
   )
  )
  (drop
   (struct.get $B 0
    (tuple.extract 0
     (local.get $temp)
    )
   )
  )
 )

 ;; CHECK:      (func $receive-f64 (param $0 f64)
 ;; CHECK-NEXT:  (unreachable)
 ;; CHECK-NEXT: )
 (func $receive-f64 (param f64)
  (unreachable)
 )

 ;; CHECK:      (func $odd-cast-and-get-non-null (param $temp (ref $func-return-i32))
 ;; CHECK-NEXT:  (local.set $temp
 ;; CHECK-NEXT:   (ref.cast
 ;; CHECK-NEXT:    (ref.func $receive-f64)
 ;; CHECK-NEXT:    (rtt.canon $func-return-i32)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT:  (drop
 ;; CHECK-NEXT:   (call_ref
 ;; CHECK-NEXT:    (local.get $temp)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $odd-cast-and-get-non-null (param $temp (ref $func-return-i32))
  ;; Try to cast a function to an incompatible type.
  (local.set $temp
   (ref.cast
    (ref.func $receive-f64)
    (rtt.canon $func-return-i32)
   )
  )
  (drop
   ;; Read from the local, checking whether precompute set a value there (it
   ;; should not, as the cast fails).
   (call_ref
    (local.get $temp)
   )
  )
 )

 ;; CHECK:      (func $new_block_unreachable (result anyref)
 ;; CHECK-NEXT:  (block
 ;; CHECK-NEXT:   (block
 ;; CHECK-NEXT:    (unreachable)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (rtt.canon $struct)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $new_block_unreachable (result anyref)
  (struct.new_with_rtt $struct
   ;; The value is a block with an unreachable. precompute will get rid of the
   ;; block, after which fuzz-exec should not crash - this is a regression test
   ;; for us being careful in how we execute an unreachable struct.new
   (block $label$1 (result i32)
    (unreachable)
   )
   (rtt.canon $struct)
  )
 )
)
