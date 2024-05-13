;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.
;; NOTE: This test was ported using port_passes_tests_to_lit.py and could be cleaned up.

;; RUN: foreach %s %t wasm-opt --local-cse --all-features -S -o - | filecheck %s

(module
  ;; CHECK:      (type $f (func (param i32) (result i32)))
  (type $f (func (param i32) (result i32)))

  ;; CHECK:      (type $1 (func))

  ;; CHECK:      (elem declare func $calls $ref.func)

  ;; CHECK:      (func $calls (type $f) (param $x i32) (result i32)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (call_ref $f
  ;; CHECK-NEXT:    (i32.const 10)
  ;; CHECK-NEXT:    (ref.func $calls)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (call_ref $f
  ;; CHECK-NEXT:    (i32.const 10)
  ;; CHECK-NEXT:    (ref.func $calls)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (i32.const 20)
  ;; CHECK-NEXT: )
  (func $calls (param $x i32) (result i32)
    ;; The side effects of calls prevent optimization.
    (drop
      (call_ref $f (i32.const 10) (ref.func $calls))
    )
    (drop
      (call_ref $f (i32.const 10) (ref.func $calls))
    )
    (i32.const 20)
  )

  ;; CHECK:      (func $ref.func (type $1)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (ref.func $ref.func)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (ref.func $ref.func)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $ref.func
    ;; RefFunc and other constants should be ignored - don't undo the effects
    ;; of constant propagation.
    (drop
      (ref.func $ref.func)
    )
    (drop
      (ref.func $ref.func)
    )
  )
)

(module
  ;; CHECK:      (type $A (struct (field i32)))
  (type $A (struct (field i32)))

  ;; CHECK:      (type $B (array (mut i32)))
  (type $B (array (mut i32)))


  ;; CHECK:      (type $2 (func (param (ref $A))))

  ;; CHECK:      (type $3 (func (param (ref null $A))))

  ;; CHECK:      (type $4 (func))

  ;; CHECK:      (type $5 (func (param (ref null $B) (ref $A))))

  ;; CHECK:      (func $struct-gets-nullable (type $3) (param $ref (ref null $A))
  ;; CHECK-NEXT:  (local $1 i32)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (local.tee $1
  ;; CHECK-NEXT:    (struct.get $A 0
  ;; CHECK-NEXT:     (local.get $ref)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (local.get $1)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (local.get $1)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $struct-gets-nullable (param $ref (ref null $A))
    ;; Repeated loads from a struct can be optimized, even with a nullable
    ;; reference: if we trap, it does not matter that we replaced the later
    ;; expressions).
    (drop
      (struct.get $A 0
        (local.get $ref)
      )
    )
    (drop
      (struct.get $A 0
        (local.get $ref)
      )
    )
    (drop
      (struct.get $A 0
        (local.get $ref)
      )
    )
  )

  ;; CHECK:      (func $struct-gets (type $2) (param $ref (ref $A))
  ;; CHECK-NEXT:  (local $1 i32)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (local.tee $1
  ;; CHECK-NEXT:    (struct.get $A 0
  ;; CHECK-NEXT:     (local.get $ref)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (local.get $1)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (local.get $1)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $struct-gets (param $ref (ref $A))
    ;; Repeated loads from a struct can be optimized.
    ;;
    ;; A potential trap would not stop us (see previous testcase), but here
    ;; there is also no trap possible anyhow, and we should optimize.
    (drop
      (struct.get $A 0
        (local.get $ref)
      )
    )
    (drop
      (struct.get $A 0
        (local.get $ref)
      )
    )
    (drop
      (struct.get $A 0
        (local.get $ref)
      )
    )
  )

  ;; CHECK:      (func $non-nullable-value (type $2) (param $ref (ref $A))
  ;; CHECK-NEXT:  (local $1 (ref $A))
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (local.tee $1
  ;; CHECK-NEXT:    (select (result (ref $A))
  ;; CHECK-NEXT:     (local.get $ref)
  ;; CHECK-NEXT:     (local.get $ref)
  ;; CHECK-NEXT:     (i32.const 1)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (local.get $1)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $non-nullable-value (param $ref (ref $A))
    ;; The value that is repeated is non-nullable, which we must do some fixups
    ;; for after creating a local of that type.
    (drop
      (select (result (ref $A))
        (local.get $ref)
        (local.get $ref)
        (i32.const 1)
      )
    )
    (drop
      (select (result (ref $A))
        (local.get $ref)
        (local.get $ref)
        (i32.const 1)
      )
    )
  )

  ;; CHECK:      (func $creations (type $4)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.new $A
  ;; CHECK-NEXT:    (i32.const 1)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.new $A
  ;; CHECK-NEXT:    (i32.const 1)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (array.new $B
  ;; CHECK-NEXT:    (i32.const 1)
  ;; CHECK-NEXT:    (i32.const 1)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (array.new $B
  ;; CHECK-NEXT:    (i32.const 1)
  ;; CHECK-NEXT:    (i32.const 1)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $creations
    ;; Allocating GC data has no side effects, but each allocation is unique
    ;; and so we cannot replace separate allocations with a single one.
    (drop
      (struct.new $A
        (i32.const 1)
      )
    )
    (drop
      (struct.new $A
        (i32.const 1)
      )
    )
    (drop
      (array.new $B
        (i32.const 1)
        (i32.const 1)
      )
    )
    (drop
      (array.new $B
        (i32.const 1)
        (i32.const 1)
      )
    )
  )

  ;; CHECK:      (func $structs-and-arrays-do-not-alias (type $5) (param $array (ref null $B)) (param $struct (ref $A))
  ;; CHECK-NEXT:  (local $2 i32)
  ;; CHECK-NEXT:  (array.set $B
  ;; CHECK-NEXT:   (local.get $array)
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:   (local.tee $2
  ;; CHECK-NEXT:    (struct.get $A 0
  ;; CHECK-NEXT:     (local.get $struct)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (array.set $B
  ;; CHECK-NEXT:   (local.get $array)
  ;; CHECK-NEXT:   (i32.const 1)
  ;; CHECK-NEXT:   (local.get $2)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (array.set $B
  ;; CHECK-NEXT:   (local.get $array)
  ;; CHECK-NEXT:   (i32.const 2)
  ;; CHECK-NEXT:   (local.get $2)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $structs-and-arrays-do-not-alias (param $array (ref null $B)) (param $struct (ref $A))
    ;; ArraySets to consecutive elements, using some fixed StructGet value. This
    ;; common pattern in j2cl can be optimized, as structs and arrays do not
    ;; alias.
    (array.set $B
      (local.get $array)
      (i32.const 0)
      (struct.get $A 0
        (local.get $struct)
      )
    )
    (array.set $B
      (local.get $array)
      (i32.const 1)
      (struct.get $A 0
        (local.get $struct)
      )
    )
    (array.set $B
      (local.get $array)
      (i32.const 2)
      (struct.get $A 0
        (local.get $struct)
      )
    )
  )
)

(module
  ;; Real-world testcase from AssemblyScript, containing multiple nested things
  ;; that can be optimized. The inputs to the add (the xors) are identical, and
  ;; we can avoid repeating them.
  ;; CHECK:      (type $0 (func (param i32 i32) (result i32)))

  ;; CHECK:      (func $div16_internal (type $0) (param $0 i32) (param $1 i32) (result i32)
  ;; CHECK-NEXT:  (local $2 i32)
  ;; CHECK-NEXT:  (i32.add
  ;; CHECK-NEXT:   (local.tee $2
  ;; CHECK-NEXT:    (i32.xor
  ;; CHECK-NEXT:     (i32.shr_s
  ;; CHECK-NEXT:      (i32.shl
  ;; CHECK-NEXT:       (local.get $0)
  ;; CHECK-NEXT:       (i32.const 16)
  ;; CHECK-NEXT:      )
  ;; CHECK-NEXT:      (i32.const 16)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:     (i32.shr_s
  ;; CHECK-NEXT:      (i32.shl
  ;; CHECK-NEXT:       (local.get $1)
  ;; CHECK-NEXT:       (i32.const 16)
  ;; CHECK-NEXT:      )
  ;; CHECK-NEXT:      (i32.const 16)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (local.get $2)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $div16_internal (param $0 i32) (param $1 i32) (result i32)
    (i32.add
      (i32.xor
        (i32.shr_s
          (i32.shl
            (local.get $0)
            (i32.const 16)
          )
          (i32.const 16)
        )
        (i32.shr_s
          (i32.shl
            (local.get $1)
            (i32.const 16)
          )
          (i32.const 16)
        )
      )
      (i32.xor
        (i32.shr_s
          (i32.shl
            (local.get $0)
            (i32.const 16)
          )
          (i32.const 16)
        )
        (i32.shr_s
          (i32.shl
            (local.get $1)
            (i32.const 16)
          )
          (i32.const 16)
        )
      )
    )
  )
)

(module
  (type $func (func (param i32)))

  (type $struct (struct (field $x i32)))

  (func $caller (param $x anyref)
    (call_ref $func
      (struct.get $struct 0
        (ref.cast (ref $struct)
          (local.get $x)
        )
      )
    )
    (call_ref $func
      (struct.get $struct 0
        (ref.cast (ref $struct)
          (local.get $x)
        )
      )
    )
  )
)
