(module
  (table 1 1 anyfunc)
  (elem (i32.const 0) $tabled)
  (func $user (export "user")
    (local $x i32)
    (local $y f64)
    (call $exported)
    (call $tabled)
    (call $multi)
    (call $multi)
    (call $ok)
    (drop (call $int))
    (drop (call $double))
    (set_local $x (call $int2))
    (set_local $y (call $double2))
    (call $with-local)
    (call $with-local2)
    (drop (call $return))
    (call $multipass)
    (call $param (f32.const 12.34) (i64.const 890005350012))
  )
  (func $exported (export "exported")
    (nop)
  )
  (func $recursive
    (call $recursive)
  )
  (func $tabled
    (nop)
  )
  (func $cycle1
    (call $cycle2)
  )
  (func $cycle2
    (call $cycle1)
  )
  (func $multi
    (nop)
  )
  (func $ok
    (drop (i32.const 1))
  )
  (func $int (result i32)
    (i32.const 2)
  )
  (func $double (result f64)
    (f64.const 3.14159)
  )
  (func $int2 (result i32)
    (i32.const 112)
  )
  (func $double2 (result f64)
    (f64.const 113.14159)
  )
  (func $with-local
    (local $x f32)
    (set_local $x (f32.const 2.141828))
  )
  (func $with-local2
    (local $y i64)
    (set_local $y (i64.const 4))
  )
  (func $return (result i32)
    (return (i32.const 5))
  )
  (func $multipass
    (call $multipass2)
  )
  (func $multipass2
    (drop (i32.const 6))
  )
  (func $param (param $x f32) (param $y i64)
    (local $z f32)
    (drop (get_local $x))
    (drop (get_local $y))
    (drop (get_local $z))
  )
)
(module
  (func $child (param i32) (result i32)
    (i32.const 1234)
  )
  (func $parent (result i32)
    (call $child
      (unreachable) ;; call is not performed, no sense to inline
    )
  )
)
(module
 (global $hangLimit (mut i32) (i32.const 25))
 (memory $0 1 1)
 (export "hangLimitInitializer" (func $hangLimitInitializer))
 (func $func_3 (result i32)
  (local $0 i32)
  (select
   (get_local $0) ;; we depend on the zero-init value here, so it must be set when inlining!
   (tee_local $0
    (i32.const -1)
   )
   (i32.const 1)
  )
 )
 (func $func_4 (param $0 f32) (param $1 i32) (result i32)
  (local $2 i64)
  (local $3 f64)
  (local $4 f32)
  (local $5 i32)
  (local $6 i32)
  (local $7 f64)
  (loop $label$0 (result i32)
   (block
    (if
     (i32.eqz
      (get_global $hangLimit)
     )
     (return
      (i32.const 54)
     )
    )
    (set_global $hangLimit
     (i32.sub
      (get_global $hangLimit)
      (i32.const 1)
     )
    )
   )
   (i32.eqz
    (if (result i32)
     (i32.const 1)
     (if (result i32)
      (i32.eqz
       (call $func_3)
      )
      (br $label$0)
      (i32.const 0)
     )
     (unreachable)
    )
   )
  )
 )
 (func $hangLimitInitializer
  (set_global $hangLimit
   (i32.const 25)
  )
 )
)
(module
 (type $T (func (param i32)))
 (table 10 anyfunc)
 (func $0
  (call $1)
 )
 (func $1
  (call_indirect (type $T)
   (if (result i32) ;; if copy must preserve the forced type
    (i32.const 0)
    (unreachable)
    (unreachable)
   )
   (i32.const 1)
  )
 )
)
(module
 (func $0
  (block $label$1 ;; copy this name
   (br_table $label$1 $label$1
    (i32.const 0)
   )
  )
 )
 (func $1
  (call $0)
 )
)

