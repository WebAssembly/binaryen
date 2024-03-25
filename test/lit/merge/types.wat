;; RUN: not wasm-merge %s env -all 2>&1 | filecheck %s

;; Test of exports / imports type matching

;; CHECK: Type mismatch when importing function f1 from module env: type (type $func.0 (func)) is not a subtype of (type $func.0 (func (param (ref eq)))).
;; CHECK-NEXT: Type mismatch when importing function f3 from module env: type (type $func.0 (sub (func (result anyref)))) is not a subtype of (type $func.0 (sub $func.1 (func (result eqref)))).
;; CHECK-NEXT: Type mismatch when importing table t1 from module env: minimal size 10 is smaller than expected minimal size 11.
;; CHECK-NEXT: Type mismatch when importing table t1 from module env: maximal size 100 is larger than expected maximal size 99.
;; CHECK-NEXT: Type mismatch when importing table t2 from module env: expecting a bounded table but the imported table is unbounded.
;; CHECK-NEXT: Type mismatch when importing table t3 from module env: export type anyref is different from import type funcref.
;; CHECK-NEXT: Type mismatch when importing memory m1 from module env: minimal size 10 is smaller than expected minimal size 11.
;; CHECK-NEXT: Type mismatch when importing memory m1 from module env: maximal size 100 is larger than expected maximal size 99.
;; CHECK-NEXT: Type mismatch when importing memory m2 from module env: expecting a bounded memory but the imported memory is unbounded.
;; CHECK-NEXT: Type mismatch when importing memory m3 from module env: index type should match.
;; CHECK-NEXT: Type mismatch when importing global g1 from module env: mutability should match.
;; CHECK-NEXT: Type mismatch when importing global g2 from module env: mutability should match.
;; CHECK-NEXT: Type mismatch when importing global g2 from module env: export type eqref is different from import type i31ref.
;; CHECK-NEXT: Type mismatch when importing global g2 from module env: export type eqref is different from import type anyref.
;; CHECK-NEXT: Type mismatch when importing global g1 from module env: type eqref is not a subtype of i31ref.
;; CHECK-NEXT: Type mismatch when importing tag t from module env: export type (func (param eqref)) is different from import type (func (param anyref)).
;; CHECK-NEXT: Type mismatch when importing tag t from module env: export type (func (param eqref)) is different from import type (func (param i31ref)).
;; CHECK-NEXT: Fatal: import/export mismatches

(module
  (type $f (sub (func (result anyref))))
  (type $g (sub $f (func (result eqref))))

  (func (export "f1"))
  (func (export "f2") (type $g) (ref.null eq))
  (func (export "f3") (type $f) (ref.null eq))

  (import "env" "f1" (func))
  (import "env" "f2" (func (type $f)))

  (import "env" "f1" (func (param (ref eq))))
  (import "env" "f3" (func (type $g)))

  (table (export "t1") 10 100 funcref)
  (table (export "t2") 10 funcref)
  (table (export "t3") 10 anyref)

  (import "env" "t1" (table 10 funcref))
  (import "env" "t1" (table 10 100 funcref))
  (import "env" "t2" (table 10 funcref))
  (import "env" "t3" (table 10 anyref))

  (import "env" "t1" (table 11 funcref))
  (import "env" "t1" (table 10 99 funcref))
  (import "env" "t2" (table 10 100 funcref))
  (import "env" "t3" (table 10 funcref))

  (memory (export "m1") 10 100)
  (memory (export "m2") 10)
  (memory (export "m3") i64 10)

  (import "env" "m1" (memory 10))
  (import "env" "m1" (memory 10 100))
  (import "env" "m2" (memory 10))
  (import "env" "m3" (memory i64 10))

  (import "env" "m1" (memory 11))
  (import "env" "m1" (memory 10 99))
  (import "env" "m2" (memory 10 100))
  (import "env" "m3" (memory 10))

  (global (export "g1") eqref (ref.null eq))
  (global (export "g2") (mut eqref) (ref.null eq))

  (import "env" "g1" (global anyref))
  (import "env" "g2" (global (mut eqref)))

  (import "env" "g1" (global (mut eqref)))
  (import "env" "g2" (global eqref))
  (import "env" "g2" (global (mut i31ref)))
  (import "env" "g2" (global (mut anyref)))
  (import "env" "g1" (global i31ref))

  (tag (export "t") (param eqref))

  (import "env" "t" (tag (param eqref)))

  (import "env" "t" (tag (param anyref)))
  (import "env" "t" (tag (param i31ref)))
)
