;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.
;; RUN: foreach %s %t wasm-opt --nominal --cfp -all -S -o - | filecheck %s

(module
  ;; CHECK:      (type $none_=>_none (func))

  ;; CHECK:      (type $default-created (struct (field i64)))

  ;; CHECK:      (type $value-created (struct (field f32)))

  ;; CHECK:      (type $never-created (struct (field i32)))
  (type $never-created (struct i32))

  (type $default-created (struct i64))

  (type $value-created (struct f32))

  ;; CHECK:      (func $impossible-get
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (block
  ;; CHECK-NEXT:    (drop
  ;; CHECK-NEXT:     (ref.null $never-created)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (unreachable)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $impossible-get
    (drop
      ;; This type is never created, so a get is impossible, and we will emit a
      ;; trap.
      (struct.get $never-created 0
        (ref.null $never-created)
      )
    )
  )

  ;; CHECK:      (func $default-created
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.new_default_with_rtt $default-created
  ;; CHECK-NEXT:    (rtt.canon $default-created)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (block (result i64)
  ;; CHECK-NEXT:    (drop
  ;; CHECK-NEXT:     (ref.as_non_null
  ;; CHECK-NEXT:      (ref.null $default-created)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (i64.const 0)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $default-created
    ;; The only place this type is created is with a default value.
    ;; (Note that the allocated reference is dropped here; this pass only looks
    ;; for a creation at all.)
    (drop
      (struct.new_default_with_rtt $default-created
        (rtt.canon $default-created)
      )
    )
    (drop
      (struct.get $default-created 0
        (ref.null $default-created)
      )
    )
  )

  ;; CHECK:      (func $value-created
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.new_with_rtt $value-created
  ;; CHECK-NEXT:    (f32.const 42)
  ;; CHECK-NEXT:    (rtt.canon $value-created)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (block (result f32)
  ;; CHECK-NEXT:    (drop
  ;; CHECK-NEXT:     (ref.as_non_null
  ;; CHECK-NEXT:      (ref.null $value-created)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (f32.const 42)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $value-created
    ;; The only place this type is created is with a value value.
    ;; (Note that the allocated reference is dropped here; this pass only looks
    ;; for a creation at all.)
    (drop
      (struct.new_with_rtt $value-created
        (f32.const 42)
        (rtt.canon $value-created)
      )
    )
    (drop
      (struct.get $value-created 0
        (ref.null $value-created)
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
