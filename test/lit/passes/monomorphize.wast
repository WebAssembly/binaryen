;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.

;; Test in both "always" mode, which always monomorphizes, and in "careful"
;; mode which does it only when it appears to actually help.

;; RUN: foreach %s %t wasm-opt --monomorphize-always -all -S -o - | filecheck %s --check-prefix ALWAYS
;; RUN: foreach %s %t wasm-opt --monomorphize        -all -S -o - | filecheck %s --check-prefix CAREFUL

(module
  ;; ALWAYS:      (type $A (sub (struct )))
  ;; CAREFUL:      (type $A (sub (struct )))
  (type $A (sub (struct)))
  ;; ALWAYS:      (type $B (sub $A (struct )))
  ;; CAREFUL:      (type $B (sub $A (struct )))
  (type $B (sub $A (struct)))

  ;; ALWAYS:      (type $2 (func (param (ref $A))))

  ;; ALWAYS:      (type $3 (func))

  ;; ALWAYS:      (type $4 (func (param (ref $B))))

  ;; ALWAYS:      (import "a" "b" (func $import (type $2) (param (ref $A))))
  ;; CAREFUL:      (type $2 (func (param (ref $A))))

  ;; CAREFUL:      (type $3 (func))

  ;; CAREFUL:      (import "a" "b" (func $import (type $2) (param (ref $A))))
  (import "a" "b" (func $import (param (ref $A))))

  ;; ALWAYS:      (func $calls (type $3)
  ;; ALWAYS-NEXT:  (call $refinable
  ;; ALWAYS-NEXT:   (struct.new_default $A)
  ;; ALWAYS-NEXT:  )
  ;; ALWAYS-NEXT:  (call $refinable
  ;; ALWAYS-NEXT:   (struct.new_default $A)
  ;; ALWAYS-NEXT:  )
  ;; ALWAYS-NEXT:  (call $refinable_4
  ;; ALWAYS-NEXT:   (struct.new_default $B)
  ;; ALWAYS-NEXT:  )
  ;; ALWAYS-NEXT:  (call $refinable_4
  ;; ALWAYS-NEXT:   (struct.new_default $B)
  ;; ALWAYS-NEXT:  )
  ;; ALWAYS-NEXT: )
  ;; CAREFUL:      (func $calls (type $3)
  ;; CAREFUL-NEXT:  (call $refinable
  ;; CAREFUL-NEXT:   (struct.new_default $A)
  ;; CAREFUL-NEXT:  )
  ;; CAREFUL-NEXT:  (call $refinable
  ;; CAREFUL-NEXT:   (struct.new_default $A)
  ;; CAREFUL-NEXT:  )
  ;; CAREFUL-NEXT:  (call $refinable
  ;; CAREFUL-NEXT:   (struct.new_default $B)
  ;; CAREFUL-NEXT:  )
  ;; CAREFUL-NEXT:  (call $refinable
  ;; CAREFUL-NEXT:   (struct.new_default $B)
  ;; CAREFUL-NEXT:  )
  ;; CAREFUL-NEXT: )
  (func $calls
    ;; Two calls with $A, two with $B. The calls to $B should both go to the
    ;; same new function which has a refined parameter of $B.
    ;;
    ;; However, in CAREFUL mode we won't do that, as there is no helpful
    ;; improvement in the target functions even with the refined types.
    (call $refinable
      (struct.new $A)
    )
    (call $refinable
      (struct.new $A)
    )
    (call $refinable
      (struct.new $B)
    )
    (call $refinable
      (struct.new $B)
    )
  )

  ;; ALWAYS:      (func $call-import (type $3)
  ;; ALWAYS-NEXT:  (call $import
  ;; ALWAYS-NEXT:   (struct.new_default $B)
  ;; ALWAYS-NEXT:  )
  ;; ALWAYS-NEXT: )
  ;; CAREFUL:      (func $call-import (type $3)
  ;; CAREFUL-NEXT:  (call $import
  ;; CAREFUL-NEXT:   (struct.new_default $B)
  ;; CAREFUL-NEXT:  )
  ;; CAREFUL-NEXT: )
  (func $call-import
    ;; Calls to imports are left as they are.
    (call $import
      (struct.new $B)
    )
  )

  ;; ALWAYS:      (func $refinable (type $2) (param $ref (ref $A))
  ;; ALWAYS-NEXT:  (drop
  ;; ALWAYS-NEXT:   (local.get $ref)
  ;; ALWAYS-NEXT:  )
  ;; ALWAYS-NEXT: )
  ;; CAREFUL:      (func $refinable (type $2) (param $0 (ref $A))
  ;; CAREFUL-NEXT:  (nop)
  ;; CAREFUL-NEXT: )
  (func $refinable (param $ref (ref $A))
    ;; Helper function for the above. Use the parameter to see we update types
    ;; etc when we make a refined version of the function (if we didn't,
    ;; validation would error).
    ;;
    ;; In CAREFUL mode we optimize to check if refined types help, which has the
    ;; side effect of optimizing the body of this function into a nop.
    (drop
      (local.get $ref)
    )
  )
)


;; ALWAYS:      (func $refinable_4 (type $4) (param $0 (ref $B))
;; ALWAYS-NEXT:  (local $ref (ref $A))
;; ALWAYS-NEXT:  (local.set $ref
;; ALWAYS-NEXT:   (local.get $0)
;; ALWAYS-NEXT:  )
;; ALWAYS-NEXT:  (drop
;; ALWAYS-NEXT:   (local.get $ref)
;; ALWAYS-NEXT:  )
;; ALWAYS-NEXT: )
(module
  ;; As above, but now the refinable function uses the local in a way that
  ;; requires a fixup.

  ;; ALWAYS:      (type $A (sub (struct )))
  ;; CAREFUL:      (type $0 (func))

  ;; CAREFUL:      (type $A (sub (struct )))
  (type $A (sub (struct)))
  ;; ALWAYS:      (type $B (sub $A (struct )))
  ;; CAREFUL:      (type $B (sub $A (struct )))
  (type $B (sub $A (struct)))



  ;; ALWAYS:      (type $2 (func))

  ;; ALWAYS:      (type $3 (func (param (ref $A))))

  ;; ALWAYS:      (type $4 (func (param (ref $B))))

  ;; ALWAYS:      (func $calls (type $2)
  ;; ALWAYS-NEXT:  (call $refinable_2
  ;; ALWAYS-NEXT:   (struct.new_default $B)
  ;; ALWAYS-NEXT:  )
  ;; ALWAYS-NEXT: )
  ;; CAREFUL:      (type $3 (func (param (ref $A))))

  ;; CAREFUL:      (func $calls (type $0)
  ;; CAREFUL-NEXT:  (call $refinable
  ;; CAREFUL-NEXT:   (struct.new_default $B)
  ;; CAREFUL-NEXT:  )
  ;; CAREFUL-NEXT: )
  (func $calls
    (call $refinable
      (struct.new $B)
    )
  )

  ;; ALWAYS:      (func $refinable (type $3) (param $ref (ref $A))
  ;; ALWAYS-NEXT:  (local $unref (ref $A))
  ;; ALWAYS-NEXT:  (local.set $unref
  ;; ALWAYS-NEXT:   (local.get $ref)
  ;; ALWAYS-NEXT:  )
  ;; ALWAYS-NEXT:  (local.set $ref
  ;; ALWAYS-NEXT:   (local.get $unref)
  ;; ALWAYS-NEXT:  )
  ;; ALWAYS-NEXT: )
  ;; CAREFUL:      (func $refinable (type $3) (param $0 (ref $A))
  ;; CAREFUL-NEXT:  (nop)
  ;; CAREFUL-NEXT: )
  (func $refinable (param $ref (ref $A))
    (local $unref (ref $A))
    (local.set $unref
      (local.get $ref)
    )
    ;; If we refine $ref then this set will be invalid - we'd be setting a less-
    ;; refined type into a local/param that is more refined. We should fix this
    ;; up by using a temp local.
    (local.set $ref
      (local.get $unref)
    )
  )
)


;; ALWAYS:      (func $refinable_2 (type $4) (param $0 (ref $B))
;; ALWAYS-NEXT:  (local $unref (ref $A))
;; ALWAYS-NEXT:  (local $ref (ref $A))
;; ALWAYS-NEXT:  (local.set $ref
;; ALWAYS-NEXT:   (local.get $0)
;; ALWAYS-NEXT:  )
;; ALWAYS-NEXT:  (block
;; ALWAYS-NEXT:   (local.set $unref
;; ALWAYS-NEXT:    (local.get $ref)
;; ALWAYS-NEXT:   )
;; ALWAYS-NEXT:   (local.set $ref
;; ALWAYS-NEXT:    (local.get $unref)
;; ALWAYS-NEXT:   )
;; ALWAYS-NEXT:  )
;; ALWAYS-NEXT: )
(module
  ;; Multiple refinings of the same function, and of different functions.

  ;; ALWAYS:      (type $A (sub (struct )))
  ;; CAREFUL:      (type $0 (func))

  ;; CAREFUL:      (type $A (sub (struct )))
  (type $A (sub (struct)))
  ;; ALWAYS:      (type $B (sub $A (struct )))
  ;; CAREFUL:      (type $B (sub $A (struct )))
  (type $B (sub $A (struct)))

  ;; ALWAYS:      (type $2 (func))

  ;; ALWAYS:      (type $C (sub $B (struct )))
  ;; CAREFUL:      (type $3 (func (param (ref $A))))

  ;; CAREFUL:      (type $C (sub $B (struct )))
  (type $C (sub $B (struct)))

  ;; ALWAYS:      (type $4 (func (param (ref $A))))

  ;; ALWAYS:      (type $5 (func (param (ref $B))))

  ;; ALWAYS:      (type $6 (func (param (ref $C))))

  ;; ALWAYS:      (func $calls1 (type $2)
  ;; ALWAYS-NEXT:  (call $refinable1
  ;; ALWAYS-NEXT:   (struct.new_default $A)
  ;; ALWAYS-NEXT:  )
  ;; ALWAYS-NEXT:  (call $refinable1_4
  ;; ALWAYS-NEXT:   (struct.new_default $B)
  ;; ALWAYS-NEXT:  )
  ;; ALWAYS-NEXT: )
  ;; CAREFUL:      (func $calls1 (type $0)
  ;; CAREFUL-NEXT:  (call $refinable1
  ;; CAREFUL-NEXT:   (struct.new_default $A)
  ;; CAREFUL-NEXT:  )
  ;; CAREFUL-NEXT:  (call $refinable1
  ;; CAREFUL-NEXT:   (struct.new_default $B)
  ;; CAREFUL-NEXT:  )
  ;; CAREFUL-NEXT: )
  (func $calls1
    (call $refinable1
      (struct.new $A)
    )
    (call $refinable1
      (struct.new $B)
    )
  )

  ;; ALWAYS:      (func $calls2 (type $2)
  ;; ALWAYS-NEXT:  (call $refinable1_5
  ;; ALWAYS-NEXT:   (struct.new_default $C)
  ;; ALWAYS-NEXT:  )
  ;; ALWAYS-NEXT:  (call $refinable2_6
  ;; ALWAYS-NEXT:   (struct.new_default $B)
  ;; ALWAYS-NEXT:  )
  ;; ALWAYS-NEXT: )
  ;; CAREFUL:      (func $calls2 (type $0)
  ;; CAREFUL-NEXT:  (call $refinable1
  ;; CAREFUL-NEXT:   (struct.new_default $C)
  ;; CAREFUL-NEXT:  )
  ;; CAREFUL-NEXT:  (call $refinable2
  ;; CAREFUL-NEXT:   (struct.new_default $B)
  ;; CAREFUL-NEXT:  )
  ;; CAREFUL-NEXT: )
  (func $calls2
    (call $refinable1
      (struct.new $C)
    )
    (call $refinable2
      (struct.new $B)
    )
  )

  ;; ALWAYS:      (func $refinable1 (type $4) (param $ref (ref $A))
  ;; ALWAYS-NEXT:  (drop
  ;; ALWAYS-NEXT:   (local.get $ref)
  ;; ALWAYS-NEXT:  )
  ;; ALWAYS-NEXT: )
  ;; CAREFUL:      (func $refinable1 (type $3) (param $0 (ref $A))
  ;; CAREFUL-NEXT:  (nop)
  ;; CAREFUL-NEXT: )
  (func $refinable1 (param $ref (ref $A))
    (drop
      (local.get $ref)
    )
  )

  ;; ALWAYS:      (func $refinable2 (type $4) (param $ref (ref $A))
  ;; ALWAYS-NEXT:  (drop
  ;; ALWAYS-NEXT:   (local.get $ref)
  ;; ALWAYS-NEXT:  )
  ;; ALWAYS-NEXT: )
  ;; CAREFUL:      (func $refinable2 (type $3) (param $0 (ref $A))
  ;; CAREFUL-NEXT:  (nop)
  ;; CAREFUL-NEXT: )
  (func $refinable2 (param $ref (ref $A))
    (drop
      (local.get $ref)
    )
  )
)

;; ALWAYS:      (func $refinable1_4 (type $5) (param $0 (ref $B))
;; ALWAYS-NEXT:  (local $ref (ref $A))
;; ALWAYS-NEXT:  (local.set $ref
;; ALWAYS-NEXT:   (local.get $0)
;; ALWAYS-NEXT:  )
;; ALWAYS-NEXT:  (drop
;; ALWAYS-NEXT:   (local.get $ref)
;; ALWAYS-NEXT:  )
;; ALWAYS-NEXT: )

;; ALWAYS:      (func $refinable1_5 (type $6) (param $0 (ref $C))
;; ALWAYS-NEXT:  (local $ref (ref $A))
;; ALWAYS-NEXT:  (local.set $ref
;; ALWAYS-NEXT:   (local.get $0)
;; ALWAYS-NEXT:  )
;; ALWAYS-NEXT:  (drop
;; ALWAYS-NEXT:   (local.get $ref)
;; ALWAYS-NEXT:  )
;; ALWAYS-NEXT: )

;; ALWAYS:      (func $refinable2_6 (type $5) (param $0 (ref $B))
;; ALWAYS-NEXT:  (local $ref (ref $A))
;; ALWAYS-NEXT:  (local.set $ref
;; ALWAYS-NEXT:   (local.get $0)
;; ALWAYS-NEXT:  )
;; ALWAYS-NEXT:  (drop
;; ALWAYS-NEXT:   (local.get $ref)
;; ALWAYS-NEXT:  )
;; ALWAYS-NEXT: )
(module
  ;; A case where even CAREFUL mode will monomorphize, as it helps the target
  ;; function get optimized better.

  ;; ALWAYS:      (type $A (sub (struct )))
  ;; CAREFUL:      (type $A (sub (struct )))
  (type $A (sub (struct)))

  ;; ALWAYS:      (type $B (sub $A (struct )))
  ;; CAREFUL:      (type $B (sub $A (struct )))
  (type $B (sub $A (struct)))

  ;; ALWAYS:      (type $2 (func (param (ref $B))))

  ;; ALWAYS:      (type $3 (func))

  ;; ALWAYS:      (type $4 (func (param (ref $A))))

  ;; ALWAYS:      (import "a" "b" (func $import (type $2) (param (ref $B))))
  ;; CAREFUL:      (type $2 (func (param (ref $B))))

  ;; CAREFUL:      (type $3 (func))

  ;; CAREFUL:      (type $4 (func (param (ref $A))))

  ;; CAREFUL:      (import "a" "b" (func $import (type $2) (param (ref $B))))
  (import "a" "b" (func $import (param (ref $B))))

  ;; ALWAYS:      (global $global (mut i32) (i32.const 1))
  ;; CAREFUL:      (global $global (mut i32) (i32.const 1))
  (global $global (mut i32) (i32.const 1))

  ;; ALWAYS:      (func $calls (type $3)
  ;; ALWAYS-NEXT:  (call $refinable
  ;; ALWAYS-NEXT:   (struct.new_default $A)
  ;; ALWAYS-NEXT:  )
  ;; ALWAYS-NEXT:  (call $refinable
  ;; ALWAYS-NEXT:   (struct.new_default $A)
  ;; ALWAYS-NEXT:  )
  ;; ALWAYS-NEXT:  (call $refinable_3
  ;; ALWAYS-NEXT:   (struct.new_default $B)
  ;; ALWAYS-NEXT:  )
  ;; ALWAYS-NEXT:  (call $refinable_3
  ;; ALWAYS-NEXT:   (struct.new_default $B)
  ;; ALWAYS-NEXT:  )
  ;; ALWAYS-NEXT: )
  ;; CAREFUL:      (func $calls (type $3)
  ;; CAREFUL-NEXT:  (call $refinable
  ;; CAREFUL-NEXT:   (struct.new_default $A)
  ;; CAREFUL-NEXT:  )
  ;; CAREFUL-NEXT:  (call $refinable
  ;; CAREFUL-NEXT:   (struct.new_default $A)
  ;; CAREFUL-NEXT:  )
  ;; CAREFUL-NEXT:  (call $refinable_3
  ;; CAREFUL-NEXT:   (struct.new_default $B)
  ;; CAREFUL-NEXT:  )
  ;; CAREFUL-NEXT:  (call $refinable_3
  ;; CAREFUL-NEXT:   (struct.new_default $B)
  ;; CAREFUL-NEXT:  )
  ;; CAREFUL-NEXT: )
  (func $calls
    ;; The calls sending $B will switch to calling a refined version, as the
    ;; refined version is better, even in CAREFUL mode.
    (call $refinable
      (struct.new $A)
    )
    (call $refinable
      (struct.new $A)
    )
    (call $refinable
      (struct.new $B)
    )
    (call $refinable
      (struct.new $B)
    )
  )

  ;; ALWAYS:      (func $refinable (type $4) (param $ref (ref $A))
  ;; ALWAYS-NEXT:  (local $x (ref $A))
  ;; ALWAYS-NEXT:  (call $import
  ;; ALWAYS-NEXT:   (ref.cast (ref $B)
  ;; ALWAYS-NEXT:    (local.get $ref)
  ;; ALWAYS-NEXT:   )
  ;; ALWAYS-NEXT:  )
  ;; ALWAYS-NEXT:  (local.set $x
  ;; ALWAYS-NEXT:   (select (result (ref $A))
  ;; ALWAYS-NEXT:    (local.get $ref)
  ;; ALWAYS-NEXT:    (struct.new_default $B)
  ;; ALWAYS-NEXT:    (global.get $global)
  ;; ALWAYS-NEXT:   )
  ;; ALWAYS-NEXT:  )
  ;; ALWAYS-NEXT:  (call $import
  ;; ALWAYS-NEXT:   (ref.cast (ref $B)
  ;; ALWAYS-NEXT:    (local.get $x)
  ;; ALWAYS-NEXT:   )
  ;; ALWAYS-NEXT:  )
  ;; ALWAYS-NEXT:  (call $import
  ;; ALWAYS-NEXT:   (ref.cast (ref $B)
  ;; ALWAYS-NEXT:    (local.get $x)
  ;; ALWAYS-NEXT:   )
  ;; ALWAYS-NEXT:  )
  ;; ALWAYS-NEXT:  (call $import
  ;; ALWAYS-NEXT:   (ref.cast (ref $B)
  ;; ALWAYS-NEXT:    (local.get $ref)
  ;; ALWAYS-NEXT:   )
  ;; ALWAYS-NEXT:  )
  ;; ALWAYS-NEXT: )
  ;; CAREFUL:      (func $refinable (type $4) (param $0 (ref $A))
  ;; CAREFUL-NEXT:  (local $1 (ref $A))
  ;; CAREFUL-NEXT:  (call $import
  ;; CAREFUL-NEXT:   (ref.cast (ref $B)
  ;; CAREFUL-NEXT:    (local.get $0)
  ;; CAREFUL-NEXT:   )
  ;; CAREFUL-NEXT:  )
  ;; CAREFUL-NEXT:  (call $import
  ;; CAREFUL-NEXT:   (ref.cast (ref $B)
  ;; CAREFUL-NEXT:    (local.tee $1
  ;; CAREFUL-NEXT:     (select (result (ref $A))
  ;; CAREFUL-NEXT:      (local.get $0)
  ;; CAREFUL-NEXT:      (struct.new_default $B)
  ;; CAREFUL-NEXT:      (global.get $global)
  ;; CAREFUL-NEXT:     )
  ;; CAREFUL-NEXT:    )
  ;; CAREFUL-NEXT:   )
  ;; CAREFUL-NEXT:  )
  ;; CAREFUL-NEXT:  (call $import
  ;; CAREFUL-NEXT:   (ref.cast (ref $B)
  ;; CAREFUL-NEXT:    (local.get $1)
  ;; CAREFUL-NEXT:   )
  ;; CAREFUL-NEXT:  )
  ;; CAREFUL-NEXT:  (call $import
  ;; CAREFUL-NEXT:   (ref.cast (ref $B)
  ;; CAREFUL-NEXT:    (local.get $0)
  ;; CAREFUL-NEXT:   )
  ;; CAREFUL-NEXT:  )
  ;; CAREFUL-NEXT: )
  (func $refinable (param $ref (ref $A))
    (local $x (ref $A))
    ;; The refined version of this function will not have the cast, since
    ;; optimizations manage to remove it using the more refined type.
    ;;
    ;; (That is the case in CAREFUL mode, which optimizes; in ALWAYS mode the
    ;; cast will remain since we monomorphize without bothering to optimize and
    ;; see if there is any benefit.)
    (call $import
      (ref.cast (ref $B)
        (local.get $ref)
      )
    )
    ;; Also copy the param into a local. The local should get refined to $B in
    ;; the refined function in CAREFUL mode.
    (local.set $x
      ;; Use a select here so optimizations don't just merge $x and $ref.
      (select (result (ref $A))
        (local.get $ref)
        (struct.new $B)
        (global.get $global)
      )
    )
    (call $import
      (ref.cast (ref $B)
        (local.get $x)
      )
    )
    (call $import
      (ref.cast (ref $B)
        (local.get $x)
      )
    )
    ;; Another use of $ref, also to avoid opts merging $x and $ref.
    (call $import
      (ref.cast (ref $B)
        (local.get $ref)
      )
    )
  )
)

;; ALWAYS:      (func $refinable_3 (type $2) (param $0 (ref $B))
;; ALWAYS-NEXT:  (local $x (ref $A))
;; ALWAYS-NEXT:  (local $ref (ref $A))
;; ALWAYS-NEXT:  (local.set $ref
;; ALWAYS-NEXT:   (local.get $0)
;; ALWAYS-NEXT:  )
;; ALWAYS-NEXT:  (block
;; ALWAYS-NEXT:   (call $import
;; ALWAYS-NEXT:    (ref.cast (ref $B)
;; ALWAYS-NEXT:     (local.get $ref)
;; ALWAYS-NEXT:    )
;; ALWAYS-NEXT:   )
;; ALWAYS-NEXT:   (local.set $x
;; ALWAYS-NEXT:    (select (result (ref $A))
;; ALWAYS-NEXT:     (local.get $ref)
;; ALWAYS-NEXT:     (struct.new_default $B)
;; ALWAYS-NEXT:     (global.get $global)
;; ALWAYS-NEXT:    )
;; ALWAYS-NEXT:   )
;; ALWAYS-NEXT:   (call $import
;; ALWAYS-NEXT:    (ref.cast (ref $B)
;; ALWAYS-NEXT:     (local.get $x)
;; ALWAYS-NEXT:    )
;; ALWAYS-NEXT:   )
;; ALWAYS-NEXT:   (call $import
;; ALWAYS-NEXT:    (ref.cast (ref $B)
;; ALWAYS-NEXT:     (local.get $x)
;; ALWAYS-NEXT:    )
;; ALWAYS-NEXT:   )
;; ALWAYS-NEXT:   (call $import
;; ALWAYS-NEXT:    (ref.cast (ref $B)
;; ALWAYS-NEXT:     (local.get $ref)
;; ALWAYS-NEXT:    )
;; ALWAYS-NEXT:   )
;; ALWAYS-NEXT:  )
;; ALWAYS-NEXT: )

;; CAREFUL:      (func $refinable_3 (type $2) (param $0 (ref $B))
;; CAREFUL-NEXT:  (local $1 (ref $B))
;; CAREFUL-NEXT:  (call $import
;; CAREFUL-NEXT:   (local.get $0)
;; CAREFUL-NEXT:  )
;; CAREFUL-NEXT:  (call $import
;; CAREFUL-NEXT:   (local.tee $1
;; CAREFUL-NEXT:    (select (result (ref $B))
;; CAREFUL-NEXT:     (local.get $0)
;; CAREFUL-NEXT:     (struct.new_default $B)
;; CAREFUL-NEXT:     (global.get $global)
;; CAREFUL-NEXT:    )
;; CAREFUL-NEXT:   )
;; CAREFUL-NEXT:  )
;; CAREFUL-NEXT:  (call $import
;; CAREFUL-NEXT:   (local.get $1)
;; CAREFUL-NEXT:  )
;; CAREFUL-NEXT:  (call $import
;; CAREFUL-NEXT:   (local.get $0)
;; CAREFUL-NEXT:  )
;; CAREFUL-NEXT: )
(module
  ;; Test that we avoid recursive calls.

  ;; ALWAYS:      (type $A (sub (struct )))
  ;; CAREFUL:      (type $A (sub (struct )))
  (type $A (sub (struct)))
  ;; ALWAYS:      (type $1 (func (param (ref $A))))

  ;; ALWAYS:      (type $B (sub $A (struct )))
  ;; CAREFUL:      (type $1 (func (param (ref $A))))

  ;; CAREFUL:      (type $B (sub $A (struct )))
  (type $B (sub $A (struct)))


  ;; ALWAYS:      (func $calls (type $1) (param $ref (ref $A))
  ;; ALWAYS-NEXT:  (call $calls
  ;; ALWAYS-NEXT:   (struct.new_default $B)
  ;; ALWAYS-NEXT:  )
  ;; ALWAYS-NEXT: )
  ;; CAREFUL:      (func $calls (type $1) (param $ref (ref $A))
  ;; CAREFUL-NEXT:  (call $calls
  ;; CAREFUL-NEXT:   (struct.new_default $B)
  ;; CAREFUL-NEXT:  )
  ;; CAREFUL-NEXT: )
  (func $calls (param $ref (ref $A))
    ;; We should change nothing in this recursive call, even though we are
    ;; sending a more refined type, so we could try to monomorphize in theory.
    (call $calls
      (struct.new $B)
    )
  )
)
