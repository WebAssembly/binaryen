;; Test that we error out on nontrivial public types with --closed-world

;; RUN: not wasm-opt -all --closed-world %s 2>&1 | filecheck %s


;; This is pulled in because it is part of a rec group with $partial-pair-0.
;; CHECK:      publicly exposed type disallowed with a closed world: $partial-pair-1, on
;; CHECK-NEXT: (func)

;; This is pulled in by a global.
;; CHECK:      publicly exposed type disallowed with a closed world: $array, on
;; CHECK-NEXT: (array (mut i8))

;; This is pulled in only by a global, so it is disallowed even though it is a function type.
;; CHECK:      publicly exposed type disallowed with a closed world: $private, on
;; CHECK-NEXT: (func (param v128))

;; This is referred to by the type of a function export, but is still not allowed.
;; CHECK:      publicly exposed type disallowed with a closed world: $struct, on
;; CHECK-NEXT: (struct)

(module
  (type $struct (struct))
  (type $array (array (mut i8)))

  (type $void (func))
  (type $abstract (func (param anyref)))
  (type $concrete (func (param (ref null $struct))))

  (rec
    (type $exported-pair-0 (func (param (ref $exported-pair-1))))
    (type $exported-pair-1 (func (param (ref $exported-pair-0))))
  )
  (rec
    (type $partial-pair-0 (func))
    (type $partial-pair-1 (func))
  )

  (type $private (func (param v128)))

  (func $1 (export "test1") (type $void)
    (unreachable)
  )

  ;; Ok because it only refers to basic heap types
  (func $2 (export "test2") (type $abstract)
    (unreachable)
  )

  ;; Not ok because it refers to $struct.
  (func $3 (export "test3") (type $concrete)
    (unreachable)
  )

  ;; Ok even though it is in a rec group because the rest of the group and the
  ;; types this refers to are on the boundary as well.
  (func $4 (export "test4") (type $exported-pair-0)
    (unreachable)
  )

  ;; Ok even though it is an import instead of an export.
  (func $5 (import "env" "test5") (type $exported-pair-1))

  ;; Not ok because another type in the group is not on the boundary.
  (func $6 (export "test6") (type $partial-pair-0)
    (unreachable)
  )

  ;; Not ok.
  (global $1 (export "g1") (ref null $array) (ref.null none))

  ;; Ok because this type is on the boundary anyway.
  (global $2 (export "g2") (ref null $void) (ref.null func))

  ;; Not ok even though it is a function type because it is not otherwise on the
  ;; boundary.
  (global $3 (export "g3") (ref null $private) (ref.null func))
)
