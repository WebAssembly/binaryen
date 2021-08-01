;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.
;; RUN: foreach %s %t wasm-opt --nominal --cfp -all -S -o - | filecheck %s

(module
  ;; CHECK:      (type $none_=>_none (func))

  ;; CHECK:      (type $struct (struct (field i32)))
  (type $struct (struct i32))
  ;; CHECK:      (func $impossible-get
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (block
  ;; CHECK-NEXT:    (drop
  ;; CHECK-NEXT:     (ref.null $struct)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (unreachable)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $impossible-get
    (drop
      ;; This type is never created, so a get is impossible, and we will trap
      ;; anyhow. So we can turn this into an unreachable.
      (struct.get $struct 0
        (ref.null $struct)
      )
    )
  )
)

(module
  ;; CHECK:      (type $struct (struct (field i64)))
  (type $struct (struct i64))
  ;; CHECK:      (type $none_=>_none (func))

  ;; CHECK:      (func $test
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.new_default_with_rtt $struct
  ;; CHECK-NEXT:    (rtt.canon $struct)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (block (result i64)
  ;; CHECK-NEXT:    (drop
  ;; CHECK-NEXT:     (ref.as_non_null
  ;; CHECK-NEXT:      (ref.null $struct)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (i64.const 0)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $test
    ;; The only place this type is created is with a default value.
    ;; (Note that the allocated reference is dropped here; this pass only looks
    ;; for a creation at all.)
    (drop
      (struct.new_default_with_rtt $struct
        (rtt.canon $struct)
      )
    )
    (drop
      (struct.get $struct 0
        (ref.null $struct)
      )
    )
  )
)

(module
  ;; CHECK:      (type $struct (struct (field f32)))
  (type $struct (struct f32))
  ;; CHECK:      (type $none_=>_none (func))

  ;; CHECK:      (func $test
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.new_with_rtt $struct
  ;; CHECK-NEXT:    (f32.const 42)
  ;; CHECK-NEXT:    (rtt.canon $struct)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (block (result f32)
  ;; CHECK-NEXT:    (drop
  ;; CHECK-NEXT:     (ref.as_non_null
  ;; CHECK-NEXT:      (ref.null $struct)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (f32.const 42)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $test
    ;; The only place this type is created is with a value value.
    ;; (Note that the allocated reference is dropped here; this pass only looks
    ;; for a creation at all.)
    (drop
      (struct.new_with_rtt $struct
        (f32.const 42)
        (rtt.canon $struct)
      )
    )
    (drop
      (struct.get $struct 0
        (ref.null $struct)
      )
    )
  )
)

(module
  ;; CHECK:      (type $struct (struct (field f32)))
  (type $struct (struct f32))
  ;; CHECK:      (type $f32_=>_none (func (param f32)))

  ;; CHECK:      (func $test (param $f f32)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.new_with_rtt $struct
  ;; CHECK-NEXT:    (local.get $f)
  ;; CHECK-NEXT:    (rtt.canon $struct)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.get $struct 0
  ;; CHECK-NEXT:    (ref.null $struct)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $test (param $f f32)
    ;; The value given is not a constant, and so we cannot optimize.
    (drop
      (struct.new_with_rtt $struct
        (local.get $f)
        (rtt.canon $struct)
      )
    )
    (drop
      (struct.get $struct 0
        (ref.null $struct)
      )
    )
  )
)

;; Create in one function, get in another. The 10 should be forwarded to the
;; get.
(module
  ;; CHECK:      (type $none_=>_none (func))

  ;; CHECK:      (type $struct (struct (field i32)))
  (type $struct (struct i32))
  ;; CHECK:      (func $create
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.new_with_rtt $struct
  ;; CHECK-NEXT:    (i32.const 10)
  ;; CHECK-NEXT:    (rtt.canon $struct)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $create
    (drop
      (struct.new_with_rtt $struct
        (i32.const 10)
        (rtt.canon $struct)
      )
    )
  )
  ;; CHECK:      (func $get
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (block (result i32)
  ;; CHECK-NEXT:    (drop
  ;; CHECK-NEXT:     (ref.as_non_null
  ;; CHECK-NEXT:      (ref.null $struct)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (i32.const 10)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $get
    (drop
      (struct.get $struct 0
        (ref.null $struct)
      )
    )
  )
)

;; As before, but with the order of functions reversed to check for any ordering
;; issues.
(module
  ;; CHECK:      (type $none_=>_none (func))

  ;; CHECK:      (type $struct (struct (field i32)))
  (type $struct (struct i32))

  ;; CHECK:      (func $get
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (block (result i32)
  ;; CHECK-NEXT:    (drop
  ;; CHECK-NEXT:     (ref.as_non_null
  ;; CHECK-NEXT:      (ref.null $struct)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (i32.const 10)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $get
    (drop
      (struct.get $struct 0
        (ref.null $struct)
      )
    )
  )

  ;; CHECK:      (func $create
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.new_with_rtt $struct
  ;; CHECK-NEXT:    (i32.const 10)
  ;; CHECK-NEXT:    (rtt.canon $struct)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $create
    (drop
      (struct.new_with_rtt $struct
        (i32.const 10)
        (rtt.canon $struct)
      )
    )
  )
)

;; Different values assigned in the same function, in different constructions,
;; so the struct.get must be retained as it is .
(module
  ;; CHECK:      (type $struct (struct (field f32)))
  (type $struct (struct f32))
  ;; CHECK:      (type $none_=>_none (func))

  ;; CHECK:      (func $test
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.new_with_rtt $struct
  ;; CHECK-NEXT:    (f32.const 42)
  ;; CHECK-NEXT:    (rtt.canon $struct)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.new_with_rtt $struct
  ;; CHECK-NEXT:    (f32.const 1337)
  ;; CHECK-NEXT:    (rtt.canon $struct)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.get $struct 0
  ;; CHECK-NEXT:    (ref.null $struct)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $test
    (drop
      (struct.new_with_rtt $struct
        (f32.const 42)
        (rtt.canon $struct)
      )
    )
    (drop
      (struct.new_with_rtt $struct
        (f32.const 1337)
        (rtt.canon $struct)
      )
    )
    (drop
      (struct.get $struct 0
        (ref.null $struct)
      )
    )
  )
)

;; Different values assigned in different functions, and one is a struct.set.
(module
  ;; CHECK:      (type $struct (struct (field (mut f32))))
  (type $struct (struct (mut f32)))
  ;; CHECK:      (type $none_=>_none (func))

  ;; CHECK:      (func $create
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.new_with_rtt $struct
  ;; CHECK-NEXT:    (f32.const 42)
  ;; CHECK-NEXT:    (rtt.canon $struct)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $create
    (drop
      (struct.new_with_rtt $struct
        (f32.const 42)
        (rtt.canon $struct)
      )
    )
  )
  ;; CHECK:      (func $set
  ;; CHECK-NEXT:  (struct.set $struct 0
  ;; CHECK-NEXT:   (ref.null $struct)
  ;; CHECK-NEXT:   (f32.const 1337)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $set
    (struct.set $struct 0
      (ref.null $struct)
      (f32.const 1337)
    )
  )
  ;; CHECK:      (func $get
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.get $struct 0
  ;; CHECK-NEXT:    (ref.null $struct)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $get
    (drop
      (struct.get $struct 0
        (ref.null $struct)
      )
    )
  )
)

;; As the last testcase, but the values happen to coincide, so we can optimize
;; the get into a constant.
(module
  ;; CHECK:      (type $struct (struct (field (mut f32))))
  (type $struct (struct (mut f32)))
  ;; CHECK:      (type $none_=>_none (func))

  ;; CHECK:      (func $create
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.new_with_rtt $struct
  ;; CHECK-NEXT:    (f32.const 42)
  ;; CHECK-NEXT:    (rtt.canon $struct)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $create
    (drop
      (struct.new_with_rtt $struct
        (f32.const 42)
        (rtt.canon $struct)
      )
    )
  )
  ;; CHECK:      (func $set
  ;; CHECK-NEXT:  (struct.set $struct 0
  ;; CHECK-NEXT:   (ref.null $struct)
  ;; CHECK-NEXT:   (f32.const 42)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $set
    (struct.set $struct 0
      (ref.null $struct)
      (f32.const 42) ;; The last testcase had 1337 here.
    )
  )
  ;; CHECK:      (func $get
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (block (result f32)
  ;; CHECK-NEXT:    (drop
  ;; CHECK-NEXT:     (ref.as_non_null
  ;; CHECK-NEXT:      (ref.null $struct)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (f32.const 42)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $get
    (drop
      (struct.get $struct 0
        (ref.null $struct)
      )
    )
  )
)

;; Test a function reference instead of a number.
(module
  ;; CHECK:      (type $none_=>_none (func))

  ;; CHECK:      (type $struct (struct (field funcref)))
  (type $struct (struct funcref))
  ;; CHECK:      (elem declare func $test)

  ;; CHECK:      (func $test
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.new_with_rtt $struct
  ;; CHECK-NEXT:    (ref.func $test)
  ;; CHECK-NEXT:    (rtt.canon $struct)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (block (result (ref $none_=>_none))
  ;; CHECK-NEXT:    (drop
  ;; CHECK-NEXT:     (ref.as_non_null
  ;; CHECK-NEXT:      (ref.null $struct)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (ref.func $test)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $test
    (drop
      (struct.new_with_rtt $struct
        (ref.func $test)
        (rtt.canon $struct)
      )
    )
    (drop
      (struct.get $struct 0
        (ref.null $struct)
      )
    )
  )
)

;; Test for unreachable creations, sets, and gets.
(module
  (type $struct (struct (mut i32)))
  ;; CHECK:      (type $none_=>_none (func))

  ;; CHECK:      (func $test
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (block
  ;; CHECK-NEXT:    (i32.const 10)
  ;; CHECK-NEXT:    (unreachable)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (block ;; (replaces something unreachable we can't emit)
  ;; CHECK-NEXT:    (drop
  ;; CHECK-NEXT:     (unreachable)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (block ;; (replaces something unreachable we can't emit)
  ;; CHECK-NEXT:   (drop
  ;; CHECK-NEXT:    (unreachable)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (drop
  ;; CHECK-NEXT:    (i32.const 20)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $test
    (drop
      (struct.new_with_rtt $struct
        (i32.const 10)
        (unreachable)
      )
    )
    (drop
      (struct.get $struct 0
        (unreachable)
      )
    )
    (struct.set $struct 0
      (unreachable)
      (i32.const 20)
    )
  )
)

;; Subtyping: Create a supertype and get a subtype. As we never create a
;;            subtype, the get must trap anyhow, and can be an unreachable.
(module
  ;; CHECK:      (type $none_=>_none (func))

  ;; CHECK:      (type $struct (struct (field i32)))
  (type $struct (struct i32))
  ;; CHECK:      (type $substruct (struct (field i32)) (extends $struct))
  (type $substruct (struct i32) (extends $struct))

  ;; CHECK:      (func $create
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.new_with_rtt $struct
  ;; CHECK-NEXT:    (i32.const 10)
  ;; CHECK-NEXT:    (rtt.canon $struct)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $create
    (drop
      (struct.new_with_rtt $struct
        (i32.const 10)
        (rtt.canon $struct)
      )
    )
  )
  ;; CHECK:      (func $get
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (block
  ;; CHECK-NEXT:    (drop
  ;; CHECK-NEXT:     (ref.null $substruct)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (unreachable)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $get
    (drop
      (struct.get $substruct 0
        (ref.null $substruct)
      )
    )
  )
)

;; Subtyping: Create a subtype and get a supertype. The get may be of a subtype
;;            instance was passed into a reference to the supertype. As in this
;;            case it is the only write, we can optimize it.
(module
  ;; CHECK:      (type $none_=>_none (func))

  ;; CHECK:      (type $struct (struct (field i32)))
  (type $struct (struct i32))
  ;; CHECK:      (type $substruct (struct (field i32) (field f64)) (extends $struct))
  (type $substruct (struct i32 f64) (extends $struct))

  ;; CHECK:      (func $create
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.new_with_rtt $substruct
  ;; CHECK-NEXT:    (i32.const 10)
  ;; CHECK-NEXT:    (f64.const 3.14159)
  ;; CHECK-NEXT:    (rtt.canon $substruct)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $create
    (drop
      (struct.new_with_rtt $substruct
        (i32.const 10)
        (f64.const 3.14159)
        (rtt.canon $substruct)
      )
    )
  )
  ;; CHECK:      (func $get
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (block (result i32)
  ;; CHECK-NEXT:    (drop
  ;; CHECK-NEXT:     (ref.as_non_null
  ;; CHECK-NEXT:      (ref.null $struct)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (i32.const 10)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $get
    (drop
      (struct.get $struct 0
        (ref.null $struct)
      )
    )
  )
)
