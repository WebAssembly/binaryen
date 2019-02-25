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
      (local.set $x (i32.const 10))
    )
    (call $basic (i32.add (local.get $x) (local.get $x)))
  )
  (func $split-but-join (param $p i32)
    (local $x i32)
    (if (i32.const 1)
      (local.set $x (i32.const 10))
      (local.set $x (i32.const 10))
    )
    (call $basic (i32.add (local.get $x) (local.get $x)))
  )
  (func $split-but-join-different (param $p i32)
    (local $x i32)
    (if (i32.const 1)
      (local.set $x (i32.const 10))
      (local.set $x (i32.const 20))
    )
    (call $basic (i32.add (local.get $x) (local.get $x)))
  )
  (func $split-but-join-different-b (param $p i32)
    (local $x i32)
    (if (i32.const 1)
      (local.set $x (i32.const 10))
      (local.set $x (local.get $p))
    )
    (call $basic (i32.add (local.get $x) (local.get $x)))
  )
  (func $split-but-join-init0 (param $p i32)
    (local $x i32)
    (if (i32.const 1)
      (local.set $x (i32.const 0))
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
      (local.set $y (i32.const 11))
      (local.set $y (i32.add (local.get $x) (i32.const 1)))
    )
    (local.set $y (i32.add (local.get $x) (local.get $y)))
    (local.get $y)
  )
  (func $two-ways-but-almost-identical (param $p i32) (result i32)
    (local $x i32)
    (local $y i32)
    (local.set $x (i32.const 10))
    (if (i32.const 1)
      (local.set $y (i32.const 12)) ;; 12, not 11...
      (local.set $y (i32.add (local.get $x) (i32.const 1)))
    )
    (local.set $y (i32.add (local.get $x) (local.get $y)))
    (local.get $y)
  )
  (func $deadloop (param $p i32) (result i32)
    (local $x i32)
    (local $y i32)
    (loop $loop ;; we look like we depend on the other, but we don't actually
      (local.set $x (if (result i32) (i32.const 1) (i32.const 0) (local.get $y)))
      (local.set $y (if (result i32) (i32.const 1) (i32.const 0) (local.get $x)))
      (br $loop)
    )
  )
  (func $deadloop2 (param $p i32)
    (local $x i32)
    (local $y i32)
    (loop $loop ;; we look like we depend on the other, but we don't actually
      (local.set $x (if (result i32) (i32.const 1) (i32.const 0) (local.get $y)))
      (local.set $y (if (result i32) (i32.const 1) (i32.const 0) (local.get $x)))
      (call $deadloop2 (local.get $x))
      (call $deadloop2 (local.get $y))
      (br $loop)
    )
  )
  (func $deadloop3 (param $p i32)
    (local $x i32)
    (local $y i32)
    (loop $loop ;; we look like we depend on the other, but we don't actually
      (local.set $x (if (result i32) (i32.const 1) (i32.const 0) (local.get $x)))
      (local.set $y (if (result i32) (i32.const 1) (i32.const 0) (local.get $y)))
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
    (local.get $3)
    (local.set $3 ;; this set is completely removed, allowing later opts
     (i32.const 24)
    )
   )
   (if
    (local.get $3)
    (local.set $2
     (i32.const 0)
    )
   )
   (local.get $2)
  )
  (func $offsets (param $x i32)
    (drop
      (i32.load
        (i32.add
          (local.get $x)
          (i32.const 1)
        )
      )
    )
    (drop
      (i32.load
        (i32.add
          (local.get $x)
          (i32.const 8)
        )
      )
    )
    (drop
      (i32.load
        (i32.add
          (local.get $x)
          (i32.const 1023)
        )
      )
    )
    (drop
      (i32.load
        (i32.add
          (local.get $x)
          (i32.const 1024)
        )
      )
    )
    (drop
      (i32.load
        (i32.add
          (local.get $x)
          (i32.const 2048)
        )
      )
    )
    (drop
      (i32.load
        (i32.add
          (i32.const 4)
          (local.get $x)
        )
      )
    )
  )
  (func $load-off-2 "load-off-2" (param $0 i32) (result i32)
    (i32.store offset=2
      (i32.add
        (i32.const 1)
        (i32.const 3)
      )
      (local.get $0)
    )
    (i32.store offset=2
      (i32.add
        (i32.const 3)
        (i32.const 1)
      )
      (local.get $0)
    )
    (i32.store offset=2
      (i32.add
        (local.get $0)
        (i32.const 5)
      )
      (local.get $0)
    )
    (i32.store offset=2
      (i32.add
        (i32.const 7)
        (local.get $0)
      )
      (local.get $0)
    )
    (i32.store offset=2
      (i32.add
        (i32.const -11) ;; do not fold this!
        (local.get $0)
      )
      (local.get $0)
    )
    (i32.store offset=2
      (i32.add
        (local.get $0)
        (i32.const -13) ;; do not fold this!
      )
      (local.get $0)
    )
    (i32.store offset=2
      (i32.add
        (i32.const -15)
        (i32.const 17)
      )
      (local.get $0)
    )
    (i32.store offset=2
      (i32.add
        (i32.const -21)
        (i32.const 19)
      )
      (local.get $0)
    )
    (i32.store offset=2
      (i32.const 23)
      (local.get $0)
    )
    (i32.store offset=2
      (i32.const -25)
      (local.get $0)
    )
    (drop
      (i32.load offset=2
        (i32.add
          (i32.const 2)
          (i32.const 4)
        )
      )
    )
    (drop
      (i32.load offset=2
        (i32.add
          (i32.const 4)
          (i32.const 2)
        )
      )
    )
    (drop
      (i32.load offset=2
        (i32.add
          (local.get $0)
          (i32.const 6)
        )
      )
    )
    (drop
      (i32.load offset=2
        (i32.const 8)
      )
    )
    (i32.load offset=2
      (i32.add
        (i32.const 10)
        (local.get $0)
      )
    )
  )
  (func $offset-constant
    (drop
      (i32.load offset=10
        (i32.const 0)
      )
    )
    (drop
      (i32.load offset=0
        (i32.const 10)
      )
    )
    (drop
      (i32.load offset=10
        (i32.const 10)
      )
    )
    (drop
      (i32.load offset=512
        (i32.const 512)
      )
    )
    (drop
      (i32.load offset=512
        (i32.const 511)
      )
    )
    (drop
      (i32.load offset=511
        (i32.const 512)
      )
    )
    (drop
      (i32.load offset=99999
        (i32.const 512)
      )
    )
  )
  (func $offset-propagate
    (local $x i32)
    (local $y i32)
    (local.set $x
      (i32.add
        (local.get $y)
        (i32.const 1)
      )
    )
    (drop
      (i32.load
        (local.get $x)
      )
    )
  )
  (func $offset-propagate2
    (local $x i32)
    (local $y i32)
    (local.set $x
      (i32.add
        (local.get $y)
        (i32.add
          (i32.const 1)
          (i32.const 2)
        )
      )
    )
    (drop
      (i32.load
        (local.get $x)
      )
    )
  )
  (func $offset-propagate3
    (local $x i32)
    (local $y i32)
    (local.set $x
      (i32.add
        (i32.const 1)
        (local.get $y)
      )
    )
    (drop
      (i32.load
        (local.get $x)
      )
    )
  )
  (func $offset-propagate4
    (local $x i32)
    (local $y i32)
    (local.set $y (i32.const -1))
    (local.set $x
      (i32.add
        (i32.const 1)
        (local.get $y)
      )
    )
    (drop
      (i32.load
        (local.get $x)
      )
    )
  )
  (func $offset-propagate5 (param $z i32)
    (local $x i32)
    (local $y i32)
    (if (local.get $z)
      (local.set $y (i32.const -1))
    )
    (local.set $x
      (i32.add
        (i32.const 1)
        (local.get $y)
      )
    )
    (drop
      (i32.load
        (local.get $x)
      )
    )
  )
  (func $offset-propagate6 (param $z i32)
    (local $x i32)
    (local $y i32)
    (local.set $y (local.get $z))
    (local.set $x
      (i32.add
        (i32.const 1)
        (local.get $y)
      )
    )
    (local.set $y (i32.const -2))
    (drop
      (i32.load
        (local.get $x)
      )
    )
  )
  (export "offset-realistic" (func $offset-realistic))
  (func $offset-realistic (param $ptr i32)
    (local $x i32)
    (local $y i32)
    (local $z i32)
    (local.set $x
      (i32.add
        (local.get $ptr)
        (i32.const 8)
      )
    )
    (local.set $y
      (i32.add
        (local.get $ptr)
        (i32.const 16)
      )
    )
    (local.set $z
      (i32.add
        (local.get $ptr)
        (i32.const 24)
      )
    )
    (loop $l
      (call $offset-realistic
        (i32.load
          (local.get $x)
        )
      )
      (call $offset-realistic
        (i32.load
          (local.get $y)
        )
      )
      (call $offset-realistic
        (i32.load
          (local.get $y)
        )
      )
      (i32.store
        (local.get $z)
        (i32.add
          (i32.load
            (local.get $z)
          )
          (i32.const 1)
        )
      )
      (br_if $l
        (i32.load
          (local.get $z)
        )
      )
    )
  )
)

