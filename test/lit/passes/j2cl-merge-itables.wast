;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.

;; RUN: foreach %s %t wasm-opt -all --closed-world --preserve-type-order \
;; RUN:     --merge-j2cl-itables -all -S -o - | filecheck %s

;; Shared itable instance.
(module
  (rec
    ;; CHECK:      (rec
    ;; CHECK-NEXT:  (type $Object (sub (struct (field $vtable (ref $Object.vtable)) (field $itable (ref $Object.itable)))))
    (type $Object (sub (struct
      (field $vtable (ref $Object.vtable))
      (field $itable (ref $Object.itable)))))

    ;; CHECK:       (type $SubObject (sub $Object (struct (field $vtable (ref $SubObject.vtable)) (field $itable (ref $Object.itable)))))
    (type $SubObject (sub $Object (struct
      (field $vtable (ref $SubObject.vtable))
      (field $itable (ref $Object.itable)))))

    ;; CHECK:       (type $function (func))
    (type $function (func))

    ;; The $Object.itable field (a structref) will be added as a field to
    ;; the beginning of this vtable.
    ;; CHECK:       (type $Object.vtable (sub (struct (field structref))))
    (type $Object.vtable (sub (struct)))

    ;; The $Object.itable field (a structref) will be added as a field to
    ;; the beginning of this vtable.
    ;; CHECK:       (type $SubObject.vtable (sub $Object.vtable (struct (field structref) (field (ref $function)))))
    (type $SubObject.vtable (sub $Object.vtable (struct
      (field (ref $function)))))

    ;; CHECK:       (type $Object.itable (struct (field structref)))
    (type $Object.itable (struct
	    (field (ref null struct))))
  )

  ;; CHECK:       (type $6 (func))

  ;; CHECK:      (global $Object.itable (ref $Object.itable) (struct.new_default $Object.itable))
  (global $Object.itable (ref $Object.itable)
    (struct.new_default $Object.itable))

  ;; CHECK:      (global $SubObject.itable (ref $Object.itable) (global.get $Object.itable))
  (global $SubObject.itable (ref $Object.itable)
    (global.get $Object.itable))  ;; uses shared empty itable instance.

  ;; The initialization for the itable field (null struct) will be added to this
  ;; vtable instance.
  ;; CHECK:      (global $SubObject.vtable (ref $SubObject.vtable) (struct.new $SubObject.vtable
  ;; CHECK-NEXT:  (ref.null none)
  ;; CHECK-NEXT:  (ref.func $SubObject.f)
  ;; CHECK-NEXT: ))
  (global $SubObject.vtable (ref $SubObject.vtable)
    (struct.new $SubObject.vtable (ref.func $SubObject.f)))


  ;; The initialization for the itable field (null struct) will be added to this
  ;; vtable instance.
  ;; CHECK:      (global $Object.vtable (ref $Object.vtable) (struct.new $Object.vtable
  ;; CHECK-NEXT:  (ref.null none)
  ;; CHECK-NEXT: ))
  (global $Object.vtable (ref $Object.vtable)
    (struct.new $Object.vtable))

  ;; CHECK:      (func $SubObject.f (type $function)
  ;; CHECK-NEXT: )
  (func $SubObject.f
    (type $function)
  )

  ;; CHECK:      (func $usages (type $6)
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
      ;; The access to vtable field 0 is offset but the itable size and
      ;; will be an access to field 1.
      (struct.get $SubObject.vtable 0
        (struct.get $SubObject $vtable
          (local.get $o))))
    (drop
      ;; The access to itable field 0 will be rerouted to be an access to
      ;; vtable field 0.
      (struct.get $Object.itable 0
        (struct.get $SubObject $itable
          (local.get $o))))
    )
)

;; Each type has its own itable.
(module
  (rec
    ;; CHECK:      (rec
    ;; CHECK-NEXT:  (type $Object (sub (struct (field $vtable (ref $Object.vtable)) (field $itable (ref $Object.itable)))))
    (type $Object (sub (struct
      (field $vtable (ref $Object.vtable))
      (field $itable (ref $Object.itable)))))

    ;; CHECK:       (type $SubObject (sub $Object (struct (field $vtable (ref $SubObject.vtable)) (field $itable (ref $SubObject.itable)))))
    (type $SubObject (sub $Object (struct
      (field $vtable (ref $SubObject.vtable))
      (field $itable (ref $SubObject.itable)))))

    ;; CHECK:       (type $function (func))
    (type $function (func))

    ;; CHECK:       (type $Object.itable (sub (struct (field structref))))
    (type $Object.itable (sub (struct
		  (field (ref null struct)))))

    ;; CHECK:       (type $SubObject.itable (sub $Object.itable (struct (field structref))))
    (type $SubObject.itable (sub $Object.itable
      (struct (field (ref null struct)))))

    ;; The $Object.itable field (a structref) will be added as a field to
    ;; the beginning of this vtable.
    ;; CHECK:       (type $Object.vtable (sub (struct (field structref))))
    (type $Object.vtable (sub (struct)))

    ;; The $SubObject.itable field (a structref) will be added as a field to
    ;; the beginning of this vtable.
    ;; CHECK:       (type $SubObject.vtable (sub $Object.vtable (struct (field structref) (field (ref $function)))))
    (type $SubObject.vtable (sub $Object.vtable
      (struct (field (ref $function)))))
  )

  ;; The initialization for the itable field (null struct) will be added to this
  ;; vtable instance.
  ;; CHECK:       (type $7 (func))

  ;; CHECK:      (global $SubObject.vtable (ref $SubObject.vtable) (struct.new $SubObject.vtable
  ;; CHECK-NEXT:  (ref.null none)
  ;; CHECK-NEXT:  (ref.func $SubObject.f)
  ;; CHECK-NEXT: ))
  (global $SubObject.vtable (ref $SubObject.vtable)
    (struct.new $SubObject.vtable (ref.func $SubObject.f)))

  ;; CHECK:      (global $SubObject.itable (ref $SubObject.itable) (struct.new_default $SubObject.itable))
  (global $SubObject.itable (ref $SubObject.itable)
    (struct.new_default $SubObject.itable))

  ;; The initialization for the itable field (null struct) will be added to this
  ;; vtable instance.
  ;; CHECK:      (global $Object.vtable (ref $Object.vtable) (struct.new $Object.vtable
  ;; CHECK-NEXT:  (ref.null none)
  ;; CHECK-NEXT: ))
  (global $Object.vtable (ref $Object.vtable)
    (struct.new $Object.vtable))

  ;; CHECK:      (global $Object.itable (ref $Object.itable) (struct.new_default $Object.itable))
  (global $Object.itable (ref $Object.itable)
    (struct.new_default $Object.itable))

  ;; CHECK:      (func $SubObject.f (type $function)
  ;; CHECK-NEXT: )
  (func $SubObject.f
    (type $function)
  )

  ;; CHECK:      (func $usages (type $7)
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
      ;; The access to vtable field 0 is offset but the itable size and
      ;; will be an access to field 1.
      (struct.get $SubObject.vtable 0
        (struct.get $SubObject $vtable
          (local.get $o))))
    (drop
      ;; The access to itable field 0 will be rerouted to be an access to
      ;; vtable field 0.
      (struct.get $Object.itable 0
        (struct.get $SubObject $itable
          (local.get $o))))
  )
)
