;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.
;; RUN: foreach %s %t wasm-opt --remove-unused-module-elements --closed-world --nominal -all -S -o - | filecheck %s
;; RUN: foreach %s %t wasm-opt --remove-unused-module-elements                --nominal -all -S -o - | filecheck %s --check-prefix OPEN_WORLD

;; Test both open world (default) and closed world. In a closed world we can do
;; more with function refs, as we assume nothing calls them on the outside, so
;; if no calls exist to the right type, the function is not reached.

(module
  ;; CHECK:      (type $A (func))
  ;; OPEN_WORLD:      (type $A (func))
  (type $A (func))

  ;; CHECK:      (type $B (func))
  ;; OPEN_WORLD:      (type $B (func))
  (type $B (func))

  ;; CHECK:      (elem declare func $target-A $target-B)

  ;; CHECK:      (export "foo" (func $foo))

  ;; CHECK:      (func $foo (type $A)
  ;; CHECK-NEXT:  (local $A (ref null $A))
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (ref.func $target-A)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (ref.func $target-B)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (call_ref $A
  ;; CHECK-NEXT:   (local.get $A)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (block ;; (replaces something unreachable we can't emit)
  ;; CHECK-NEXT:   (drop
  ;; CHECK-NEXT:    (unreachable)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (unreachable)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  ;; OPEN_WORLD:      (elem declare func $target-A $target-B)

  ;; OPEN_WORLD:      (export "foo" (func $foo))

  ;; OPEN_WORLD:      (func $foo (type $A)
  ;; OPEN_WORLD-NEXT:  (local $A (ref null $A))
  ;; OPEN_WORLD-NEXT:  (drop
  ;; OPEN_WORLD-NEXT:   (ref.func $target-A)
  ;; OPEN_WORLD-NEXT:  )
  ;; OPEN_WORLD-NEXT:  (drop
  ;; OPEN_WORLD-NEXT:   (ref.func $target-B)
  ;; OPEN_WORLD-NEXT:  )
  ;; OPEN_WORLD-NEXT:  (call_ref $A
  ;; OPEN_WORLD-NEXT:   (local.get $A)
  ;; OPEN_WORLD-NEXT:  )
  ;; OPEN_WORLD-NEXT:  (block ;; (replaces something unreachable we can't emit)
  ;; OPEN_WORLD-NEXT:   (drop
  ;; OPEN_WORLD-NEXT:    (unreachable)
  ;; OPEN_WORLD-NEXT:   )
  ;; OPEN_WORLD-NEXT:   (unreachable)
  ;; OPEN_WORLD-NEXT:  )
  ;; OPEN_WORLD-NEXT: )
  (func $foo (export "foo")
    (local $A (ref null $A))
    ;; This export has two RefFuncs, and one CallRef.
    (drop
      (ref.func $target-A)
    )
    (drop
      (ref.func $target-B)
    )
    (call_ref $A
      (local.get $A)
    )
    ;; Verify that we do not crash on an unreachable call_ref, which has no
    ;; heap type for us to analyze.
    (call_ref $A
      (unreachable)
    )
  )

  ;; CHECK:      (func $target-A (type $A)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  ;; OPEN_WORLD:      (func $target-A (type $A)
  ;; OPEN_WORLD-NEXT:  (nop)
  ;; OPEN_WORLD-NEXT: )
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
  ;; OPEN_WORLD:      (func $target-B (type $B)
  ;; OPEN_WORLD-NEXT:  (nop)
  ;; OPEN_WORLD-NEXT: )
  (func $target-B (type $B)
    ;; This function is not reachable. We have a RefFunc in "foo" but no
    ;; suitable CallRef.
    ;;
    ;; Note that we cannot remove the function, as the RefFunc must refer to
    ;; something in order to validate. But we can clear out the body of this
    ;; function with an unreachable.
    ;;
    ;; As mentioned above, in an open world we cannot optimize here, so the
    ;; function body will remain empty as a nop, and not turn into an
    ;; unreachable.
  )
)

;; As above, but reverse the order inside $foo, so we see the CallRef first.
(module
  ;; CHECK:      (type $A (func))
  ;; OPEN_WORLD:      (type $A (func))
  (type $A (func))
  (type $B (func))

  ;; CHECK:      (elem declare func $target-A)

  ;; CHECK:      (export "foo" (func $foo))

  ;; CHECK:      (func $foo (type $A)
  ;; CHECK-NEXT:  (local $A (ref null $A))
  ;; CHECK-NEXT:  (call_ref $A
  ;; CHECK-NEXT:   (local.get $A)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (ref.func $target-A)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  ;; OPEN_WORLD:      (elem declare func $target-A)

  ;; OPEN_WORLD:      (export "foo" (func $foo))

  ;; OPEN_WORLD:      (func $foo (type $A)
  ;; OPEN_WORLD-NEXT:  (local $A (ref null $A))
  ;; OPEN_WORLD-NEXT:  (call_ref $A
  ;; OPEN_WORLD-NEXT:   (local.get $A)
  ;; OPEN_WORLD-NEXT:  )
  ;; OPEN_WORLD-NEXT:  (drop
  ;; OPEN_WORLD-NEXT:   (ref.func $target-A)
  ;; OPEN_WORLD-NEXT:  )
  ;; OPEN_WORLD-NEXT: )
  (func $foo (export "foo")
    (local $A (ref null $A))
    (call_ref $A
      (local.get $A)
    )
    (drop
      (ref.func $target-A)
    )
  )

  ;; CHECK:      (func $target-A (type $A)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  ;; OPEN_WORLD:      (func $target-A (type $A)
  ;; OPEN_WORLD-NEXT:  (nop)
  ;; OPEN_WORLD-NEXT: )
  (func $target-A (type $A)
    ;; This function is reachable.
  )

  (func $target-A-noref (type $A)
    ;; This function is not reachable.
  )
)

;; As above, but interleave CallRefs with RefFuncs.
(module
  ;; CHECK:      (type $A (func))
  ;; OPEN_WORLD:      (type $A (func))
  (type $A (func))
  (type $B (func))

  ;; CHECK:      (elem declare func $target-A-1 $target-A-2)

  ;; CHECK:      (export "foo" (func $foo))

  ;; CHECK:      (func $foo (type $A)
  ;; CHECK-NEXT:  (local $A (ref null $A))
  ;; CHECK-NEXT:  (call_ref $A
  ;; CHECK-NEXT:   (local.get $A)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (ref.func $target-A-1)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (call_ref $A
  ;; CHECK-NEXT:   (local.get $A)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (ref.func $target-A-2)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  ;; OPEN_WORLD:      (elem declare func $target-A-1 $target-A-2)

  ;; OPEN_WORLD:      (export "foo" (func $foo))

  ;; OPEN_WORLD:      (func $foo (type $A)
  ;; OPEN_WORLD-NEXT:  (local $A (ref null $A))
  ;; OPEN_WORLD-NEXT:  (call_ref $A
  ;; OPEN_WORLD-NEXT:   (local.get $A)
  ;; OPEN_WORLD-NEXT:  )
  ;; OPEN_WORLD-NEXT:  (drop
  ;; OPEN_WORLD-NEXT:   (ref.func $target-A-1)
  ;; OPEN_WORLD-NEXT:  )
  ;; OPEN_WORLD-NEXT:  (call_ref $A
  ;; OPEN_WORLD-NEXT:   (local.get $A)
  ;; OPEN_WORLD-NEXT:  )
  ;; OPEN_WORLD-NEXT:  (drop
  ;; OPEN_WORLD-NEXT:   (ref.func $target-A-2)
  ;; OPEN_WORLD-NEXT:  )
  ;; OPEN_WORLD-NEXT: )
  (func $foo (export "foo")
    (local $A (ref null $A))
    (call_ref $A
      (local.get $A)
    )
    (drop
      (ref.func $target-A-1)
    )
    (call_ref $A
      (local.get $A)
    )
    (drop
      (ref.func $target-A-2)
    )
  )

  ;; WORLD_OPEN-NEXT: )
  ;; CHECK:      (func $target-A-1 (type $A)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  ;; OPEN_WORLD:      (func $target-A-1 (type $A)
  ;; OPEN_WORLD-NEXT:  (nop)
  ;; OPEN_WORLD-NEXT: )
  (func $target-A-1 (type $A)
    ;; This function is reachable.
  )

  ;; CHECK:      (func $target-A-2 (type $A)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  ;; OPEN_WORLD:      (func $target-A-2 (type $A)
  ;; OPEN_WORLD-NEXT:  (nop)
  ;; OPEN_WORLD-NEXT: )
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
  ;; CHECK:      (type $A (func))
  ;; OPEN_WORLD:      (type $A (func))
  (type $A (func))
  (type $B (func))

  ;; CHECK:      (elem declare func $target-A-1 $target-A-2)

  ;; CHECK:      (export "foo" (func $foo))

  ;; CHECK:      (func $foo (type $A)
  ;; CHECK-NEXT:  (local $A (ref null $A))
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (ref.func $target-A-1)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (call_ref $A
  ;; CHECK-NEXT:   (local.get $A)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (ref.func $target-A-2)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (call_ref $A
  ;; CHECK-NEXT:   (local.get $A)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  ;; OPEN_WORLD:      (elem declare func $target-A-1 $target-A-2)

  ;; OPEN_WORLD:      (export "foo" (func $foo))

  ;; OPEN_WORLD:      (func $foo (type $A)
  ;; OPEN_WORLD-NEXT:  (local $A (ref null $A))
  ;; OPEN_WORLD-NEXT:  (drop
  ;; OPEN_WORLD-NEXT:   (ref.func $target-A-1)
  ;; OPEN_WORLD-NEXT:  )
  ;; OPEN_WORLD-NEXT:  (call_ref $A
  ;; OPEN_WORLD-NEXT:   (local.get $A)
  ;; OPEN_WORLD-NEXT:  )
  ;; OPEN_WORLD-NEXT:  (drop
  ;; OPEN_WORLD-NEXT:   (ref.func $target-A-2)
  ;; OPEN_WORLD-NEXT:  )
  ;; OPEN_WORLD-NEXT:  (call_ref $A
  ;; OPEN_WORLD-NEXT:   (local.get $A)
  ;; OPEN_WORLD-NEXT:  )
  ;; OPEN_WORLD-NEXT: )
  (func $foo (export "foo")
    (local $A (ref null $A))
    (drop
      (ref.func $target-A-1)
    )
    (call_ref $A
      (local.get $A)
    )
    (drop
      (ref.func $target-A-2)
    )
    (call_ref $A
      (local.get $A)
    )
  )

  ;; CHECK:      (func $target-A-1 (type $A)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  ;; OPEN_WORLD:      (func $target-A-1 (type $A)
  ;; OPEN_WORLD-NEXT:  (nop)
  ;; OPEN_WORLD-NEXT: )
  (func $target-A-1 (type $A)
    ;; This function is reachable.
  )

  ;; CHECK:      (func $target-A-2 (type $A)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  ;; OPEN_WORLD:      (func $target-A-2 (type $A)
  ;; OPEN_WORLD-NEXT:  (nop)
  ;; OPEN_WORLD-NEXT: )
  (func $target-A-2 (type $A)
    ;; This function is reachable.
  )

  (func $target-A-3 (type $A)
    ;; This function is not reachable.
  )
)

;; The call.without.effects intrinsic does a call to the reference given to it,
;; but for now other imports do not (until we add a flag for closed-world).
(module
  ;; CHECK:      (type $A (func))
  ;; OPEN_WORLD:      (type $A (func))
  (type $A (func))

  ;; CHECK:      (type $funcref_=>_none (func (param funcref)))

  ;; CHECK:      (import "binaryen-intrinsics" "call.without.effects" (func $call-without-effects (param funcref)))
  ;; OPEN_WORLD:      (type $funcref_=>_none (func (param funcref)))

  ;; OPEN_WORLD:      (import "binaryen-intrinsics" "call.without.effects" (func $call-without-effects (param funcref)))
  (import "binaryen-intrinsics" "call.without.effects"
    (func $call-without-effects (param funcref)))

  ;; CHECK:      (import "other" "import" (func $other-import (param funcref)))
  ;; OPEN_WORLD:      (import "other" "import" (func $other-import (param funcref)))
  (import "other" "import"
    (func $other-import (param funcref)))

  ;; CHECK:      (elem declare func $target-drop $target-keep)

  ;; CHECK:      (export "foo" (func $foo))

  ;; CHECK:      (func $foo (type $A)
  ;; CHECK-NEXT:  (call $call-without-effects
  ;; CHECK-NEXT:   (ref.func $target-keep)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (call $other-import
  ;; CHECK-NEXT:   (ref.func $target-drop)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  ;; OPEN_WORLD:      (elem declare func $target-drop $target-keep)

  ;; OPEN_WORLD:      (export "foo" (func $foo))

  ;; OPEN_WORLD:      (func $foo (type $A)
  ;; OPEN_WORLD-NEXT:  (call $call-without-effects
  ;; OPEN_WORLD-NEXT:   (ref.func $target-keep)
  ;; OPEN_WORLD-NEXT:  )
  ;; OPEN_WORLD-NEXT:  (call $other-import
  ;; OPEN_WORLD-NEXT:   (ref.func $target-drop)
  ;; OPEN_WORLD-NEXT:  )
  ;; OPEN_WORLD-NEXT: )
  (func $foo (export "foo")
    ;; Calling the intrinsic with a reference is considered a call of the
    ;; reference, so we will not remove $target-keep.
    (call $call-without-effects
      (ref.func $target-keep)
    )
    ;; The other import is not enough to keep $target-drop alive.
    (call $other-import
      (ref.func $target-drop)
    )
  )

  ;; CHECK:      (func $target-keep (type $A)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  ;; OPEN_WORLD:      (func $target-keep (type $A)
  ;; OPEN_WORLD-NEXT:  (nop)
  ;; OPEN_WORLD-NEXT: )
  (func $target-keep (type $A)
  )

  ;; CHECK:      (func $target-drop (type $A)
  ;; CHECK-NEXT:  (unreachable)
  ;; CHECK-NEXT: )
  ;; OPEN_WORLD:      (func $target-drop (type $A)
  ;; OPEN_WORLD-NEXT:  (nop)
  ;; OPEN_WORLD-NEXT: )
  (func $target-drop (type $A)
    ;; In a closed world we can turn this body into unreachable.
  )
)

;; As above, but now the call to the intrinsic does not let us see the exact
;; function being called.
(module
  ;; CHECK:      (type $A (func))
  ;; OPEN_WORLD:      (type $A (func))
  (type $A (func))

  ;; CHECK:      (type $funcref_=>_none (func (param funcref)))

  ;; CHECK:      (import "binaryen-intrinsics" "call.without.effects" (func $call-without-effects (param funcref)))
  ;; OPEN_WORLD:      (type $funcref_=>_none (func (param funcref)))

  ;; OPEN_WORLD:      (import "binaryen-intrinsics" "call.without.effects" (func $call-without-effects (param funcref)))
  (import "binaryen-intrinsics" "call.without.effects"
    (func $call-without-effects (param funcref)))

  ;; CHECK:      (import "other" "import" (func $other-import (param funcref)))
  ;; OPEN_WORLD:      (import "other" "import" (func $other-import (param funcref)))
  (import "other" "import"
    (func $other-import (param funcref)))

  ;; CHECK:      (elem declare func $target-keep $target-keep-2)

  ;; CHECK:      (export "foo" (func $foo))

  ;; CHECK:      (func $foo (type $A)
  ;; CHECK-NEXT:  (local $A (ref null $A))
  ;; CHECK-NEXT:  (call $call-without-effects
  ;; CHECK-NEXT:   (local.get $A)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (ref.func $target-keep)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (call $other-import
  ;; CHECK-NEXT:   (ref.func $target-keep-2)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  ;; OPEN_WORLD:      (elem declare func $target-keep $target-keep-2)

  ;; OPEN_WORLD:      (export "foo" (func $foo))

  ;; OPEN_WORLD:      (func $foo (type $A)
  ;; OPEN_WORLD-NEXT:  (local $A (ref null $A))
  ;; OPEN_WORLD-NEXT:  (call $call-without-effects
  ;; OPEN_WORLD-NEXT:   (local.get $A)
  ;; OPEN_WORLD-NEXT:  )
  ;; OPEN_WORLD-NEXT:  (drop
  ;; OPEN_WORLD-NEXT:   (ref.func $target-keep)
  ;; OPEN_WORLD-NEXT:  )
  ;; OPEN_WORLD-NEXT:  (call $other-import
  ;; OPEN_WORLD-NEXT:   (ref.func $target-keep-2)
  ;; OPEN_WORLD-NEXT:  )
  ;; OPEN_WORLD-NEXT: )
  (func $foo (export "foo")
    (local $A (ref null $A))
    ;; Call the intrinsic without a RefFunc. All we infer here is the type,
    ;; which means we must assume anything with type $A (and a reference) can be
    ;; called, which will keep alive both $target-keep and $target-keep-2
    (call $call-without-effects
      (local.get $A)
    )
    (drop
      (ref.func $target-keep)
    )
    (call $other-import
      (ref.func $target-keep-2)
    )
  )

  ;; CHECK:      (func $target-keep (type $A)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  ;; OPEN_WORLD:      (func $target-keep (type $A)
  ;; OPEN_WORLD-NEXT:  (nop)
  ;; OPEN_WORLD-NEXT: )
  (func $target-keep (type $A)
  )

  ;; CHECK:      (func $target-keep-2 (type $A)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  ;; OPEN_WORLD:      (func $target-keep-2 (type $A)
  ;; OPEN_WORLD-NEXT:  (nop)
  ;; OPEN_WORLD-NEXT: )
  (func $target-keep-2 (type $A)
  )
)

;; Test reachability of struct fields in globals. Only fields that have actual
;; reads need to be processed.
(module
  ;; CHECK:      (type $void (func))
  ;; OPEN_WORLD:      (type $void (func))
  (type $void (func))

  ;; CHECK:      (type $vtable (struct (field (ref $void)) (field (ref $void))))
  ;; OPEN_WORLD:      (type $vtable (struct (field (ref $void)) (field (ref $void))))
  (type $vtable (struct_subtype (field (ref $void)) (field (ref $void)) data))

  ;; CHECK:      (global $vtable (ref $vtable) (struct.new $vtable
  ;; CHECK-NEXT:  (ref.func $a)
  ;; CHECK-NEXT:  (ref.func $b)
  ;; CHECK-NEXT: ))
  ;; OPEN_WORLD:      (global $vtable (ref $vtable) (struct.new $vtable
  ;; OPEN_WORLD-NEXT:  (ref.func $a)
  ;; OPEN_WORLD-NEXT:  (ref.func $b)
  ;; OPEN_WORLD-NEXT: ))
  (global $vtable (ref $vtable) (struct.new $vtable
    (ref.func $a)
    (ref.func $b)
  ))

  (global $vtable-2 (ref $vtable) (struct.new $vtable
    (ref.func $c)
    (ref.func $d)
  ))

  ;; CHECK:      (export "export" (func $export))

  ;; CHECK:      (func $export (type $void)
  ;; CHECK-NEXT:  (call $b)
  ;; CHECK-NEXT: )
  ;; OPEN_WORLD:      (export "export" (func $export))

  ;; OPEN_WORLD:      (func $export (type $void)
  ;; OPEN_WORLD-NEXT:  (call $b)
  ;; OPEN_WORLD-NEXT: )
  (func $export (export "export")
    ;; Call $b but not $a or $c
    (call $b)
  )

  ;; CHECK:      (func $a (type $void)
  ;; CHECK-NEXT:  (unreachable)
  ;; CHECK-NEXT: )
  ;; OPEN_WORLD:      (func $a (type $void)
  ;; OPEN_WORLD-NEXT:  (call_ref $void
  ;; OPEN_WORLD-NEXT:   (struct.get $vtable 0
  ;; OPEN_WORLD-NEXT:    (global.get $vtable)
  ;; OPEN_WORLD-NEXT:   )
  ;; OPEN_WORLD-NEXT:  )
  ;; OPEN_WORLD-NEXT: )
  (func $a (type $void)
    ;; $a calls field #0 in the vtable.
    ;;
    ;; Even though $a is in the vtable, it is dead, since the vtable is alive
    ;; but there is no live read of field #0 - the only read is in here, which
    ;; is basically an unreachable cycle that we can collect. We can empty out
    ;; this function since it is dead, but we cannot remove it entirely due to
    ;; the ref in the vtable.
    ;;
    ;; (In open world, however, we cannot do this, as we must assume reads of
    ;; struct fields can occur outside of our view. That is, the vtable could be
    ;; sent somewhere that reads field #0, which would make $a live.)
    (call_ref $void
      (struct.get $vtable 0
        (global.get $vtable)
      )
    )
  )

  ;; CHECK:      (func $b (type $void)
  ;; CHECK-NEXT:  (call_ref $void
  ;; CHECK-NEXT:   (struct.get $vtable 1
  ;; CHECK-NEXT:    (global.get $vtable)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  ;; OPEN_WORLD:      (func $b (type $void)
  ;; OPEN_WORLD-NEXT:  (call_ref $void
  ;; OPEN_WORLD-NEXT:   (struct.get $vtable 1
  ;; OPEN_WORLD-NEXT:    (global.get $vtable)
  ;; OPEN_WORLD-NEXT:   )
  ;; OPEN_WORLD-NEXT:  )
  ;; OPEN_WORLD-NEXT: )
  (func $b (type $void)
    ;; $b calls field #1 in the vtable.
    ;;
    ;; As $b is called from the export, this function is not dead.
    (call_ref $void
      (struct.get $vtable 1
        (global.get $vtable)
      )
    )
  )

  (func $c (type $void)
    ;; $c is parallel to $a, but using vtable-2, which has no other references,
    ;; so this is dead like $a, and can be removed entirely.
    (call_ref $void
      (struct.get $vtable 0
        (global.get $vtable-2)
      )
    )
  )

  (func $d (type $void)
    ;; $d is parallel to $b, but using vtable-2, which has no other references.
    ;; This is dead, even though the struct type + index have a use (due to the
    ;; other vtable) - there is no use of vtable-2 (except from unreachable
    ;; places like here), so this cannot be reached.
    (call_ref $void
      (struct.get $vtable 0
        (global.get $vtable-2)
      )
    )
  )
)

;; Test struct.news not in globals.
(module
  ;; CHECK:      (type $void (func))
  ;; OPEN_WORLD:      (type $void (func))
  (type $void (func))

  ;; CHECK:      (type $vtable (struct (field (ref $void)) (field (ref $void))))
  ;; OPEN_WORLD:      (type $vtable (struct (field (ref $void)) (field (ref $void))))
  (type $vtable (struct_subtype (field (ref $void)) (field (ref $void)) data))

  ;; CHECK:      (type $struct (struct (field (ref $vtable)) (field (ref $vtable)) (field (ref $vtable)) (field (ref $vtable))))
  ;; OPEN_WORLD:      (type $struct (struct (field (ref $vtable)) (field (ref $vtable)) (field (ref $vtable)) (field (ref $vtable))))
  (type $struct (struct_subtype (field (ref $vtable)) (field (ref $vtable)) (field (ref $vtable)) (field (ref $vtable)) data))

  ;; CHECK:      (global $vtable (ref $vtable) (struct.new $vtable
  ;; CHECK-NEXT:  (ref.func $a)
  ;; CHECK-NEXT:  (ref.func $b)
  ;; CHECK-NEXT: ))
  ;; OPEN_WORLD:      (global $vtable (ref $vtable) (struct.new $vtable
  ;; OPEN_WORLD-NEXT:  (ref.func $a)
  ;; OPEN_WORLD-NEXT:  (ref.func $b)
  ;; OPEN_WORLD-NEXT: ))
  (global $vtable (ref $vtable) (struct.new $vtable
    (ref.func $a)
    (ref.func $b)
  ))

  ;; CHECK:      (elem declare func $c $d $e $f $g $h $void)

  ;; CHECK:      (export "func" (func $func))

  ;; CHECK:      (func $func (type $void)
  ;; CHECK-NEXT:  (local $ref (ref $struct))
  ;; CHECK-NEXT:  (local $vtable (ref $vtable))
  ;; CHECK-NEXT:  (local.set $ref
  ;; CHECK-NEXT:   (struct.new $struct
  ;; CHECK-NEXT:    (global.get $vtable)
  ;; CHECK-NEXT:    (struct.new $vtable
  ;; CHECK-NEXT:     (ref.func $c)
  ;; CHECK-NEXT:     (ref.func $d)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (local.tee $vtable
  ;; CHECK-NEXT:     (struct.new $vtable
  ;; CHECK-NEXT:      (ref.func $e)
  ;; CHECK-NEXT:      (ref.func $f)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (struct.new $vtable
  ;; CHECK-NEXT:     (ref.func $g)
  ;; CHECK-NEXT:     (ref.func $h)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.get $struct 0
  ;; CHECK-NEXT:    (local.get $ref)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.get $struct 1
  ;; CHECK-NEXT:    (local.get $ref)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.get $struct 2
  ;; CHECK-NEXT:    (local.get $ref)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.get $vtable 1
  ;; CHECK-NEXT:    (local.get $vtable)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (call_ref $void
  ;; CHECK-NEXT:   (ref.func $void)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  ;; OPEN_WORLD:      (elem declare func $c $d $e $f $g $h $void)

  ;; OPEN_WORLD:      (export "func" (func $func))

  ;; OPEN_WORLD:      (func $func (type $void)
  ;; OPEN_WORLD-NEXT:  (local $ref (ref $struct))
  ;; OPEN_WORLD-NEXT:  (local $vtable (ref $vtable))
  ;; OPEN_WORLD-NEXT:  (local.set $ref
  ;; OPEN_WORLD-NEXT:   (struct.new $struct
  ;; OPEN_WORLD-NEXT:    (global.get $vtable)
  ;; OPEN_WORLD-NEXT:    (struct.new $vtable
  ;; OPEN_WORLD-NEXT:     (ref.func $c)
  ;; OPEN_WORLD-NEXT:     (ref.func $d)
  ;; OPEN_WORLD-NEXT:    )
  ;; OPEN_WORLD-NEXT:    (local.tee $vtable
  ;; OPEN_WORLD-NEXT:     (struct.new $vtable
  ;; OPEN_WORLD-NEXT:      (ref.func $e)
  ;; OPEN_WORLD-NEXT:      (ref.func $f)
  ;; OPEN_WORLD-NEXT:     )
  ;; OPEN_WORLD-NEXT:    )
  ;; OPEN_WORLD-NEXT:    (struct.new $vtable
  ;; OPEN_WORLD-NEXT:     (ref.func $g)
  ;; OPEN_WORLD-NEXT:     (ref.func $h)
  ;; OPEN_WORLD-NEXT:    )
  ;; OPEN_WORLD-NEXT:   )
  ;; OPEN_WORLD-NEXT:  )
  ;; OPEN_WORLD-NEXT:  (drop
  ;; OPEN_WORLD-NEXT:   (struct.get $struct 0
  ;; OPEN_WORLD-NEXT:    (local.get $ref)
  ;; OPEN_WORLD-NEXT:   )
  ;; OPEN_WORLD-NEXT:  )
  ;; OPEN_WORLD-NEXT:  (drop
  ;; OPEN_WORLD-NEXT:   (struct.get $struct 1
  ;; OPEN_WORLD-NEXT:    (local.get $ref)
  ;; OPEN_WORLD-NEXT:   )
  ;; OPEN_WORLD-NEXT:  )
  ;; OPEN_WORLD-NEXT:  (drop
  ;; OPEN_WORLD-NEXT:   (struct.get $struct 2
  ;; OPEN_WORLD-NEXT:    (local.get $ref)
  ;; OPEN_WORLD-NEXT:   )
  ;; OPEN_WORLD-NEXT:  )
  ;; OPEN_WORLD-NEXT:  (drop
  ;; OPEN_WORLD-NEXT:   (struct.get $vtable 1
  ;; OPEN_WORLD-NEXT:    (local.get $vtable)
  ;; OPEN_WORLD-NEXT:   )
  ;; OPEN_WORLD-NEXT:  )
  ;; OPEN_WORLD-NEXT:  (call_ref $void
  ;; OPEN_WORLD-NEXT:   (ref.func $void)
  ;; OPEN_WORLD-NEXT:  )
  ;; OPEN_WORLD-NEXT: )
  (func $func (export "func")
    (local $ref (ref $struct))
    (local $vtable (ref $vtable))

    (local.set $ref
      (struct.new $struct
        ;; Init one field using the global vtable.
        (global.get $vtable)
        ;; Init another field using a vtable we create here - a nested
        ;; struct.new inside this one.
        (struct.new $vtable
          (ref.func $c)
          (ref.func $d)
        )
        ;; Another nested one, but now there is a side effect. Everything here
        ;; is considered to escape due to that.
        (local.tee $vtable
          (struct.new $vtable
            (ref.func $e)
            (ref.func $f)
          )
        )
        ;; Another nested one. This field will not be read.
        (struct.new $vtable
          (ref.func $g)
          (ref.func $h)
        )
      )
    )

    ;; Read from all fields of $struct except for the last.
    (drop
      (struct.get $struct 0
        (local.get $ref)
      )
    )
    (drop
      (struct.get $struct 1
        (local.get $ref)
      )
    )
    (drop
      (struct.get $struct 2
        (local.get $ref)
      )
    )

    ;; Read from field #1 of the vtable type, but not #0.
    (drop
      (struct.get $vtable 1
        (local.get $vtable)
      )
    )

    ;; Call something of type void so we don't eliminate them all instantly.
    (call_ref $void
      (ref.func $void)
    )
  )

  ;; CHECK:      (func $void (type $void)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  ;; OPEN_WORLD:      (func $void (type $void)
  ;; OPEN_WORLD-NEXT:  (nop)
  ;; OPEN_WORLD-NEXT: )
  (func $void (type $void)
    ;; Helper function. This is reached via a call_ref.
  )

  ;; CHECK:      (func $a (type $void)
  ;; CHECK-NEXT:  (unreachable)
  ;; CHECK-NEXT: )
  ;; OPEN_WORLD:      (func $a (type $void)
  ;; OPEN_WORLD-NEXT:  (nop)
  ;; OPEN_WORLD-NEXT: )
  (func $a (type $void)
    ;; This is unreachable (in closed world) since a reference to it only exists
    ;; in field #0 of the vtable type, which is never read from.
  )

  ;; CHECK:      (func $b (type $void)
  ;; CHECK-NEXT:  (unreachable)
  ;; CHECK-NEXT: )
  ;; OPEN_WORLD:      (func $b (type $void)
  ;; OPEN_WORLD-NEXT:  (nop)
  ;; OPEN_WORLD-NEXT: )
  (func $b (type $void)
    ;; This is reachable. It is in field #1, which is read, and the global
    ;; vtable is also read, and the type $void is call_reffed.
  )

  ;; CHECK:      (func $c (type $void)
  ;; CHECK-NEXT:  (unreachable)
  ;; CHECK-NEXT: )
  ;; OPEN_WORLD:      (func $c (type $void)
  ;; OPEN_WORLD-NEXT:  (nop)
  ;; OPEN_WORLD-NEXT: )
  (func $c (type $void)
    ;; Like $a, this is unreachable. That it is in a nested struct.new, and not
    ;; in a global, does not matter.
  )

  ;; CHECK:      (func $d (type $void)
  ;; CHECK-NEXT:  (unreachable)
  ;; CHECK-NEXT: )
  ;; OPEN_WORLD:      (func $d (type $void)
  ;; OPEN_WORLD-NEXT:  (nop)
  ;; OPEN_WORLD-NEXT: )
  (func $d (type $void)
    ;; Like $b, this is reachable. That it is in a nested struct.new, and not
    ;; in a global, does not matter.
  )

  ;; CHECK:      (func $e (type $void)
  ;; CHECK-NEXT:  (unreachable)
  ;; CHECK-NEXT: )
  ;; OPEN_WORLD:      (func $e (type $void)
  ;; OPEN_WORLD-NEXT:  (nop)
  ;; OPEN_WORLD-NEXT: )
  (func $e (type $void)
    ;; Side effects on the struct field this appears in cause this to be
    ;; reachable (even though field #0 is never read).
  )

  ;; CHECK:      (func $f (type $void)
  ;; CHECK-NEXT:  (unreachable)
  ;; CHECK-NEXT: )
  ;; OPEN_WORLD:      (func $f (type $void)
  ;; OPEN_WORLD-NEXT:  (nop)
  ;; OPEN_WORLD-NEXT: )
  (func $f (type $void)
    ;; Side effects on the struct field this appears in cause this to be
    ;; reachable.
  )

  ;; CHECK:      (func $g (type $void)
  ;; CHECK-NEXT:  (unreachable)
  ;; CHECK-NEXT: )
  ;; OPEN_WORLD:      (func $g (type $void)
  ;; OPEN_WORLD-NEXT:  (nop)
  ;; OPEN_WORLD-NEXT: )
  (func $g (type $void)
    ;; This is in a struct written to a field that is never read in $struct, so
    ;; it is unreachable.
  )

  ;; CHECK:      (func $h (type $void)
  ;; CHECK-NEXT:  (unreachable)
  ;; CHECK-NEXT: )
  ;; OPEN_WORLD:      (func $h (type $void)
  ;; OPEN_WORLD-NEXT:  (nop)
  ;; OPEN_WORLD-NEXT: )
  (func $h (type $void)
    ;; This is in a struct written to a field that is never read in $struct, so
    ;; it is unreachable.
  )
)

;; TODO: test removing the vtable, and handling its refs.
;; TODO: cycle of those
;; TODO; remove call to $void and they all fall
