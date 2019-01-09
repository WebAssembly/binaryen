(module
  ;; Recursive factorial
  (func (export "fac-rec") (param i64) (result i64)
    (if i64 (i64.eq (local.get 0) (i64.const 0))
      (i64.const 1)
      (i64.mul (local.get 0) (call 0 (i64.sub (local.get 0) (i64.const 1))))
    )
  )

  ;; Recursive factorial named
  (func $fac-rec-named (export "fac-rec-named") (param $n i64) (result i64)
    (if i64 (i64.eq (local.get $n) (i64.const 0))
      (i64.const 1)
      (i64.mul
        (local.get $n)
        (call $fac-rec-named (i64.sub (local.get $n) (i64.const 1)))
      )
    )
  )

  ;; Iterative factorial
  (func (export "fac-iter") (param i64) (result i64)
    (local i64 i64)
    (local.set 1 (local.get 0))
    (local.set 2 (i64.const 1))
    (block
      (loop
        (if
          (i64.eq (local.get 1) (i64.const 0))
          (br 2)
          (block
            (local.set 2 (i64.mul (local.get 1) (local.get 2)))
            (local.set 1 (i64.sub (local.get 1) (i64.const 1)))
          )
        )
        (br 0)
      )
    )
    (local.get 2)
  )

  ;; Iterative factorial named
  (func (export "fac-iter-named") (param $n i64) (result i64)
    (local $i i64)
    (local $res i64)
    (local.set $i (local.get $n))
    (local.set $res (i64.const 1))
    (block $done
      (loop $loop
        (if
          (i64.eq (local.get $i) (i64.const 0))
          (br $done)
          (block
            (local.set $res (i64.mul (local.get $i) (local.get $res)))
            (local.set $i (i64.sub (local.get $i) (i64.const 1)))
          )
        )
        (br $loop)
      )
    )
    (local.get $res)
  )

  ;; Optimized factorial.
  (func (export "fac-opt") (param i64) (result i64)
    (local i64)
    (local.set 1 (i64.const 1))
    (block
      (br_if 0 (i64.lt_s (local.get 0) (i64.const 2)))
      (loop
        (local.set 1 (i64.mul (local.get 1) (local.get 0)))
        (local.set 0 (i64.add (local.get 0) (i64.const -1)))
        (br_if 0 (i64.gt_s (local.get 0) (i64.const 1)))
      )
    )
    (local.get 1)
  )
)

(assert_return (invoke "fac-rec" (i64.const 25)) (i64.const 7034535277573963776))
(assert_return (invoke "fac-iter" (i64.const 25)) (i64.const 7034535277573963776))
(assert_return (invoke "fac-rec-named" (i64.const 25)) (i64.const 7034535277573963776))
(assert_return (invoke "fac-iter-named" (i64.const 25)) (i64.const 7034535277573963776))
(assert_return (invoke "fac-opt" (i64.const 25)) (i64.const 7034535277573963776))
(assert_trap (invoke "fac-rec" (i64.const 1073741824)) "call stack exhausted")
