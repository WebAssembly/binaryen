;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.

;; RUN: foreach %s %t wasm-opt --closed-world --merge-j2cl-itables -all -S -o - | filecheck %s

;; Empty itables.
(module
  ;; Object class type definitions.
  ;; CHECK:      (type $Object.vtable (struct))
  (type $Object.vtable (struct ))
  (type $Object.itable (struct ))

  (type $Object (sub (struct
      (field $vtable (ref $Object.vtable))
      (field $itable (ref $Object.itable)))))

  ;; Object vtable and itable initialization.
  ;; CHECK:      (global $Object.itable (ref $Object.vtable) (struct.new_default $Object.vtable))
  (global $Object.itable (ref $Object.itable)  (struct.new $Object.itable))
  ;; CHECK:      (global $Object.vtable (ref $Object.vtable) (struct.new_default $Object.vtable))
  (global $Object.vtable (ref $Object.vtable)  (struct.new $Object.vtable))
)

;; Shared itable.
(module
  (rec
    ;; Object class type definitions.
    ;; CHECK:      (rec
    ;; CHECK-NEXT:  (type $Object (sub (struct (field $vtable (ref $Object.vtable)) (field $itable (ref $Object.itable)))))

    ;; CHECK:       (type $SubObject (sub $Object (struct (field $vtable (ref $SubObject.vtable)) (field $itable (ref $Object.itable)))))

    ;; CHECK:       (type $2 (func))

    ;; CHECK:       (type $function (func))

    ;; CHECK:       (type $Object.vtable (sub (struct (field structref))))
    (type $Object.vtable (sub (struct )))
    ;; CHECK:       (type $SubObject.vtable (sub $Object.vtable (struct (field structref) (field (ref $function)))))

    ;; CHECK:       (type $Object.itable (struct (field structref)))
    (type $Object.itable (struct (field (ref null struct))))

    (type $Object (sub (struct
        (field $vtable (ref $Object.vtable))
        (field $itable (ref $Object.itable)))))

    ;; SubObject class type definitions.
    (type $SubObject.vtable (sub $Object.vtable (struct (field (ref $function)))))

    (type $SubObject (sub $Object (struct
        (field $vtable (ref $SubObject.vtable))
        (field $itable (ref $Object.itable)))))

    (type $function (func  ))
  )

  ;; Object vtable and itable initialization.
  ;; CHECK:      (global $Object.itable (ref $Object.itable) (struct.new_default $Object.itable))

  ;; CHECK:      (global $SubObject.itable (ref $Object.itable) (global.get $Object.itable))

  ;; CHECK:      (global $SubObject.vtable (ref $SubObject.vtable) (struct.new $SubObject.vtable
  ;; CHECK-NEXT:  (ref.null none)
  ;; CHECK-NEXT:  (ref.func $SubObject.f)
  ;; CHECK-NEXT: ))

  ;; CHECK:      (global $Object.vtable (ref $Object.vtable) (struct.new $Object.vtable
  ;; CHECK-NEXT:  (ref.null none)
  ;; CHECK-NEXT: ))
  (global $Object.vtable (ref $Object.vtable)
      (struct.new $Object.vtable))
  (global $Object.itable (ref $Object.itable)
      (struct.new_default $Object.itable))

  ;; SubObject vtable and itable initialization. Shared empty itable.
  (global $SubObject.itable (ref $Object.itable)
      (global.get $Object.itable))
  (global $SubObject.vtable (ref $SubObject.vtable)
      (struct.new $SubObject.vtable (ref.func $SubObject.f)))

  ;; CHECK:      (func $SubObject.f (type $function)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  (func $SubObject.f
      (type $function)
  )

  ;; CHECK:      (func $usages (type $2)
  ;; CHECK-NEXT:  (local $o (ref null $SubObject))
  ;; CHECK-NEXT:  (local.set $o
  ;; CHECK-NEXT:   (struct.new $SubObject
  ;; CHECK-NEXT:    (global.get $SubObject.vtable)
  ;; CHECK-NEXT:    (global.get $SubObject.itable)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.get $SubObject.vtable 1
  ;; CHECK-NEXT:    (struct.get $SubObject $vtable
  ;; CHECK-NEXT:     (local.get $o)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (struct.get $SubObject.vtable 0
  ;; CHECK-NEXT:    (struct.get $SubObject $vtable
  ;; CHECK-NEXT:     (local.get $o)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $usages
    (local $o (ref null $SubObject))
    (local.set $o
        (struct.new $SubObject
              (global.get $SubObject.vtable)
              (global.get $SubObject.itable)))
    (drop
        (struct.get $SubObject.vtable 0
            (struct.get $SubObject $vtable
                (local.get $o))))
    (drop
        (struct.get $Object.itable 0
            (struct.get $SubObject $itable
                (local.get $o))))
  )
)
