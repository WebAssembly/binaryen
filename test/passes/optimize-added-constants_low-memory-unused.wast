(module
  (memory 1 1)
  (func $consts
    (drop
      (i32.load (i32.const 0))
    )
    (drop
      (i32.load (i32.const 1))
    )
    (drop
      (i32.load (i32.const 1023))
    )
    (drop
      (i32.load (i32.const 1024))
    )
    (drop
      (i32.load offset=0 (i32.const 0))
    )
    (drop
      (i32.load offset=1 (i32.const 0))
    )
    (drop
      (i32.load offset=1023 (i32.const 0))
    )
    (drop
      (i32.load offset=1024 (i32.const 0))
    )
    (drop
      (i32.load offset=512 (i32.const 511))
    )
    (drop
      (i32.load offset=512 (i32.const 512))
    )
    (i32.store (i32.const 1) (i32.const 1))
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
  (func $load-off-2 (param $0 i32) (result i32)
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
  (func $offset-propagate-param (param $x i32)
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

