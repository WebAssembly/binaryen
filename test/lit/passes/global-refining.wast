;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.

;; RUN: foreach %s %t wasm-opt --global-refining                -all -S -o - | filecheck %s
;; RUN: foreach %s %t wasm-opt --global-refining --closed-world -all -S -o - | filecheck %s --check-prefix=CLOSD

(module
  ;; Globals with no assignments aside from their initial values. The first is a
  ;; null, so we can optimize to a nullfuncref. The second is a ref.func which
  ;; lets us refine to the specific function type.
  ;; CHECK:      (type $foo_t (func))
  ;; CLOSD:      (type $foo_t (func))
  (type $foo_t (func))

  ;; CHECK:      (global $func-null-init (mut nullfuncref) (ref.null nofunc))
  ;; CLOSD:      (global $func-null-init (mut nullfuncref) (ref.null nofunc))
  (global $func-null-init (mut funcref) (ref.null $foo_t))
  ;; CHECK:      (global $func-func-init (mut (ref $foo_t)) (ref.func $foo))
  ;; CLOSD:      (global $func-func-init (mut (ref $foo_t)) (ref.func $foo))
  (global $func-func-init (mut funcref) (ref.func $foo))
  ;; CHECK:      (func $foo (type $foo_t)
  ;; CHECK-NEXT: )
  ;; CLOSD:      (func $foo (type $foo_t)
  ;; CLOSD-NEXT: )
  (func $foo (type $foo_t))
)

(module
  ;; Globals with later assignments of null. The global with a function in its
  ;; init will update the null to allow it to refine.

  ;; CHECK:      (type $foo_t (func))
  ;; CLOSD:      (type $foo_t (func))
  (type $foo_t (func))

  ;; CHECK:      (global $func-null-init (mut nullfuncref) (ref.null nofunc))
  ;; CLOSD:      (global $func-null-init (mut nullfuncref) (ref.null nofunc))
  (global $func-null-init (mut funcref) (ref.null $foo_t))
  ;; CHECK:      (global $func-func-init (mut (ref null $foo_t)) (ref.func $foo))
  ;; CLOSD:      (global $func-func-init (mut (ref null $foo_t)) (ref.func $foo))
  (global $func-func-init (mut funcref) (ref.func $foo))

  ;; CHECK:      (func $foo (type $foo_t)
  ;; CHECK-NEXT:  (global.set $func-null-init
  ;; CHECK-NEXT:   (ref.null nofunc)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (global.set $func-func-init
  ;; CHECK-NEXT:   (ref.null nofunc)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  ;; CLOSD:      (func $foo (type $foo_t)
  ;; CLOSD-NEXT:  (global.set $func-null-init
  ;; CLOSD-NEXT:   (ref.null nofunc)
  ;; CLOSD-NEXT:  )
  ;; CLOSD-NEXT:  (global.set $func-func-init
  ;; CLOSD-NEXT:   (ref.null nofunc)
  ;; CLOSD-NEXT:  )
  ;; CLOSD-NEXT: )
  (func $foo (type $foo_t)
   (global.set $func-null-init (ref.null func))
   (global.set $func-func-init (ref.null $foo_t))
  )
)

(module
  ;; Globals with later assignments of something non-null. Both can be refined,
  ;; and the one with a non-null initial value can even become non-nullable.

  ;; CHECK:      (type $0 (func))

  ;; CHECK:      (global $func-null-init (mut (ref null $0)) (ref.null nofunc))
  ;; CLOSD:      (type $0 (func))

  ;; CLOSD:      (global $func-null-init (mut (ref null $0)) (ref.null nofunc))
  (global $func-null-init (mut funcref) (ref.null func))
  ;; CHECK:      (global $func-func-init (mut (ref $0)) (ref.func $foo))
  ;; CLOSD:      (global $func-func-init (mut (ref $0)) (ref.func $foo))
  (global $func-func-init (mut funcref) (ref.func $foo))

  ;; CHECK:      (elem declare func $foo)

  ;; CHECK:      (func $foo (type $0)
  ;; CHECK-NEXT:  (global.set $func-null-init
  ;; CHECK-NEXT:   (ref.func $foo)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (global.set $func-func-init
  ;; CHECK-NEXT:   (ref.func $foo)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  ;; CLOSD:      (elem declare func $foo)

  ;; CLOSD:      (func $foo (type $0)
  ;; CLOSD-NEXT:  (global.set $func-null-init
  ;; CLOSD-NEXT:   (ref.func $foo)
  ;; CLOSD-NEXT:  )
  ;; CLOSD-NEXT:  (global.set $func-func-init
  ;; CLOSD-NEXT:   (ref.func $foo)
  ;; CLOSD-NEXT:  )
  ;; CLOSD-NEXT: )
  (func $foo
   (global.set $func-null-init (ref.func $foo))
   (global.set $func-func-init (ref.func $foo))
  )
)

(module
  ;; A global with multiple later assignments. The refined type is more
  ;; specific than the original, but less than each of the non-null values.

  ;; CHECK:      (type $0 (func))

  ;; CHECK:      (type $struct (struct))
  ;; CLOSD:      (type $0 (func))

  ;; CLOSD:      (type $struct (struct))
  (type $struct (struct))
  (type $array (array i8))

  ;; CHECK:      (global $global (mut eqref) (ref.null none))
  ;; CLOSD:      (global $global (mut eqref) (ref.null none))
  (global $global (mut anyref) (ref.null any))

  ;; CHECK:      (func $foo (type $0)
  ;; CHECK-NEXT:  (global.set $global
  ;; CHECK-NEXT:   (ref.i31
  ;; CHECK-NEXT:    (i32.const 0)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (global.set $global
  ;; CHECK-NEXT:   (struct.new_default $struct)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (global.set $global
  ;; CHECK-NEXT:   (ref.null none)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (global.set $global
  ;; CHECK-NEXT:   (ref.null none)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (global.set $global
  ;; CHECK-NEXT:   (ref.null none)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  ;; CLOSD:      (func $foo (type $0)
  ;; CLOSD-NEXT:  (global.set $global
  ;; CLOSD-NEXT:   (ref.i31
  ;; CLOSD-NEXT:    (i32.const 0)
  ;; CLOSD-NEXT:   )
  ;; CLOSD-NEXT:  )
  ;; CLOSD-NEXT:  (global.set $global
  ;; CLOSD-NEXT:   (struct.new_default $struct)
  ;; CLOSD-NEXT:  )
  ;; CLOSD-NEXT:  (global.set $global
  ;; CLOSD-NEXT:   (ref.null none)
  ;; CLOSD-NEXT:  )
  ;; CLOSD-NEXT:  (global.set $global
  ;; CLOSD-NEXT:   (ref.null none)
  ;; CLOSD-NEXT:  )
  ;; CLOSD-NEXT:  (global.set $global
  ;; CLOSD-NEXT:   (ref.null none)
  ;; CLOSD-NEXT:  )
  ;; CLOSD-NEXT: )
  (func $foo
   (global.set $global (ref.i31 (i32.const 0)))
   (global.set $global (struct.new_default $struct))
   (global.set $global (ref.null eq))
   ;; These nulls will be updated.
   (global.set $global (ref.null i31))
   (global.set $global (ref.null $array))
  )
)

;; We can refine $a, after which we should update the global.get in the other
;; global, or else we'd error on validation.
;; TODO: we could optimize further here and refine the type of the global $b.
(module
  ;; CHECK:      (type $super (sub (func)))
  ;; CLOSD:      (type $super (sub (func)))
  (type $super (sub (func)))
  ;; CHECK:      (type $sub (sub $super (func)))
  ;; CLOSD:      (type $sub (sub $super (func)))
  (type $sub (sub $super (func)))

  ;; CHECK:      (global $a (ref $sub) (ref.func $func))
  ;; CLOSD:      (global $a (ref $sub) (ref.func $func))
  (global $a (ref $super) (ref.func $func))
  ;; CHECK:      (global $b (ref $super) (global.get $a))
  ;; CLOSD:      (global $b (ref $super) (global.get $a))
  (global $b (ref $super) (global.get $a))

  ;; CHECK:      (func $func (type $sub)
  ;; CHECK-NEXT: )
  ;; CLOSD:      (func $func (type $sub)
  ;; CLOSD-NEXT: )
  (func $func (type $sub)
  )
)

;; Test all combinations of being exported and being mutable.
;;
;; Mutability limits our ability to optimize in open world: mutable globals that
;; are exported cannot be refined, as they might be modified in another module
;; using the old type. In closed world, however, we can optimize both globals
;; here, as mutability is not a concern. As a result, we can refine the
;; (ref null func) to nullfuncref only when not exported, and if exported, then
;; only when immutable in open world.
(module
  ;; CHECK:      (global $mut (mut nullfuncref) (ref.null nofunc))
  ;; CLOSD:      (global $mut (mut nullfuncref) (ref.null nofunc))
  (global $mut (mut (ref null func)) (ref.null nofunc))
  ;; CHECK:      (global $imm nullfuncref (ref.null nofunc))
  ;; CLOSD:      (global $imm nullfuncref (ref.null nofunc))
  (global $imm (ref null func) (ref.null nofunc))
  ;; CHECK:      (global $mut-exp (mut funcref) (ref.null nofunc))
  ;; CLOSD:      (global $mut-exp (mut funcref) (ref.null nofunc))
  (global $mut-exp (mut (ref null func)) (ref.null nofunc))
  ;; CHECK:      (global $imm-exp nullfuncref (ref.null nofunc))
  ;; CLOSD:      (global $imm-exp funcref (ref.null nofunc))
  (global $imm-exp (ref null func) (ref.null nofunc))

  ;; CHECK:      (export "mut-exp" (global $mut-exp))
  ;; CLOSD:      (export "mut-exp" (global $mut-exp))
  (export "mut-exp" (global $mut-exp))
  ;; CHECK:      (export "imm-exp" (global $imm-exp))
  ;; CLOSD:      (export "imm-exp" (global $imm-exp))
  (export "imm-exp" (global $imm-exp))
)

