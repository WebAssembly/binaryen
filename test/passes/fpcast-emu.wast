(module
  (type $vijfd (func (param i32) (param i64) (param f32) (param f64)))
  (type $jii (func (param i32) (param i32) (result i64)))
  (type $fjj (func (param i64) (param i64) (result f32)))
  (type $dff (func (param f32) (param f32) (result f64)))
  (type $idd (func (param f64) (param f64) (result i32)))
  (import "env" "imported_func" (func $imported-func (param i32 i64 f32 f64) (result f32)))
  (table 10 10 funcref)
  (elem (i32.const 0) $a $b $c $d $e $e $imported-func)
  (func $a (param $x i32) (param $y i64) (param $z f32) (param $w f64)
    (call_indirect (type $vijfd)
      (i32.const 1)
      (i64.const 2)
      (f32.const 3)
      (f64.const 4)
      (i32.const 1337)
    )
  )
  (func $b (param $x i32) (param $y i32) (result i64)
    (call_indirect (type $jii)
      (i32.const 1)
      (i32.const 2)
      (i32.const 1337)
    )
  )
  (func $c (param $x i64) (param $y i64) (result f32)
    (call_indirect (type $fjj)
      (i64.const 1)
      (i64.const 2)
      (i32.const 1337)
    )
  )
  (func $d (param $x f32) (param $y f32) (result f64)
    (call_indirect (type $dff)
      (f32.const 1)
      (f32.const 2)
      (i32.const 1337)
    )
  )
  (func $e (param $x f64) (param $y f64) (result i32)
    (call_indirect (type $idd)
      (f64.const 1)
      (f64.const 2)
      (i32.const 1337)
    )
  )
)
(module
 (type $0 (func (param i64)))
 (type $1 (func (param f32) (result i64)))
 (global $global$0 (mut i32) (i32.const 10))
 (table 42 42 funcref)
 (export "func_106" (func $0))
 (func $0 (; 0 ;) (type $1) (param $0 f32) (result i64)
  (block $label$1 (result i64)
   (loop $label$2
    (global.set $global$0
     (i32.const 0)
    )
    (call_indirect (type $0)
     (br $label$1
      (i64.const 4294967295)
     )
     (i32.const 18)
    )
   )
  )
 )
)
(module
 (table 42 42 funcref)
 (elem (i32.const 0) $a $b)
 (export "dynCall_vf" (func $dynCall_vf))
 (export "dynCall_vd" (func $min_vd))
 (func $a (param $0 f32))
 (func $a (param $0 f64))
 (func $dynCall_vf (param $0 f32))
 (func $min_vd (param $0 f32))
)

