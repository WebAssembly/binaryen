;; NOTE: Assertions have been generated by update_lit_checks.py and should not be edited.
;; RUN: wasm-opt %s --local-subtyping -all -S -o - \
;; RUN:   | filecheck %s

(module
  ;; CHECK:      (type ${} (struct ))
  (type ${} (struct_subtype data))

  ;; CHECK:      (type ${i32} (struct (field i32)))
  (type ${i32} (struct_subtype (field i32) data))

  (type $array (array_subtype i8 data))

  ;; CHECK:      (import "out" "i32" (func $i32 (result i32)))
  (import "out" "i32" (func $i32 (result i32)))
  ;; CHECK:      (import "out" "i64" (func $i64 (result i64)))
  (import "out" "i64" (func $i64 (result i64)))

  ;; Refinalization can find a more specific type, where the declared type was
  ;; not the optimal LUB.
  ;; CHECK:      (func $refinalize (param $x i32)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (if (result i31ref)
  ;; CHECK-NEXT:    (local.get $x)
  ;; CHECK-NEXT:    (i31.new
  ;; CHECK-NEXT:     (i32.const 0)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (i31.new
  ;; CHECK-NEXT:     (i32.const 1)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (block $block (result i31ref)
  ;; CHECK-NEXT:    (br $block
  ;; CHECK-NEXT:     (i31.new
  ;; CHECK-NEXT:      (i32.const 0)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (i31.new
  ;; CHECK-NEXT:     (i32.const 1)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $refinalize (param $x i32)
    (drop
      (if (result anyref)
        (local.get $x)
        (i31.new (i32.const 0))
        (i31.new (i32.const 1))
      )
    )
    (drop
      (block $block (result anyref)
        (br $block
          (i31.new (i32.const 0))
        )
        (i31.new (i32.const 1))
      )
    )
  )

  ;; A simple case where a local has a single assignment that we can use as a
  ;; more specific type. A similar thing with a parameter, however, is not a
  ;; thing we can optimize. Also, ignore a local with zero assignments.
  ;; CHECK:      (func $simple-local-but-not-param (param $x funcref)
  ;; CHECK-NEXT:  (local $y (ref null $none_=>_i32))
  ;; CHECK-NEXT:  (local $unused funcref)
  ;; CHECK-NEXT:  (local.set $x
  ;; CHECK-NEXT:   (ref.func $i32)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (local.set $y
  ;; CHECK-NEXT:   (ref.func $i32)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $simple-local-but-not-param (param $x funcref)
    (local $y funcref)
    (local $unused funcref)
    (local.set $x
      (ref.func $i32)
    )
    (local.set $y
      (ref.func $i32)
    )
  )

  ;; CHECK:      (func $locals-with-multiple-assignments (param $data (ref null data))
  ;; CHECK-NEXT:  (local $x eqref)
  ;; CHECK-NEXT:  (local $y (ref null i31))
  ;; CHECK-NEXT:  (local $z (ref null data))
  ;; CHECK-NEXT:  (local $w funcref)
  ;; CHECK-NEXT:  (local.set $x
  ;; CHECK-NEXT:   (i31.new
  ;; CHECK-NEXT:    (i32.const 0)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (local.set $x
  ;; CHECK-NEXT:   (local.get $data)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (local.set $y
  ;; CHECK-NEXT:   (i31.new
  ;; CHECK-NEXT:    (i32.const 0)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (local.set $y
  ;; CHECK-NEXT:   (i31.new
  ;; CHECK-NEXT:    (i32.const 1)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (local.set $z
  ;; CHECK-NEXT:   (local.get $data)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (local.set $z
  ;; CHECK-NEXT:   (local.get $data)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (local.set $w
  ;; CHECK-NEXT:   (ref.func $i32)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (local.set $w
  ;; CHECK-NEXT:   (ref.func $i64)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $locals-with-multiple-assignments (param $data (ref null data))
    (local $x anyref)
    (local $y anyref)
    (local $z anyref)
    (local $w funcref)
    ;; x is assigned two different types with a new LUB possible
    (local.set $x
      (i31.new (i32.const 0))
    )
    (local.set $x
      (local.get $data)
    )
    ;; y and z are assigned the same more specific type twice
    (local.set $y
      (i31.new (i32.const 0))
    )
    (local.set $y
      (i31.new (i32.const 1))
    )
    (local.set $z
      (local.get $data)
    )
    (local.set $z
      (local.get $data)
    )
    ;; w is assigned two different types *without* a new LUB possible, as it
    ;; already had the optimal LUB
    (local.set $w
      (ref.func $i32)
    )
    (local.set $w
      (ref.func $i64)
    )
  )

  ;; In some cases multiple iterations are necessary, as one inferred new type
  ;; applies to a get which then allows another inference.
  ;; CHECK:      (func $multiple-iterations
  ;; CHECK-NEXT:  (local $x (ref null $none_=>_i32))
  ;; CHECK-NEXT:  (local $y (ref null $none_=>_i32))
  ;; CHECK-NEXT:  (local $z (ref null $none_=>_i32))
  ;; CHECK-NEXT:  (local.set $x
  ;; CHECK-NEXT:   (ref.func $i32)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (local.set $y
  ;; CHECK-NEXT:   (local.get $x)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (local.set $z
  ;; CHECK-NEXT:   (local.get $y)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $multiple-iterations
    (local $x funcref)
    (local $y funcref)
    (local $z funcref)
    (local.set $x
      (ref.func $i32)
    )
    (local.set $y
      (local.get $x)
    )
    (local.set $z
      (local.get $y)
    )
  )

  ;; Sometimes a refinalize is necessary in between the iterations.
  ;; CHECK:      (func $multiple-iterations-refinalize (param $i i32)
  ;; CHECK-NEXT:  (local $x (ref null $none_=>_i32))
  ;; CHECK-NEXT:  (local $y (ref null $none_=>_i64))
  ;; CHECK-NEXT:  (local $z funcref)
  ;; CHECK-NEXT:  (local.set $x
  ;; CHECK-NEXT:   (ref.func $i32)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (local.set $y
  ;; CHECK-NEXT:   (ref.func $i64)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (local.set $z
  ;; CHECK-NEXT:   (select (result funcref)
  ;; CHECK-NEXT:    (local.get $x)
  ;; CHECK-NEXT:    (local.get $y)
  ;; CHECK-NEXT:    (local.get $i)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $multiple-iterations-refinalize (param $i i32)
    (local $x funcref)
    (local $y funcref)
    (local $z funcref)
    (local.set $x
      (ref.func $i32)
    )
    (local.set $y
      (ref.func $i64)
    )
    (local.set $z
      (select
        (local.get $x)
        (local.get $y)
        (local.get $i)
      )
    )
  )

  ;; CHECK:      (func $nondefaultable
  ;; CHECK-NEXT:  (local $x (funcref funcref))
  ;; CHECK-NEXT:  (local.set $x
  ;; CHECK-NEXT:   (tuple.make
  ;; CHECK-NEXT:    (ref.func $i32)
  ;; CHECK-NEXT:    (ref.func $i32)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $nondefaultable
    (local $x (funcref funcref))
    ;; This tuple is assigned non-nullable values, which means the subtype is
    ;; nondefaultable, and we must not apply it.
    (local.set $x
      (tuple.make
        (ref.func $i32)
        (ref.func $i32)
      )
    )
  )

  ;; CHECK:      (func $uses-default (param $i i32)
  ;; CHECK-NEXT:  (local $x (ref null $i32_=>_none))
  ;; CHECK-NEXT:  (if
  ;; CHECK-NEXT:   (local.get $i)
  ;; CHECK-NEXT:   (local.set $x
  ;; CHECK-NEXT:    (ref.func $uses-default)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (local.get $x)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $uses-default (param $i i32)
    (local $x funcref)
    (if
      (local.get $i)
      ;; The only set to this local uses a more specific type than funcref.
      (local.set $x (ref.func $uses-default))
    )
    (drop
      ;; This get may use the default value, but it is ok to have a null of a
      ;; more refined type in the local.
      (local.get $x)
    )
  )

  ;; CHECK:      (func $unreachables (result funcref)
  ;; CHECK-NEXT:  (local $temp (ref null $none_=>_funcref))
  ;; CHECK-NEXT:  (local.set $temp
  ;; CHECK-NEXT:   (ref.func $unreachables)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (unreachable)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (block (result (ref null $none_=>_funcref))
  ;; CHECK-NEXT:    (local.tee $temp
  ;; CHECK-NEXT:     (ref.func $unreachables)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (local.get $temp)
  ;; CHECK-NEXT: )
  (func $unreachables (result funcref)
    (local $temp funcref)
    ;; Set a value that allows us to refine the local's type.
    (local.set $temp
      (ref.func $unreachables)
    )
    (unreachable)
    ;; A tee that is not reachable. We must still update its type, and the
    ;; parents.
    (drop
      (block (result funcref)
        (local.tee $temp
          (ref.func $unreachables)
        )
      )
    )
    ;; A get that is not reachable. We must still update its type.
    (local.get $temp)
  )

  ;; CHECK:      (func $incompatible-sets (result i32)
  ;; CHECK-NEXT:  (local $temp (ref null $none_=>_i32))
  ;; CHECK-NEXT:  (local.set $temp
  ;; CHECK-NEXT:   (ref.func $incompatible-sets)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (unreachable)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (local.tee $temp
  ;; CHECK-NEXT:    (block
  ;; CHECK-NEXT:     (drop
  ;; CHECK-NEXT:      (ref.null func)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:     (unreachable)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (local.tee $temp
  ;; CHECK-NEXT:   (block
  ;; CHECK-NEXT:    (drop
  ;; CHECK-NEXT:     (ref.null func)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (unreachable)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (unreachable)
  ;; CHECK-NEXT: )
  (func $incompatible-sets (result i32)
    (local $temp funcref)
    ;; Set a value that allows us to specialize the local type.
    (local.set $temp
      (ref.func $incompatible-sets)
    )
    ;; Make all code unreachable from here.
    (unreachable)
    ;; In unreachable code, assign values that are not compatible with the more
    ;; specific type we will optimize to. Those cannot be left as they are, and
    ;; will be fixed up so that they validate. (All we need is validation, as
    ;; their contents do not matter, given they are not reached.)
    (drop
      (local.tee $temp
        (ref.null func)
      )
    )
    (local.set $temp
      (ref.null func)
    )
    (unreachable)
  )

  ;; CHECK:      (func $update-nulls
  ;; CHECK-NEXT:  (local $x (ref null ${}))
  ;; CHECK-NEXT:  (local.set $x
  ;; CHECK-NEXT:   (ref.null ${})
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (local.set $x
  ;; CHECK-NEXT:   (ref.null ${})
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (local.set $x
  ;; CHECK-NEXT:   (struct.new_default ${})
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (local.set $x
  ;; CHECK-NEXT:   (ref.null ${})
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (local.set $x
  ;; CHECK-NEXT:   (ref.null ${})
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (local.set $x
  ;; CHECK-NEXT:   (ref.null ${})
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (local.set $x
  ;; CHECK-NEXT:   (ref.null ${i32})
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $update-nulls
    (local $x anyref)
    (local.set $x (ref.null any))
    (local.set $x (ref.null eq))
    ;; All the nulls can be changed into other nulls here, for the new LUB,
    ;; which will be ${}
    (local.set $x (struct.new ${}))
    (local.set $x (ref.null data))
    ;; Note that this func null is even of a type that is incompatible with the
    ;; new lub (array vs struct). Still, we can just update it along with the
    ;; others.
    (local.set $x (ref.null $array))
    ;; This null is equal to the LUB we'll find, and will not change.
    (local.set $x (ref.null ${}))
    ;; This null is more specific than the LUB we'll find, and will not change,
    ;; as there is no point to making something less specific in type.
    (local.set $x (ref.null ${i32}))
  )
)
