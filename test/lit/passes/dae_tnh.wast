;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.

;; RUN: foreach %s %t wasm-opt --dae --all-features -tnh -S -o - | filecheck %s

(module
  ;; CHECK:      (type $0 (func))

  ;; CHECK:      (type $struct (sub (struct (field i32))))
  (type $struct (sub (struct (field i32))))

  ;; CHECK:      (type $2 (func (param (ref null $struct))))

  ;; CHECK:      (func $target (type $0)
  ;; CHECK-NEXT:  (local $0 i32)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  (func $target (param $x i32)
    (nop)
  )

  ;; CHECK:      (func $caller (type $2) (param $ref (ref null $struct))
  ;; CHECK-NEXT:  (call $target)
  ;; CHECK-NEXT: )
  (func $caller (param $ref (ref null $struct))
    (call $target
      ;; This might trap in theory, but in traps-never-happen mode which is
      ;; enabled here, we can ignore and remove such side effects, allowing us
      ;; to optimize away this parameter which is never used.
      (struct.get $struct 0
        (local.get $ref)
      )
    )
  )
)

(module
  ;; CHECK:      (type $0 (func))

  ;; CHECK:      (func $caller (type $0)
  ;; CHECK-NEXT:  (call $target)
  ;; CHECK-NEXT: )
  (func $caller
    ;; Removing this parameter makes the type of the call change from
    ;; unreachable to none. This is only possible because we assume traps never
    ;; happen, so that unreachable never executes anyhow.
    (call $target
      (unreachable)
    )
  )

  ;; CHECK:      (func $target (type $0)
  ;; CHECK-NEXT:  (local $0 i32)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  (func $target (param i32)
  )
)

;; As above but the called target has a result.
(module
  ;; CHECK:      (type $0 (func (result i32)))

  ;; CHECK:      (func $caller (type $0) (result i32)
  ;; CHECK-NEXT:  (call $target)
  ;; CHECK-NEXT: )
  (func $caller (result i32)
    ;; This call will change type from unreachable to i32, after the unreachable
    ;; child is removed.
    (call $target
      (unreachable)
    )
  )

  ;; CHECK:      (func $target (type $0) (result i32)
  ;; CHECK-NEXT:  (local $0 i32)
  ;; CHECK-NEXT:  (i32.const 42)
  ;; CHECK-NEXT: )
  (func $target (param i32) (result i32)
    (i32.const 42)
  )
)

;; As above, but use a return_call. We can optimize that too (return_calls have
;; type unreachable anyhow, and the optimization would not change the type, so
;; it is even simpler).
(module
  ;; CHECK:      (type $0 (func))

  ;; CHECK:      (func $caller (type $0)
  ;; CHECK-NEXT:  (return_call $target)
  ;; CHECK-NEXT: )
  (func $caller
    (return_call $target
      (unreachable)
    )
  )

  ;; CHECK:      (func $target (type $0)
  ;; CHECK-NEXT:  (local $0 i32)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  (func $target (param i32)
  )
)

(module
  ;; CHECK:      (type $0 (func (param i32)))

  ;; CHECK:      (type $1 (func))

  ;; CHECK:      (func $target (type $0) (param $0 i32)
  ;; CHECK-NEXT:  (local $1 f64)
  ;; CHECK-NEXT:  (local.set $1
  ;; CHECK-NEXT:   (f64.const 4.2)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (local.get $0)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $target (param $used i32) (param $unused f64)
    ;; One parameter is used, and one is not.
    (drop
      (local.get $used)
    )
  )

  ;; CHECK:      (func $caller (type $1)
  ;; CHECK-NEXT:  (call $target
  ;; CHECK-NEXT:   (unreachable)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $caller
    ;; There is an unreachable parameter, and as in the cases above, we can't
    ;; remove it as it would change the type. But it isn't the param we want to
    ;; remove here, so we can optimize: we'll remove the other param, and leave
    ;; the unreachable, and the type does not change.
    (call $target
      (unreachable)
      (f64.const 4.2)
    )
  )
)
