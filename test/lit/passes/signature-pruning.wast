;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.
;; RUN: foreach %s %t wasm-opt --signature-pruning --closed-world -all -S -o - | filecheck %s

(module
  ;; CHECK:      (rec
  ;; CHECK-NEXT:  (type $0 (func))

  ;; CHECK:       (type $sig (sub (func (param i32 f64))))
  (type $sig (sub (func (param i32) (param i64) (param f32) (param f64))))

  (memory 1 1)

  ;; CHECK:      (memory $0 1 1)

  ;; CHECK:      (elem declare func $foo)

  ;; CHECK:      (func $foo (type $sig) (param $0 i32) (param $1 f64)
  ;; CHECK-NEXT:  (local $2 f32)
  ;; CHECK-NEXT:  (local $3 i64)
  ;; CHECK-NEXT:  (i32.store
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:   (local.get $0)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (f64.store
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:   (local.get $1)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $foo (type $sig) (param $i32 i32) (param $i64 i64) (param $f32 f32) (param $f64 f64)
    ;; Use the first and last parameter. The middle parameters will be removed
    ;; both from the function and from $sig, and also in the calls below.
    (i32.store
      (i32.const 0)
      (local.get $i32)
    )
    (f64.store
      (i32.const 0)
      (local.get $f64)
    )
  )

  ;; CHECK:      (func $caller (type $0)
  ;; CHECK-NEXT:  (call $foo
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:   (f64.const 3)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (call_ref $sig
  ;; CHECK-NEXT:   (i32.const 4)
  ;; CHECK-NEXT:   (f64.const 7)
  ;; CHECK-NEXT:   (ref.func $foo)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $caller
    (call $foo
      (i32.const 0)
      (i64.const 1)
      (f32.const 2)
      (f64.const 3)
    )
    (call_ref $sig
      (i32.const 4)
      (i64.const 5)
      (f32.const 6)
      (f64.const 7)
      (ref.func $foo)
    )
  )
)

(module
  ;; CHECK:      (rec
  ;; CHECK-NEXT:  (type $0 (func))

  ;; CHECK:       (type $sig (sub (func (param i64 f32))))
  (type $sig (sub (func (param i32) (param i64) (param f32) (param f64))))

  (memory 1 1)

  ;; CHECK:      (memory $0 1 1)

  ;; CHECK:      (elem declare func $foo)

  ;; CHECK:      (func $foo (type $sig) (param $0 i64) (param $1 f32)
  ;; CHECK-NEXT:  (local $2 f64)
  ;; CHECK-NEXT:  (local $3 i32)
  ;; CHECK-NEXT:  (i64.store
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:   (local.get $0)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (f32.store
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:   (local.get $1)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $foo (type $sig) (param $i32 i32) (param $i64 i64) (param $f32 f32) (param $f64 f64)
    ;; Use the middle two parameters.
    (i64.store
      (i32.const 0)
      (local.get $i64)
    )
    (f32.store
      (i32.const 0)
      (local.get $f32)
    )
  )

  ;; CHECK:      (func $caller (type $0)
  ;; CHECK-NEXT:  (call $foo
  ;; CHECK-NEXT:   (i64.const 1)
  ;; CHECK-NEXT:   (f32.const 2)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (call_ref $sig
  ;; CHECK-NEXT:   (i64.const 5)
  ;; CHECK-NEXT:   (f32.const 6)
  ;; CHECK-NEXT:   (ref.func $foo)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $caller
    (call $foo
      (i32.const 0)
      (i64.const 1)
      (f32.const 2)
      (f64.const 3)
    )
    (call_ref $sig
      (i32.const 4)
      (i64.const 5)
      (f32.const 6)
      (f64.const 7)
      (ref.func $foo)
    )
  )
)

(module
  ;; CHECK:      (rec
  ;; CHECK-NEXT:  (type $0 (func))

  ;; CHECK:       (type $sig (sub (func (param i32 i64 f32))))
  (type $sig (sub (func (param i32) (param i64) (param f32) (param f64))))

  (memory 1 1)

  ;; CHECK:      (memory $0 1 1)

  ;; CHECK:      (elem declare func $foo)

  ;; CHECK:      (func $foo (type $sig) (param $0 i32) (param $1 i64) (param $2 f32)
  ;; CHECK-NEXT:  (local $3 f64)
  ;; CHECK-NEXT:  (i64.store
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:   (local.get $1)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (f32.store
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:   (local.get $2)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $foo (type $sig) (param $i32 i32) (param $i64 i64) (param $f32 f32) (param $f64 f64)
    ;; Use the middle two parameters.
    (i64.store
      (i32.const 0)
      (local.get $i64)
    )
    (f32.store
      (i32.const 0)
      (local.get $f32)
    )
  )

  ;; CHECK:      (func $caller (type $0)
  ;; CHECK-NEXT:  (call $foo
  ;; CHECK-NEXT:   (block (result i32)
  ;; CHECK-NEXT:    (call $caller)
  ;; CHECK-NEXT:    (i32.const 0)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (i64.const 1)
  ;; CHECK-NEXT:   (f32.const 2)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (call_ref $sig
  ;; CHECK-NEXT:   (i32.const 4)
  ;; CHECK-NEXT:   (i64.const 5)
  ;; CHECK-NEXT:   (f32.const 6)
  ;; CHECK-NEXT:   (ref.func $foo)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $caller
    ;; As above, but now one of the unused parameters has a side effect. We
    ;; move it to a local, which allows us to remove it (and also the last,
    ;; which is trivial).
    (call $foo
      (block (result i32)
        (call $caller)
        (i32.const 0)
      )
      (i64.const 1)
      (f32.const 2)
      (f64.const 3)
    )
    (call_ref $sig
      (i32.const 4)
      (i64.const 5)
      (f32.const 6)
      (f64.const 7)
      (ref.func $foo)
    )
  )
)

;; As above, but with the effects on a call_ref. Once more, we can optimize
;; even with effects on a param, using locals.
(module
  ;; CHECK:      (rec
  ;; CHECK-NEXT:  (type $0 (func))

  ;; CHECK:       (type $sig (sub (func (param i64 f32))))
  (type $sig (sub (func (param i32) (param i64) (param f32) (param f64))))

  (memory 1 1)

  ;; CHECK:      (memory $0 1 1)

  ;; CHECK:      (elem declare func $foo)

  ;; CHECK:      (func $foo (type $sig) (param $0 i64) (param $1 f32)
  ;; CHECK-NEXT:  (local $2 f64)
  ;; CHECK-NEXT:  (local $3 i32)
  ;; CHECK-NEXT:  (i64.store
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:   (local.get $0)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (f32.store
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:   (local.get $1)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $foo (type $sig) (param $i32 i32) (param $i64 i64) (param $f32 f32) (param $f64 f64)
    (i64.store
      (i32.const 0)
      (local.get $i64)
    )
    (f32.store
      (i32.const 0)
      (local.get $f32)
    )
  )

  ;; CHECK:      (func $caller (type $0)
  ;; CHECK-NEXT:  (local $0 i32)
  ;; CHECK-NEXT:  (call $foo
  ;; CHECK-NEXT:   (i64.const 1)
  ;; CHECK-NEXT:   (f32.const 2)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (block
  ;; CHECK-NEXT:   (local.set $0
  ;; CHECK-NEXT:    (block (result i32)
  ;; CHECK-NEXT:     (call $caller)
  ;; CHECK-NEXT:     (i32.const 4)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (call_ref $sig
  ;; CHECK-NEXT:    (i64.const 5)
  ;; CHECK-NEXT:    (f32.const 6)
  ;; CHECK-NEXT:    (ref.func $foo)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $caller
    (call $foo
      (i32.const 0)
      (i64.const 1)
      (f32.const 2)
      (f64.const 3)
    )
    (call_ref $sig
      (block (result i32)
        (call $caller)
        (i32.const 4)
      )
      (i64.const 5)
      (f32.const 6)
      (f64.const 7)
      (ref.func $foo)
    )
  )
)

(module
  ;; CHECK:      (rec
  ;; CHECK-NEXT:  (type $0 (func))

  ;; CHECK:       (type $sig (sub (func)))
  (type $sig (sub (func (param i32) (param i64) (param f32) (param f64))))

  (memory 1 1)

  ;; CHECK:      (memory $0 1 1)

  ;; CHECK:      (elem declare func $foo)

  ;; CHECK:      (func $foo (type $sig)
  ;; CHECK-NEXT:  (local $0 f64)
  ;; CHECK-NEXT:  (local $1 f32)
  ;; CHECK-NEXT:  (local $2 i64)
  ;; CHECK-NEXT:  (local $3 i32)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  (func $foo (type $sig) (param $i32 i32) (param $i64 i64) (param $f32 f32) (param $f64 f64)
    ;; Use nothing at all: all params can be removed.
  )

  ;; CHECK:      (func $caller (type $0)
  ;; CHECK-NEXT:  (call $foo)
  ;; CHECK-NEXT:  (call_ref $sig
  ;; CHECK-NEXT:   (ref.func $foo)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $caller
    (call $foo
      (i32.const 0)
      (i64.const 1)
      (f32.const 2)
      (f64.const 3)
    )
    (call_ref $sig
      (i32.const 4)
      (i64.const 5)
      (f32.const 6)
      (f64.const 7)
      (ref.func $foo)
    )
  )
)

(module
  ;; CHECK:      (rec
  ;; CHECK-NEXT:  (type $0 (func))

  ;; CHECK:       (type $sig (sub (func)))
  (type $sig (sub (func (param i32))))

  (memory 1 1)

  ;; CHECK:      (memory $0 1 1)

  ;; CHECK:      (func $foo (type $sig)
  ;; CHECK-NEXT:  (local $0 i32)
  ;; CHECK-NEXT:  (local.set $0
  ;; CHECK-NEXT:   (i32.const 1)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (i32.store
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:   (local.get $0)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $foo (type $sig) (param $i32 i32)
    ;; Use the parameters' index, but not its value. We can still remove it,
    ;; and the value set in the function is then set to a local and not a param,
    ;; which works just as well.
    (local.set $i32
      (i32.const 1)
    )
    (i32.store
      (i32.const 0)
      (local.get $i32)
    )
  )

  ;; CHECK:      (func $caller (type $0)
  ;; CHECK-NEXT:  (local $x i32)
  ;; CHECK-NEXT:  (call $foo)
  ;; CHECK-NEXT: )
  (func $caller
    (local $x i32)
    (call $foo
      ;; (avoid passing in a constant value to avoid other opts kicking in)
      (local.get $x)
    )
  )
)

(module
  ;; CHECK:      (type $sig (sub (func)))
  (type $sig (sub (func (param i32))))

  (memory 1 1)

  ;; CHECK:      (memory $0 1 1)

  ;; CHECK:      (func $foo (type $sig)
  ;; CHECK-NEXT:  (local $0 i32)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  (func $foo (type $sig) (param $i32 i32)
    ;; This function does not use the parameter. It also has no calls, but that
    ;; is not a problem - we can still remove the parameter.
  )
)

(module
  ;; CHECK:      (type $sig (sub (func (param i32))))
  (type $sig (sub (func (param i32))))

  ;; As above, but now an import also uses this signature, which prevents us
  ;; from changing anything.
  ;; CHECK:      (import "out" "func" (func $import (type $sig) (param i32)))
  (import "out" "func" (func $import (type $sig) (param i32)))

  (memory 1 1)

  ;; CHECK:      (memory $0 1 1)

  ;; CHECK:      (func $foo (type $sig) (param $i32 i32)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  (func $foo (type $sig) (param $i32 i32)
  )
)

(module
  ;; CHECK:      (type $sig (sub (func (param i32))))
  (type $sig (sub (func (param i32))))

  (memory 1 1)

  ;; CHECK:      (memory $0 1 1)

  ;; CHECK:      (func $foo (type $sig) (param $i32 i32)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  (func $foo (type $sig) (param $i32 i32)
  )

  ;; CHECK:      (func $bar (type $sig) (param $i32 i32)
  ;; CHECK-NEXT:  (i32.store
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:   (local.get $i32)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $bar (type $sig) (param $i32 i32)
    ;; As above, but now there is a second (non-imported) function using this
    ;; signature, and it does use the param, so we cannot optimize.
    (i32.store
      (i32.const 0)
      (local.get $i32)
    )
  )
)

(module
  (rec
    ;; CHECK:      (rec
    ;; CHECK-NEXT:  (type $sig2 (sub (func (param i32))))

    ;; CHECK:       (type $sig (sub (func)))
    (type $sig (sub (func (param i32))))

    (type $sig2 (sub (func (param i32))))
  )

  (memory 1 1)

  ;; CHECK:      (memory $0 1 1)

  ;; CHECK:      (func $foo (type $sig)
  ;; CHECK-NEXT:  (local $0 i32)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  (func $foo (type $sig) (param $i32 i32)
  )

  ;; CHECK:      (func $bar (type $sig2) (param $i32 i32)
  ;; CHECK-NEXT:  (i32.store
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:   (local.get $i32)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $bar (type $sig2) (param $i32 i32)
    ;; As above, but now the second function has a different signature, so we
    ;; can optimize one while not modifying the other.
    (i32.store
      (i32.const 0)
      (local.get $i32)
    )
  )
)

(module
  ;; CHECK:      (rec
  ;; CHECK-NEXT:  (type $0 (func))

  ;; CHECK:       (type $sig (sub (func)))
  (type $sig (sub (func (param i32))))

  (memory 1 1)

  ;; CHECK:      (memory $0 1 1)

  ;; CHECK:      (elem declare func $bar $foo)

  ;; CHECK:      (func $foo (type $sig)
  ;; CHECK-NEXT:  (local $0 i32)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  (func $foo (type $sig) (param $i32 i32)
  )

  ;; CHECK:      (func $bar (type $sig)
  ;; CHECK-NEXT:  (local $0 i32)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  (func $bar (type $sig) (param $i32 i32)
    ;; As above, but the second function also does not use the parameter, and
    ;; has the same type. We can optimize both at once.
  )

  ;; CHECK:      (func $caller (type $0)
  ;; CHECK-NEXT:  (call $foo)
  ;; CHECK-NEXT:  (call $bar)
  ;; CHECK-NEXT:  (call_ref $sig
  ;; CHECK-NEXT:   (ref.func $foo)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (call_ref $sig
  ;; CHECK-NEXT:   (ref.func $bar)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $caller
    (call $foo
      (i32.const 0)
    )
    (call $bar
      (i32.const 1)
    )
    (call_ref $sig
      (i32.const 2)
      (ref.func $foo)
    )
    (call_ref $sig
      (i32.const 2)
      (ref.func $bar)
    )
  )

  ;; CHECK:      (func $caller-2 (type $0)
  ;; CHECK-NEXT:  (call $bar)
  ;; CHECK-NEXT:  (call_ref $sig
  ;; CHECK-NEXT:   (ref.func $foo)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $caller-2
    ;; Also add some more calls to see they are updated too.
    (call $bar
      (i32.const 1)
    )
    (call_ref $sig
      (i32.const 2)
      (ref.func $foo)
    )
  )
)

(module
  ;; The presence of a table prevents us from doing any optimizations.
  (table 1 1 anyref)

  ;; CHECK:      (type $sig (sub (func (param i32))))
  (type $sig (sub (func (param i32))))

  ;; CHECK:      (table $0 1 1 anyref)

  ;; CHECK:      (func $foo (type $sig) (param $i32 i32)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  (func $foo (type $sig) (param $i32 i32)
  )
)

;; Exports cannot be optimized in any way: we cannot remove parameters from
;; them, and also we cannot apply constant parameter values either.
(module
  ;; CHECK:      (type $sig (sub (func (param i32))))
  (type $sig (sub (func (param i32))))

  ;; CHECK:      (type $1 (func))

  ;; CHECK:      (export "foo" (func $foo))

  ;; CHECK:      (export "bar" (func $bar))

  ;; CHECK:      (func $foo (type $sig) (param $i32 i32)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  (func $foo (export "foo") (type $sig) (param $i32 i32)
  )

  ;; CHECK:      (func $bar (type $sig) (param $i32 i32)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  (func $bar (export "bar") (type $sig) (param $i32 i32)
  )

  ;; CHECK:      (func $call-bar (type $1)
  ;; CHECK-NEXT:  (call $bar
  ;; CHECK-NEXT:   (i32.const 42)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $call-bar
    (call $bar
      (i32.const 42)
    )
  )
)

;; Two functions with two different types have an unused parameter. After
;; removing the parameter from each, they both have no parameters. They should
;; *not* have the same type, however: the type should be different nominally
;; even though after the pruning they are identical structurally.
(module
  (rec
    ;; CHECK:      (rec
    ;; CHECK-NEXT:  (type $sig2 (sub (func)))

    ;; CHECK:       (type $sig1 (sub (func)))
    (type $sig1 (sub (func (param i32))))
    (type $sig2 (sub (func (param f64))))
  )

  ;; CHECK:      (func $foo1 (type $sig1)
  ;; CHECK-NEXT:  (local $0 i32)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  (func $foo1 (type $sig1) (param $i32 i32)
  )

  ;; CHECK:      (func $foo2 (type $sig2)
  ;; CHECK-NEXT:  (local $0 f64)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  (func $foo2 (type $sig2) (param $f64 f64)
  )
)

(module
  (rec
    ;; CHECK:      (rec
    ;; CHECK-NEXT:  (type $sig-bar (sub (func (param i32))))

    ;; CHECK:       (type $sig-foo (sub (func)))
    (type $sig-foo (sub (func (param i32))))
    (type $sig-bar (sub (func (param i32))))
  )

  (memory 1 1)

  ;; CHECK:      (memory $0 1 1)

  ;; CHECK:      (func $foo (type $sig-foo)
  ;; CHECK-NEXT:  (local $0 i32)
  ;; CHECK-NEXT:  (local.set $0
  ;; CHECK-NEXT:   (i32.const 42)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (block
  ;; CHECK-NEXT:   (i32.store
  ;; CHECK-NEXT:    (i32.const 0)
  ;; CHECK-NEXT:    (local.get $0)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (call $foo)
  ;; CHECK-NEXT:   (call $foo)
  ;; CHECK-NEXT:   (call $foo)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $foo (type $sig-foo) (param $i32 i32)
    ;; This function is always called with the same constant, and we can
    ;; apply that constant here and prune the param.
    (i32.store
      (i32.const 0)
      (local.get $i32)
    )
    (call $foo (i32.const 42))
    (call $foo (i32.const 42))
    (call $foo (i32.const 42))
  )

  ;; CHECK:      (func $bar (type $sig-bar) (param $i32 i32)
  ;; CHECK-NEXT:  (i32.store
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:   (local.get $i32)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (call $bar
  ;; CHECK-NEXT:   (i32.const 42)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (call $bar
  ;; CHECK-NEXT:   (i32.const 43)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $bar (type $sig-bar) (param $i32 i32)
    ;; This function is called with various values, and cannot be optimized like
    ;; the previous one.
    (i32.store
      (i32.const 0)
      (local.get $i32)
    )
    (call $bar (i32.const 42))
    (call $bar (i32.const 43))
  )
)

;; As above, but $foo's parameter is a ref.func, which is also a constant
;; value that we can optimize in the case of $foo (but not $bar, again, as $bar
;; is not always sent a constant value).
(module
  (rec
    ;; CHECK:      (rec
    ;; CHECK-NEXT:  (type $sig-bar (sub (func (param funcref))))

    ;; CHECK:       (type $sig-foo (sub (func)))
    (type $sig-foo (sub (func (param funcref))))
    (type $sig-bar (sub (func (param funcref))))
  )

  (memory 1 1)

  ;; CHECK:      (memory $0 1 1)

  ;; CHECK:      (elem declare func $bar $foo)

  ;; CHECK:      (func $foo (type $sig-foo)
  ;; CHECK-NEXT:  (local $0 funcref)
  ;; CHECK-NEXT:  (local.set $0
  ;; CHECK-NEXT:   (ref.func $foo)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (block
  ;; CHECK-NEXT:   (drop
  ;; CHECK-NEXT:    (local.get $0)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (call $foo)
  ;; CHECK-NEXT:   (call $foo)
  ;; CHECK-NEXT:   (call $foo)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $foo (type $sig-foo) (param $funcref funcref)
    (drop (local.get $funcref))
    (call $foo (ref.func $foo))
    (call $foo (ref.func $foo))
    (call $foo (ref.func $foo))
  )

  ;; CHECK:      (func $bar (type $sig-bar) (param $funcref funcref)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (local.get $funcref)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (call $bar
  ;; CHECK-NEXT:   (ref.func $foo)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (call $bar
  ;; CHECK-NEXT:   (ref.func $bar)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $bar (type $sig-bar) (param $funcref funcref)
    (drop (local.get $funcref))
    (call $bar (ref.func $foo))
    (call $bar (ref.func $bar))
  )
)

;; As above, but the values are now ref.nulls.
(module
  (rec
    ;; CHECK:      (rec
    ;; CHECK-NEXT:  (type $sig-bar (sub (func (param anyref))))

    ;; CHECK:       (type $sig-foo (sub (func)))
    (type $sig-foo (sub (func (param anyref))))
    (type $sig-bar (sub (func (param anyref))))
  )

  (memory 1 1)

  ;; CHECK:      (memory $0 1 1)

  ;; CHECK:      (func $foo (type $sig-foo)
  ;; CHECK-NEXT:  (local $0 anyref)
  ;; CHECK-NEXT:  (local.set $0
  ;; CHECK-NEXT:   (ref.null none)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (block
  ;; CHECK-NEXT:   (drop
  ;; CHECK-NEXT:    (local.get $0)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (call $foo)
  ;; CHECK-NEXT:   (call $foo)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $foo (type $sig-foo) (param $anyref anyref)
    (drop (local.get $anyref))
    (call $foo (ref.null none))
    (call $foo (ref.null none))
  )

  ;; CHECK:      (func $bar (type $sig-bar) (param $anyref anyref)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (local.get $anyref)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (call $bar
  ;; CHECK-NEXT:   (ref.i31
  ;; CHECK-NEXT:    (i32.const 0)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (call $bar
  ;; CHECK-NEXT:   (ref.null none)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $bar (type $sig-bar) (param $anyref anyref)
    (drop (local.get $anyref))
    ;; Mixing a null with something else prevents optimization, of course.
    (call $bar (ref.i31 (i32.const 0)))
    (call $bar (ref.null none))
  )
)

(module
  (type $A (struct))
  ;; CHECK:      (type $0 (func))

  ;; CHECK:      (func $0 (type $0)
  ;; CHECK-NEXT:  (local $0 f32)
  ;; CHECK-NEXT:  (block ;; (replaces unreachable RefCast we can't emit)
  ;; CHECK-NEXT:   (drop
  ;; CHECK-NEXT:    (unreachable)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (unreachable)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $0 (param $0 f32)
    ;; $A is only used in an unreachable cast. We should not error when
    ;; removing the param from this function, during which we collect heap
    ;; types, and must find this one even though the cast is unreachable, as
    ;; we do need to handle it in the optimization as well as print it (note how
    ;; type $A is declared in the output here - it would be a bug if it were
    ;; not, which this is a regression test for).
    (ref.cast (ref null $A)
      (unreachable)
    )
  )
)

;; Do not prune signatures used in the call.without.effects intrinsic.
(module
  ;; CHECK:      (type $0 (func (param i32 funcref) (result i32)))

  ;; CHECK:      (type $1 (func (param i32) (result i32)))

  ;; CHECK:      (type $2 (func (result i32)))

  ;; CHECK:      (import "binaryen-intrinsics" "call.without.effects" (func $cwe (type $0) (param i32 funcref) (result i32)))
  (import "binaryen-intrinsics" "call.without.effects" (func $cwe (param i32 funcref) (result i32)))

  ;; CHECK:      (elem declare func $func)

  ;; CHECK:      (func $func (type $1) (param $0 i32) (result i32)
  ;; CHECK-NEXT:  (i32.const 1)
  ;; CHECK-NEXT: )
  (func $func (param i32) (result i32)
    ;; The parameter is unused, so we want to prune it. We won't because of the
    ;; situation in the calling function, below.
    (i32.const 1)
  )

  ;; CHECK:      (func $caller (type $2) (result i32)
  ;; CHECK-NEXT:  (call $cwe
  ;; CHECK-NEXT:   (i32.const 41)
  ;; CHECK-NEXT:   (ref.func $func)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $caller (result i32)
    ;; We call $func using call.without.effects. This causes us to not optimize
    ;; in this case.
    (call $cwe
      (i32.const 41)
      (ref.func $func)
    )
  )
)

;; Due to function subtyping, we cannot prune fields from $func.B without also
;; pruning them in $func.A, and vice versa, if they have a subtyping
;; relationship. Atm we do not prune such "cycles" so we do not optimize here.
;; TODO
(module
  ;; CHECK:      (type $struct.A (sub (struct (field i32))))
  (type $struct.A (sub (struct (field i32))))
  ;; CHECK:      (type $array.A (sub (array (ref $struct.A))))

  ;; CHECK:      (type $struct.B (sub $struct.A (struct (field i32) (field i64))))
  (type $struct.B (sub $struct.A (struct (field i32) (field i64))))

  (type $array.A (sub (array (ref $struct.A))))
  ;; CHECK:      (type $array.B (sub $array.A (array (ref $struct.B))))
  (type $array.B (sub $array.A (array (ref $struct.B))))

  ;; CHECK:      (type $func.A (sub (func (param (ref $array.B)) (result (ref $array.A)))))
  (type $func.A (sub (func (param (ref $array.B)) (result (ref $array.A)))))
  ;; CHECK:      (type $func.B (sub $func.A (func (param (ref $array.A)) (result (ref $array.B)))))
  (type $func.B (sub $func.A (func (param (ref $array.A)) (result (ref $array.B)))))

  ;; CHECK:      (func $func.A (type $func.A) (param $0 (ref $array.B)) (result (ref $array.A))
  ;; CHECK-NEXT:  (unreachable)
  ;; CHECK-NEXT: )
  (func $func.A (type $func.A) (param $0 (ref $array.B)) (result (ref $array.A))
    (unreachable)
  )

  ;; CHECK:      (func $func.B (type $func.B) (param $0 (ref $array.A)) (result (ref $array.B))
  ;; CHECK-NEXT:  (unreachable)
  ;; CHECK-NEXT: )
  (func $func.B (type $func.B) (param $0 (ref $array.A)) (result (ref $array.B))
    (unreachable)
  )
)
