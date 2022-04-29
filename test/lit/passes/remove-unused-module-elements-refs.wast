;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.
;; RUN: foreach %s %t wasm-opt --remove-unused-module-elements --nominal -all -S -o - | filecheck %s

(module
  ;; CHECK:      (type $A (func_subtype func))
  (type $A (func))
  ;; CHECK:      (type $B (func_subtype func))
  (type $B (func))

  ;; CHECK:      (elem declare func $target-A $target-B)

  ;; CHECK:      (export "foo" (func $foo))

  ;; CHECK:      (func $foo (type $A)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (ref.func $target-A)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (ref.func $target-B)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (call_ref
  ;; CHECK-NEXT:   (ref.null $A)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (block
  ;; CHECK-NEXT:   (unreachable)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $foo (export "foo")
    ;; This export has two RefFuncs, and one CallRef.
    (drop
      (ref.func $target-A)
    )
    (drop
      (ref.func $target-B)
    )
    (call_ref
      (ref.null $A)
    )
    ;; Verify that we do not crash on an unreachable call_ref, which has no
    ;; heap type for us to analyze.
    (call_ref
      (unreachable)
    )
  )

  ;; CHECK:      (func $target-A (type $A)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  (func $target-A (type $A)
    ;; This function is reachable from the export "foo": there is a RefFunc and
    ;; a CallRef for it there.
  )

  (func $target-A-noref (type $A)
    ;; This function is not reachable. We have a CallRef of the right type, but
    ;; no RefFunc.
  )

  ;; CHECK:      (func $target-B (type $B)
  ;; CHECK-NEXT:  (unreachable)
  ;; CHECK-NEXT: )
  (func $target-B (type $B)
    ;; This function is not reachable. We have a RefFunc in "foo" but no
    ;; suitable CallRef.
    ;;
    ;; Note that we cannot remove the function, as the RefFunc must refer to
    ;; something in order to validate. But we can clear out the body of this
    ;; function with an unreachable.
  )
)

;; As above, but reverse the order inside $foo, so we see the CallRef first.
(module
  ;; CHECK:      (type $A (func_subtype func))
  (type $A (func))
  (type $B (func))

  ;; CHECK:      (elem declare func $target-A)

  ;; CHECK:      (export "foo" (func $foo))

  ;; CHECK:      (func $foo (type $A)
  ;; CHECK-NEXT:  (call_ref
  ;; CHECK-NEXT:   (ref.null $A)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (ref.func $target-A)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $foo (export "foo")
    (call_ref
      (ref.null $A)
    )
    (drop
      (ref.func $target-A)
    )
  )

  ;; CHECK:      (func $target-A (type $A)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  (func $target-A (type $A)
    ;; This function is reachable.
  )

  (func $target-A-noref (type $A)
    ;; This function is not reachable.
  )
)

;; As above, but interleave CallRefs with RefFuncs.
(module
  ;; CHECK:      (type $A (func_subtype func))
  (type $A (func))
  (type $B (func))

  ;; CHECK:      (elem declare func $target-A-1 $target-A-2)

  ;; CHECK:      (export "foo" (func $foo))

  ;; CHECK:      (func $foo (type $A)
  ;; CHECK-NEXT:  (call_ref
  ;; CHECK-NEXT:   (ref.null $A)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (ref.func $target-A-1)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (call_ref
  ;; CHECK-NEXT:   (ref.null $A)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (ref.func $target-A-2)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $foo (export "foo")
    (call_ref
      (ref.null $A)
    )
    (drop
      (ref.func $target-A-1)
    )
    (call_ref
      (ref.null $A)
    )
    (drop
      (ref.func $target-A-2)
    )
  )

  ;; CHECK:      (func $target-A-1 (type $A)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  (func $target-A-1 (type $A)
    ;; This function is reachable.
  )

  ;; CHECK:      (func $target-A-2 (type $A)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  (func $target-A-2 (type $A)
    ;; This function is reachable.
  )

  (func $target-A-3 (type $A)
    ;; This function is not reachable.
  )
)

;; As above, with the order reversed inside $foo. The results should be the
;; same.
(module
  ;; CHECK:      (type $A (func_subtype func))
  (type $A (func))
  (type $B (func))

  ;; CHECK:      (elem declare func $target-A-1 $target-A-2)

  ;; CHECK:      (export "foo" (func $foo))

  ;; CHECK:      (func $foo (type $A)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (ref.func $target-A-1)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (call_ref
  ;; CHECK-NEXT:   (ref.null $A)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (ref.func $target-A-2)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (call_ref
  ;; CHECK-NEXT:   (ref.null $A)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $foo (export "foo")
    (drop
      (ref.func $target-A-1)
    )
    (call_ref
      (ref.null $A)
    )
    (drop
      (ref.func $target-A-2)
    )
    (call_ref
      (ref.null $A)
    )
  )

  ;; CHECK:      (func $target-A-1 (type $A)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  (func $target-A-1 (type $A)
    ;; This function is reachable.
  )

  ;; CHECK:      (func $target-A-2 (type $A)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  (func $target-A-2 (type $A)
    ;; This function is reachable.
  )

  (func $target-A-3 (type $A)
    ;; This function is not reachable.
  )
)

;; Multiple references to the same function.
(module
  ;; CHECK:      (type $A (func_subtype func))
  (type $A (func))
  ;; CHECK:      (type $B (func_subtype func))
  (type $B (func))
  ;; CHECK:      (type $C (func_subtype func))
  (type $C (func))

  ;; CHECK:      (elem declare func $target-A-1 $target-C-1)

  ;; CHECK:      (export "foo" (func $foo))

  ;; CHECK:      (func $foo (type $A)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (ref.func $target-A-1)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (call_ref
  ;; CHECK-NEXT:   (ref.null $A)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (ref.func $target-A-1)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (call_ref
  ;; CHECK-NEXT:   (ref.null $A)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (call_ref
  ;; CHECK-NEXT:   (ref.null $B)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (call_ref
  ;; CHECK-NEXT:   (ref.null $B)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (ref.func $target-C-1)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (ref.func $target-C-1)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $foo (export "foo")
    (drop
      (ref.func $target-A-1)
    )
    (call_ref
      (ref.null $A)
    )
    (drop
      (ref.func $target-A-1)
    )
    (call_ref
      (ref.null $A)
    )
    ;; For B just have call_refs.
    (call_ref
      (ref.null $B)
    )
    (call_ref
      (ref.null $B)
    )
    ;; For C just have ref.funcs.
    (drop
      (ref.func $target-C-1)
    )
    (drop
      (ref.func $target-C-1)
    )
  )

  ;; CHECK:      (func $target-A-1 (type $A)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  (func $target-A-1 (type $A)
    ;; This function is reachable.
  )

  (func $target-A-2 (type $A)
    ;; This function is not reachable.
  )

  (func $target-B-1 (type $B)
    ;; This function is not reachable.
  )

  (func $target-B-2 (type $B)
    ;; This function is not reachable.
  )

  ;; CHECK:      (func $target-C-1 (type $C)
  ;; CHECK-NEXT:  (unreachable)
  ;; CHECK-NEXT: )
  (func $target-C-1 (type $C)
    ;; This function is not reachable, but has a reference.
  )

  (func $target-C-2 (type $C)
    ;; This function is not reachable.
  )
)

(module
  ;; A j2wasm-like itable pattern: An itable is an array of (possibly-null)
  ;; data that is filled with vtables of different types. On usage, we do a
  ;; cast of the vtable type.

  ;; CHECK:      (type $vtable-B (struct_subtype (field (ref $B)) data))

  ;; CHECK:      (type $A (func_subtype func))
  (type $A (func))

  ;; CHECK:      (type $object (struct_subtype (field (ref $itable)) data))

  ;; CHECK:      (type $itable (array_subtype (ref null data) data))

  ;; CHECK:      (type $B (func_subtype func))
  (type $B (func))

  (type $itable (array_subtype (ref null data) data))

  (type $object (struct_subtype (ref $itable) data))

  ;; CHECK:      (type $vtable-A (struct_subtype (field (ref $A)) data))
  (type $vtable-A (struct_subtype (ref $A) data))

  (type $vtable-B (struct_subtype (ref $B) data))

  ;; CHECK:      (global $itable (ref $itable) (array.init_static $itable
  ;; CHECK-NEXT:  (struct.new $vtable-A
  ;; CHECK-NEXT:   (ref.func $func-A)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (struct.new $vtable-B
  ;; CHECK-NEXT:   (ref.func $func-B)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: ))
  (global $itable (ref $itable)
    (array.init_static $itable
      (struct.new $vtable-A
        (ref.func $func-A)
      )
      (struct.new $vtable-B
        (ref.func $func-B)
      )
    )
  )

  ;; CHECK:      (export "use-itable" (func $use-itable))

  ;; CHECK:      (func $use-itable (type $A)
  ;; CHECK-NEXT:  (local $ref (ref null $object))
  ;; CHECK-NEXT:  (local.set $ref
  ;; CHECK-NEXT:   (struct.new $object
  ;; CHECK-NEXT:    (global.get $itable)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (call_ref
  ;; CHECK-NEXT:   (struct.get $vtable-B 0
  ;; CHECK-NEXT:    (ref.cast_static $vtable-B
  ;; CHECK-NEXT:     (array.get $itable
  ;; CHECK-NEXT:      (struct.get $object 0
  ;; CHECK-NEXT:       (local.get $ref)
  ;; CHECK-NEXT:      )
  ;; CHECK-NEXT:      (i32.const 1)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $use-itable (export "use-itable")
    (local $ref (ref null $object))
    ;; This is enough to use all the elements in the itable, which means we need
    ;; to keep references to $func-A/B around.
    (local.set $ref
      (struct.new $object
        (global.get $itable)
      )
    )
    ;; Also call one of them, $vtable-B, but not the other. $A can be emptied
    ;; out with an unreachable.
    (call_ref
      (struct.get $vtable-B 0
        (ref.cast_static $vtable-B
          (array.get $itable
            (struct.get $object 0
              (local.get $ref)
            )
            (i32.const 1)
          )
        )
      )
    )
  )

  ;; CHECK:      (func $func-A (type $A)
  ;; CHECK-NEXT:  (unreachable)
  ;; CHECK-NEXT: )
  (func $func-A (type $A)
    (nop)
  )

  ;; CHECK:      (func $func-B (type $B)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  (func $func-B (type $B)
    (nop)
  )
)

(module
  ;; As above, but do not use the global itable (see comments on the 2 changed
  ;; lines). This lets us completely remove both functions.

  ;; CHECK:      (type $object (struct_subtype (field (ref null $itable)) data))

  ;; CHECK:      (type $itable (array_subtype (ref null data) data))

  ;; CHECK:      (type $vtable-B (struct_subtype (field (ref $B)) data))

  ;; CHECK:      (type $A (func_subtype func))
  (type $A (func))

  ;; CHECK:      (type $B (func_subtype func))
  (type $B (func))

  (type $itable (array_subtype (ref null data) data))

  (type $object (struct_subtype (ref null $itable) data)) ;; nullable now

  (type $vtable-A (struct_subtype (ref $A) data))

  (type $vtable-B (struct_subtype (ref $B) data))

  (global $itable (ref $itable)
    (array.init_static $itable
      (struct.new $vtable-A
        (ref.func $func-A)
      )
      (struct.new $vtable-B
        (ref.func $func-B)
      )
    )
  )

  ;; CHECK:      (export "use-itable" (func $use-itable))

  ;; CHECK:      (func $use-itable (type $A)
  ;; CHECK-NEXT:  (local $ref (ref null $object))
  ;; CHECK-NEXT:  (local.set $ref
  ;; CHECK-NEXT:   (struct.new $object
  ;; CHECK-NEXT:    (ref.null $itable)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (call_ref
  ;; CHECK-NEXT:   (struct.get $vtable-B 0
  ;; CHECK-NEXT:    (ref.cast_static $vtable-B
  ;; CHECK-NEXT:     (array.get $itable
  ;; CHECK-NEXT:      (struct.get $object 0
  ;; CHECK-NEXT:       (local.get $ref)
  ;; CHECK-NEXT:      )
  ;; CHECK-NEXT:      (i32.const 1)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $use-itable (export "use-itable")
    (local $ref (ref null $object))
    (local.set $ref
      (struct.new $object
        (ref.null $itable) ;; This is the difference.
      )
    )
    (call_ref
      (struct.get $vtable-B 0
        (ref.cast_static $vtable-B
          (array.get $itable
            (struct.get $object 0
              (local.get $ref)
            )
            (i32.const 1)
          )
        )
      )
    )
  )

  (func $func-A (type $A)
    (nop)
  )

  (func $func-B (type $B)
    (nop)
  )
)

(module
  ;; As above, but now the functions are both imports. We know one of them is
  ;; not reachable, but we can't do anything about that - we can't empty out
  ;; the body of an import.

  ;; CHECK:      (type $vtable-B (struct_subtype (field (ref $B)) data))

  ;; CHECK:      (type $A (func_subtype func))
  (type $A (func))

  ;; CHECK:      (type $object (struct_subtype (field (ref $itable)) data))

  ;; CHECK:      (type $itable (array_subtype (ref null data) data))

  ;; CHECK:      (type $B (func_subtype func))
  (type $B (func))

  (type $itable (array_subtype (ref null data) data))

  (type $object (struct_subtype (ref $itable) data))

  ;; CHECK:      (type $vtable-A (struct_subtype (field (ref $A)) data))
  (type $vtable-A (struct_subtype (ref $A) data))

  (type $vtable-B (struct_subtype (ref $B) data))

  ;; CHECK:      (import "env" "func-A" (func $func-A))
  (import "env" "func-A" (func $func-A (type $A)))

  ;; CHECK:      (import "env" "func-B" (func $func-B))
  (import "env" "func-B" (func $func-B (type $B)))

  ;; CHECK:      (global $itable (ref $itable) (array.init_static $itable
  ;; CHECK-NEXT:  (struct.new $vtable-A
  ;; CHECK-NEXT:   (ref.func $func-A)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (struct.new $vtable-B
  ;; CHECK-NEXT:   (ref.func $func-B)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: ))
  (global $itable (ref $itable)
    (array.init_static $itable
      (struct.new $vtable-A
        (ref.func $func-A)
      )
      (struct.new $vtable-B
        (ref.func $func-B)
      )
    )
  )

  ;; CHECK:      (export "use-itable" (func $use-itable))

  ;; CHECK:      (func $use-itable (type $A)
  ;; CHECK-NEXT:  (local $ref (ref null $object))
  ;; CHECK-NEXT:  (local.set $ref
  ;; CHECK-NEXT:   (struct.new $object
  ;; CHECK-NEXT:    (global.get $itable)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (call_ref
  ;; CHECK-NEXT:   (struct.get $vtable-B 0
  ;; CHECK-NEXT:    (ref.cast_static $vtable-B
  ;; CHECK-NEXT:     (array.get $itable
  ;; CHECK-NEXT:      (struct.get $object 0
  ;; CHECK-NEXT:       (local.get $ref)
  ;; CHECK-NEXT:      )
  ;; CHECK-NEXT:      (i32.const 1)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $use-itable (export "use-itable")
    (local $ref (ref null $object))
    (local.set $ref
      (struct.new $object
        (global.get $itable)
      )
    )
    (call_ref
      (struct.get $vtable-B 0
        (ref.cast_static $vtable-B
          (array.get $itable
            (struct.get $object 0
              (local.get $ref)
            )
            (i32.const 1)
          )
        )
      )
    )
  )
)

;; A sequence of call_ref -> function -> call_ref -> function. This checks that
;; we properly scan the contents of called functions.
(module
  ;; CHECK:      (type $A (func_subtype func))
  (type $A (func))
  ;; CHECK:      (type $X (func_subtype func))

  ;; CHECK:      (type $C (func_subtype func))

  ;; CHECK:      (type $Z (func_subtype func))

  ;; CHECK:      (type $B (func_subtype func))
  (type $B (func))
  (type $C (func))

  (type $X (func))
  ;; CHECK:      (type $Y (func_subtype func))
  (type $Y (func))
  (type $Z (func))


  ;; CHECK:      (elem declare func $target-A $target-B $target-X $target-Y)

  ;; CHECK:      (export "foo" (func $foo))

  ;; CHECK:      (func $foo (type $A)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (ref.func $target-A)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (call_ref
  ;; CHECK-NEXT:   (ref.null $A)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (ref.func $target-B)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (call_ref
  ;; CHECK-NEXT:   (ref.null $C)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $foo (export "foo")
    ;; Provide everything for A, just a ref for B, and just a call for C
    (drop
      (ref.func $target-A)
    )
    (call_ref
      (ref.null $A)
    )
    (drop
      (ref.func $target-B)
    )
    (call_ref
      (ref.null $C)
    )
  )

  ;; CHECK:      (func $target-A (type $A)
  ;; CHECK-NEXT:  (call_ref
  ;; CHECK-NEXT:   (ref.null $Z)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (ref.func $target-Y)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (call_ref
  ;; CHECK-NEXT:   (ref.null $X)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (ref.func $target-X)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $target-A (type $A)
    ;; Similar to $foo, this provides everything for X, and only partial for Y
    ;; and Z.
    (call_ref
      (ref.null $Z)
    )
    (drop
      (ref.func $target-Y)
    )
    (call_ref
      (ref.null $X)
    )
    (drop
      (ref.func $target-X)
    )
  )

  ;; CHECK:      (func $target-B (type $B)
  ;; CHECK-NEXT:  (unreachable)
  ;; CHECK-NEXT: )
  (func $target-B (type $B)
    ;; The complement of $foo: provide a call for B and a ref for C, but these
    ;; are not reached, so it does not matter.
    (call_ref
      (ref.null $B)
    )
    (drop
      (ref.func $target-C)
    )
  )

  (func $target-C (type $C)
    ;; Identical to $target-B.
    (call_ref
      (ref.null $B)
    )
    (drop
      (ref.func $target-C)
    )
  )

  ;; CHECK:      (func $target-X (type $X)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  (func $target-X (type $X)
    ;; This is reached via foo -> target-A -> here.
  )

  ;; CHECK:      (func $target-Y (type $Y)
  ;; CHECK-NEXT:  (unreachable)
  ;; CHECK-NEXT: )
  (func $target-Y (type $Y)
    ;; This is never reached.
  )

  (func $target-Z (type $Z)
    ;; This is never reached.
  )
)
