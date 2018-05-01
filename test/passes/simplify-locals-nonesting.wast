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
   (set_local $6
    (get_local $a)
   )
   (set_local $7
    (get_local $x)
   )
   (set_local $8
    (i64.eq
     (get_local $6)
     (get_local $7)
    )
   )
   (set_local $i
    (get_local $8)
   )
   (nop)
   (set_local $9
    (get_local $a)
   )
   (set_local $10
    (get_local $y)
   )
   (set_local $11
    (i64.ne
     (get_local $9)
     (get_local $10)
    )
   )
   (set_local $j
    (get_local $11)
   )
   (nop)
   (set_local $12
    (get_local $i)
   )
   (set_local $13
    (get_local $j)
   )
   (set_local $14
    (i32.and
     (get_local $12)
     (get_local $13)
    )
   )
   (set_local $r
    (get_local $14)
   )
   (nop)
   (set_local $15
    (get_local $r)
   )
   (return
    (get_local $15)
   )
   (unreachable)
  )
  (set_local $17
   (get_local $16)
  )
  (return
   (get_local $17)
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
   (set_local $6
    (get_local $x)
   )
   (set_local $7
    (get_local $y)
   )
   (set_local $8
    (i64.lt_s
     (get_local $6)
     (get_local $7)
    )
   )
   (if
    (get_local $8)
    (block
     (block $block
      (set_local $9
       (get_local $a)
      )
      (set_local $10
       (get_local $x)
      )
      (set_local $11
       (i64.eq
        (get_local $9)
        (get_local $10)
       )
      )
      (set_local $i
       (get_local $11)
      )
      (nop)
      (set_local $12
       (get_local $a)
      )
      (set_local $13
       (get_local $y)
      )
      (set_local $14
       (i64.ne
        (get_local $12)
        (get_local $13)
       )
      )
      (set_local $j
       (get_local $14)
      )
      (nop)
      (set_local $15
       (get_local $i)
      )
      (set_local $16
       (get_local $j)
      )
      (set_local $17
       (i32.and
        (get_local $15)
        (get_local $16)
       )
      )
      (set_local $r
       (get_local $17)
      )
      (nop)
      (set_local $18
       (get_local $r)
      )
      (return
       (get_local $18)
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
    (set_local $1
     (get_local $x)
    )
    (set_local $2
     (i32.and
      (get_local $1)
      (i32.const 1)
     )
    )
    (if
     (get_local $2)
     (block
      (set_local $3
       (get_local $x)
      )
      (set_local $4
       (i32.add
        (get_local $3)
        (i32.const 1)
       )
      )
      (set_local $x
       (get_local $4)
      )
      (nop)
     )
     (block
      (set_local $5
       (get_local $x)
      )
      (set_local $6
       (i32.add
        (get_local $5)
        (i32.const 2)
       )
      )
      (set_local $x
       (get_local $6)
      )
      (nop)
     )
    )
   )
   (nop)
   (set_local $7
    (get_local $x)
   )
   (set_local $8
    (i32.and
     (get_local $7)
     (i32.const 1)
    )
   )
   (return
    (get_local $8)
   )
   (unreachable)
  )
  (set_local $10
   (get_local $9)
  )
  (return
   (get_local $10)
  )
 )
)
