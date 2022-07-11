;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.

;; RUN: wasm-opt --new-wat-parser --hybrid -all %s -S -o - | filecheck %s

(module $parse
 ;; types
 (rec
  ;; CHECK:      (rec 
  ;; CHECK-NEXT:  (type $s0 (struct_subtype  data))
  (type $s0 (sub (struct)))
  ;; CHECK:       (type $s1 (struct_subtype  data))
  (type $s1 (struct (field)))
 )

 (rec)

 ;; CHECK:      (type $s2 (struct_subtype (field i32) data))
 (type $s2 (struct i32))
 ;; CHECK:      (type $s3 (struct_subtype (field i64) data))
 (type $s3 (struct (field i64)))
 ;; CHECK:      (type $s4 (struct_subtype (field $x f32) data))
 (type $s4 (struct (field $x f32)))
 ;; CHECK:      (type $s5 (struct_subtype (field i32) (field i64) data))
 (type $s5 (struct i32 i64))
 ;; CHECK:      (type $s6 (struct_subtype (field i64) (field f32) data))
 (type $s6 (struct (field i64 f32)))
 ;; CHECK:      (type $s7 (struct_subtype (field $x f32) (field $y f64) data))
 (type $s7 (struct (field $x f32) (field $y f64)))
 ;; CHECK:      (type $s8 (struct_subtype (field i32) (field i64) (field $z f32) (field f64) (field (mut i32)) data))
 (type $s8 (struct i32 (field) i64 (field $z f32) (field f64 (mut i32))))

 ;; CHECK:      (type $a0 (array_subtype i32 data))
 (type $a0 (array i32))
 ;; CHECK:      (type $a1 (array_subtype i64 data))
 (type $a1 (array (field i64)))
 ;; CHECK:      (type $a2 (array_subtype (mut f32) data))
 (type $a2 (array (mut f32)))
 ;; CHECK:      (type $a3 (array_subtype (mut f64) data))
 (type $a3 (array (field $x (mut f64))))

 (rec
   ;; CHECK:      (type $void (func_subtype func))
   (type $void (func))
 )

 ;; CHECK:      (type $subvoid (func_subtype $void))
 (type $subvoid (sub $void (func)))

 ;; CHECK:      (type $many (func_subtype (param i32 i64 f32 f64) (result anyref (ref func)) func))
 (type $many (func (param $x i32) (param i64 f32) (param) (param $y f64)
                   (result anyref (ref func))))

 ;; CHECK:      (type $submany (func_subtype (param i32 i64 f32 f64) (result anyref (ref func)) $many))
 (type $submany (sub $many (func (param i32 i64 f32 f64) (result anyref (ref func)))))

 ;; globals
 (global $g1 (export "g1") (export "g1.1") (import "mod" "g1") i32)
 (global $g2 (import "mod" "g2") (mut i64))
 (global (import "" "g3") (ref 0))
 (global (import "mod" "") (ref null $many))

 (global i32 i32.const 0)
 ;; CHECK:      (import "mod" "g1" (global $g1 i32))

 ;; CHECK:      (import "mod" "g2" (global $g2 (mut i64)))

 ;; CHECK:      (import "" "g3" (global $gimport$0 (ref $s0)))

 ;; CHECK:      (import "mod" "" (global $gimport$1 (ref null $many)))

 ;; CHECK:      (global $2 i32 (i32.const 0))

 ;; CHECK:      (global $i32 i32 (i32.const 42))
 (global $i32 i32 i32.const 42)

 ;; uninteresting globals just to use the types
 ;; CHECK:      (global $s0 (mut (ref null $s0)) (ref.null $s0))
 (global $s0 (mut (ref null $s0)) ref.null $s0)
 ;; CHECK:      (global $s1 (mut (ref null $s1)) (ref.null $s1))
 (global $s1 (mut (ref null $s1)) ref.null $s1)
 ;; CHECK:      (global $s2 (mut (ref null $s2)) (ref.null $s2))
 (global $s2 (mut (ref null $s2)) ref.null $s2)
 ;; CHECK:      (global $s3 (mut (ref null $s3)) (ref.null $s3))
 (global $s3 (mut (ref null $s3)) ref.null $s3)
 ;; CHECK:      (global $s4 (mut (ref null $s4)) (ref.null $s4))
 (global $s4 (mut (ref null $s4)) ref.null $s4)
 ;; CHECK:      (global $s5 (mut (ref null $s5)) (ref.null $s5))
 (global $s5 (mut (ref null $s5)) ref.null $s5)
 ;; CHECK:      (global $s6 (mut (ref null $s6)) (ref.null $s6))
 (global $s6 (mut (ref null $s6)) ref.null $s6)
 ;; CHECK:      (global $s7 (mut (ref null $s7)) (ref.null $s7))
 (global $s7 (mut (ref null $s7)) ref.null $s7)
 ;; CHECK:      (global $s8 (mut (ref null $s8)) (ref.null $s8))
 (global $s8 (mut (ref null $s8)) ref.null $s8)
 ;; CHECK:      (global $a0 (mut (ref null $a0)) (ref.null $a0))
 (global $a0 (mut (ref null $a0)) ref.null $a0)
 ;; CHECK:      (global $a1 (mut (ref null $a1)) (ref.null $a1))
 (global $a1 (mut (ref null $a1)) ref.null $a1)
 ;; CHECK:      (global $a2 (mut (ref null $a2)) (ref.null $a2))
 (global $a2 (mut (ref null $a2)) ref.null $a2)
 ;; CHECK:      (global $a3 (mut (ref null $a3)) (ref.null $a3))
 (global $a3 (mut (ref null $a3)) ref.null $a3)
 ;; CHECK:      (global $sub0 (mut (ref null $subvoid)) (ref.null $subvoid))
 (global $sub0 (mut (ref null $subvoid)) ref.null $subvoid)
 ;; CHECK:      (global $sub1 (mut (ref null $submany)) (ref.null $submany))
 (global $sub1 (mut (ref null $submany)) ref.null $submany)
)
;; CHECK:      (export "g1" (global $g1))

;; CHECK:      (export "g1.1" (global $g1))
