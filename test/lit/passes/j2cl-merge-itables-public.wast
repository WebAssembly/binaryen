;; RUN: foreach %s %t not wasm-opt -all --closed-world --preserve-type-order --merge-j2cl-itables 2>&1 | filecheck %s

;; Java class type is public
(module
  (rec
    (type $Object (sub (struct
      (field $vtable (ref $Object.vtable))
      (field $itable (ref $Object.itable)))))
    (type $Object.vtable (sub (struct)))
    (type $Object.itable (struct (field (ref null struct))))
  )

  (func $f (export "f") (param $o (ref $Object)))
)
;; CHECK: Fatal: Cannot merge itables because the J2CL type $Object or its dispatch tables are public

;; Java vtable type is public.
;; Note that making the vtable type public also makes the described class type public.
(module
  (rec
    (type $Object (sub (struct
      (field $vtable (ref $Object.vtable))
      (field $itable (ref $Object.itable)))))
    (type $Object.vtable (sub (struct)))
    (type $Object.itable (struct (field (ref null struct))))
  )

  (func $f (export "f") (param $o (ref $Object.vtable)))
)
;; CHECK: Fatal: Cannot merge itables because the J2CL type $Object or its dispatch tables are public

;; Java itable type is public, and is defined in a separate recursion group.
(module
  (type $Object.itable (struct (field (ref null struct))))
  (rec
    (type $Object (sub (struct
      (field $vtable (ref $Object.vtable))
      (field $itable (ref $Object.itable)))))
    (type $Object.vtable (sub (struct)))
  )

  (func $f (export "f") (param $o (ref $Object.itable)))
)
;; CHECK: Fatal: Cannot merge itables because the J2CL type $Object or its dispatch tables are public
