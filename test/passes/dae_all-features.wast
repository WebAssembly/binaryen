(module
  (export "a8" (func $a8))
  (table 2 2 funcref)
  (elem (i32.const 0) $a9 $c8)
  (func $a (param $x i32))
  (func $b
    (call $a (i32.const 1)) ;; best case scenario
  )
  (func $a1 (param $x i32)
    (unreachable)
  )
  (func $b1
    (call $a1 (i32.const 2)) ;; same value in both, so works
  )
  (func $b11
    (call $a1 (i32.const 2))
  )
  (func $a2 (param $x i32)
    (drop (local.get $x))
  )
  (func $b2
    (call $a2 (i32.const 3)) ;; different value!
  )
  (func $b22
    (call $a2 (i32.const 4))
  )
  (func $a3 (param $x i32)
    (drop (i32.const -1)) ;; diff value, but at least unused, so no need to send
  )
  (func $b3
    (call $a3 (i32.const 3))
  )
  (func $b33
    (call $a3 (i32.const 4))
  )
  (func $a4 (param $x i32) ;; diff value, but with effects
  )
  (func $b4
    (call $a4 (unreachable))
  )
  (func $b43
    (call $a4 (i32.const 4))
  )
  (func $a5 (param $x i32) (param $y f64) ;; optimize two
    (drop (local.get $x))
    (drop (local.get $y))
  )
  (func $b5
    (call $a5 (i32.const 1) (f64.const 3.14159))
  )
  (func $a6 (param $x i32) (param $y f64) ;; optimize just one
    (drop (local.get $x))
    (drop (local.get $y))
  )
  (func $b6
    (call $a6 (unreachable) (f64.const 3.14159))
  )
  (func $a7 (param $x i32) (param $y f64) ;; optimize just the other one
    (drop (local.get $x))
    (drop (local.get $y))
  )
  (func $b7
    (call $a7 (i32.const 1) (unreachable))
  )
  (func $a8 (param $x i32)) ;; exported, do not optimize
  (func $b8
    (call $a8 (i32.const 1))
  )
  (func $a9 (param $x i32)) ;; tabled, do not optimize
  (func $b9
    (call $a9 (i32.const 1))
  )
  (func $a10 (param $x i32) ;; recursion
    (call $a10 (i32.const 1))
    (call $a10 (i32.const 1))
  )
  (func $a11 (param $x i32) ;; partially successful recursion
    (call $a11 (i32.const 1))
    (call $a11 (i32.const 2))
  )
  (func $a12 (param $x i32) ;; unsuccessful recursion
    (drop (local.get $x))
    (call $a12 (i32.const 1))
    (call $a12 (i32.const 2))
  )
  ;; return values
  (func $c1
    (local $x i32)
    (drop (call $c2))
    (drop (call $c3))
    (drop (call $c3))
    (drop (call $c4))
    (local.set $x (call $c4))
    (drop (call $c5 (unreachable)))
    (drop (call $c6))
    (drop (call $c7))
    (drop (call $c8))
  )
  (func $c2 (result i32)
    (i32.const 1)
  )
  (func $c3 (result i32)
    (i32.const 2)
  )
  (func $c4 (result i32)
    (i32.const 3)
  )
  (func $c5 (param $x i32) (result i32)
    (local.get $x)
  )
  (func $c6 (result i32)
    (unreachable)
  )
  (func $c7 (result i32)
    (return (i32.const 4))
  )
  (func $c8 (result i32)
    (i32.const 5)
  )
)
(module ;; both operations at once: remove params and return value
  (func "a"
    (drop
      (call $b
        (i32.const 1)
      )
    )
  )
  (func $b (param $x i32) (result i32)
    (local.get $x)
  )
)
(module ;; tail calls inhibit dropped result removal
  (func $foo (param $x i32) (result i32)
    (drop
      (return_call $bar
        (i32.const 0)
      )
    )
    (i32.const 42)
  )
  (func $bar (param $x i32) (result i32)
    (i32.const 7)
  )
)
(module ;; indirect tail calls inhibit dropped result removal
  (type $T (func (result i32)))
  (table 1 1 funcref)
  (func $foo (param $x i32) (result i32)
    (drop
      (return_call_indirect (type $T)
        (i32.const 0)
      )
    )
  )
  (func $bar
    (drop
      (call $foo
        (i32.const 42)
      )
    )
  )
)
(module
 (func $0 (param $0 funcref) (param $1 i32) (param $2 f64) (result i64)
  (nop)
  (unreachable)
 )
 (func "export" (param $0 f32) (result funcref)
  ;; a ref.func should prevent us from changing the type of a function, as it
  ;; may escape
  (ref.func $0)
 )
)
(module
 (type $i64 (func (param i64)))
 (global $global$0 (ref $i64) (ref.func $0))
 (export "even" (func $1))
 ;; the argument to this function cannot be removed due to the ref.func of it
 ;; in a global
 (func $0 (param $0 i64)
  (unreachable)
 )
 (func $1
  (call_ref
   (i64.const 0)
   (global.get $global$0)
  )
 )
 (func $2
  (call $0
   (i64.const 0)
  )
 )
)
(module
 ;; a removable non-nullable parameter
 (func $0 (param $x i31ref)
  (nop)
 )
 (func $1
  (call $0
   (i31.new (i32.const 0))
  )
 )
)
