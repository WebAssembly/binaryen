(module
 (type $0 (func (param i64 i64 i64) (result i32)))
 (type $1 (func (param i32) (result i32)))
 (func $figure-1a (; 0 ;) (type $0) (param $a i64) (param $x i64) (param $y i64) (result i32)
  (local $i i32)
  (local $j i32)
  (local $r i32)
  (local $6 i64)
  (local $7 i64)
  (local $8 i32)
  (local $9 i64)
  (local $10 i64)
  (local $11 i32)
  (local $12 i32)
  (local $13 i32)
  (local $14 i32)
  (local $15 i32)
  (local $16 i32)
  (local $17 i32)
  (block
   (local.set $6
    (local.get $a)
   )
   (local.set $7
    (local.get $x)
   )
   (local.set $8
    (i64.eq
     (local.get $6)
     (local.get $7)
    )
   )
   (local.set $i
    (local.get $8)
   )
   (nop)
   (local.set $9
    (local.get $a)
   )
   (local.set $10
    (local.get $y)
   )
   (local.set $11
    (i64.ne
     (local.get $9)
     (local.get $10)
    )
   )
   (local.set $j
    (local.get $11)
   )
   (nop)
   (local.set $12
    (local.get $i)
   )
   (local.set $13
    (local.get $j)
   )
   (local.set $14
    (i32.and
     (local.get $12)
     (local.get $13)
    )
   )
   (local.set $r
    (local.get $14)
   )
   (nop)
   (local.set $15
    (local.get $r)
   )
   (return
    (local.get $15)
   )
   (unreachable)
  )
  (local.set $17
   (local.get $16)
  )
  (return
   (local.get $17)
  )
 )
 (func $figure-1b (; 1 ;) (type $0) (param $a i64) (param $x i64) (param $y i64) (result i32)
  (local $i i32)
  (local $j i32)
  (local $r i32)
  (local $6 i64)
  (local $7 i64)
  (local $8 i32)
  (local $9 i64)
  (local $10 i64)
  (local $11 i32)
  (local $12 i64)
  (local $13 i64)
  (local $14 i32)
  (local $15 i32)
  (local $16 i32)
  (local $17 i32)
  (local $18 i32)
  (block
   (local.set $6
    (local.get $x)
   )
   (local.set $7
    (local.get $y)
   )
   (local.set $8
    (i64.lt_s
     (local.get $6)
     (local.get $7)
    )
   )
   (if
    (local.get $8)
    (block
     (block $block
      (local.set $9
       (local.get $a)
      )
      (local.set $10
       (local.get $x)
      )
      (local.set $11
       (i64.eq
        (local.get $9)
        (local.get $10)
       )
      )
      (local.set $i
       (local.get $11)
      )
      (nop)
      (local.set $12
       (local.get $a)
      )
      (local.set $13
       (local.get $y)
      )
      (local.set $14
       (i64.ne
        (local.get $12)
        (local.get $13)
       )
      )
      (local.set $j
       (local.get $14)
      )
      (nop)
      (local.set $15
       (local.get $i)
      )
      (local.set $16
       (local.get $j)
      )
      (local.set $17
       (i32.and
        (local.get $15)
        (local.get $16)
       )
      )
      (local.set $r
       (local.get $17)
      )
      (nop)
      (local.set $18
       (local.get $r)
      )
      (return
       (local.get $18)
      )
      (unreachable)
     )
     (unreachable)
    )
    (block
     (unreachable)
     (unreachable)
    )
   )
  )
  (unreachable)
 )
 (func $figure-3-if (; 2 ;) (type $1) (param $x i32) (result i32)
  (local $1 i32)
  (local $2 i32)
  (local $3 i32)
  (local $4 i32)
  (local $5 i32)
  (local $6 i32)
  (local $7 i32)
  (local $8 i32)
  (local $9 i32)
  (local $10 i32)
  (block
   (block
    (local.set $1
     (local.get $x)
    )
    (local.set $2
     (i32.and
      (local.get $1)
      (i32.const 1)
     )
    )
    (if
     (local.get $2)
     (block
      (local.set $3
       (local.get $x)
      )
      (local.set $4
       (i32.add
        (local.get $3)
        (i32.const 1)
       )
      )
      (local.set $x
       (local.get $4)
      )
      (nop)
     )
     (block
      (local.set $5
       (local.get $x)
      )
      (local.set $6
       (i32.add
        (local.get $5)
        (i32.const 2)
       )
      )
      (local.set $x
       (local.get $6)
      )
      (nop)
     )
    )
   )
   (nop)
   (local.set $7
    (local.get $x)
   )
   (local.set $8
    (i32.and
     (local.get $7)
     (i32.const 1)
    )
   )
   (return
    (local.get $8)
   )
   (unreachable)
  )
  (local.set $10
   (local.get $9)
  )
  (return
   (local.get $10)
  )
 )
)
