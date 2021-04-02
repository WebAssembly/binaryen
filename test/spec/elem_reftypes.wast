;; Test the element section

;; Syntax
(module
  (table $t 10 funcref)
  (func $f)
  (func $g)

  ;; Passive
  (elem funcref)
  (elem funcref (ref.func $f) (item ref.func $f) (item (ref.null func)) (ref.func $g))
  (elem func)
  (elem func $f $f $g $g)

  (elem $p1 funcref)
  (elem $p2 funcref (ref.func $f) (ref.func $f) (ref.null func) (ref.func $g))
  (elem $p3 func)
  (elem $p4 func $f $f $g $g)

  ;; Active
  (elem (table $t) (i32.const 0) funcref)
  (elem (table $t) (i32.const 0) funcref (ref.func $f) (ref.null func))
  (elem (table $t) (i32.const 0) func)
  (elem (table $t) (i32.const 0) func $f $g)
  (elem (table $t) (offset (i32.const 0)) funcref)
  (elem (table $t) (offset (i32.const 0)) func $f $g)
  (elem (table 0) (i32.const 0) func)
  ;; (elem (table 0x0) (i32.const 0) func $f $f)
  ;; (elem (table 0x000) (offset (i32.const 0)) func)
  (elem (table 0) (offset (i32.const 0)) func $f $f)
  (elem (table $t) (i32.const 0) func)
  (elem (table $t) (i32.const 0) func $f $f)
  (elem (table $t) (offset (i32.const 0)) func)
  (elem (table $t) (offset (i32.const 0)) func $f $f)
  (elem (offset (i32.const 0)))
  (elem (offset (i32.const 0)) funcref (ref.func $f) (ref.null func))
  (elem (offset (i32.const 0)) func $f $f)
  (elem (offset (i32.const 0)) $f $f)
  (elem (i32.const 0))
  (elem (i32.const 0) funcref (ref.func $f) (ref.null func))
  (elem (i32.const 0) func $f $f)
  (elem (i32.const 0) $f $f)

  (elem $a1 (table $t) (i32.const 0) funcref)
  (elem $a2 (table $t) (i32.const 0) funcref (ref.func $f) (ref.null func))
  (elem $a3 (table $t) (i32.const 0) func)
  (elem $a4 (table $t) (i32.const 0) func $f $g)
  (elem $a9 (table $t) (offset (i32.const 0)) funcref)
  (elem $a10 (table $t) (offset (i32.const 0)) func $f $g)
  (elem $a11 (table 0) (i32.const 0) func)
  ;; (elem $a12 (table 0x0) (i32.const 0) func $f $f)
  ;; (elem $a13 (table 0x000) (offset (i32.const 0)) func)
  (elem $a14 (table 0) (offset (i32.const 0)) func $f $f)
  (elem $a15 (table $t) (i32.const 0) func)
  (elem $a16 (table $t) (i32.const 0) func $f $f)
  (elem $a17 (table $t) (offset (i32.const 0)) func)
  (elem $a18 (table $t) (offset (i32.const 0)) func $f $f)
  (elem $a19 (offset (i32.const 0)))
  (elem $a20 (offset (i32.const 0)) funcref (ref.func $f) (ref.null func))
  (elem $a21 (offset (i32.const 0)) func $f $f)
  (elem $a22 (offset (i32.const 0)) $f $f)
  (elem $a23 (i32.const 0))
  (elem $a24 (i32.const 0) funcref (ref.func $f) (ref.null func))
  (elem $a25 (i32.const 0) func $f $f)
  (elem $a26 (i32.const 0) $f $f)

  ;; Declarative
  (elem declare funcref)
  (elem declare funcref (ref.func $f) (ref.func $f) (ref.null func) (ref.func $g))
  (elem declare func)
  (elem declare func $f $f $g $g)

  (elem $d1 declare funcref)
  (elem $d2 declare funcref (ref.func $f) (ref.func $f) (ref.null func) (ref.func $g))
  (elem $d3 declare func)
  (elem $d4 declare func $f $f $g $g)
)

(module
  (func $f)
  (func $g)

  (table $t1 funcref (elem (ref.func $f) (ref.null func) (ref.func $g)))
  (table $t2 (ref null func) (elem (ref.func $f) (ref.null func) (ref.func $g)))
)


;; Basic use

(module
  (table 10 funcref)
  (func $f)
  (elem (i32.const 0) $f)
)
(module
  (import "spectest" "table" (table 10 funcref))
  (func $f)
  (elem (i32.const 0) $f)
)

(module
  (table 10 funcref)
  (func $f)
  (elem (i32.const 0) $f)
  (elem (i32.const 3) $f)
  (elem (i32.const 7) $f)
  (elem (i32.const 5) $f)
  (elem (i32.const 3) $f)
)
(module
  (import "spectest" "table" (table 10 funcref))
  (func $f)
  (elem (i32.const 9) $f)
  (elem (i32.const 3) $f)
  (elem (i32.const 7) $f)
  (elem (i32.const 3) $f)
  (elem (i32.const 5) $f)
)

(module
  (global (import "spectest" "global_i32") i32)
  (table 1000 funcref)
  (func $f)
  (elem (global.get 0) $f)
)

(module
  (global $g (import "spectest" "global_i32") i32)
  (table 1000 funcref)
  (func $f)
  (elem (global.get $g) $f)
)

(module
  (type $out-i32 (func (result i32)))
  (table 10 funcref)
  (elem (i32.const 7) $const-i32-a)
  (elem (i32.const 9) $const-i32-b)
  (func $const-i32-a (type $out-i32) (i32.const 65))
  (func $const-i32-b (type $out-i32) (i32.const 66))
  (func (export "call-7") (type $out-i32)
    (call_indirect (type $out-i32) (i32.const 7))
  )
  (func (export "call-9") (type $out-i32)
    (call_indirect (type $out-i32) (i32.const 9))
  )
)
(assert_return (invoke "call-7") (i32.const 65))
(assert_return (invoke "call-9") (i32.const 66))

;; Corner cases

(module
  (table 10 funcref)
  (func $f)
  (elem (i32.const 9) $f)
)
(module
  (import "spectest" "table" (table 10 funcref))
  (func $f)
  (elem (i32.const 9) $f)
)

(module
  (table 0 funcref)
  (elem (i32.const 0))
)
(module
  (import "spectest" "table" (table 0 funcref))
  (elem (i32.const 0))
)

(module
  (table 0 0 funcref)
  (elem (i32.const 0))
)

(module
  (table 20 funcref)
  (elem (i32.const 20))
)

;;; We cannot enable these yet since we check table bounds at validation stage,
;;; which is incorrect for imported tables.
;; (module
;;   (import "spectest" "table" (table 0 funcref))
;;   (func $f)
;;   (elem (i32.const 0) $f)
;; )

;; (module
;;   (import "spectest" "table" (table 0 100 funcref))
;;   (func $f)
;;   (elem (i32.const 0) $f)
;; )

;; (module
;;   (import "spectest" "table" (table 0 funcref))
;;   (func $f)
;;   (elem (i32.const 1) $f)
;; )

;; (module
;;   (import "spectest" "table" (table 0 30 funcref))
;;   (func $f)
;;   (elem (i32.const 1) $f)
;; )

;; Two elements target the same slot

(module
  (type $out-i32 (func (result i32)))
  (table 10 funcref)
  (elem (i32.const 9) $const-i32-a)
  (elem (i32.const 9) $const-i32-b)
  (func $const-i32-a (type $out-i32) (i32.const 65))
  (func $const-i32-b (type $out-i32) (i32.const 66))
  (func (export "call-overwritten") (type $out-i32)
    (call_indirect (type $out-i32) (i32.const 9))
  )
)
(assert_return (invoke "call-overwritten") (i32.const 66))

(module
  (type $out-i32 (func (result i32)))
  (import "spectest" "table" (table 10 funcref))
  (elem (i32.const 9) $const-i32-a)
  (elem (i32.const 9) $const-i32-b)
  (func $const-i32-a (type $out-i32) (i32.const 65))
  (func $const-i32-b (type $out-i32) (i32.const 66))
  (func (export "call-overwritten-element") (type $out-i32)
    (call_indirect (type $out-i32) (i32.const 9))
  )
)
(assert_return (invoke "call-overwritten-element") (i32.const 66))

;; Element sections across multiple modules change the same table

(module $module1
  (type $out-i32 (func (result i32)))
  (table (export "shared-table") 10 funcref)
  (elem (i32.const 8) $const-i32-a)
  (elem (i32.const 9) $const-i32-b)
  (func $const-i32-a (type $out-i32) (i32.const 65))
  (func $const-i32-b (type $out-i32) (i32.const 66))
  (func (export "call-7") (type $out-i32)
    (call_indirect (type $out-i32) (i32.const 7))
  )
  (func (export "call-8") (type $out-i32)
    (call_indirect (type $out-i32) (i32.const 8))
  )
  (func (export "call-9") (type $out-i32)
    (call_indirect (type $out-i32) (i32.const 9))
  )
)

(assert_invalid
  (module
    (type $none_=>_none (func))
    (table 0 (ref null $none_=>_none))
    (elem (i32.const 0) funcref)
  )
)