;; NOTE: Assertions have been generated by update_lit_checks.py and should not be edited.
;; RUN: wasm-opt %s --remove-unused-brs -all -S -o - \
;; RUN:  | filecheck %s

(module
 ;; CHECK:      (type $struct (struct ))
 (type $struct (struct ))

 ;; CHECK:      (func $br_on_non_i31-1 (type $none_=>_none)
 ;; CHECK-NEXT:  (drop
 ;; CHECK-NEXT:   (block $any (result (ref null $struct))
 ;; CHECK-NEXT:    (drop
 ;; CHECK-NEXT:     (br $any
 ;; CHECK-NEXT:      (struct.new_default $struct)
 ;; CHECK-NEXT:     )
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:    (ref.null none)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $br_on_non_i31-1
  (drop
   (block $any (result anyref)
    (drop
     ;; An struct is not an i31, and so we should branch.
     (br_on_non_i31 $any
      (struct.new $struct)
     )
    )
    (ref.null any)
   )
  )
 )
 ;; CHECK:      (func $br_on_non_i31-2 (type $none_=>_none)
 ;; CHECK-NEXT:  (drop
 ;; CHECK-NEXT:   (block $any (result nullref)
 ;; CHECK-NEXT:    (drop
 ;; CHECK-NEXT:     (i31.new
 ;; CHECK-NEXT:      (i32.const 0)
 ;; CHECK-NEXT:     )
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:    (ref.null none)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $br_on_non_i31-2
  (drop
   (block $any (result anyref)
    (drop
     ;; An i31 is provided here, and so we will not branch.
     (br_on_non_i31 $any
      (i31.new (i32.const 0))
     )
    )
    (ref.null any)
   )
  )
 )

 ;; CHECK:      (func $br_on-if (type $ref|data|_=>_none) (param $0 (ref data))
 ;; CHECK-NEXT:  (block $label
 ;; CHECK-NEXT:   (drop
 ;; CHECK-NEXT:    (select (result (ref data))
 ;; CHECK-NEXT:     (local.get $0)
 ;; CHECK-NEXT:     (local.get $0)
 ;; CHECK-NEXT:     (i32.const 0)
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $br_on-if (param $0 (ref struct))
  (block $label
   (drop
    ;; This br is never taken, as the input is non-nullable, so we can remove
    ;; it. When we do so, we replace it with the if. We should not rescan that
    ;; if, which has already been walked, as that would hit an assertion.
    ;;
    (br_on_null $label
     ;; This if can also be turned into a select, separately from the above
     ;; (that is not specifically intended to be tested here).
     (if (result (ref struct))
      (i32.const 0)
      (local.get $0)
      (local.get $0)
     )
    )
   )
  )
 )

 ;; CHECK:      (func $nested_br_on (type $none_=>_i31ref) (result i31ref)
 ;; CHECK-NEXT:  (block $label$1 (result (ref i31))
 ;; CHECK-NEXT:   (drop
 ;; CHECK-NEXT:    (br $label$1
 ;; CHECK-NEXT:     (i31.new
 ;; CHECK-NEXT:      (i32.const 0)
 ;; CHECK-NEXT:     )
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (unreachable)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $nested_br_on (result i31ref)
  (block $label$1 (result i31ref)
   (drop
    ;; The inner br_on_i31 will become a direct br since the type proves it
    ;; is in fact data. That then becomes unreachable, and the parent must
    ;; handle that properly (do nothing without hitting an assertion).
    (br_on_i31 $label$1
     (br_on_i31 $label$1
      (i31.new (i32.const 0))
     )
    )
   )
   (unreachable)
  )
 )

 ;; CHECK:      (func $br_on_cast (type $none_=>_ref|$struct|) (result (ref $struct))
 ;; CHECK-NEXT:  (local $temp (ref null $struct))
 ;; CHECK-NEXT:  (block $block (result (ref $struct))
 ;; CHECK-NEXT:   (drop
 ;; CHECK-NEXT:    (br $block
 ;; CHECK-NEXT:     (struct.new_default $struct)
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (unreachable)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $br_on_cast (result (ref $struct))
  (local $temp (ref null $struct))
  (block $block (result (ref $struct))
   (drop
    ;; This static cast can be computed at compile time: it will definitely be
    ;; taken, so we can turn it into a normal br.
    (br_on_cast $block $struct
     (struct.new $struct)
    )
   )
   (unreachable)
  )
 )

 ;; CHECK:      (func $br_on_cast_no (type $none_=>_ref|$struct|) (result (ref $struct))
 ;; CHECK-NEXT:  (local $temp (ref null $struct))
 ;; CHECK-NEXT:  (block $block (result (ref $struct))
 ;; CHECK-NEXT:   (drop
 ;; CHECK-NEXT:    (br_on_cast $block $struct
 ;; CHECK-NEXT:     (ref.null none)
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (unreachable)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $br_on_cast_no (result (ref $struct))
  (local $temp (ref null $struct))
  (block $block (result (ref $struct))
   (drop
    (br_on_cast $block $struct
     ;; As above, but now the type is nullable, so we cannot infer anything.
     (ref.null $struct)
    )
   )
   (unreachable)
  )
 )

 ;; CHECK:      (func $br_on_cast_fail (type $none_=>_ref|$struct|) (result (ref $struct))
 ;; CHECK-NEXT:  (local $temp (ref null $struct))
 ;; CHECK-NEXT:  (block $block
 ;; CHECK-NEXT:   (drop
 ;; CHECK-NEXT:    (struct.new_default $struct)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (unreachable)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $br_on_cast_fail (result (ref $struct))
  (local $temp (ref null $struct))
  (block $block (result (ref $struct))
   (drop
    ;; As $br_on_cast, but this checks for a failing cast, so we know it will
    ;; *not* be taken.
    (br_on_cast_fail $block $struct
     (struct.new $struct)
    )
   )
   (unreachable)
  )
 )

 ;; CHECK:      (func $casts-are-costly (type $i32_=>_none) (param $x i32)
 ;; CHECK-NEXT:  (drop
 ;; CHECK-NEXT:   (if (result i32)
 ;; CHECK-NEXT:    (local.get $x)
 ;; CHECK-NEXT:    (ref.test $struct
 ;; CHECK-NEXT:     (ref.null none)
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:    (i32.const 0)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT:  (drop
 ;; CHECK-NEXT:   (if (result anyref)
 ;; CHECK-NEXT:    (local.get $x)
 ;; CHECK-NEXT:    (ref.null none)
 ;; CHECK-NEXT:    (ref.cast $struct
 ;; CHECK-NEXT:     (ref.null none)
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT:  (drop
 ;; CHECK-NEXT:   (if (result anyref)
 ;; CHECK-NEXT:    (local.get $x)
 ;; CHECK-NEXT:    (block $something (result anyref)
 ;; CHECK-NEXT:     (drop
 ;; CHECK-NEXT:      (br_on_cast $something $struct
 ;; CHECK-NEXT:       (ref.null none)
 ;; CHECK-NEXT:      )
 ;; CHECK-NEXT:     )
 ;; CHECK-NEXT:     (ref.null none)
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:    (ref.null none)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT:  (drop
 ;; CHECK-NEXT:   (select (result anyref)
 ;; CHECK-NEXT:    (block (result anyref)
 ;; CHECK-NEXT:     (block $nothing
 ;; CHECK-NEXT:      (drop
 ;; CHECK-NEXT:       (br_on_null $nothing
 ;; CHECK-NEXT:        (ref.null none)
 ;; CHECK-NEXT:       )
 ;; CHECK-NEXT:      )
 ;; CHECK-NEXT:     )
 ;; CHECK-NEXT:     (ref.null none)
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:    (ref.null none)
 ;; CHECK-NEXT:    (local.get $x)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $casts-are-costly (param $x i32)
  ;; We never turn an if into a select if an arm has a cast of any kind, as
  ;; those things involve branches internally, so we'd be adding more than we
  ;; save.
  (drop
   (if (result i32)
    (local.get $x)
    (ref.test $struct
     (ref.null any)
    )
    (i32.const 0)
   )
  )
  (drop
   (if (result anyref)
    (local.get $x)
    (ref.null any)
    (ref.cast $struct
     (ref.null any)
    )
   )
  )
  (drop
   (if (result anyref)
    (local.get $x)
    (block (result anyref)
     (block $something (result anyref)
      (drop
       (br_on_cast $something $struct
        (ref.null $struct)
       )
      )
      (ref.null any)
     )
    )
    (ref.null any)
   )
  )
  ;; However, null checks are fairly fast, and we will emit a select here.
  (drop
   (if (result anyref)
    (local.get $x)
    (block (result anyref)
     (block $nothing
      (drop
       (br_on_null $nothing
        (ref.null $struct)
       )
      )
     )
     (ref.null any)
    )
    (ref.null any)
   )
  )
 )
)
