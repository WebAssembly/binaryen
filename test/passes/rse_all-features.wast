(module
  (func $basic (param $x i32) (param $y f64)
    (local $a f32)
    (local $b i64)
    (local.set $x (i32.const 0))
    (local.set $y (f64.const 0))
    (local.set $a (f32.const 0))
    (local.set $b (i64.const 0))
  )
  (func $later-param-use (param $x i32)
    (local.set $x (i32.const 0))
    (local.set $x (i32.const 0))
  )
  (func $diff-value (param $x i32)
    (local $a i32)
    (local.set $x (i32.const 0))
    (local.set $x (i32.const 1))
    (local.set $x (i32.const 1))
    (local.set $a (i32.const 1))
    (local.set $a (i32.const 1))
    (local.set $a (i32.const 0))
  )
  (func $tuple-value
    (local $x (i32 i64))
    (local.set $x
      (tuple.make (i32.const 42) (i64.const 42))
    )
    (local.set $x
      (tuple.make (i32.const 42) (i64.const 42))
    )
  )
  (func $unreach
    (local $a i32)
    (block $x
      (local.set $a (i32.const 0))
      (local.set $a (i32.const 1))
      (local.set $a (i32.const 1))
      (br $x)
      (local.set $a (i32.const 1)) ;; ignore all these
      (local.set $a (i32.const 2))
      (local.set $a (i32.const 2))
    )
  )
  (func $loop
    (local $a i32)
    (local $b i32)
    (loop $x
      (local.set $a (i32.const 0))
      (local.set $a (i32.const 1))
      (br_if $x (i32.const 1))
    )
    (block $y
      (local.set $b (i32.const 0))
      (local.set $b (i32.const 1))
      (br $y)
    )
    (local.set $b (i32.const 1))
  )
  (func $if
    (local $x i32)
    (if (local.tee $x (i32.const 0))
      (local.set $x (i32.const 1))
      (local.set $x (i32.const 1))
    )
    (local.set $x (i32.const 1))
  )
  (func $if2
    (local $x i32)
    (if (local.tee $x (i32.const 1))
      (local.set $x (i32.const 1))
      (local.set $x (i32.const 1))
    )
    (local.set $x (i32.const 1))
  )
  (func $if3
    (local $x i32)
    (if (local.tee $x (i32.const 1))
      (local.set $x (i32.const 1))
      (local.set $x (i32.const 2))
    )
    (local.set $x (i32.const 1))
  )
  (func $copy
    (local $x i32)
    (local $y i32)
    (local.set $x (i32.const 1))
    (local.set $y (local.get $x))
    (local.set $y (i32.const 1))
    (local.set $x (i32.const 2))
    (if (i32.const 1) (nop) (nop)) ;; control flow
    (local.set $y (local.get $x))
    (local.set $y (i32.const 2))
    (if (i32.const 1) (nop) (nop)) ;; control flow
    (local.set $y (i32.const 2))
    ;; flip
    (local.set $x (i32.const 3))
    (local.set $y (i32.const 3))
    (local.set $y (local.get $x)) ;; do this last
  )
  (func $param-unique
    (param $x i32)
    (local $a i32)
    (local.set $a (local.get $x))
    (local.set $a (local.get $x))
    (local.set $x (i32.eqz (i32.const 9999)))
    (local.set $a (local.get $x))
    (local.set $a (local.get $x))
  )
  (func $set-unique
    (local $x i32)
    (local $y i32)
    (local.set $x (i32.eqz (i32.const 123)))
    (local.set $y (local.get $x))
    (local.set $y (local.get $x))
    (local.set $x (i32.eqz (i32.const 456)))
    (local.set $y (local.get $x))
    (local.set $y (local.get $x))
    (local.set $x (i32.eqz (i32.const 789)))
    (if (i32.const 1) (nop) (nop)) ;; control flow
    (local.set $y (local.get $x))
    (local.set $y (local.get $x))
    (local.set $x (i32.eqz (i32.const 1000)))
    (local.set $y (local.get $x))
    (if (i32.const 1) (nop) (nop)) ;; control flow
    (local.set $y (local.get $x))
  )
  (func $identical_complex (param $x i32)
    (local $y i32)
    (local.set $y (local.get $x))
    (local.set $y (local.get $x))
    (local.set $y (local.get $x))
    (local.set $x (local.get $x))
    (local.set $y (local.get $y))
    (local.set $x (local.get $y))
  )
  (func $merge
    (local $x i32)
    (if (i32.const 1)
      (local.set $x (i32.const 1))
      (local.set $x (i32.const 1))
    )
    (local.set $x (i32.const 1))
    (local.set $x (i32.const 2))
    (loop $loop
      (local.set $x (i32.const 2))
      (local.set $x (i32.const 3))
      (local.set $x (i32.const 2))
      (br_if $loop (i32.const 2))
    )
    (local.set $x (i32.const 2))
  )
  (func $one-arm
   (param $1 i32)
   (param $3 i32)
   (local.set $1
    (local.get $3)
   )
   (if
    (i32.const 1)
    (nop)
    (local.set $3
     (local.get $1)
    )
   )
  )
  (func $one-arm2
   (param $1 i32)
   (param $3 i32)
   (local.set $1
    (local.get $3)
   )
   (if
    (i32.const 1)
    (local.set $3
     (local.get $1)
    )
   )
  )
  (func $many-merges
   (local $0 i32)
   (local $1 i32)
   (block $block
    (br_if $block
     (i32.const 0)
    )
    (loop $loop
     (local.set $1
      (local.get $0)
     )
     (local.set $0
      (i32.const 99)
     )
     (br_if $loop
      (i32.const 1)
     )
    )
   )
   (local.set $0 ;; make them equal
    (local.get $1)
   )
   (if
    (i32.const 0)
    (local.set $1 ;; we can drop this
     (local.get $0)
    )
   )
  )
  (func $fuzz
   (local $x i32)
   (loop $label$4
    (block $label$5
     (if
      (i32.const 1)
      (block
       (local.set $x
        (i32.const 203)
       )
       (br $label$5)
      )
     )
     (br_if $label$4
      (i32.const 2)
     )
    )
   )
   (loop $label$7
    (if
     (if (result i32)
      (i32.const 3)
      (i32.const 4)
      (i32.const 5)
     )
     (br $label$7)
    )
   )
  )
  (func $fuzz2
   (local $var$1 i32)
   (if
    (i32.const 0)
    (if
     (i32.const 1)
     (local.set $var$1
      (i32.const 2)
     )
    )
   )
   (loop $label$10
    (block $label$11
     (if
      (i32.const 5)
      (br_if $label$11
       (i32.const 6)
      )
     )
     (br $label$10)
    )
   )
  )
  (func $fuzz-nan
   (local $0 f64)
   (local $1 f64)
   (block $block
    (br_if $block
     (i32.const 0)
    )
    (loop $loop
     (local.set $1
      (local.get $0)
     )
     (local.set $0
      (f64.const -nan:0xfffffffffff87)
     )
     (br_if $loop
      (i32.const 1)
     )
    )
   )
   (local.set $0 ;; make them equal
    (local.get $1)
   )
   (if
    (i32.const 0)
    (local.set $1 ;; we can drop this
     (local.get $0)
    )
   )
  )

  (event $e (attr 0) (param i32))
  (func $try1
    (local $x i32)
    (try
      (do)
      (catch_all
        (local.set $x (i32.const 1))
      )
    )
    ;; try will not throw. So this should NOT be dropped
    (local.set $x (i32.const 1))
  )
  (func $try2
    (local $x i32)
    (try
      (do
        (throw $e (i32.const 0))
        (local.set $x (i32.const 1))
      )
      (catch_all)
    )
    ;; local.set is after 'throw' so it will not run. This should NOT be
    ;; dropped.
    (local.set $x (i32.const 1))
  )
  (func $try3
    (local $x i32)
    (try
      (do
        (throw $e (i32.const 0))
      )
      (catch_all
        (local.set $x (i32.const 1))
      )
    )
    ;; try body will throw and catch_all contains the same local.set. This
    ;; should be dropped.
    (local.set $x (i32.const 1))
  )
  (func $foo)
  (func $try4
    (local $x i32)
    (try
      (do
        (call $foo)
        (local.set $x (i32.const 1))
      )
      (catch_all)
    )
    ;; (call $foo) may throw and the local.set may not run, so this should NOT
    ;; be dropped
    (local.set $x (i32.const 1))
  )
  (func $try5
    (local $x i32)
    (try
      (do
        (local.set $x (i32.const 1))
        (call $foo)
      )
      (catch_all)
    )
    ;; Even if (call $foo) throws, local.set runs before it, so this should be
    ;; dropped
    (local.set $x (i32.const 1))
  )
  (func $nested-try1
    (local $x i32)
    (try
      (do
        (try $l0
          (do
            (throw $e (i32.const 0))
          )
          (catch_all
            (rethrow $l0)
          )
        )
      )
      (catch_all
        (local.set $x (i32.const 1))
      )
    )
    ;; The exception is caught by the inner catch_all and rethrown and again
    ;; caught by the outer catch_all, which runs the local.set. So this should
    ;; be dropped.
    (local.set $x (i32.const 1))
  )
  (func $nested-try2
    (local $x i32)
    (try
      (do
        (try $l0
          (do
            (throw $e (i32.const 0))
          )
          (catch_all
            (local.set $x (i32.const 1))
            (rethrow $l0)
          )
        )
      )
      (catch_all)
    )
    ;; The exception is caught by the inner catch_all, which runs the local.set,
    ;; so this should be dropped
    (local.set $x (i32.const 1))
  )
  (func $nested-try3
    (local $x i32)
    (try
      (do
        (try $l0
          (do
            (throw $e (i32.const 0))
          )
          (catch $e
            (drop (pop i32))
            (local.set $x (i32.const 1))
            (rethrow $l0)
          )
        )
      )
      (catch_all)
    )
    ;; Unlike nested-try2, the exception may not be caught by the inner catch,
    ;; so the local.set may not run. So this should NOT be dropped.
    (local.set $x (i32.const 1))
  )
)
