;; RUN: not wasm-merge %s env -all 2>&1 | filecheck %s

;; Test of exports / imports type matching

;; CHECK: Type mismatch when importing function f1 from module env ($bad1): type (type $func.0 (func)) is not a subtype of (type $func.0 (func (param (ref eq)))).
;; CHECK-NEXT: Type mismatch when importing function f3 from module env ($bad2): type (type $func.0 (sub (func (result anyref)))) is not a subtype of (type $func.0 (sub $func.1 (func (result eqref)))).
;; CHECK-NEXT: Type mismatch when importing table t1 from module env ($bad1): minimal size 10 is smaller than expected minimal size 11.
;; CHECK-NEXT: Type mismatch when importing table t1 from module env ($bad2): maximal size 100 is larger than expected maximal size 99.
;; CHECK-NEXT: Type mismatch when importing table t2 from module env ($bad3): expecting a bounded table but the imported table is unbounded.
;; CHECK-NEXT: Type mismatch when importing table t3 from module env ($bad4): export type anyref is different from import type funcref.
;; CHECK-NEXT: Type mismatch when importing memory m1 from module env ($bad1): minimal size 10 is smaller than expected minimal size 11.
;; CHECK-NEXT: Type mismatch when importing memory m1 from module env ($bad2): maximal size 100 is larger than expected maximal size 99.
;; CHECK-NEXT: Type mismatch when importing memory m2 from module env ($bad3): expecting a bounded memory but the imported memory is unbounded.
;; CHECK-NEXT: Type mismatch when importing memory m3 from module env ($bad4): index type should match.
;; CHECK-NEXT: Type mismatch when importing global g1 from module env ($bad1): mutability should match.
;; CHECK-NEXT: Type mismatch when importing global g2 from module env ($bad2): mutability should match.
;; CHECK-NEXT: Type mismatch when importing global g2 from module env ($bad3): export type eqref is different from import type i31ref.
;; CHECK-NEXT: Type mismatch when importing global g2 from module env ($bad4): export type eqref is different from import type anyref.
;; CHECK-NEXT: Type mismatch when importing global g1 from module env ($bad5): type eqref is not a subtype of i31ref.
;; CHECK-NEXT: Type mismatch when importing tag t from module env ($bad1): export type (func (param eqref)) is different from import type (func (param anyref)).
;; CHECK-NEXT: Type mismatch when importing tag t from module env ($bad2): export type (func (param eqref)) is different from import type (func (param i31ref)).
;; CHECK-NEXT: Fatal: import/export mismatches

(module
  (type $f (sub (func (result anyref))))
  (type $g (sub $f (func (result eqref))))

  (import "env" "f1" (func $good1))
  (import "env" "f2" (func $good2 (type $f)))

  (import "env" "f1" (func $bad1 (param (ref eq))))
  (import "env" "f3" (func $bad2 (type $g)))

  (import "env" "t1" (table $good1 10 funcref))
  (import "env" "t1" (table $good2 10 100 funcref))
  (import "env" "t2" (table $good3 10 funcref))
  (import "env" "t3" (table $good4 10 anyref))

  (import "env" "t1" (table $bad1 11 funcref))
  (import "env" "t1" (table $bad2 10 99 funcref))
  (import "env" "t2" (table $bad3 10 100 funcref))
  (import "env" "t3" (table $bad4 10 funcref))

  (import "env" "m1" (memory $good1 10))
  (import "env" "m1" (memory $good2 10 100))
  (import "env" "m2" (memory $good3 10))
  (import "env" "m3" (memory $good4 i64 10))

  (import "env" "m1" (memory $bad1 11))
  (import "env" "m1" (memory $bad2 10 99))
  (import "env" "m2" (memory $bad3 10 100))
  (import "env" "m3" (memory $bad4 10))

  (import "env" "g1" (global $good1 anyref))
  (import "env" "g2" (global $good2 (mut eqref)))

  (import "env" "g1" (global $bad1 (mut eqref)))
  (import "env" "g2" (global $bad2 eqref))
  (import "env" "g2" (global $bad3 (mut i31ref)))
  (import "env" "g2" (global $bad4 (mut anyref)))
  (import "env" "g1" (global $bad5 i31ref))

  (import "env" "t" (tag $good1 (param eqref)))

  (import "env" "t" (tag $bad1 (param anyref)))
  (import "env" "t" (tag $bad2 (param i31ref)))

  (func (export "f1"))
  (func (export "f2") (type $g) (ref.null eq))
  (func (export "f3") (type $f) (ref.null eq))

  (table (export "t1") 10 100 funcref)
  (table (export "t2") 10 funcref)
  (table (export "t3") 10 anyref)

  (memory (export "m1") 10 100)
  (memory (export "m2") 10)
  (memory (export "m3") i64 10)

  (global (export "g1") eqref (ref.null eq))
  (global (export "g2") (mut eqref) (ref.null eq))

  (tag (export "t") (param eqref))
)
