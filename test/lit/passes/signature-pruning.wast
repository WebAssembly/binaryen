;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.
;; RUN: foreach %s %t wasm-opt --nominal --signature-pruning -all -S -o - | filecheck %s

(module
  ;; CHECK:      (type $sig (func_subtype (param i32 f64) func))
  (type $sig (func_subtype (param i32) (param i64) (param f32) (param f64) func))

  (memory 1 1)

  ;; CHECK:      (type $none_=>_none (func_subtype func))

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

  ;; CHECK:      (func $caller (type $none_=>_none)
  ;; CHECK-NEXT:  (call $foo
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:   (f64.const 3)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (call_ref
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
    (call_ref
      (i32.const 4)
      (i64.const 5)
      (f32.const 6)
      (f64.const 7)
      (ref.func $foo)
    )
  )
)

(module
  ;; CHECK:      (type $sig (func_subtype (param i64 f32) func))
  (type $sig (func_subtype (param i32) (param i64) (param f32) (param f64) func))

  (memory 1 1)

  ;; CHECK:      (type $none_=>_none (func_subtype func))

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

  ;; CHECK:      (func $caller (type $none_=>_none)
  ;; CHECK-NEXT:  (call $foo
  ;; CHECK-NEXT:   (i64.const 1)
  ;; CHECK-NEXT:   (f32.const 2)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (call_ref
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
    (call_ref
      (i32.const 4)
      (i64.const 5)
      (f32.const 6)
      (f64.const 7)
      (ref.func $foo)
    )
  )
)

(module
  ;; CHECK:      (type $sig (func_subtype (param i32 i64 f32) func))
  (type $sig (func_subtype (param i32) (param i64) (param f32) (param f64) func))

  (memory 1 1)

  ;; CHECK:      (type $none_=>_none (func_subtype func))

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

  ;; CHECK:      (func $caller (type $none_=>_none)
  ;; CHECK-NEXT:  (call $foo
  ;; CHECK-NEXT:   (block $block (result i32)
  ;; CHECK-NEXT:    (call $caller)
  ;; CHECK-NEXT:    (i32.const 0)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (i64.const 1)
  ;; CHECK-NEXT:   (f32.const 2)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (call_ref
  ;; CHECK-NEXT:   (i32.const 4)
  ;; CHECK-NEXT:   (i64.const 5)
  ;; CHECK-NEXT:   (f32.const 6)
  ;; CHECK-NEXT:   (ref.func $foo)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $caller
    ;; As above, but now one of the unused parameters has a side effect which
    ;; prevents us from removing it (flattening the IR first would avoid this
    ;; limitation). We only end up removing a single unused param, the last.
    (call $foo
      (block (result i32)
        (call $caller)
        (i32.const 0)
      )
      (i64.const 1)
      (f32.const 2)
      (f64.const 3)
    )
    (call_ref
      (i32.const 4)
      (i64.const 5)
      (f32.const 6)
      (f64.const 7)
      (ref.func $foo)
    )
  )
)

(module
  ;; CHECK:      (type $sig (func_subtype func))
  (type $sig (func_subtype (param i32) (param i64) (param f32) (param f64) func))

  (memory 1 1)

  ;; CHECK:      (type $none_=>_none (func_subtype func))

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

  ;; CHECK:      (func $caller (type $none_=>_none)
  ;; CHECK-NEXT:  (call $foo)
  ;; CHECK-NEXT:  (call_ref
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
    (call_ref
      (i32.const 4)
      (i64.const 5)
      (f32.const 6)
      (f64.const 7)
      (ref.func $foo)
    )
  )
)

(module
  ;; CHECK:      (type $sig (func_subtype func))
  (type $sig (func_subtype (param i32) func))

  (memory 1 1)

  ;; CHECK:      (type $none_=>_none (func_subtype func))

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

  ;; CHECK:      (func $caller (type $none_=>_none)
  ;; CHECK-NEXT:  (call $foo)
  ;; CHECK-NEXT: )
  (func $caller
    (call $foo
      (i32.const 0)
    )
  )
)

(module
  ;; CHECK:      (type $sig (func_subtype func))
  (type $sig (func_subtype (param i32) func))

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
  ;; CHECK:      (type $sig (func_subtype (param i32) func))
  (type $sig (func_subtype (param i32) func))

  ;; As above, but now an import also uses this signature, which prevents us
  ;; from changing anything.
  ;; CHECK:      (import "out" "func" (func $import (param i32)))
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
  ;; CHECK:      (type $sig (func_subtype (param i32) func))
  (type $sig (func_subtype (param i32) func))

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
  ;; CHECK:      (type $sig (func_subtype func))
  (type $sig (func_subtype (param i32) func))

  ;; CHECK:      (type $sig2 (func_subtype (param i32) func))
  (type $sig2 (func_subtype (param i32) func))

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
  ;; CHECK:      (type $sig (func_subtype func))
  (type $sig (func_subtype (param i32) func))

  (memory 1 1)

  ;; CHECK:      (type $none_=>_none (func_subtype func))

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

  ;; CHECK:      (func $caller (type $none_=>_none)
  ;; CHECK-NEXT:  (call $foo)
  ;; CHECK-NEXT:  (call $bar)
  ;; CHECK-NEXT:  (call_ref
  ;; CHECK-NEXT:   (ref.func $foo)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (call_ref
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
    (call_ref
      (i32.const 2)
      (ref.func $foo)
    )
    (call_ref
      (i32.const 2)
      (ref.func $bar)
    )
  )

  ;; CHECK:      (func $caller-2 (type $none_=>_none)
  ;; CHECK-NEXT:  (call $bar)
  ;; CHECK-NEXT:  (call_ref
  ;; CHECK-NEXT:   (ref.func $foo)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $caller-2
    ;; Also add some more calls to see they are updated too.
    (call $bar
      (i32.const 1)
    )
    (call_ref
      (i32.const 2)
      (ref.func $foo)
    )
  )
)

(module
  ;; The presence of a table prevents us from doing any optimizations.
  (table 1 1 anyref)

  ;; CHECK:      (type $sig (func_subtype (param i32) func))
  (type $sig (func_subtype (param i32) func))

  ;; CHECK:      (table $0 1 1 anyref)

  ;; CHECK:      (func $foo (type $sig) (param $i32 i32)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  (func $foo (type $sig) (param $i32 i32)
  )
)

;; Exports cannot be optimized.
(module
  ;; CHECK:      (type $sig (func_subtype (param i32) func))
  (type $sig (func_subtype (param i32) func))

  ;; CHECK:      (export "foo" (func $foo))

  ;; CHECK:      (func $foo (type $sig) (param $i32 i32)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  (func $foo (export "foo") (type $sig) (param $i32 i32)
  )
)

;; Two functions with two different types have an unused parameter. After
;; removing the parameter from each, they both have no parameters. They should
;; *not* have the same type, however: the type should be different nominally
;; even though after the pruning they are identical structurally.
(module
  ;; CHECK:      (type $sig1 (func_subtype func))
  (type $sig1 (func_subtype (param i32) func))
  ;; CHECK:      (type $sig2 (func_subtype func))
  (type $sig2 (func_subtype (param f64) func))

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

