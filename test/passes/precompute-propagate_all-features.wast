(module
  (memory 10 10)
  (func $basic (param $p i32)
    (local $x i32)
    (local.set $x (i32.const 10))
    (call $basic (i32.add (local.get $x) (local.get $x)))
  )
  (func $split (param $p i32)
    (local $x i32)
    (if (i32.const 1)
      (then
        (local.set $x (i32.const 10))
      )
    )
    (call $basic (i32.add (local.get $x) (local.get $x)))
  )
  (func $split-but-join (param $p i32)
    (local $x i32)
    (if (i32.const 1)
      (then
        (local.set $x (i32.const 10))
      )
      (else
        (local.set $x (i32.const 10))
      )
    )
    (call $basic (i32.add (local.get $x) (local.get $x)))
  )
  (func $split-but-join-different (param $p i32)
    (local $x i32)
    (if (i32.const 1)
      (then
        (local.set $x (i32.const 10))
      )
      (else
        (local.set $x (i32.const 20))
      )
    )
    (call $basic (i32.add (local.get $x) (local.get $x)))
  )
  (func $split-but-join-different-b (param $p i32)
    (local $x i32)
    (if (i32.const 1)
      (then
        (local.set $x (i32.const 10))
      )
      (else
        (local.set $x (local.get $p))
      )
    )
    (call $basic (i32.add (local.get $x) (local.get $x)))
  )
  (func $split-but-join-init0 (param $p i32)
    (local $x i32)
    (if (i32.const 1)
      (then
        (local.set $x (i32.const 0))
      )
    )
    (call $basic (i32.add (local.get $x) (local.get $x)))
  )
  (func $later (param $p i32)
    (local $x i32)
    (local.set $x (i32.const 10))
    (call $basic (i32.add (local.get $x) (local.get $x)))
    (local.set $x (i32.const 22))
    (call $basic (i32.add (local.get $x) (local.get $x)))
    (local.set $x (i32.const 39))
  )
  (func $later2 (param $p i32) (result i32)
    (local $x i32)
    (local.set $x (i32.const 10))
    (local.set $x (i32.add (local.get $x) (local.get $x)))
    (local.get $x)
  )
  (func $two-ways-but-identical (param $p i32) (result i32)
    (local $x i32)
    (local $y i32)
    (local.set $x (i32.const 10))
    (if (i32.const 1)
      (then
        (local.set $y (i32.const 11))
      )
      (else
        (local.set $y (i32.add (local.get $x) (i32.const 1)))
      )
    )
    (local.set $y (i32.add (local.get $x) (local.get $y)))
    (local.get $y)
  )
  (func $two-ways-but-almost-identical (param $p i32) (result i32)
    (local $x i32)
    (local $y i32)
    (local.set $x (i32.const 10))
    (if (i32.const 1)
      (then
        (local.set $y (i32.const 12)) ;; 12, not 11...
      )
      (else
        (local.set $y (i32.add (local.get $x) (i32.const 1)))
      )
    )
    (local.set $y (i32.add (local.get $x) (local.get $y)))
    (local.get $y)
  )
  (func $deadloop (param $p i32) (result i32)
    (local $x i32)
    (local $y i32)
    (loop $loop ;; we look like we depend on the other, but we don't actually
      (local.set $x (if (result i32) (i32.const 1) (then (i32.const 0) )(else (local.get $y))))
      (local.set $y (if (result i32) (i32.const 1) (then (i32.const 0) )(else (local.get $x))))
      (br $loop)
    )
  )
  (func $deadloop2 (param $p i32)
    (local $x i32)
    (local $y i32)
    (loop $loop ;; we look like we depend on the other, but we don't actually
      (local.set $x (if (result i32) (i32.const 1) (then (i32.const 0) )(else (local.get $y))))
      (local.set $y (if (result i32) (i32.const 1) (then (i32.const 0) )(else (local.get $x))))
      (call $deadloop2 (local.get $x))
      (call $deadloop2 (local.get $y))
      (br $loop)
    )
  )
  (func $deadloop3 (param $p i32)
    (local $x i32)
    (local $y i32)
    (loop $loop ;; we look like we depend on the other, but we don't actually
      (local.set $x (if (result i32) (i32.const 1) (then (i32.const 0) )(else (local.get $x))))
      (local.set $y (if (result i32) (i32.const 1) (then (i32.const 0) )(else (local.get $y))))
      (call $deadloop2 (local.get $x))
      (call $deadloop2 (local.get $y))
      (br $loop)
    )
  )
  (func $through-tee (param $x i32) (param $y i32) (result i32)
    (local.set $x
      (local.tee $y
        (i32.const 7)
      )
    )
    (return
      (i32.add
        (local.get $x)
        (local.get $y)
      )
    )
  )
  (func $through-tee-more (param $x i32) (param $y i32) (result i32)
    (local.set $x
      (i32.eqz
        (local.tee $y
          (i32.const 7)
        )
      )
    )
    (return
      (i32.add
        (local.get $x)
        (local.get $y)
      )
    )
  )
  (func $multipass (param $0 i32) (param $1 i32) (param $2 i32) (result i32)
   (local $3 i32)
   (if
    (local.get $3) ;; this will be precomputed to 0. after that, the if will be
                   ;; precomputed to not exist at all. removing the set in the
                   ;; if body then allows us to optimize the value of $3 in the
                   ;; if lower down, but we do not do an additional cycle of
                   ;; this pass automatically as such things are fairly rare,
                   ;; so that opportunity remains unoptimized in this test.
    (then
     (local.set $3 ;; this set is completely removed, allowing later opts
      (i32.const 24)
     )
    )
   )
   (if
    (local.get $3)
    (then
     (local.set $2
      (i32.const 0)
     )
    )
   )
   (local.get $2)
  )
  (func $through-fallthrough (param $x i32) (param $y i32) (result i32)
    (local.set $x
      (block (result i32)
        (nop)
        (local.tee $y
          (i32.const 7)
        )
      )
    )
    (return
      (i32.add
        (local.get $x)
        (local.get $y)
      )
    )
  )
  (func $simd-load (result v128)
   (local $x v128)
   (local.set $x (v128.load8_splat (i32.const 0)))
   (local.get $x)
  )
  (func $tuple-local (result i32 i64)
   (local $i32s (tuple i32 i32))
   (local $i64s (tuple i64 i64))
   (local.set $i32s
    (tuple.make 2
     (i32.const 42)
     (i32.const 0)
    )
   )
   (local.set $i64s
    (tuple.make 2
     (i64.const 42)
     (i64.const 0)
    )
   )
   (tuple.make 2
    (tuple.extract 2 0
     (local.get $i32s)
    )
    (tuple.extract 2 1
     (local.get $i64s)
    )
   )
  )
)
