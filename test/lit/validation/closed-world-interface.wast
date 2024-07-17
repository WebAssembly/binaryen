;; Test that we error out on nontrivial public types with --closed-world

;; RUN: not wasm-opt -all --closed-world %s 2>&1 | filecheck %s


;; This is pulled in by a global.
;; CHECK:      publicly exposed type disallowed with a closed world: $array, on
;; CHECK-NEXT: (array (mut i32))

;; This is pulled in only by a global, so it is disallowed even though it is a function type.
;; CHECK:      publicly exposed type disallowed with a closed world: $private, on
;; CHECK-NEXT: (func (param v128))

;; This is referred to by the type of a function export, but is still not allowed.
;; CHECK:      publicly exposed type disallowed with a closed world: $struct, on
;; CHECK-NEXT: (struct)

(module
  (type $struct (struct))
  (type $array (array (mut i32)))

  (type $void (func))
  (type $abstract (func (param anyref)))
  (type $concrete (func (param (ref null $struct))))

  (rec
    (type $exported-pair-0 (func (param (ref $exported-pair-1))))
    (type $exported-pair-1 (func (param (ref $exported-pair-0))))
  )
  (rec
    ;; This is on an exported function.
    (type $partial-pair-0 (func))
    ;; The latter type types are not public, but allowed to be because the
    ;; entire rec group is allowed due to the first.
    (type $partial-pair-1 (func))
    ;; Test a non-function type.
    (type $partial-pair-2 (struct))
  )

  (type $private (func (param v128)))

  ;; Ok even though it is an import instead of an export.
  (func $1 (import "env" "test5") (type $exported-pair-1))

  (func $2 (export "test1") (type $void)
    (unreachable)
  )

  ;; Ok because it only refers to basic heap types
  (func $3 (export "test2") (type $abstract)
    (unreachable)
  )

  ;; Not ok because it refers to $struct.
  (func $4 (export "test3") (type $concrete)
    (unreachable)
  )

  ;; Ok even though it is in a rec group because the rest of the group and the
  ;; types this refers to are on the boundary as well.
  (func $5 (export "test4") (type $exported-pair-0)
    (unreachable)
  )

  ;; Ok, and we also allow the other type in the group.
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
