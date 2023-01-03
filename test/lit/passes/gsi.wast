;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.
;; RUN: foreach %s %t wasm-opt --nominal --gsi -all -S -o - | filecheck %s

(module
  ;; CHECK:      (type $struct (struct (field i32)))
  (type $struct (struct i32))

  ;; CHECK:      (type $ref?|$struct|_=>_none (func (param (ref null $struct))))

  ;; CHECK:      (global $global1 (ref $struct) (struct.new $struct
  ;; CHECK-NEXT:  (i32.const 42)
  ;; CHECK-NEXT: ))
  (global $global1 (ref $struct) (struct.new $struct
    (i32.const 42)
  ))

  ;; CHECK:      (global $global2 (ref $struct) (struct.new $struct
  ;; CHECK-NEXT:  (i32.const 1337)
  ;; CHECK-NEXT: ))
  (global $global2 (ref $struct) (struct.new $struct
    (i32.const 1337)
  ))

  ;; A non-reference global does not confuse us.
  ;; CHECK:      (global $global-other i32 (i32.const 123456))
  (global $global-other i32 (i32.const 123456))

  ;; CHECK:      (func $test (type $ref?|$struct|_=>_none) (param $struct (ref null $struct))
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (select
  ;; CHECK-NEXT:    (i32.const 42)
  ;; CHECK-NEXT:    (i32.const 1337)
  ;; CHECK-NEXT:    (ref.eq
  ;; CHECK-NEXT:     (ref.as_non_null
  ;; CHECK-NEXT:      (local.get $struct)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:     (global.get $global1)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $test (param $struct (ref null $struct))
    ;; We can infer that this get can reference either $global1 or $global2,
    ;; and nothing else (aside from a null), and can emit a select between
    ;; those values.
    (drop
      (struct.get $struct 0
        (local.get $struct)
      )
    )
  )
)

;; As above, but now the field is mutable, so we cannot optimize.
(module
  ;; CHECK:      (type $struct (struct (field (mut i32))))
  (type $struct (struct (mut i32)))

  ;; CHECK:      (type $ref?|$struct|_=>_none (func (param (ref null $struct))))

  ;; CHECK:      (global $global1 (ref $struct) (struct.new $struct
  ;; CHECK-NEXT:  (i32.const 42)
  ;; CHECK-NEXT: ))
  (global $global1 (ref $struct) (struct.new $struct
    (i32.const 42)
  ))

  ;; CHECK:      (global $global2 (ref $struct) (struct.new $struct
  ;; CHECK-NEXT:  (i32.const 1337)
  ;; CHECK-NEXT: ))
  (global $global2 (ref $struct) (struct.new $struct
    (i32.const 1337)
  ))

  ;; CHECK:      (func $test (type $ref?|$struct|_=>_none) (param $struct (ref null $struct))
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.get $struct 0
  ;; CHECK-NEXT:    (local.get $struct)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $test (param $struct (ref null $struct))
    (drop
      (struct.get $struct 0
        (local.get $struct)
      )
    )
  )
)

;; Just one global.
(module
  ;; CHECK:      (type $struct1 (struct (field i32)))
  (type $struct1 (struct i32))

  ;; CHECK:      (type $struct2 (struct (field i32)))
  (type $struct2 (struct i32))

  ;; CHECK:      (type $ref?|$struct1|_ref?|$struct2|_=>_none (func (param (ref null $struct1) (ref null $struct2))))

  ;; CHECK:      (import "a" "b" (global $imported i32))
  (import "a" "b" (global $imported i32))

  ;; CHECK:      (global $global1 (ref $struct1) (struct.new $struct1
  ;; CHECK-NEXT:  (global.get $imported)
  ;; CHECK-NEXT: ))
  (global $global1 (ref $struct1) (struct.new $struct1
    (global.get $imported)
  ))

  ;; CHECK:      (global $global2 (ref $struct2) (struct.new $struct2
  ;; CHECK-NEXT:  (i32.const 42)
  ;; CHECK-NEXT: ))
  (global $global2 (ref $struct2) (struct.new $struct2
    (i32.const 42)
  ))

  ;; CHECK:      (func $test1 (type $ref?|$struct1|_ref?|$struct2|_=>_none) (param $struct1 (ref null $struct1)) (param $struct2 (ref null $struct2))
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.get $struct1 0
  ;; CHECK-NEXT:    (block (result (ref $struct1))
  ;; CHECK-NEXT:     (drop
  ;; CHECK-NEXT:      (ref.as_non_null
  ;; CHECK-NEXT:       (local.get $struct1)
  ;; CHECK-NEXT:      )
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:     (global.get $global1)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.get $struct2 0
  ;; CHECK-NEXT:    (block (result (ref $struct2))
  ;; CHECK-NEXT:     (drop
  ;; CHECK-NEXT:      (ref.as_non_null
  ;; CHECK-NEXT:       (local.get $struct2)
  ;; CHECK-NEXT:      )
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:     (global.get $global2)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $test1 (param $struct1 (ref null $struct1)) (param $struct2 (ref null $struct2))
    ;; We can infer that this get must reference $global1 and make the reference
    ;; point to that. Note that we do not infer the value of 42 here, but leave
    ;; it for other passes to do.
    (drop
      (struct.get $struct1 0
        (local.get $struct1)
      )
    )
    ;; Even though the value here is not known at compile time - it reads an
    ;; imported global - we can still infer that we are reading from $global2.
    (drop
      (struct.get $struct2 0
        (local.get $struct2)
      )
    )
  )
)

;; Three globals. For now, we do not optimize here.
(module
  ;; CHECK:      (type $struct (struct (field i32)))
  (type $struct (struct i32))

  ;; CHECK:      (type $ref?|$struct|_=>_none (func (param (ref null $struct))))

  ;; CHECK:      (global $global1 (ref $struct) (struct.new $struct
  ;; CHECK-NEXT:  (i32.const 42)
  ;; CHECK-NEXT: ))
  (global $global1 (ref $struct) (struct.new $struct
    (i32.const 42)
  ))

  ;; CHECK:      (global $global2 (ref $struct) (struct.new $struct
  ;; CHECK-NEXT:  (i32.const 1337)
  ;; CHECK-NEXT: ))
  (global $global2 (ref $struct) (struct.new $struct
    (i32.const 1337)
  ))

  ;; CHECK:      (global $global3 (ref $struct) (struct.new $struct
  ;; CHECK-NEXT:  (i32.const 99999)
  ;; CHECK-NEXT: ))
  (global $global3 (ref $struct) (struct.new $struct
    (i32.const 99999)
  ))

  ;; CHECK:      (func $test (type $ref?|$struct|_=>_none) (param $struct (ref null $struct))
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.get $struct 0
  ;; CHECK-NEXT:    (local.get $struct)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $test (param $struct (ref null $struct))
    (drop
      (struct.get $struct 0
        (local.get $struct)
      )
    )
  )
)

;; Three globals, as above, but now two agree on their values. We can optimize
;; by comparing to the one that has a single value.
(module
  ;; CHECK:      (type $struct (struct (field i32)))
  (type $struct (struct i32))

  ;; CHECK:      (type $ref?|$struct|_=>_none (func (param (ref null $struct))))

  ;; CHECK:      (global $global1 (ref $struct) (struct.new $struct
  ;; CHECK-NEXT:  (i32.const 42)
  ;; CHECK-NEXT: ))
  (global $global1 (ref $struct) (struct.new $struct
    (i32.const 42)
  ))

  ;; CHECK:      (global $global2 (ref $struct) (struct.new $struct
  ;; CHECK-NEXT:  (i32.const 1337)
  ;; CHECK-NEXT: ))
  (global $global2 (ref $struct) (struct.new $struct
    (i32.const 1337)
  ))

  ;; CHECK:      (global $global3 (ref $struct) (struct.new $struct
  ;; CHECK-NEXT:  (i32.const 1337)
  ;; CHECK-NEXT: ))
  (global $global3 (ref $struct) (struct.new $struct
    (i32.const 1337)
  ))

  ;; CHECK:      (func $test (type $ref?|$struct|_=>_none) (param $struct (ref null $struct))
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (select
  ;; CHECK-NEXT:    (i32.const 42)
  ;; CHECK-NEXT:    (i32.const 1337)
  ;; CHECK-NEXT:    (ref.eq
  ;; CHECK-NEXT:     (ref.as_non_null
  ;; CHECK-NEXT:      (local.get $struct)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:     (global.get $global1)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $test (param $struct (ref null $struct))
    (drop
      (struct.get $struct 0
        (local.get $struct)
      )
    )
  )
)

;; As above, but move the different value of the three to the middle.
(module
  ;; CHECK:      (type $struct (struct (field i32)))
  (type $struct (struct i32))

  ;; CHECK:      (type $ref?|$struct|_=>_none (func (param (ref null $struct))))

  ;; CHECK:      (global $global1 (ref $struct) (struct.new $struct
  ;; CHECK-NEXT:  (i32.const 1337)
  ;; CHECK-NEXT: ))
  (global $global1 (ref $struct) (struct.new $struct
    (i32.const 1337)
  ))

  ;; CHECK:      (global $global2 (ref $struct) (struct.new $struct
  ;; CHECK-NEXT:  (i32.const 42)
  ;; CHECK-NEXT: ))
  (global $global2 (ref $struct) (struct.new $struct
    (i32.const 42)
  ))

  ;; CHECK:      (global $global3 (ref $struct) (struct.new $struct
  ;; CHECK-NEXT:  (i32.const 1337)
  ;; CHECK-NEXT: ))
  (global $global3 (ref $struct) (struct.new $struct
    (i32.const 1337)
  ))

  ;; CHECK:      (func $test (type $ref?|$struct|_=>_none) (param $struct (ref null $struct))
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (select
  ;; CHECK-NEXT:    (i32.const 42)
  ;; CHECK-NEXT:    (i32.const 1337)
  ;; CHECK-NEXT:    (ref.eq
  ;; CHECK-NEXT:     (ref.as_non_null
  ;; CHECK-NEXT:      (local.get $struct)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:     (global.get $global2)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $test (param $struct (ref null $struct))
    (drop
      (struct.get $struct 0
        (local.get $struct)
      )
    )
  )
)

;; As above, but move the different value of the three to the end.
(module
  ;; CHECK:      (type $struct (struct (field i32)))
  (type $struct (struct i32))

  ;; CHECK:      (type $ref?|$struct|_=>_none (func (param (ref null $struct))))

  ;; CHECK:      (global $global1 (ref $struct) (struct.new $struct
  ;; CHECK-NEXT:  (i32.const 1337)
  ;; CHECK-NEXT: ))
  (global $global1 (ref $struct) (struct.new $struct
    (i32.const 1337)
  ))

  ;; CHECK:      (global $global2 (ref $struct) (struct.new $struct
  ;; CHECK-NEXT:  (i32.const 1337)
  ;; CHECK-NEXT: ))
  (global $global2 (ref $struct) (struct.new $struct
    (i32.const 1337)
  ))

  ;; CHECK:      (global $global3 (ref $struct) (struct.new $struct
  ;; CHECK-NEXT:  (i32.const 42)
  ;; CHECK-NEXT: ))
  (global $global3 (ref $struct) (struct.new $struct
    (i32.const 42)
  ))

  ;; CHECK:      (func $test (type $ref?|$struct|_=>_none) (param $struct (ref null $struct))
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (select
  ;; CHECK-NEXT:    (i32.const 42)
  ;; CHECK-NEXT:    (i32.const 1337)
  ;; CHECK-NEXT:    (ref.eq
  ;; CHECK-NEXT:     (ref.as_non_null
  ;; CHECK-NEXT:      (local.get $struct)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:     (global.get $global3)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $test (param $struct (ref null $struct))
    (drop
      (struct.get $struct 0
        (local.get $struct)
      )
    )
  )
)

;; Four values, two pairs of equal ones. We do not optimize this.
(module
  ;; CHECK:      (type $struct (struct (field i32)))
  (type $struct (struct i32))

  ;; CHECK:      (type $ref?|$struct|_=>_none (func (param (ref null $struct))))

  ;; CHECK:      (global $global1 (ref $struct) (struct.new $struct
  ;; CHECK-NEXT:  (i32.const 42)
  ;; CHECK-NEXT: ))
  (global $global1 (ref $struct) (struct.new $struct
    (i32.const 42)
  ))

  ;; CHECK:      (global $global2 (ref $struct) (struct.new $struct
  ;; CHECK-NEXT:  (i32.const 42)
  ;; CHECK-NEXT: ))
  (global $global2 (ref $struct) (struct.new $struct
    (i32.const 42)
  ))

  ;; CHECK:      (global $global3 (ref $struct) (struct.new $struct
  ;; CHECK-NEXT:  (i32.const 1337)
  ;; CHECK-NEXT: ))
  (global $global3 (ref $struct) (struct.new $struct
    (i32.const 1337)
  ))

  ;; CHECK:      (global $global4 (ref $struct) (struct.new $struct
  ;; CHECK-NEXT:  (i32.const 1337)
  ;; CHECK-NEXT: ))
  (global $global4 (ref $struct) (struct.new $struct
    (i32.const 1337)
  ))

  ;; CHECK:      (func $test (type $ref?|$struct|_=>_none) (param $struct (ref null $struct))
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.get $struct 0
  ;; CHECK-NEXT:    (local.get $struct)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $test (param $struct (ref null $struct))
    (drop
      (struct.get $struct 0
        (local.get $struct)
      )
    )
  )
)

;; Four values, three equal and one unique. We can optimize this with a single
;; comparison on the unique one.
(module
  ;; CHECK:      (type $struct (struct (field i32)))
  (type $struct (struct i32))

  ;; CHECK:      (type $ref?|$struct|_=>_none (func (param (ref null $struct))))

  ;; CHECK:      (global $global1 (ref $struct) (struct.new $struct
  ;; CHECK-NEXT:  (i32.const 42)
  ;; CHECK-NEXT: ))
  (global $global1 (ref $struct) (struct.new $struct
    (i32.const 42)
  ))

  ;; CHECK:      (global $global2 (ref $struct) (struct.new $struct
  ;; CHECK-NEXT:  (i32.const 42)
  ;; CHECK-NEXT: ))
  (global $global2 (ref $struct) (struct.new $struct
    (i32.const 42)
  ))

  ;; CHECK:      (global $global3 (ref $struct) (struct.new $struct
  ;; CHECK-NEXT:  (i32.const 1337)
  ;; CHECK-NEXT: ))
  (global $global3 (ref $struct) (struct.new $struct
    (i32.const 1337)
  ))

  ;; CHECK:      (global $global4 (ref $struct) (struct.new $struct
  ;; CHECK-NEXT:  (i32.const 42)
  ;; CHECK-NEXT: ))
  (global $global4 (ref $struct) (struct.new $struct
    (i32.const 42)
  ))

  ;; CHECK:      (func $test (type $ref?|$struct|_=>_none) (param $struct (ref null $struct))
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (select
  ;; CHECK-NEXT:    (i32.const 1337)
  ;; CHECK-NEXT:    (i32.const 42)
  ;; CHECK-NEXT:    (ref.eq
  ;; CHECK-NEXT:     (ref.as_non_null
  ;; CHECK-NEXT:      (local.get $struct)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:     (global.get $global3)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $test (param $struct (ref null $struct))
    (drop
      (struct.get $struct 0
        (local.get $struct)
      )
    )
  )
)

;; A struct.new inside a function stops us from optimizing.
(module
  ;; CHECK:      (type $struct (struct (field i32)))
  (type $struct (struct i32))

  ;; CHECK:      (type $ref?|$struct|_=>_none (func (param (ref null $struct))))

  ;; CHECK:      (global $global1 (ref $struct) (struct.new $struct
  ;; CHECK-NEXT:  (i32.const 42)
  ;; CHECK-NEXT: ))
  (global $global1 (ref $struct) (struct.new $struct
    (i32.const 42)
  ))

  ;; CHECK:      (global $global2 (ref $struct) (struct.new $struct
  ;; CHECK-NEXT:  (i32.const 1337)
  ;; CHECK-NEXT: ))
  (global $global2 (ref $struct) (struct.new $struct
    (i32.const 1337)
  ))

  ;; CHECK:      (func $test (type $ref?|$struct|_=>_none) (param $struct (ref null $struct))
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.new $struct
  ;; CHECK-NEXT:    (i32.const 1)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.get $struct 0
  ;; CHECK-NEXT:    (local.get $struct)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $test (param $struct (ref null $struct))
    (drop
      (struct.new $struct
        (i32.const 1)
      )
    )
    (drop
      (struct.get $struct 0
        (local.get $struct)
      )
    )
  )
)

;; We ignore imports, as we assume a closed world, but that might change in the
;; future. For now, we will optimize here.
(module
  ;; CHECK:      (type $struct (struct (field i32)))
  (type $struct (struct i32))

  ;; CHECK:      (type $ref?|$struct|_=>_none (func (param (ref null $struct))))

  ;; CHECK:      (import "a" "b" (global $global-import (ref $struct)))
  (import "a" "b" (global $global-import (ref $struct)))

  ;; CHECK:      (global $global1 (ref $struct) (struct.new $struct
  ;; CHECK-NEXT:  (i32.const 42)
  ;; CHECK-NEXT: ))
  (global $global1 (ref $struct) (struct.new $struct
    (i32.const 42)
  ))

  ;; CHECK:      (global $global2 (ref $struct) (struct.new $struct
  ;; CHECK-NEXT:  (i32.const 1337)
  ;; CHECK-NEXT: ))
  (global $global2 (ref $struct) (struct.new $struct
    (i32.const 1337)
  ))

  ;; CHECK:      (func $test (type $ref?|$struct|_=>_none) (param $struct (ref null $struct))
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (select
  ;; CHECK-NEXT:    (i32.const 42)
  ;; CHECK-NEXT:    (i32.const 1337)
  ;; CHECK-NEXT:    (ref.eq
  ;; CHECK-NEXT:     (ref.as_non_null
  ;; CHECK-NEXT:      (local.get $struct)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:     (global.get $global1)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $test (param $struct (ref null $struct))
    (drop
      (struct.get $struct 0
        (local.get $struct)
      )
    )
  )
)

;; A struct.new in a non-toplevel position in a global stops us from
;; optimizing.
(module
  ;; CHECK:      (type $struct (struct (field i32)))
  (type $struct (struct i32))

  ;; CHECK:      (type $tuple (struct (field anyref) (field anyref)))
  (type $tuple (struct anyref anyref))

  ;; CHECK:      (type $ref?|$struct|_=>_none (func (param (ref null $struct))))

  ;; CHECK:      (global $global1 (ref $struct) (struct.new $struct
  ;; CHECK-NEXT:  (i32.const 42)
  ;; CHECK-NEXT: ))
  (global $global1 (ref $struct) (struct.new $struct
    (i32.const 42)
  ))

  ;; CHECK:      (global $global2 (ref $struct) (struct.new $struct
  ;; CHECK-NEXT:  (i32.const 1337)
  ;; CHECK-NEXT: ))
  (global $global2 (ref $struct) (struct.new $struct
    (i32.const 1337)
  ))

  ;; CHECK:      (global $global-tuple (ref $tuple) (struct.new $tuple
  ;; CHECK-NEXT:  (struct.new $struct
  ;; CHECK-NEXT:   (i32.const 999999)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (ref.null none)
  ;; CHECK-NEXT: ))
  (global $global-tuple (ref $tuple) (struct.new $tuple
    (struct.new $struct
      (i32.const 999999)
    )
    (ref.null any)
  ))

  ;; CHECK:      (func $test (type $ref?|$struct|_=>_none) (param $struct (ref null $struct))
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.get $struct 0
  ;; CHECK-NEXT:    (local.get $struct)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $test (param $struct (ref null $struct))
    (drop
      (struct.get $struct 0
        (local.get $struct)
      )
    )
  )
)

;; As above, but remove the struct.new in a nested position, while keeping all
;; the other stuff in the above test. Now we should optimize.
(module
  ;; CHECK:      (type $struct (struct (field i32)))
  (type $struct (struct i32))

  ;; CHECK:      (type $tuple (struct (field anyref) (field anyref)))
  (type $tuple (struct anyref anyref))

  ;; CHECK:      (type $ref?|$struct|_=>_none (func (param (ref null $struct))))

  ;; CHECK:      (global $global1 (ref $struct) (struct.new $struct
  ;; CHECK-NEXT:  (i32.const 42)
  ;; CHECK-NEXT: ))
  (global $global1 (ref $struct) (struct.new $struct
    (i32.const 42)
  ))

  ;; CHECK:      (global $global2 (ref $struct) (struct.new $struct
  ;; CHECK-NEXT:  (i32.const 1337)
  ;; CHECK-NEXT: ))
  (global $global2 (ref $struct) (struct.new $struct
    (i32.const 1337)
  ))

  ;; CHECK:      (global $global-tuple (ref $tuple) (struct.new $tuple
  ;; CHECK-NEXT:  (ref.null none)
  ;; CHECK-NEXT:  (ref.null none)
  ;; CHECK-NEXT: ))
  (global $global-tuple (ref $tuple) (struct.new $tuple
    (ref.null any)
    (ref.null any)
  ))

  ;; CHECK:      (func $test (type $ref?|$struct|_=>_none) (param $struct (ref null $struct))
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (select
  ;; CHECK-NEXT:    (i32.const 42)
  ;; CHECK-NEXT:    (i32.const 1337)
  ;; CHECK-NEXT:    (ref.eq
  ;; CHECK-NEXT:     (ref.as_non_null
  ;; CHECK-NEXT:      (local.get $struct)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:     (global.get $global1)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $test (param $struct (ref null $struct))
    (drop
      (struct.get $struct 0
        (local.get $struct)
      )
    )
  )
)

;; When one of the globals is mutable, we cannot optimize.
(module
  ;; CHECK:      (type $struct (struct (field i32)))
  (type $struct (struct i32))

  ;; CHECK:      (type $ref?|$struct|_=>_none (func (param (ref null $struct))))

  ;; CHECK:      (global $global1 (ref $struct) (struct.new $struct
  ;; CHECK-NEXT:  (i32.const 42)
  ;; CHECK-NEXT: ))
  (global $global1 (ref $struct) (struct.new $struct
    (i32.const 42)
  ))

  ;; CHECK:      (global $global2 (mut (ref $struct)) (struct.new $struct
  ;; CHECK-NEXT:  (i32.const 1337)
  ;; CHECK-NEXT: ))
  (global $global2 (mut (ref $struct)) (struct.new $struct
    (i32.const 1337)
  ))

  ;; CHECK:      (func $test (type $ref?|$struct|_=>_none) (param $struct (ref null $struct))
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.get $struct 0
  ;; CHECK-NEXT:    (local.get $struct)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $test (param $struct (ref null $struct))
    (drop
      (struct.get $struct 0
        (local.get $struct)
      )
    )
  )
)

;; A subtype is not optimizable, which prevents $struct from being optimized.
(module
  ;; CHECK:      (type $struct (struct (field i32)))
  (type $struct (struct_subtype i32 data))

  ;; CHECK:      (type $ref?|$struct|_=>_none (func (param (ref null $struct))))

  ;; CHECK:      (type $sub-struct (struct_subtype (field i32) $struct))
  (type $sub-struct (struct_subtype i32 $struct))

  ;; CHECK:      (global $global1 (ref $struct) (struct.new $struct
  ;; CHECK-NEXT:  (i32.const 42)
  ;; CHECK-NEXT: ))
  (global $global1 (ref $struct) (struct.new $struct
    (i32.const 42)
  ))

  ;; CHECK:      (global $global2 (ref $struct) (struct.new $struct
  ;; CHECK-NEXT:  (i32.const 1337)
  ;; CHECK-NEXT: ))
  (global $global2 (ref $struct) (struct.new $struct
    (i32.const 1337)
  ))

  ;; CHECK:      (func $test (type $ref?|$struct|_=>_none) (param $struct (ref null $struct))
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.new $sub-struct
  ;; CHECK-NEXT:    (i32.const 999999)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.get $struct 0
  ;; CHECK-NEXT:    (local.get $struct)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $test (param $struct (ref null $struct))
    (drop
      (struct.new $sub-struct
        (i32.const 999999)
      )
    )
    (drop
      (struct.get $struct 0
        (local.get $struct)
      )
    )
  )
)

;; As above, but add a global for the subtype. The supertype is still not
;; optimizable.
(module
  ;; CHECK:      (type $struct (struct (field i32)))
  (type $struct (struct_subtype i32 data))

  ;; CHECK:      (type $sub-struct (struct_subtype (field i32) $struct))
  (type $sub-struct (struct_subtype i32 $struct))

  ;; CHECK:      (type $ref?|$struct|_=>_none (func (param (ref null $struct))))

  ;; CHECK:      (global $global1 (ref $struct) (struct.new $struct
  ;; CHECK-NEXT:  (i32.const 42)
  ;; CHECK-NEXT: ))
  (global $global1 (ref $struct) (struct.new $struct
    (i32.const 42)
  ))

  ;; CHECK:      (global $global2 (ref $struct) (struct.new $struct
  ;; CHECK-NEXT:  (i32.const 1337)
  ;; CHECK-NEXT: ))
  (global $global2 (ref $struct) (struct.new $struct
    (i32.const 1337)
  ))

  ;; CHECK:      (global $global3 (ref $sub-struct) (struct.new $sub-struct
  ;; CHECK-NEXT:  (i32.const 56789)
  ;; CHECK-NEXT: ))
  (global $global3 (ref $sub-struct) (struct.new $sub-struct
    (i32.const 56789) ;; this global is new compared to before
  ))

  ;; CHECK:      (func $test (type $ref?|$struct|_=>_none) (param $struct (ref null $struct))
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.new $sub-struct
  ;; CHECK-NEXT:    (i32.const 999999)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.get $struct 0
  ;; CHECK-NEXT:    (local.get $struct)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $test (param $struct (ref null $struct))
    (drop
      (struct.new $sub-struct
        (i32.const 999999)
      )
    )
    (drop
      (struct.get $struct 0
        (local.get $struct)
      )
    )
  )
)

;; A *super*-type is not optimizable, but that does not block us, and we can
;; optimize.
(module
  ;; CHECK:      (type $super-struct (struct (field i32)))
  (type $super-struct (struct_subtype i32 data))

  ;; CHECK:      (type $struct (struct_subtype (field i32) $super-struct))
  (type $struct (struct_subtype i32 $super-struct))

  ;; CHECK:      (type $ref?|$struct|_=>_none (func (param (ref null $struct))))

  ;; CHECK:      (global $global1 (ref $struct) (struct.new $struct
  ;; CHECK-NEXT:  (i32.const 42)
  ;; CHECK-NEXT: ))
  (global $global1 (ref $struct) (struct.new $struct
    (i32.const 42)
  ))

  ;; CHECK:      (global $global2 (ref $struct) (struct.new $struct
  ;; CHECK-NEXT:  (i32.const 1337)
  ;; CHECK-NEXT: ))
  (global $global2 (ref $struct) (struct.new $struct
    (i32.const 1337)
  ))

  ;; CHECK:      (func $test (type $ref?|$struct|_=>_none) (param $struct (ref null $struct))
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.new $super-struct
  ;; CHECK-NEXT:    (i32.const 999999)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (select
  ;; CHECK-NEXT:    (i32.const 42)
  ;; CHECK-NEXT:    (i32.const 1337)
  ;; CHECK-NEXT:    (ref.eq
  ;; CHECK-NEXT:     (ref.as_non_null
  ;; CHECK-NEXT:      (local.get $struct)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:     (global.get $global1)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $test (param $struct (ref null $struct))
    (drop
      (struct.new $super-struct
        (i32.const 999999)
      )
    )
    (drop
      (struct.get $struct 0
        (local.get $struct)
      )
    )
  )
)

;; One global for each of the type and the subtype. The optimization will pick
;; between their 2 values.
(module
  ;; CHECK:      (type $super-struct (struct (field i32)))
  (type $super-struct (struct_subtype i32 data))

  ;; CHECK:      (type $struct (struct_subtype (field i32) $super-struct))
  (type $struct (struct_subtype i32 $super-struct))

  ;; CHECK:      (type $ref?|$struct|_ref?|$super-struct|_=>_none (func (param (ref null $struct) (ref null $super-struct))))

  ;; CHECK:      (global $global1 (ref $super-struct) (struct.new $super-struct
  ;; CHECK-NEXT:  (i32.const 42)
  ;; CHECK-NEXT: ))
  (global $global1 (ref $super-struct) (struct.new $super-struct
    (i32.const 42)
  ))

  ;; CHECK:      (global $global2 (ref $struct) (struct.new $struct
  ;; CHECK-NEXT:  (i32.const 1337)
  ;; CHECK-NEXT: ))
  (global $global2 (ref $struct) (struct.new $struct
    (i32.const 1337)
  ))

  ;; CHECK:      (func $test (type $ref?|$struct|_ref?|$super-struct|_=>_none) (param $struct (ref null $struct)) (param $super-struct (ref null $super-struct))
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.get $struct 0
  ;; CHECK-NEXT:    (block (result (ref $struct))
  ;; CHECK-NEXT:     (drop
  ;; CHECK-NEXT:      (ref.as_non_null
  ;; CHECK-NEXT:       (local.get $struct)
  ;; CHECK-NEXT:      )
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:     (global.get $global2)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (select
  ;; CHECK-NEXT:    (i32.const 42)
  ;; CHECK-NEXT:    (i32.const 1337)
  ;; CHECK-NEXT:    (ref.eq
  ;; CHECK-NEXT:     (ref.as_non_null
  ;; CHECK-NEXT:      (local.get $super-struct)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:     (global.get $global1)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $test (param $struct (ref null $struct)) (param $super-struct (ref null $super-struct))
    ;; The first has just one global, which we switch the reference to, while
    ;; the second will consider the struct and sub-struct, find 2 possible
    ;; values, and optimize.
    (drop
      (struct.get $struct 0
        (local.get $struct)
      )
    )
    (drop
      (struct.get $super-struct 0
        (local.get $super-struct)
      )
    )
  )
)

;; One global has a non-constant field, so we cannot optimize.
(module
  ;; CHECK:      (type $struct (struct (field i32)))
  (type $struct (struct i32))

  ;; CHECK:      (type $ref?|$struct|_=>_none (func (param (ref null $struct))))

  ;; CHECK:      (global $global1 (ref $struct) (struct.new $struct
  ;; CHECK-NEXT:  (i32.add
  ;; CHECK-NEXT:   (i32.const 41)
  ;; CHECK-NEXT:   (i32.const 1)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: ))
  (global $global1 (ref $struct) (struct.new $struct
    (i32.add
      (i32.const 41)
      (i32.const 1)
    )
  ))

  ;; CHECK:      (global $global2 (ref $struct) (struct.new $struct
  ;; CHECK-NEXT:  (i32.const 1337)
  ;; CHECK-NEXT: ))
  (global $global2 (ref $struct) (struct.new $struct
    (i32.const 1337)
  ))

  ;; CHECK:      (func $test (type $ref?|$struct|_=>_none) (param $struct (ref null $struct))
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.get $struct 0
  ;; CHECK-NEXT:    (local.get $struct)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $test (param $struct (ref null $struct))
    (drop
      (struct.get $struct 0
        (local.get $struct)
      )
    )
  )
)

;; One global each for two subtypes of a common supertype, and one for the
;; supertype.
(module
  ;; CHECK:      (type $super-struct (struct (field i32)))
  (type $super-struct (struct_subtype i32 data))

  ;; CHECK:      (type $struct1 (struct_subtype (field i32) (field f32) $super-struct))
  (type $struct1 (struct_subtype i32 f32 $super-struct))

  ;; CHECK:      (type $struct2 (struct_subtype (field i32) (field f64) $super-struct))
  (type $struct2 (struct_subtype i32 f64 $super-struct))


  ;; CHECK:      (type $ref?|$super-struct|_ref?|$struct1|_ref?|$struct2|_=>_none (func (param (ref null $super-struct) (ref null $struct1) (ref null $struct2))))

  ;; CHECK:      (global $global0 (ref $super-struct) (struct.new $super-struct
  ;; CHECK-NEXT:  (i32.const 42)
  ;; CHECK-NEXT: ))
  (global $global0 (ref $super-struct) (struct.new $super-struct
    (i32.const 42)
  ))

  ;; CHECK:      (global $global1 (ref $struct1) (struct.new $struct1
  ;; CHECK-NEXT:  (i32.const 1337)
  ;; CHECK-NEXT:  (f32.const 3.141590118408203)
  ;; CHECK-NEXT: ))
  (global $global1 (ref $struct1) (struct.new $struct1
    (i32.const 1337)
    (f32.const 3.14159)
  ))

  ;; CHECK:      (global $global2 (ref $struct2) (struct.new $struct2
  ;; CHECK-NEXT:  (i32.const 99999)
  ;; CHECK-NEXT:  (f64.const 2.71828)
  ;; CHECK-NEXT: ))
  (global $global2 (ref $struct2) (struct.new $struct2
    (i32.const 99999)
    (f64.const 2.71828)
  ))

  ;; CHECK:      (func $test (type $ref?|$super-struct|_ref?|$struct1|_ref?|$struct2|_=>_none) (param $super-struct (ref null $super-struct)) (param $struct1 (ref null $struct1)) (param $struct2 (ref null $struct2))
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.get $super-struct 0
  ;; CHECK-NEXT:    (local.get $super-struct)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.get $struct1 0
  ;; CHECK-NEXT:    (block (result (ref $struct1))
  ;; CHECK-NEXT:     (drop
  ;; CHECK-NEXT:      (ref.as_non_null
  ;; CHECK-NEXT:       (local.get $struct1)
  ;; CHECK-NEXT:      )
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:     (global.get $global1)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.get $struct2 0
  ;; CHECK-NEXT:    (block (result (ref $struct2))
  ;; CHECK-NEXT:     (drop
  ;; CHECK-NEXT:      (ref.as_non_null
  ;; CHECK-NEXT:       (local.get $struct2)
  ;; CHECK-NEXT:      )
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:     (global.get $global2)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $test (param $super-struct (ref null $super-struct)) (param $struct1 (ref null $struct1)) (param $struct2 (ref null $struct2))
    ;; This has three possible values due to the two children, so we do not
    ;; optimize.
    (drop
      (struct.get $super-struct 0
        (local.get $super-struct)
      )
    )
    ;; These each have one possible value, which we can switch the references
    ;; to.
    (drop
      (struct.get $struct1 0
        (local.get $struct1)
      )
    )
    (drop
      (struct.get $struct2 0
        (local.get $struct2)
      )
    )
  )
)

;; As above, but now the subtypes each have 2 values, and we can optimize.
(module
  ;; CHECK:      (type $super-struct (struct (field i32)))
  (type $super-struct (struct_subtype i32 data))

  ;; CHECK:      (type $struct1 (struct_subtype (field i32) (field f32) $super-struct))
  (type $struct1 (struct_subtype i32 f32 $super-struct))

  ;; CHECK:      (type $struct2 (struct_subtype (field i32) (field f64) $super-struct))
  (type $struct2 (struct_subtype i32 f64 $super-struct))


  ;; CHECK:      (type $ref?|$super-struct|_ref?|$struct1|_ref?|$struct2|_=>_none (func (param (ref null $super-struct) (ref null $struct1) (ref null $struct2))))

  ;; CHECK:      (global $global0 (ref $super-struct) (struct.new $super-struct
  ;; CHECK-NEXT:  (i32.const 42)
  ;; CHECK-NEXT: ))
  (global $global0 (ref $super-struct) (struct.new $super-struct
    (i32.const 42)
  ))

  ;; CHECK:      (global $global1 (ref $struct1) (struct.new $struct1
  ;; CHECK-NEXT:  (i32.const 1337)
  ;; CHECK-NEXT:  (f32.const 3.141590118408203)
  ;; CHECK-NEXT: ))
  (global $global1 (ref $struct1) (struct.new $struct1
    (i32.const 1337)
    (f32.const 3.14159)
  ))

  ;; CHECK:      (global $global1b (ref $struct1) (struct.new $struct1
  ;; CHECK-NEXT:  (i32.const 1338)
  ;; CHECK-NEXT:  (f32.const 3.141590118408203)
  ;; CHECK-NEXT: ))
  (global $global1b (ref $struct1) (struct.new $struct1
    (i32.const 1338)
    (f32.const 3.14159)
  ))

  ;; CHECK:      (global $global2 (ref $struct2) (struct.new $struct2
  ;; CHECK-NEXT:  (i32.const 99999)
  ;; CHECK-NEXT:  (f64.const 2.71828)
  ;; CHECK-NEXT: ))
  (global $global2 (ref $struct2) (struct.new $struct2
    (i32.const 99999)
    (f64.const 2.71828)
  ))

  ;; CHECK:      (global $global2b (ref $struct2) (struct.new $struct2
  ;; CHECK-NEXT:  (i32.const 99998)
  ;; CHECK-NEXT:  (f64.const 2.71828)
  ;; CHECK-NEXT: ))
  (global $global2b (ref $struct2) (struct.new $struct2
    (i32.const 99998)
    (f64.const 2.71828)
  ))

  ;; CHECK:      (func $test (type $ref?|$super-struct|_ref?|$struct1|_ref?|$struct2|_=>_none) (param $super-struct (ref null $super-struct)) (param $struct1 (ref null $struct1)) (param $struct2 (ref null $struct2))
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.get $super-struct 0
  ;; CHECK-NEXT:    (local.get $super-struct)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (select
  ;; CHECK-NEXT:    (i32.const 1337)
  ;; CHECK-NEXT:    (i32.const 1338)
  ;; CHECK-NEXT:    (ref.eq
  ;; CHECK-NEXT:     (ref.as_non_null
  ;; CHECK-NEXT:      (local.get $struct1)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:     (global.get $global1)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (select
  ;; CHECK-NEXT:    (i32.const 99999)
  ;; CHECK-NEXT:    (i32.const 99998)
  ;; CHECK-NEXT:    (ref.eq
  ;; CHECK-NEXT:     (ref.as_non_null
  ;; CHECK-NEXT:      (local.get $struct2)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:     (global.get $global2)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $test (param $super-struct (ref null $super-struct)) (param $struct1 (ref null $struct1)) (param $struct2 (ref null $struct2))
    ;; This still cannot be optimized.
    (drop
      (struct.get $super-struct 0
        (local.get $super-struct)
      )
    )
    ;; These can be optimized, and will be different from one another.
    (drop
      (struct.get $struct1 0
        (local.get $struct1)
      )
    )
    (drop
      (struct.get $struct2 0
        (local.get $struct2)
      )
    )
  )
)

;; Multiple globals, but all the same value, so we do not even need a select and
;; can just apply the value.
(module
  ;; CHECK:      (type $struct (struct (field i32)))
  (type $struct (struct i32))

  ;; CHECK:      (type $ref?|$struct|_=>_none (func (param (ref null $struct))))

  ;; CHECK:      (global $global1 (ref $struct) (struct.new $struct
  ;; CHECK-NEXT:  (i32.const 42)
  ;; CHECK-NEXT: ))
  (global $global1 (ref $struct) (struct.new $struct
    (i32.const 42)
  ))

  ;; CHECK:      (global $global2 (ref $struct) (struct.new $struct
  ;; CHECK-NEXT:  (i32.const 42)
  ;; CHECK-NEXT: ))
  (global $global2 (ref $struct) (struct.new $struct
    (i32.const 42)
  ))

  ;; CHECK:      (func $test (type $ref?|$struct|_=>_none) (param $struct (ref null $struct))
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (block (result i32)
  ;; CHECK-NEXT:    (drop
  ;; CHECK-NEXT:     (ref.as_non_null
  ;; CHECK-NEXT:      (local.get $struct)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (i32.const 42)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $test (param $struct (ref null $struct))
    (drop
      (struct.get $struct 0
        (local.get $struct)
      )
    )
  )
)

;; One global is declared as heap type |any|, which we cannot do a ref.eq on, so
;; we do not optimize.
(module
  ;; CHECK:      (type $A (struct (field i32)))
  (type $A (struct (field i32)))

  ;; CHECK:      (type $ref?|$A|_=>_i32 (func (param (ref null $A)) (result i32)))

  ;; CHECK:      (global $A0 (ref any) (struct.new $A
  ;; CHECK-NEXT:  (i32.const 1337)
  ;; CHECK-NEXT: ))
  (global $A0 (ref any) (struct.new $A
    (i32.const 1337)
  ))

  ;; CHECK:      (global $A1 (ref $A) (struct.new $A
  ;; CHECK-NEXT:  (i32.const 9999)
  ;; CHECK-NEXT: ))
  (global $A1 (ref $A) (struct.new $A
    (i32.const 9999)
  ))

  ;; CHECK:      (func $func (type $ref?|$A|_=>_i32) (param $ref (ref null $A)) (result i32)
  ;; CHECK-NEXT:  (struct.get $A 0
  ;; CHECK-NEXT:   (local.get $ref)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $func (param $ref (ref null $A)) (result i32)
    (struct.get $A 0
      (local.get $ref)
    )
  )
)

;; As above, but now there is just a single global. Again, we should not
;; optimize because the global is not declared as a struct type (which means we
;; cannot do a struct.get on a global.get of that global - we'd need a cast; it
;; is simpler to not optimize here and let other passes first refine the global
;; type).
(module
  ;; CHECK:      (type $A (struct (field i32)))
  (type $A (struct (field i32)))

  ;; CHECK:      (type $ref?|$A|_=>_i32 (func (param (ref null $A)) (result i32)))

  ;; CHECK:      (global $A0 (ref any) (struct.new $A
  ;; CHECK-NEXT:  (i32.const 1337)
  ;; CHECK-NEXT: ))
  (global $A0 (ref any) (struct.new $A
    (i32.const 1337)
  ))

  ;; CHECK:      (func $func (type $ref?|$A|_=>_i32) (param $ref (ref null $A)) (result i32)
  ;; CHECK-NEXT:  (struct.get $A 0
  ;; CHECK-NEXT:   (local.get $ref)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $func (param $ref (ref null $A)) (result i32)
    (struct.get $A 0
      (local.get $ref)
    )
  )
)

(module
  ;; CHECK:      (type $A (struct (field i32)))
  (type $A (struct (field i32)))

  ;; CHECK:      (type $ref?|$A|_=>_i32 (func (param (ref null $A)) (result i32)))

  ;; CHECK:      (global $A0 (ref $A) (struct.new $A
  ;; CHECK-NEXT:  (i32.const 1337)
  ;; CHECK-NEXT: ))
  (global $A0 (ref $A) (struct.new $A
    (i32.const 1337)
  ))

  ;; CHECK:      (func $func (type $ref?|$A|_=>_i32) (param $ref (ref null $A)) (result i32)
  ;; CHECK-NEXT:  (block ;; (replaces something unreachable we can't emit)
  ;; CHECK-NEXT:   (drop
  ;; CHECK-NEXT:    (ref.null none)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (unreachable)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $func (param $ref (ref null $A)) (result i32)
    ;; Test that we do not error when we see a struct.get of a bottom type.
    (struct.get $A 0
      (ref.null none)
    )
  )
)
