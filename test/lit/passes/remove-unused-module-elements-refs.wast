;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.

;; RUN: foreach %s %t wasm-opt --remove-unused-module-elements --nominal -all -S -o - | filecheck %s

(module
  ;; CHECK:      (type $A (func))
  (type $A (func))

  ;; CHECK:      (type $ref?|$A|_=>_none (func (param (ref null $A))))

  ;; CHECK:      (type $B (func))
  (type $B (func))

  ;; CHECK:      (elem declare func $target-A $target-B)

  ;; CHECK:      (export "foo" (func $foo))

  ;; CHECK:      (func $foo (type $ref?|$A|_=>_none) (param $A (ref null $A))
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
  (func $foo (export "foo") (param $A (ref null $A))
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
  (func $target-A (type $A)
    ;; This function is reachable from the export "foo": there is a RefFunc and
    ;; a CallRef for it there.
  )

  (func $target-A-noref (type $A)
    ;; This function is not reachable. We have a CallRef of the right type, but
    ;; no RefFunc.
  )

  ;; CHECK:      (func $target-B (type $B)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
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
  (type $A (func))
  (type $B (func))

  ;; CHECK:      (type $ref?|$A|_=>_none (func (param (ref null $A))))

  ;; CHECK:      (elem declare func $target-A)

  ;; CHECK:      (export "foo" (func $foo))

  ;; CHECK:      (func $foo (type $ref?|$A|_=>_none) (param $A (ref null $A))
  ;; CHECK-NEXT:  (call_ref $A
  ;; CHECK-NEXT:   (local.get $A)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (ref.func $target-A)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $foo (export "foo") (param $A (ref null $A))
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
  (type $A (func))
  (type $B (func))

  ;; CHECK:      (type $ref?|$A|_=>_none (func (param (ref null $A))))

  ;; CHECK:      (elem declare func $target-A-1 $target-A-2)

  ;; CHECK:      (export "foo" (func $foo))

  ;; CHECK:      (func $foo (type $ref?|$A|_=>_none) (param $A (ref null $A))
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
  (func $foo (export "foo") (param $A (ref null $A))
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
  ;; CHECK:      (type $A (func))
  (type $A (func))
  (type $B (func))

  ;; CHECK:      (type $ref?|$A|_=>_none (func (param (ref null $A))))

  ;; CHECK:      (elem declare func $target-A-1 $target-A-2)

  ;; CHECK:      (export "foo" (func $foo))

  ;; CHECK:      (func $foo (type $ref?|$A|_=>_none) (param $A (ref null $A))
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
  (func $foo (export "foo") (param $A (ref null $A))
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

;; The call.without.effects intrinsic does a call to the reference given to it,
;; but for now other imports do not (until we add a flag for closed-world).
(module
  ;; CHECK:      (type $A (func))
  (type $A (func))

  ;; CHECK:      (type $funcref_=>_none (func (param funcref)))

  ;; CHECK:      (import "binaryen-intrinsics" "call.without.effects" (func $call-without-effects (param funcref)))
  (import "binaryen-intrinsics" "call.without.effects"
    (func $call-without-effects (param funcref)))

  ;; CHECK:      (import "other" "import" (func $other-import (param funcref)))
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
  (func $target-keep (type $A)
  )

  ;; CHECK:      (func $target-drop (type $A)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  (func $target-drop (type $A)
    ;; In a closed world we can turn this body into unreachable.
  )
)

;; As above, but now the call to the intrinsic does not let us see the exact
;; function being called.
(module
  ;; CHECK:      (type $A (func))
  (type $A (func))

  ;; CHECK:      (type $funcref_=>_none (func (param funcref)))

  ;; CHECK:      (type $ref?|$A|_=>_none (func (param (ref null $A))))

  ;; CHECK:      (import "binaryen-intrinsics" "call.without.effects" (func $call-without-effects (param funcref)))
  (import "binaryen-intrinsics" "call.without.effects"
    (func $call-without-effects (param funcref)))

  ;; CHECK:      (import "other" "import" (func $other-import (param funcref)))
  (import "other" "import"
    (func $other-import (param funcref)))

  ;; CHECK:      (elem declare func $target-keep $target-keep-2)

  ;; CHECK:      (export "foo" (func $foo))

  ;; CHECK:      (func $foo (type $ref?|$A|_=>_none) (param $A (ref null $A))
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
  (func $foo (export "foo") (param $A (ref null $A))
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
  (func $target-keep (type $A)
  )

  ;; CHECK:      (func $target-keep-2 (type $A)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  (func $target-keep-2 (type $A)
  )
)
