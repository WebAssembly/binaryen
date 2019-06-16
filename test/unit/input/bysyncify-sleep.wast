(module
  (memory 1 2)
  (type $ii (func (param i32) (result i32)))
  (import "env" "sleep" (func $sleep))
  (import "env" "tunnel" (func $tunnel (param $x i32) (result i32)))
  (export "memory" (memory 0))
  (export "factorial-recursive" (func $factorial-recursive))
  (global $temp (mut i32) (i32.const 0))
  (table 10 funcref)
  (elem (i32.const 5) $tablefunc)
  (func "minimal" (result i32)
    (call $sleep)
    (i32.const 21)
  )
  (func "repeat" (result i32)
    ;; sleep twice, then return 42
    (call $sleep)
    (call $sleep)
    (i32.const 42)
  )
  (func "local" (result i32)
    (local $x i32)
    (local.set $x (i32.load (i32.const 0))) ;; a zero that the optimizer won't see
    (local.set $x
      (i32.add (local.get $x) (i32.const 10)) ;; add 10
    )
    (call $sleep)
    (local.get $x)
  )
  (func "local2" (result i32)
    (local $x i32)
    (local.set $x (i32.load (i32.const 0))) ;; a zero that the optimizer won't see
    (local.set $x
      (i32.add (local.get $x) (i32.const 10)) ;; add 10
    )
    (call $sleep)
    (local.set $x
      (i32.add (local.get $x) (i32.const 12)) ;; add 12 more
    )
    (local.get $x)
  )
  (func "params" (param $x i32) (param $y i32) (result i32)
    (local.set $x
      (i32.add (local.get $x) (i32.const 17)) ;; add 10
    )
    (local.set $y
      (i32.add (local.get $y) (i32.const 1)) ;; add 12 more
    )
    (call $sleep)
    (i32.add (local.get $x) (local.get $y))
  )
  (func $pre
    (global.set $temp (i32.const 1))
  )
  (func $inner (param $x i32)
    (if (i32.eqz (local.get $x)) (call $post))
    (if (local.get $x) (call $sleep))
    (if (i32.eqz (local.get $x)) (call $post))
  )
  (func $post
    (global.set $temp
      (i32.mul
        (global.get $temp)
        (i32.const 3)
      )
    )
  )
  (func "deeper" (param $x i32) (result i32)
    (call $pre)
    (call $inner (local.get $x))
    (call $post)
    (global.get $temp)
  )
  (func $factorial-recursive (param $x i32) (result i32)
    (if
      (i32.eq
        (local.get $x)
        (i32.const 1)
      )
      (return (i32.const 1))
    )
    (call $sleep)
    (return
      (i32.mul
        (local.get $x)
        (call $factorial-recursive
          (i32.sub
            (local.get $x)
            (i32.const 1)
          )
        )
      )
    )
  )
  (func "factorial-loop" (param $x i32) (result i32)
    (local $i i32)
    (local $ret i32)
    (local.set $ret (i32.const 1))
    (local.set $i (i32.const 2))
    (loop $l
      (if
        (i32.gt_u
          (local.get $i)
          (local.get $x)
        )
        (return (local.get $ret))
      )
      (local.set $ret
        (i32.mul
          (local.get $ret)
          (local.get $i)
        )
      )
      (call $sleep)
      (local.set $i
        (i32.add
          (local.get $i)
          (i32.const 1)
        )
      )
      (br $l)
    )
  )
  (func "end_tunnel" (param $x i32) (result i32)
    (local.set $x
      (i32.add (local.get $x) (i32.const 22))
    )
    (call $sleep)
    (i32.add (local.get $x) (i32.const 5))
  )
  (func "do_tunnel" (param $x i32) (result i32)
    (local.set $x
      (i32.add (local.get $x) (i32.const 11))
    )
    (local.set $x
      (call $tunnel (local.get $x)) ;; calls js which calls back into wasm for end_tunnel
    )
    (call $sleep)
    (i32.add (local.get $x) (i32.const 33))
  )
  (func $tablefunc (param $y i32) (result i32)
    (local.set $y
      (i32.add (local.get $y) (i32.const 10))
    )
    (call $sleep)
    (i32.add (local.get $y) (i32.const 30))
  )
  (func "call_indirect" (param $x i32) (param $y i32) (result i32)
    (local.set $x
      (i32.add (local.get $x) (i32.const 1))
    )
    (call $sleep)
    (local.set $x
      (i32.add (local.get $x) (i32.const 3))
    )
    (local.set $y
      (call_indirect (type $ii) (local.get $y) (local.get $x)) ;; call function pointer x + 4, which will be 5
    )
    (local.set $y
      (i32.add (local.get $y) (i32.const 90))
    )
    (call $sleep)
    (i32.add (local.get $y) (i32.const 300)) ;; total is 10+30+90+300=430 + y's original value
  )
  (func "if_else" (param $x i32) (param $y i32) (result i32)
    (if (i32.eq (local.get $x) (i32.const 1))
      (local.set $y
        (i32.add (local.get $y) (i32.const 10))
      )
      (local.set $y
        (i32.add (local.get $y) (i32.const 20))
      )
    )
    (if (i32.eq (local.get $x) (i32.const 1))
      (local.set $y
        (i32.add (local.get $y) (i32.const 40))
      )
      (call $sleep)
    )
    (if (i32.eq (local.get $x) (i32.const 1))
      (call $sleep)
      (local.set $y
        (i32.add (local.get $y) (i32.const 90))
      )
    )
    (if (i32.eq (local.get $x) (i32.const 1))
      (call $sleep)
      (call $sleep)
    )
    (local.set $y
      (i32.add (local.get $y) (i32.const 160))
    )
    (call $sleep)
    (local.set $y
      (i32.add (local.get $y) (i32.const 250))
    )
    (local.get $y)
  )
)

