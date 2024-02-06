;; NOTE: Assertions have been generated by update_lit_checks.py and should not be edited.
;; RUN: wasm-opt %s --vacuum -all -S -o - | filecheck %s

(module
  ;; CHECK:      (import "binaryen-intrinsics" "call.without.effects" (func $call.without.effects (type $2) (param i32 i32 funcref) (result anyref)))
  (import "binaryen-intrinsics" "call.without.effects" (func $call.without.effects (param i32 i32 funcref) (result (ref null any))))
  ;; CHECK:      (import "binaryen-intrinsics" "call.without.effects" (func $call.without.effects.non.null (type $3) (param i32 i32 funcref) (result (ref any))))
  (import "binaryen-intrinsics" "call.without.effects" (func $call.without.effects.non.null (param i32 i32 funcref) (result (ref any))))

  (type $"{}" (struct))

  ;; CHECK:      (func $drop-ref-as (type $4) (param $x anyref)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (ref.as_non_null
  ;; CHECK-NEXT:    (local.get $x)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (ref.cast i31ref
  ;; CHECK-NEXT:    (local.get $x)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $drop-ref-as (param $x anyref)
    ;; Without -tnh, we must assume all casts can have a trap effect, and so
    ;; we cannot remove anything here.
    (drop
      (ref.as_non_null
        (local.get $x)
      )
    )
    (drop
      (ref.cast i31ref
        (local.get $x)
      )
    )
  )

  ;; CHECK:      (func $vacuum-nonnull (type $0)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  (func $vacuum-nonnull
    (drop
      (if (result (ref $"{}"))
        (i32.const 1)
        ;; This block's result is not used. As a consequence vacuum will try to
        ;; generate a replacement zero for the block's fallthrough value. A
        ;; non-nullable reference is a problem for that, since we don't want to
        ;; synthesize and allocate a new struct value.  Vacuum should not error
        ;; on this case, though. Instead, the end result of this function should
        ;; simply be empty, as everything here can be vacuumed away.
        (then
          (block (result (ref $"{}"))
            (struct.new $"{}")
          )
        )
        (else
          (unreachable)
        )
      )
    )
  )

  ;; CHECK:      (func $drop-i31.get (type $5) (param $ref i31ref) (param $ref-nn (ref i31))
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (i31.get_s
  ;; CHECK-NEXT:    (local.get $ref)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $drop-i31.get (param $ref i31ref) (param $ref-nn (ref i31))
    ;; A nullable get might trap, so only the second item can be removed.
    (drop
      (i31.get_s
        (local.get $ref)
      )
    )
    (drop
      (i31.get_s
        (local.get $ref-nn)
      )
    )
  )

  ;; CHECK:      (func $ref.cast.null.block (type $6) (param $ref (ref ${})) (result structref)
  ;; CHECK-NEXT:  (ref.cast (ref ${})
  ;; CHECK-NEXT:   (local.get $ref)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $ref.cast.null.block (param $ref (ref $"{}")) (result (ref null struct))
    ;; We can vacuum away the block, which will make this ref.cast null operate
    ;; on a non-nullable input. That is, we are refining the input to the cast.
    ;; The cast must be updated properly following that, to be a non-nullable
    ;; cast.
    (ref.cast (ref null $"{}")
      (block (result (ref null $"{}"))
        (local.get $ref)
      )
    )
  )

  ;; CHECK:      (func $dropped-calls (type $0)
  ;; CHECK-NEXT:  (block
  ;; CHECK-NEXT:   (drop
  ;; CHECK-NEXT:    (call $helper-i32)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (drop
  ;; CHECK-NEXT:    (call $helper-i32)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (block
  ;; CHECK-NEXT:   (drop
  ;; CHECK-NEXT:    (call $helper-ref)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (drop
  ;; CHECK-NEXT:    (call $helper-ref)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (block
  ;; CHECK-NEXT:   (drop
  ;; CHECK-NEXT:    (call $helper-i32)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (drop
  ;; CHECK-NEXT:    (call $helper-i32)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (call $call.without.effects.non.null
  ;; CHECK-NEXT:    (call $helper-i32)
  ;; CHECK-NEXT:    (call $helper-i32)
  ;; CHECK-NEXT:    (ref.func $helper-two-refs-non-null)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $dropped-calls
    ;; The calls' outputs are used in a computation that itself has no effects,
    ;; and is dropped, so we don't need it. But we can't remove the calls
    ;; themselves, which should be all that remains, with drops of them (there
    ;; will also be blocks, which merge-blocks would remove).
    (drop
      (i32.add
        (call $helper-i32)
        (call $helper-i32)
      )
    )
    (drop
      (ref.eq
        (call $helper-ref)
        (call $helper-ref)
      )
    )
    ;; The call.without.effects can be removed, but not the two calls nested in
    ;; it.
    (drop
      (call $call.without.effects
        (call $helper-i32)
        (call $helper-i32)
        (ref.func $helper-two-refs)
      )
    )
    ;; The non-null case however is tricky, and we do not handle it atm. TODO
    (drop
      (call $call.without.effects.non.null
        (call $helper-i32)
        (call $helper-i32)
        (ref.func $helper-two-refs-non-null)
      )
    )
  )

  ;; CHECK:      (func $helper-i32 (type $7) (result i32)
  ;; CHECK-NEXT:  (i32.const 1)
  ;; CHECK-NEXT: )
  (func $helper-i32 (result i32)
    (i32.const 1)
  )

  ;; CHECK:      (func $helper-ref (type $8) (result eqref)
  ;; CHECK-NEXT:  (unreachable)
  ;; CHECK-NEXT: )
  (func $helper-ref (result eqref)
    (unreachable)
  )

  ;; CHECK:      (func $helper-two-refs (type $9) (param $0 i32) (param $1 i32) (result anyref)
  ;; CHECK-NEXT:  (unreachable)
  ;; CHECK-NEXT: )
  (func $helper-two-refs (param i32) (param i32) (result (ref null any))
    (unreachable)
  )

  ;; CHECK:      (func $helper-two-refs-non-null (type $10) (param $0 i32) (param $1 i32) (result (ref any))
  ;; CHECK-NEXT:  (unreachable)
  ;; CHECK-NEXT: )
  (func $helper-two-refs-non-null (param i32) (param i32) (result (ref any))
    (unreachable)
  )
)
