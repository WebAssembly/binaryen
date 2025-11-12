;; TODO: Use the upstream version from the custom descriptors proposal.

(module
  (type $f (func))
  (import "" "" (func $1 (exact (type 0))))
  (import "" "" (func $2 (exact (type $f) (param) (result))))
  (import "" "" (func $3 (exact (type $f))))
  (import "" "" (func $4 (exact (type 1)))) ;; Implicitly defined next
  (import "" "" (func $5 (exact (param i32) (result i64))))

  (func $6 (import "" "") (exact (type 0)))
  (func $7 (import "" "") (exact (type $f) (param) (result)))
  (func $8 (import "" "") (exact (type $f)))
  (func $9 (import "" "") (exact (type 2))) ;; Implicitly defined next
  (func $10 (import "" "") (exact (param i64) (result i32)))

  (global (ref (exact $f)) (ref.func $1))
  (global (ref (exact $f)) (ref.func $2))
  (global (ref (exact $f)) (ref.func $3))
  (global (ref (exact 1)) (ref.func $4))
  (global (ref (exact 1)) (ref.func $5))
  (global (ref (exact $f)) (ref.func $6))
  (global (ref (exact $f)) (ref.func $7))
  (global (ref (exact $f)) (ref.func $8))
  (global (ref (exact 2)) (ref.func $9))
  (global (ref (exact 2)) (ref.func $10))
)

;; References to inexact imports are not exact.

(assert_invalid
  (module
    (type $f (func))
    (import "" "" (func $1 (type $f)))
    (global (ref (exact $f)) (ref.func $1))
  )
  "type mismatch"
)

(assert_invalid
  (module
    (type $f (func))
    (import "" "" (func $1 (type $f)))
    (elem declare func $1)
    (func (result (ref (exact $f)))
      (ref.func $1)
    )
  )
  "type mismatch"
)

;; Inexact imports can still be referenced inexactly, though.

(module
  (type $f (func))
  (import "" "" (func $1 (type $f)))
  (global (ref $f) (ref.func $1))
  (func (result (ref $f))
    (ref.func $1)
  )
)

;; Define a function and export it exactly.
(module $A
  (type $f (func))
  (func (export "f") (type $f))
)
(register "A")

;; Import and re-export inexactly.
(module $B
  (type $f (func))
  (func (export "f") (import "A" "f") (type $f))
)
(register "B")

;; The export from A is exact.
(module
  (type $f (func))
  (import "A" "f" (func (exact (type $f))))
)

;; The export from B is _statically_ inexact, but instantiation checks
;; the dynamic types of imports, so this link still succeeds.
(module
  (type $f (func))
  (import "B" "f" (func (exact (type $f))))
)

;; Even when the function is imported inexactly, it can still be cast to its
;; exact type.
(module
  (type $f (func))
  (import "A" "f" (func $1 (type $f)))
  (elem declare func $1)
  (func (export "exact-test") (result i32)
    (ref.test (ref (exact $f)) (ref.func $1))
  )
  (func (export "exact-cast") (result (ref (exact $f)))
    (ref.cast (ref (exact $f)) (ref.func $1))
  )
  (func (export "exact-br-on-cast") (result funcref)
    (br_on_cast 0 funcref (ref (exact $f)) (ref.func $1))
    (unreachable)
  )
  (func (export "exact-br-on-cast-fail") (result funcref)
    (block (result funcref)
      (br_on_cast_fail 0 funcref (ref (exact $f)) (ref.func $1))
      (return)
    )
    (unreachable)
  )
)

(assert_return (invoke "exact-test") (i32.const 1))
(assert_return (invoke "exact-cast") (ref.func))
(assert_return (invoke "exact-br-on-cast") (ref.func))
(assert_return (invoke "exact-br-on-cast-fail") (ref.func))

;; Define a function with a type that has a supertype.
(module $C
  (type $super (sub (func)))
  (type $sub (sub $super (func)))
  (func (export "f") (type $sub))
  (func (export "g") (type $super))
)
(register "C")

;; TODO: Fix function type checking on linking.

;; ;; We should not be able to import the function with the exact supertype.
;; (assert_unlinkable
;;   (module
;;     (type $super (sub (func)))
;;     (type $sub (sub $super (func)))
;;     (import "C" "f" (func (exact (type $super))))
;;   )
;;   "incompatible import type"
;; )

;; But we can still import it and re-export it inexactly with the supertype.
(module $D
  (type $super (sub (func)))
  (type $sub (sub $super (func)))
  (import "C" "f" (func (type $super)))
  (export "f" (func 0))
)
(register "D")

;; As before, we can still import the function with its real dynamic type.
(module
  (type $super (sub (func)))
  (type $sub (sub $super (func)))
  (import "D" "f" (func (exact (type $sub))))
)

;; As before, even when the function is imported inexactly (this time with its
;; supertype), it can still be cast to its exact type.
(module
  (type $super (sub (func)))
  (type $sub (sub $super (func)))
  (import "C" "f" (func $1 (type $super)))
  (elem declare func $1)
  (func (export "exact-test") (result i32)
    (ref.test (ref (exact $sub)) (ref.func $1))
  )
  (func (export "exact-cast") (result (ref (exact $sub)))
    (ref.cast (ref (exact $sub)) (ref.func $1))
  )
  (func (export "exact-br-on-cast") (result funcref)
    (br_on_cast 0 funcref (ref (exact $sub)) (ref.func $1))
    (unreachable)
  )
  (func (export "exact-br-on-cast-fail") (result funcref)
    (block (result funcref)
      (br_on_cast_fail 0 funcref (ref (exact $sub)) (ref.func $1))
      (return)
    )
    (unreachable)
  )
)

(assert_return (invoke "exact-test") (i32.const 1))
(assert_return (invoke "exact-cast") (ref.func))
(assert_return (invoke "exact-br-on-cast") (ref.func))
(assert_return (invoke "exact-br-on-cast-fail") (ref.func))

;; But if we import a function whose dynamic type is the supertype, the same
;; casts will fail.
(module
  (type $super (sub (func)))
  (type $sub (sub $super (func)))
  (import "C" "g" (func $1 (type $super)))
  (elem declare func $1)
  (func (export "exact-test") (result i32)
    (ref.test (ref (exact $sub)) (ref.func $1))
  )
  (func (export "exact-cast") (result (ref (exact $sub)))
    (ref.cast (ref (exact $sub)) (ref.func $1))
  )
  (func (export "exact-br-on-cast") (result funcref)
    (br_on_cast 0 funcref (ref (exact $sub)) (ref.func $1))
    (unreachable)
  )
  (func (export "exact-br-on-cast-fail") (result funcref)
    (block (result funcref)
      (br_on_cast_fail 0 funcref (ref (exact $sub)) (ref.func $1))
      (return)
    )
    (unreachable)
  )
)

(assert_return (invoke "exact-test") (i32.const 0))
(assert_trap (invoke "exact-cast") "cast failure")
(assert_trap (invoke "exact-br-on-cast") "unreachable")
(assert_trap (invoke "exact-br-on-cast-fail") "unreachable")


;; Test the binary format

;; Exact function imports use 0x20.
(module binary
  "\00asm" "\01\00\00\00"
  "\01"  ;; Type section id
  "\04"  ;; Type section length
  "\01"  ;; Types vector length
  "\60"  ;; Function
  "\00"  ;; Number of params
  "\00"  ;; Number of results
  "\02"  ;; Import section id
  "\05"  ;; Import section length
  "\01"  ;; Import vector length
  "\00"  ;; Module name length
  "\00"  ;; Base name length
  "\20"  ;; Exact function
  "\00"  ;; Type index
)

;; 0x20 is malformed in exports.
(assert_malformed
  (module binary
    "\00asm" "\01\00\00\00"
    "\01"  ;; Type section id
    "\04"  ;; Type section length
    "\01"  ;; Types vector length
    "\60"  ;; Function
    "\00"  ;; Number of params
    "\00"  ;; Number of results
    "\03"  ;; Function section id
    "\02"  ;; Function section length
    "\01"  ;; Function vector length
    "\00"  ;; Type index
    "\07"  ;; Export section id
    "\04"  ;; Export section length
    "\01"  ;; Export vector length
    "\00"  ;; Name length
    "\20"  ;; Exact func (malformed)
    "\00"  ;; Function index
    "\0a"  ;; Code section
    "\04"  ;; Code section length
    "\01"  ;; Code vector length
    "\02"  ;; Function length
    "\00"  ;; Type index
    "\0b"  ;; End
  )
  "malformed export kind"
)
