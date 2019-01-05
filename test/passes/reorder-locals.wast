(module
  (memory 256 256)
  (type $0 (func (param i32 i32)))
  (type $1 (func))
  (func $b0-yes (type $0) (param $a i32) (param $b i32)
    (local $x i32)
    (local $y i32)
    (local $z i32)
    (local.set $x
      (local.get $x)
    )
    (local.set $y
      (local.get $y)
    )
    (local.set $y
      (local.get $y)
    )
    (local.set $z
      (local.get $z)
    )
    (local.set $z
      (local.get $z)
    )
    (local.set $z
      (local.get $z)
    )
    (local.set $b
      (local.get $b)
    )
    (local.set $b
      (local.get $b)
    )
    (local.set $b
      (local.get $b)
    )
    (local.set $b
      (local.get $b)
    )
    (local.set $b
      (local.get $b)
    )
    (local.set $b
      (local.get $b)
    )
  )
  (func $zero (type $1)
    (local $a i32)
    (local $b i32)
    (local $c i32)
    (drop
      (local.get $b)
    )
  )
  (func $null (type $1)
    (local $a i32)
    (local $c i32)
    (nop)
  )
)
