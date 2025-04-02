;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.

;; Compare the normal type refining pass to the GUFA variant. Also compare to
;; -O3 -O3, that is, all the refining passes run twice, showing that GUFA can
;; outdo them all.

;; RUN: foreach %s %t wasm-opt -all --closed-world --preserve-type-order \
;; RUN:     --type-refining      -S -o - | filecheck %s --check-prefix=NRML
;; RUN: foreach %s %t wasm-opt -all --closed-world --preserve-type-order \
;; RUN:     --type-refining-gufa -S -o - | filecheck %s --check-prefix=GUFA
;; RUN: foreach %s %t wasm-opt -all --closed-world --preserve-type-order \
;; RUN:     -O3 -O3              -S -o - | filecheck %s --check-prefix=O3O3

;; A module that requires GUFA to fully optimize, as we must track type
;; information through locals etc.
;;
;; In NRML mode (normal type-refining), we can improve $A's field to nullref,
;; but can do nothing for $B.
;;
;; In GUFA mode we can also turn $B's field to (ref $A).
;;
;; -O3 -O3 can remove the field from $A, but ...
(module
  (rec
    ;; NRML:      (rec
    ;; NRML-NEXT:  (type $A (sub (struct (field (mut nullref)))))
    ;; GUFA:      (rec
    ;; GUFA-NEXT:  (type $A (sub (struct (field (mut nullref)))))
    ;; O3O3:      (rec
    ;; O3O3-NEXT:  (type $A (sub (struct)))
    (type $A (sub (struct (field (mut anyref)))))
    ;; NRML:       (type $B (sub (struct (field (mut anyref)))))
    ;; GUFA:       (type $B (sub (struct (field (mut (ref $A))))))
    ;; O3O3:       (type $B (sub (struct (field (ref $A)))))
    (type $B (sub (struct (field (mut anyref)))))
  )

  ;; NRML:      (type $2 (func (param i32) (result anyref)))

  ;; NRML:      (global $any (mut anyref) (ref.null none))
  ;; GUFA:      (type $2 (func (param i32) (result anyref)))

  ;; GUFA:      (global $any (mut anyref) (ref.null none))
  ;; O3O3:      (type $2 (func (param i32) (result anyref)))

  ;; O3O3:      (global $any (mut structref) (ref.null none))
  (global $any (mut anyref) (ref.null any))

  ;; NRML:      (export "get_from_global" (func $get_from_global))

  ;; NRML:      (export "work" (func $work))

  ;; NRML:      (func $get_from_global (type $2) (param $x i32) (result anyref)
  ;; NRML-NEXT:  (if (result anyref)
  ;; NRML-NEXT:   (local.get $x)
  ;; NRML-NEXT:   (then
  ;; NRML-NEXT:    (struct.get $A 0
  ;; NRML-NEXT:     (ref.cast (ref $A)
  ;; NRML-NEXT:      (global.get $any)
  ;; NRML-NEXT:     )
  ;; NRML-NEXT:    )
  ;; NRML-NEXT:   )
  ;; NRML-NEXT:   (else
  ;; NRML-NEXT:    (struct.get $B 0
  ;; NRML-NEXT:     (ref.cast (ref $B)
  ;; NRML-NEXT:      (global.get $any)
  ;; NRML-NEXT:     )
  ;; NRML-NEXT:    )
  ;; NRML-NEXT:   )
  ;; NRML-NEXT:  )
  ;; NRML-NEXT: )
  ;; GUFA:      (export "get_from_global" (func $get_from_global))

  ;; GUFA:      (export "work" (func $work))

  ;; GUFA:      (func $get_from_global (type $2) (param $x i32) (result anyref)
  ;; GUFA-NEXT:  (if (result (ref null $A))
  ;; GUFA-NEXT:   (local.get $x)
  ;; GUFA-NEXT:   (then
  ;; GUFA-NEXT:    (struct.get $A 0
  ;; GUFA-NEXT:     (ref.cast (ref $A)
  ;; GUFA-NEXT:      (global.get $any)
  ;; GUFA-NEXT:     )
  ;; GUFA-NEXT:    )
  ;; GUFA-NEXT:   )
  ;; GUFA-NEXT:   (else
  ;; GUFA-NEXT:    (struct.get $B 0
  ;; GUFA-NEXT:     (ref.cast (ref $B)
  ;; GUFA-NEXT:      (global.get $any)
  ;; GUFA-NEXT:     )
  ;; GUFA-NEXT:    )
  ;; GUFA-NEXT:   )
  ;; GUFA-NEXT:  )
  ;; GUFA-NEXT: )
  ;; O3O3:      (export "get_from_global" (func $get_from_global))

  ;; O3O3:      (export "work" (func $work))

  ;; O3O3:      (func $get_from_global (type $2) (param $0 i32) (result anyref)
  ;; O3O3-NEXT:  (if (result (ref null $A))
  ;; O3O3-NEXT:   (local.get $0)
  ;; O3O3-NEXT:   (then
  ;; O3O3-NEXT:    (drop
  ;; O3O3-NEXT:     (ref.cast (ref $A)
  ;; O3O3-NEXT:      (global.get $any)
  ;; O3O3-NEXT:     )
  ;; O3O3-NEXT:    )
  ;; O3O3-NEXT:    (ref.null none)
  ;; O3O3-NEXT:   )
  ;; O3O3-NEXT:   (else
  ;; O3O3-NEXT:    (struct.get $B 0
  ;; O3O3-NEXT:     (ref.cast (ref $B)
  ;; O3O3-NEXT:      (global.get $any)
  ;; O3O3-NEXT:     )
  ;; O3O3-NEXT:    )
  ;; O3O3-NEXT:   )
  ;; O3O3-NEXT:  )
  ;; O3O3-NEXT: )
  (func $get_from_global (export "get_from_global") (param $x i32) (result anyref)
    ;; Read from the global, casting in a way that depends on the parameter.
    ;; By storing objects in the global + having this function, we prevent -O3
    ;; from being able to trivially clear out the entire module.
    (if (result anyref)
      (local.get $x)
      (then
        (struct.get $A 0
          (ref.cast (ref $A)
            (global.get $any)
          )
        )
      )
      (else
        (struct.get $B 0
          (ref.cast (ref $B)
            (global.get $any)
          )
        )
      )
    )
  )

  ;; NRML:      (func $work (type $2) (param $x i32) (result anyref)
  ;; NRML-NEXT:  (local $a anyref)
  ;; NRML-NEXT:  (local $b (ref null $B))
  ;; NRML-NEXT:  (local.set $a
  ;; NRML-NEXT:   (struct.new_default $A)
  ;; NRML-NEXT:  )
  ;; NRML-NEXT:  (local.set $b
  ;; NRML-NEXT:   (struct.new $B
  ;; NRML-NEXT:    (local.get $a)
  ;; NRML-NEXT:   )
  ;; NRML-NEXT:  )
  ;; NRML-NEXT:  (local.set $b
  ;; NRML-NEXT:   (struct.new $B
  ;; NRML-NEXT:    (struct.get $B 0
  ;; NRML-NEXT:     (local.get $b)
  ;; NRML-NEXT:    )
  ;; NRML-NEXT:   )
  ;; NRML-NEXT:  )
  ;; NRML-NEXT:  (if
  ;; NRML-NEXT:   (local.get $x)
  ;; NRML-NEXT:   (then
  ;; NRML-NEXT:    (global.set $any
  ;; NRML-NEXT:     (local.get $a)
  ;; NRML-NEXT:    )
  ;; NRML-NEXT:   )
  ;; NRML-NEXT:   (else
  ;; NRML-NEXT:    (global.set $any
  ;; NRML-NEXT:     (local.get $b)
  ;; NRML-NEXT:    )
  ;; NRML-NEXT:   )
  ;; NRML-NEXT:  )
  ;; NRML-NEXT:  (local.get $b)
  ;; NRML-NEXT: )
  ;; GUFA:      (func $work (type $2) (param $x i32) (result anyref)
  ;; GUFA-NEXT:  (local $a anyref)
  ;; GUFA-NEXT:  (local $b (ref null $B))
  ;; GUFA-NEXT:  (local.set $a
  ;; GUFA-NEXT:   (struct.new_default $A)
  ;; GUFA-NEXT:  )
  ;; GUFA-NEXT:  (local.set $b
  ;; GUFA-NEXT:   (struct.new $B
  ;; GUFA-NEXT:    (ref.cast (ref $A)
  ;; GUFA-NEXT:     (local.get $a)
  ;; GUFA-NEXT:    )
  ;; GUFA-NEXT:   )
  ;; GUFA-NEXT:  )
  ;; GUFA-NEXT:  (local.set $b
  ;; GUFA-NEXT:   (struct.new $B
  ;; GUFA-NEXT:    (struct.get $B 0
  ;; GUFA-NEXT:     (local.get $b)
  ;; GUFA-NEXT:    )
  ;; GUFA-NEXT:   )
  ;; GUFA-NEXT:  )
  ;; GUFA-NEXT:  (if
  ;; GUFA-NEXT:   (local.get $x)
  ;; GUFA-NEXT:   (then
  ;; GUFA-NEXT:    (global.set $any
  ;; GUFA-NEXT:     (local.get $a)
  ;; GUFA-NEXT:    )
  ;; GUFA-NEXT:   )
  ;; GUFA-NEXT:   (else
  ;; GUFA-NEXT:    (global.set $any
  ;; GUFA-NEXT:     (local.get $b)
  ;; GUFA-NEXT:    )
  ;; GUFA-NEXT:   )
  ;; GUFA-NEXT:  )
  ;; GUFA-NEXT:  (local.get $b)
  ;; GUFA-NEXT: )
  ;; O3O3:      (func $work (type $2) (param $0 i32) (result anyref)
  ;; O3O3-NEXT:  (local $1 (ref $B))
  ;; O3O3-NEXT:  (local $2 (ref $A))
  ;; O3O3-NEXT:  (local.set $1
  ;; O3O3-NEXT:   (struct.new $B
  ;; O3O3-NEXT:    (local.tee $2
  ;; O3O3-NEXT:     (struct.new_default $A)
  ;; O3O3-NEXT:    )
  ;; O3O3-NEXT:   )
  ;; O3O3-NEXT:  )
  ;; O3O3-NEXT:  (if
  ;; O3O3-NEXT:   (local.get $0)
  ;; O3O3-NEXT:   (then
  ;; O3O3-NEXT:    (global.set $any
  ;; O3O3-NEXT:     (local.get $2)
  ;; O3O3-NEXT:    )
  ;; O3O3-NEXT:   )
  ;; O3O3-NEXT:   (else
  ;; O3O3-NEXT:    (global.set $any
  ;; O3O3-NEXT:     (local.get $1)
  ;; O3O3-NEXT:    )
  ;; O3O3-NEXT:   )
  ;; O3O3-NEXT:  )
  ;; O3O3-NEXT:  (local.get $1)
  ;; O3O3-NEXT: )
  (func $work (export "work") (param $x i32) (result anyref)
    (local $a anyref)
    (local $b (ref null $B))
    ;; $A's field contains null.
    (local.set $a
      (struct.new_default $A)
    )
    ;; $B's field contains a reference to $A, even though the local's type is
    ;; anyref. When we refine the field in GUFA, a cast will be added here.
    (local.set $b
      (struct.new $B
        (local.get $a)
      )
    )
    ;; Another write to $B's field, reading from it, which forms a cycle. This
    ;; does not prevent us from optimizing.
    (local.set $b
      (struct.new $B
        (struct.get $B 0
          (local.get $b)
        )
      )
    )
    ;; Store something in the global, so the entire program is not trivial in
    ;; the eyes of -O3.
    (if
      (local.get $x)
      (then
        (global.set $any
          (local.get $a)
        )
      )
      (else
        (global.set $any
          (local.get $b)
        )
      )
    )
    (local.get $b)
  )
)

