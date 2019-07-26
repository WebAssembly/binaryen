(module
  (table 1 1 funcref)
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
    (local.set $x (call $int2))
    (local.set $y (call $double2))
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
    (local.set $x (f32.const 2.141828))
  )
  (func $with-local2
    (local $y i64)
    (local.set $y (i64.const 4))
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
    (drop (local.get $x))
    (drop (local.get $y))
    (drop (local.get $z))
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
   (local.get $0) ;; we depend on the zero-init value here, so it must be set when inlining!
   (local.tee $0
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
      (global.get $hangLimit)
     )
     (return
      (i32.const 54)
     )
    )
    (global.set $hangLimit
     (i32.sub
      (global.get $hangLimit)
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
  (global.set $hangLimit
   (i32.const 25)
  )
 )
)
(module
 (type $T (func (param i32)))
 (table 10 funcref)
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
(module
 (func $0 (result i32)
  (return_call $1)
 )
 (func $1 (result i32)
  (i32.const 42)
 )
)
(module
 (func $0
  (return_call $1
   (i32.const 42)
  )
 )
 (func $1 (param i32)
  (drop
   (local.get 0)
  )
 )
)
(module
 (func $0 (result i32)
  (return_call $1
   (i32.const 42)
  )
 )
 (func $1 (param i32) (result i32)
  (local.get 0)
 )
)
(module
 (func $0
  (drop
   (call $1)
  )
 )
 (func $1 (result i32)
  (return_call $2)
 )
 (func $2 (result i32)
  (i32.const 42)
 )
)
(module
 (func $0
  (call $1)
 )
 (func $1
  (return_call $2
   (i32.const 42)
  )
 )
 (func $2 (param i32)
  (drop
   (local.get 0)
  )
 )
)
(module
 (type $T (func (param i32) (result i32)))
 (table 10 funcref)
 (func $0
  (drop
   (call $1)
  )
 )
 (func $1 (result i32)
  (return_call_indirect (type $T)
   (i32.const 42)
   (i32.const 0)
  )
 )
)
(module
 (type $T (func (param i32)))
 (table 10 funcref)
 (func $0
  (call $1)
 )
 (func $1
  (return_call_indirect (type $T)
   (i32.const 42)
   (i32.const 0)
  )
 )
)
(module
 (type $6 (func))
 (memory $0 1 1)
 (global $global$0 (mut i32) (i32.const 10))
 (export "func_102_invoker" (func $19))
 (func $2 (; 2 ;) (type $6)
  (if
   (global.get $global$0)
   (return)
  )
  (global.set $global$0
   (i32.const 1)
  )
 )
 (func $13 (; 13 ;) (type $6)
  (if
   (global.get $global$0)
   (unreachable)
  )
  (return_call $2)
 )
 (func $19 (; 19 ;) (type $6)
  (call $13)
  (unreachable)
 )
)
