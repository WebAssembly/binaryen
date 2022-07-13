;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.
;; RUN: foreach %s %t wasm-opt --nominal --gto -all -S -o - | filecheck %s
;; (remove-unused-names is added to test fallthrough values without a block
;; name getting in the way)

(module
  ;; A struct with a field that is never read or written, so it can be
  ;; removed.

  ;; CHECK:      (type $ref|$struct|_=>_none (func_subtype (param (ref $struct)) func))

  ;; CHECK:      (type $struct (struct_subtype  data))
  (type $struct (struct_subtype (field (mut funcref)) data))

  ;; CHECK:      (func $func (type $ref|$struct|_=>_none) (param $x (ref $struct))
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  (func $func (param $x (ref $struct))
  )
)

(module
  ;; A write does not keep a field from being removed.

  ;; CHECK:      (type $struct (struct_subtype  data))
  (type $struct (struct_subtype (field (mut funcref)) data))

  ;; CHECK:      (type $ref|$struct|_=>_none (func_subtype (param (ref $struct)) func))

  ;; CHECK:      (func $func (type $ref|$struct|_=>_none) (param $x (ref $struct))
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (ref.as_non_null
  ;; CHECK-NEXT:    (block (result (ref $struct))
  ;; CHECK-NEXT:     (drop
  ;; CHECK-NEXT:      (ref.null func)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:     (local.get $x)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $func (param $x (ref $struct))
    ;; The fields of this set will be dropped, as we do not need to perform
    ;; the write.
    (struct.set $struct 0
      (local.get $x)
      (ref.null func)
    )
  )
)

(module
  ;; A new does not keep a field from being removed.

  ;; CHECK:      (type $struct (struct_subtype  data))
  (type $struct (struct_subtype (field (mut funcref)) data))

  ;; CHECK:      (type $ref|$struct|_=>_none (func_subtype (param (ref $struct)) func))

  ;; CHECK:      (func $func (type $ref|$struct|_=>_none) (param $x (ref $struct))
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.new_default $struct)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $func (param $x (ref $struct))
    ;; The fields in this new will be removed.
    (drop
      (struct.new $struct
        (ref.null func)
      )
    )
  )
)

(module
  ;; A new_default does not keep a field from being removed.

  ;; CHECK:      (type $struct (struct_subtype  data))
  (type $struct (struct_subtype (field (mut funcref)) data))

  ;; CHECK:      (type $ref|$struct|_=>_none (func_subtype (param (ref $struct)) func))

  ;; CHECK:      (func $func (type $ref|$struct|_=>_none) (param $x (ref $struct))
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.new_default $struct)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $func (param $x (ref $struct))
    ;; The fields in this new will be removed.
    (drop
      (struct.new_default $struct
      )
    )
  )
)

(module
  ;; A read *does* keep a field from being removed.

  ;; CHECK:      (type $struct (struct_subtype (field funcref) data))
  (type $struct (struct_subtype (field (mut funcref)) data))

  ;; CHECK:      (type $ref|$struct|_=>_none (func_subtype (param (ref $struct)) func))

  ;; CHECK:      (func $func (type $ref|$struct|_=>_none) (param $x (ref $struct))
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.get $struct 0
  ;; CHECK-NEXT:    (local.get $x)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $func (param $x (ref $struct))
    (drop
      (struct.get $struct 0
        (local.get $x)
      )
    )
  )
)

(module
  ;; Different struct types with different situations: some fields are read,
  ;; some written, and some both. (Note that this also tests the interaction
  ;; of removing with the immutability inference that --gto does.)

  ;; A struct with all fields marked mutable.
  ;; CHECK:      (type $mut-struct (struct_subtype (field $r i32) (field $rw (mut i32)) (field $r-2 i32) (field $rw-2 (mut i32)) data))
  (type $mut-struct (struct_subtype (field $r (mut i32)) (field $w (mut i32)) (field $rw (mut i32)) (field $r-2 (mut i32)) (field $w-2 (mut i32)) (field $rw-2 (mut i32)) data))

  ;; A similar struct but with all fields marked immutable, and the only
  ;; writes are from during creation (so all fields are at least writeable).
  ;; CHECK:      (type $imm-struct (struct_subtype (field $rw i32) (field $rw-2 i32) data))
  (type $imm-struct (struct_subtype (field $w i32) (field $rw i32) (field $w-2 i32) (field $rw-2 i32) data))

  ;; CHECK:      (type $ref|$mut-struct|_=>_none (func_subtype (param (ref $mut-struct)) func))

  ;; CHECK:      (type $ref|$imm-struct|_=>_none (func_subtype (param (ref $imm-struct)) func))

  ;; CHECK:      (func $func-mut (type $ref|$mut-struct|_=>_none) (param $x (ref $mut-struct))
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.get $mut-struct $r
  ;; CHECK-NEXT:    (local.get $x)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (ref.as_non_null
  ;; CHECK-NEXT:    (block (result (ref $mut-struct))
  ;; CHECK-NEXT:     (drop
  ;; CHECK-NEXT:      (i32.const 0)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:     (local.get $x)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (struct.set $mut-struct $rw
  ;; CHECK-NEXT:   (local.get $x)
  ;; CHECK-NEXT:   (i32.const 1)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.get $mut-struct $rw
  ;; CHECK-NEXT:    (local.get $x)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.get $mut-struct $r-2
  ;; CHECK-NEXT:    (local.get $x)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (ref.as_non_null
  ;; CHECK-NEXT:    (block (result (ref $mut-struct))
  ;; CHECK-NEXT:     (drop
  ;; CHECK-NEXT:      (i32.const 2)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:     (local.get $x)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (struct.set $mut-struct $rw-2
  ;; CHECK-NEXT:   (local.get $x)
  ;; CHECK-NEXT:   (i32.const 3)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.get $mut-struct $rw-2
  ;; CHECK-NEXT:    (local.get $x)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $func-mut (param $x (ref $mut-struct))
    ;; $r is only read
    (drop
      (struct.get $mut-struct $r
        (local.get $x)
      )
    )
    ;; $w is only written
    (struct.set $mut-struct $w
      (local.get $x)
      (i32.const 0)
    )
    ;; $rw is both
    (struct.set $mut-struct $rw
      (local.get $x)
      (i32.const 1)
    )
    (drop
      (struct.get $mut-struct $rw
        (local.get $x)
      )
    )
    ;; The same, for the $*-2 fields
    (drop
      (struct.get $mut-struct $r-2
        (local.get $x)
      )
    )
    (struct.set $mut-struct $w-2
      (local.get $x)
      (i32.const 2)
    )
    (struct.set $mut-struct $rw-2
      (local.get $x)
      (i32.const 3)
    )
    (drop
      (struct.get $mut-struct $rw-2
        (local.get $x)
      )
    )
  )

  ;; CHECK:      (func $func-imm (type $ref|$imm-struct|_=>_none) (param $x (ref $imm-struct))
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.new $imm-struct
  ;; CHECK-NEXT:    (i32.const 1)
  ;; CHECK-NEXT:    (i32.const 3)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.get $imm-struct $rw
  ;; CHECK-NEXT:    (local.get $x)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.get $imm-struct $rw-2
  ;; CHECK-NEXT:    (local.get $x)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $func-imm (param $x (ref $imm-struct))
    ;; create an instance
    (drop
      (struct.new $imm-struct
        (i32.const 0)
        (i32.const 1)
        (i32.const 2)
        (i32.const 3)
      )
    )
    ;; $rw and $rw-2 are also read
    (drop
      (struct.get $imm-struct $rw
        (local.get $x)
      )
    )
    (drop
      (struct.get $imm-struct $rw-2
        (local.get $x)
      )
    )
  )
)

(module
  ;; A vtable-like structure created in a global location. Only some of the
  ;; fields are accessed.

  ;; CHECK:      (type $none_=>_none (func_subtype func))

  ;; CHECK:      (type $vtable (struct_subtype (field $v1 funcref) (field $v2 funcref) data))
  (type $vtable (struct_subtype (field $v0 funcref) (field $v1 funcref) (field $v2 funcref) (field $v3 funcref) (field $v4 funcref) data))

  ;; CHECK:      (global $vtable (ref $vtable) (struct.new $vtable
  ;; CHECK-NEXT:  (ref.func $func-1)
  ;; CHECK-NEXT:  (ref.func $func-2)
  ;; CHECK-NEXT: ))
  (global $vtable (ref $vtable) (struct.new $vtable
    (ref.func $func-0)
    (ref.func $func-1)
    (ref.func $func-2)
    (ref.func $func-3)
    (ref.func $func-4)
  ))

  ;; CHECK:      (func $test (type $none_=>_none)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.get $vtable $v1
  ;; CHECK-NEXT:    (global.get $vtable)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.get $vtable $v2
  ;; CHECK-NEXT:    (global.get $vtable)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $test
    ;; To differ from previous tests, do not read the very first field.
    (drop
      (struct.get $vtable 1
        (global.get $vtable)
      )
    )
    ;; To differ from previous tests, do reads in two adjacent fields.
    (drop
      (struct.get $vtable 2
        (global.get $vtable)
      )
    )
    ;; To differ from previous tests, do not read the very last field, and the
    ;; one before it.
  )

  ;; CHECK:      (func $func-0 (type $none_=>_none)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  (func $func-0)
  ;; CHECK:      (func $func-1 (type $none_=>_none)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  (func $func-1)
  ;; CHECK:      (func $func-2 (type $none_=>_none)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  (func $func-2)
  ;; CHECK:      (func $func-3 (type $none_=>_none)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  (func $func-3)
  ;; CHECK:      (func $func-4 (type $none_=>_none)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  (func $func-4)
)

(module
  ;; Similar to the above, but with different types in each field, to verify
  ;; that we emit valid code and are not confused by the names being right
  ;; by coincidence.


  ;; CHECK:      (type $vtable (struct_subtype (field $v1 i64) (field $v2 f32) data))
  (type $vtable (struct_subtype (field $v0 i32) (field $v1 i64) (field $v2 f32) (field $v3 f64) (field $v4 anyref) data))

  ;; CHECK:      (type $none_=>_none (func_subtype func))

  ;; CHECK:      (global $vtable (ref $vtable) (struct.new $vtable
  ;; CHECK-NEXT:  (i64.const 1)
  ;; CHECK-NEXT:  (f32.const 2.200000047683716)
  ;; CHECK-NEXT: ))
  (global $vtable (ref $vtable) (struct.new $vtable
    (i32.const 0)
    (i64.const 1)
    (f32.const 2.2)
    (f64.const 3.3)
    (ref.null data)
  ))

  ;; CHECK:      (func $test (type $none_=>_none)
  ;; CHECK-NEXT:  (local $i64 i64)
  ;; CHECK-NEXT:  (local $f32 f32)
  ;; CHECK-NEXT:  (local.set $i64
  ;; CHECK-NEXT:   (struct.get $vtable $v1
  ;; CHECK-NEXT:    (global.get $vtable)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (local.set $f32
  ;; CHECK-NEXT:   (struct.get $vtable $v2
  ;; CHECK-NEXT:    (global.get $vtable)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $test
    (local $i64 i64)
    (local $f32 f32)
    (local.set $i64
      (struct.get $vtable 1
        (global.get $vtable)
      )
    )
    (local.set $f32
      (struct.get $vtable 2
        (global.get $vtable)
      )
    )
  )
)

(module
  ;; A new with side effects

  ;; CHECK:      (type $struct (struct_subtype (field i32) (field (rtt $struct)) data))
  (type $struct (struct i32 f64 (ref any) (rtt $struct)))


  ;; CHECK:      (type $none_=>_none (func_subtype func))

  ;; CHECK:      (type $ref|any|_=>_none (func_subtype (param (ref any)) func))

  ;; CHECK:      (type $i32_=>_i32 (func_subtype (param i32) (result i32) func))

  ;; CHECK:      (type $i32_=>_f64 (func_subtype (param i32) (result f64) func))

  ;; CHECK:      (type $i32_=>_ref|any| (func_subtype (param i32) (result (ref any)) func))

  ;; CHECK:      (global $imm-i32 i32 (i32.const 1234))
  (global $imm-i32 i32 (i32.const 1234))

  ;; CHECK:      (global $mut-i32 (mut i32) (i32.const 5678))
  (global $mut-i32 (mut i32) (i32.const 5678))

  ;; CHECK:      (func $gets (type $ref|any|_=>_none) (param $x (ref any))
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.get $struct 0
  ;; CHECK-NEXT:    (ref.null $struct)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.get $struct 1
  ;; CHECK-NEXT:    (ref.null $struct)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $gets (param $x (ref any))
    ;; Gets to keep certain fields alive.
    (drop
      (struct.get $struct 0
        (ref.null $struct)
      )
    )
    (drop
      (struct.get $struct 3
        (ref.null $struct)
      )
    )
  )

  ;; CHECK:      (func $new-side-effect (type $none_=>_none)
  ;; CHECK-NEXT:  (local $0 i32)
  ;; CHECK-NEXT:  (local $1 f64)
  ;; CHECK-NEXT:  (local $2 anyref)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (block (result (ref $struct))
  ;; CHECK-NEXT:    (local.set $0
  ;; CHECK-NEXT:     (call $helper0
  ;; CHECK-NEXT:      (i32.const 0)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (local.set $1
  ;; CHECK-NEXT:     (call $helper1
  ;; CHECK-NEXT:      (i32.const 1)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (local.set $2
  ;; CHECK-NEXT:     (call $helper2
  ;; CHECK-NEXT:      (i32.const 2)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (struct.new $struct
  ;; CHECK-NEXT:     (local.get $0)
  ;; CHECK-NEXT:     (rtt.canon $struct)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $new-side-effect
    ;; The 2nd&3rd fields here will be removed, since those fields have no
    ;; reads. They has side effects, though, so the operands will be saved in
    ;; locals. Note that we can't save the rtt.canon in locals, but it has
    ;; no effects, and we leave such arguments as they are.
    ;; Note also that one of the fields is non-nullable, and we need to use a
    ;; nullable local for it.
    (drop
      (struct.new $struct
        (call $helper0 (i32.const 0))
        (call $helper1 (i32.const 1))
        (call $helper2 (i32.const 2))
        (rtt.canon $struct)
      )
    )
  )

  ;; CHECK:      (func $new-side-effect-global-imm (type $none_=>_none)
  ;; CHECK-NEXT:  (local $0 f64)
  ;; CHECK-NEXT:  (local $1 anyref)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (block (result (ref $struct))
  ;; CHECK-NEXT:    (local.set $0
  ;; CHECK-NEXT:     (call $helper1
  ;; CHECK-NEXT:      (i32.const 0)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (local.set $1
  ;; CHECK-NEXT:     (call $helper2
  ;; CHECK-NEXT:      (i32.const 1)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (struct.new $struct
  ;; CHECK-NEXT:     (global.get $imm-i32)
  ;; CHECK-NEXT:     (rtt.canon $struct)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $new-side-effect-global-imm
    ;; As above, the 2nd&3rd fields here will be removed. The first field does
    ;; a global.get, which has effects, but those effects do not interact with
    ;; anything else (since it is an immutable global), so we do not need a
    ;; local for it.
    (drop
      (struct.new $struct
        (global.get $imm-i32)
        (call $helper1 (i32.const 0))
        (call $helper2 (i32.const 1))
        (rtt.canon $struct)
      )
    )
  )

  ;; CHECK:      (func $new-side-effect-global-mut (type $none_=>_none)
  ;; CHECK-NEXT:  (local $0 i32)
  ;; CHECK-NEXT:  (local $1 f64)
  ;; CHECK-NEXT:  (local $2 anyref)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (block (result (ref $struct))
  ;; CHECK-NEXT:    (local.set $0
  ;; CHECK-NEXT:     (global.get $mut-i32)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (local.set $1
  ;; CHECK-NEXT:     (call $helper1
  ;; CHECK-NEXT:      (i32.const 0)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (local.set $2
  ;; CHECK-NEXT:     (call $helper2
  ;; CHECK-NEXT:      (i32.const 1)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (struct.new $struct
  ;; CHECK-NEXT:     (local.get $0)
  ;; CHECK-NEXT:     (rtt.canon $struct)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $new-side-effect-global-mut
    ;; As above, but the global is mutable, so we will use a local: the calls
    ;; might alter that global, in theory.
    (drop
      (struct.new $struct
        (global.get $mut-i32)
        (call $helper1 (i32.const 0))
        (call $helper2 (i32.const 1))
        (rtt.canon $struct)
      )
    )
  )

  ;; CHECK:      (func $new-unreachable (type $none_=>_none)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (block ;; (replaces something unreachable we can't emit)
  ;; CHECK-NEXT:    (drop
  ;; CHECK-NEXT:     (i32.const 2)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (drop
  ;; CHECK-NEXT:     (unreachable)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (drop
  ;; CHECK-NEXT:     (call $helper2
  ;; CHECK-NEXT:      (i32.const 3)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (drop
  ;; CHECK-NEXT:     (rtt.canon $struct)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $new-unreachable
    ;; Another case with side effects. We stop at the unreachable param before
    ;; it, however.
    (drop
      (struct.new $struct
        (i32.const 2)
        (unreachable)
        (call $helper2 (i32.const 3))
        (rtt.canon $struct)
      )
    )
  )

  ;; CHECK:      (func $new-side-effect-in-kept (type $ref|any|_=>_none) (param $any (ref any))
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.new $struct
  ;; CHECK-NEXT:    (call $helper0
  ;; CHECK-NEXT:     (i32.const 0)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (rtt.canon $struct)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $new-side-effect-in-kept (param $any (ref any))
    ;; Side effects appear in fields that we do *not* remove. In that case,
    ;; we do not need to use locals.
    (drop
      (struct.new $struct
        (call $helper0 (i32.const 0))
        (f64.const 3.14159)
        (local.get $any)
        (rtt.canon $struct)
      )
    )
  )

  ;; CHECK:      (func $helper0 (type $i32_=>_i32) (param $x i32) (result i32)
  ;; CHECK-NEXT:  (unreachable)
  ;; CHECK-NEXT: )
  (func $helper0 (param $x i32) (result i32)
    (unreachable)
  )

  ;; CHECK:      (func $helper1 (type $i32_=>_f64) (param $x i32) (result f64)
  ;; CHECK-NEXT:  (unreachable)
  ;; CHECK-NEXT: )
  (func $helper1 (param $x i32) (result f64)
    (unreachable)
  )

  ;; CHECK:      (func $helper2 (type $i32_=>_ref|any|) (param $x i32) (result (ref any))
  ;; CHECK-NEXT:  (unreachable)
  ;; CHECK-NEXT: )
  (func $helper2 (param $x i32) (result (ref any))
    (unreachable)
  )
)

;; We can remove fields from the end if they are only used in subtypes, because
;; the subtypes can always add fields at the end (and only at the end).
(module
  ;; CHECK:      (type $parent (struct_subtype (field i32) (field i64) data))

  ;; CHECK:      (type $child (struct_subtype (field i32) (field i64) (field f32) (field f64) (field anyref) $parent))
  (type $child (struct_subtype (field i32) (field i64) (field f32) (field f64) (field anyref) $parent))

  (type $parent (struct_subtype (field i32) (field i64) (field f32) (field f64) data))

  ;; CHECK:      (type $ref|$parent|_ref|$child|_=>_none (func_subtype (param (ref $parent) (ref $child)) func))

  ;; CHECK:      (func $func (type $ref|$parent|_ref|$child|_=>_none) (param $x (ref $parent)) (param $y (ref $child))
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.get $parent 1
  ;; CHECK-NEXT:    (local.get $x)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.get $child 0
  ;; CHECK-NEXT:    (local.get $y)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.get $child 2
  ;; CHECK-NEXT:    (local.get $y)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.get $child 3
  ;; CHECK-NEXT:    (local.get $y)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.get $child 4
  ;; CHECK-NEXT:    (local.get $y)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $func (param $x (ref $parent)) (param $y (ref $child))
    ;; The parent has fields 0, 1, 2, 3 and the child adds 4.
    ;; Use fields only 1 in the parent, and all the rest in the child. We can
    ;; only remove from the end in the child, which means we can remove 2 and 3
    ;; in the parent, but not 0.
    (drop (struct.get $parent 1 (local.get $x)))
    (drop (struct.get $child  0 (local.get $y)))
    (drop (struct.get $child  2 (local.get $y)))
    (drop (struct.get $child  3 (local.get $y)))
    (drop (struct.get $child  4 (local.get $y)))
  )
)

(module
  ;; CHECK:      (type $parent (struct_subtype (field i32) (field i64) (field (mut f32)) data))

  ;; CHECK:      (type $child (struct_subtype (field i32) (field i64) (field (mut f32)) (field f64) (field anyref) $parent))
  (type $child (struct_subtype (field (mut i32)) (field (mut i64)) (field (mut f32)) (field (mut f64)) (field (mut anyref)) $parent))

  (type $parent (struct_subtype (field (mut i32)) (field (mut i64)) (field (mut f32)) (field (mut f64)) data))

  ;; CHECK:      (type $ref|$parent|_ref|$child|_=>_none (func_subtype (param (ref $parent) (ref $child)) func))

  ;; CHECK:      (func $func (type $ref|$parent|_ref|$child|_=>_none) (param $x (ref $parent)) (param $y (ref $child))
  ;; CHECK-NEXT:  (struct.set $parent 2
  ;; CHECK-NEXT:   (local.get $x)
  ;; CHECK-NEXT:   (f32.const 0)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.get $parent 1
  ;; CHECK-NEXT:    (local.get $x)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.get $child 0
  ;; CHECK-NEXT:    (local.get $y)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.get $child 2
  ;; CHECK-NEXT:    (local.get $y)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.get $child 3
  ;; CHECK-NEXT:    (local.get $y)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.get $child 4
  ;; CHECK-NEXT:    (local.get $y)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $func (param $x (ref $parent)) (param $y (ref $child))
    ;; As above, but add a write in the parent of field 2. That prevents us from
    ;; removing it from the parent.
    (struct.set $parent 2 (local.get $x) (f32.const 0))

    (drop (struct.get $parent 1 (local.get $x)))
    (drop (struct.get $child  0 (local.get $y)))
    (drop (struct.get $child  2 (local.get $y)))
    (drop (struct.get $child  3 (local.get $y)))
    (drop (struct.get $child  4 (local.get $y)))
  )
)

;; A parent with two children, and there are only reads of the parent. Those
;; reads might be of data of either child, of course (as a refernce to the
;; parent might point to them), so we cannot optimize here.
(module
  ;; CHECK:      (type $parent (struct_subtype (field i32) data))
  (type $parent (struct_subtype (field i32) data))
  ;; CHECK:      (type $ref|$parent|_ref|$child1|_ref|$child2|_=>_none (func_subtype (param (ref $parent) (ref $child1) (ref $child2)) func))

  ;; CHECK:      (type $child1 (struct_subtype (field i32) $parent))
  (type $child1 (struct_subtype (field i32) $parent))
  ;; CHECK:      (type $child2 (struct_subtype (field i32) $parent))
  (type $child2 (struct_subtype (field i32) $parent))

  ;; CHECK:      (func $func (type $ref|$parent|_ref|$child1|_ref|$child2|_=>_none) (param $parent (ref $parent)) (param $child1 (ref $child1)) (param $child2 (ref $child2))
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.get $parent 0
  ;; CHECK-NEXT:    (local.get $parent)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $func (param $parent (ref $parent)) (param $child1 (ref $child1)) (param $child2 (ref $child2))
    (drop (struct.get $parent 0 (local.get $parent)))
  )
)

;; As above, but now the read is just of one child. We can remove the field
;; from the parent and the other child.
(module
  ;; CHECK:      (type $parent (struct_subtype  data))

  ;; CHECK:      (type $child1 (struct_subtype (field i32) $parent))
  (type $child1 (struct_subtype (field i32) $parent))

  (type $parent (struct_subtype (field i32) data))
  ;; CHECK:      (type $ref|$parent|_ref|$child1|_ref|$child2|_=>_none (func_subtype (param (ref $parent) (ref $child1) (ref $child2)) func))

  ;; CHECK:      (type $child2 (struct_subtype  $parent))
  (type $child2 (struct_subtype (field i32) $parent))

  ;; CHECK:      (func $func (type $ref|$parent|_ref|$child1|_ref|$child2|_=>_none) (param $parent (ref $parent)) (param $child1 (ref $child1)) (param $child2 (ref $child2))
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.get $child1 0
  ;; CHECK-NEXT:    (local.get $child1)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $func (param $parent (ref $parent)) (param $child1 (ref $child1)) (param $child2 (ref $child2))
    (drop (struct.get $child1 0 (local.get $child1)))
  )
)

(module
  ;; CHECK:      (type ${mut:i8} (struct_subtype  data))
  (type ${mut:i8} (struct_subtype (field (mut i8)) data))

  ;; CHECK:      (type $none_=>_none (func_subtype func))

  ;; CHECK:      (type $none_=>_i32 (func_subtype (result i32) func))

  ;; CHECK:      (type $none_=>_ref|${mut:i8}| (func_subtype (result (ref ${mut:i8})) func))

  ;; CHECK:      (func $unreachable-set (type $none_=>_none)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (ref.as_non_null
  ;; CHECK-NEXT:    (block (result (ref null ${mut:i8}))
  ;; CHECK-NEXT:     (drop
  ;; CHECK-NEXT:      (call $helper-i32)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:     (ref.null ${mut:i8})
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $unreachable-set
    ;; The struct type has no reads, so we want to remove all of the sets of it.
    ;; This struct.set will trap on null, but first the call must run. When we
    ;; optimize here we should be careful to not emit something with different
    ;; ordering (naively emitting ref.as_non_null on the reference would trap
    ;; before the call, so we must reorder).
    (struct.set ${mut:i8} 0
      (ref.null ${mut:i8})
      (call $helper-i32)
    )
  )

  ;; CHECK:      (func $unreachable-set-2 (type $none_=>_none)
  ;; CHECK-NEXT:  (block $block
  ;; CHECK-NEXT:   (drop
  ;; CHECK-NEXT:    (ref.as_non_null
  ;; CHECK-NEXT:     (block (result (ref null ${mut:i8}))
  ;; CHECK-NEXT:      (drop
  ;; CHECK-NEXT:       (br $block)
  ;; CHECK-NEXT:      )
  ;; CHECK-NEXT:      (ref.null ${mut:i8})
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $unreachable-set-2
    ;; As above, but the side effects now are a br. Again, the br must happen
    ;; before the trap (in fact, the br will skip the trap here).
    (block
      (struct.set ${mut:i8} 0
        (ref.null ${mut:i8})
        (br $block)
      )
    )
  )

  ;; CHECK:      (func $unreachable-set-3 (type $none_=>_none)
  ;; CHECK-NEXT:  (local $0 (ref null ${mut:i8}))
  ;; CHECK-NEXT:  (block $block
  ;; CHECK-NEXT:   (drop
  ;; CHECK-NEXT:    (ref.as_non_null
  ;; CHECK-NEXT:     (block (result (ref ${mut:i8}))
  ;; CHECK-NEXT:      (local.set $0
  ;; CHECK-NEXT:       (call $helper-ref)
  ;; CHECK-NEXT:      )
  ;; CHECK-NEXT:      (drop
  ;; CHECK-NEXT:       (call $helper-i32)
  ;; CHECK-NEXT:      )
  ;; CHECK-NEXT:      (ref.as_non_null
  ;; CHECK-NEXT:       (local.get $0)
  ;; CHECK-NEXT:      )
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $unreachable-set-3
    ;; As above, but now we have side effects in both children.
    (block
      (struct.set ${mut:i8} 0
        (call $helper-ref)
        (call $helper-i32)
      )
    )
  )

  ;; CHECK:      (func $helper-i32 (type $none_=>_i32) (result i32)
  ;; CHECK-NEXT:  (i32.const 1)
  ;; CHECK-NEXT: )
  (func $helper-i32 (result i32)
    (i32.const 1)
  )

  ;; CHECK:      (func $helper-ref (type $none_=>_ref|${mut:i8}|) (result (ref ${mut:i8}))
  ;; CHECK-NEXT:  (unreachable)
  ;; CHECK-NEXT: )
  (func $helper-ref (result (ref ${mut:i8}))
    (unreachable)
  )
)
