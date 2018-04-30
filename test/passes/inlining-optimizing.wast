(module
  (table 1 1 anyfunc)
  (elem (i32.const 0) $tabled)
  (func $user (export "user")
    (local $x i32)
    (local $y f64)
    (call $exported)
    (call $exported_small)
    (call $tabled)
    (call $tabled_small)
    (call $multi)
    (call $multi)
    (call $multi_small)
    (call $multi_small)
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
    (nop)
  )
  (func $exported_small (export "exported_small")
    (nop)
  )
  (func $recursive
    (call $recursive)
  )
  (func $tabled
    (nop)
    (nop)
  )
  (func $tabled_small
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
    (nop)
  )
  (func $multi_small
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
 (func $main (result i32)
  (call $func_51)
  (i32.const 0)
 )
 (func $func_51
  (unreachable) ;; void function but having unreachable body, when inlined, type must be fixed
 )
)
(module
 (memory $0 (shared 1 1))
 (func $0 (result i32)
  (i32.atomic.store16
   (i32.const 0)
   (i32.const 0)
  )
  (i32.const 1)
 )
 (func $1 (result i64)
  (drop
   (call $0)
  )
  (i64.const 0)
 )
)
;; potential infinite recursion
(module
 (func $main
  (call $one)
  (call $one)
 )
 (func $one
  (call $one)
 )
)
;; potential infinite cycling recursion
(module
 (func $main
  (call $one)
  (call $one)
 )
 (func $one
  (call $two)
 )
 (func $two
  (call $one)
 )
)
;; make sure to dce, as we may be combining unreachable code with others
(module
 (type $0 (func))
 (type $1 (func (param i32 i32) (result i32)))
 (table 89 89 anyfunc)
 (memory $0 17)
 (start $1)
 (func $0 (; 0 ;) (type $1) (param $0 i32) (param $1 i32) (result i32)
  (i32.store
   (i32.const 4)
   (tee_local $0
    (i32.const 0)
   )
  )
  (i32.store
   (i32.add
    (get_local $0)
    (i32.const 56)
   )
   (i32.const 0)
  )
  (i64.store
   (i32.const 49)
   (i64.load
    (i32.const 24)
   )
  )
  (unreachable)
 )
 (func $1 (; 1 ;) (type $0)
  (drop
   (call $0
    (i32.const 0)
    (i32.const 0)
   )
  )
 )
)
