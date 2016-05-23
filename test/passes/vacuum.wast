(module
  (memory 256 256)
  (func $b
    (i32.const 50)
    (nop)
    (i32.const 51)
    (nop)
    (nop)
    (i32.const 52)
    (block $waka1
      (i32.const 53)
      (br $waka1)
      (i32.const 54)
    )
    (block $waka2
      (nop)
      (br $waka2)
      (i32.const 56)
    )
    (block $waka3
      (br_table $waka3 $waka3 $waka3
        (i32.const 57)
      )
      (i32.const 58)
    )
    (if
      (i32.const 100)
      (nop)
      (i32.const 101)
    )
    (if
      (i32.const 102)
      (i32.const 103)
      (nop)
    )
    (if
      (i32.const 104)
      (nop)
      (nop)
    )
  )
  (func $l
    (local $x i32)
    (local $y i32)
    (get_local $x)
    (set_local $x (get_local $x))
    (block $in-a-block
      (get_local $x)
    )
    (block $two-in-a-block
      (get_local $x)
      (get_local $y)
    )
    (set_local $x
      (block $result-used
        (get_local $x)
      )
    )
    (set_local $x
      (block $two-and-result-used
        (get_local $x)
        (get_local $y)
      )
    )
  )
  (func $loopy (param $0 i32)
    (loop (nop))
    (loop
      (nop)
      (nop)
    )
    (loop
      (get_local $0)
      (i32.const 20)
    )
  )
  (func $unary (result f32)
    (f32.abs (f32.const 1.0)) ;; unneeded position
    (f32.abs (unreachable)) ;; side effects

    (f32.abs (f32.const 2.0)) ;; return position
  )
  (func $binary (result f32)
    (f32.add (f32.const 1.0) (f32.const 2.0))
    (f32.add (unreachable)   (f32.const 3.0))
    (f32.add (f32.const 4.0) (unreachable))
    (f32.add (unreachable)   (unreachable))

    (f32.add (f32.const 5.0) (f32.const 6.0))
  )
  (func $select (result i32)
    (select (i32.const 1)  (i32.const 2)  (i32.const 3))
    (select (unreachable)  (i32.const 4)  (i32.const 5))
    (select (i32.const 6)  (unreachable)  (i32.const 7))
    (select (i32.const 8)  (i32.const 9)  (unreachable))
    (select (unreachable)  (unreachable)  (i32.const 10))
    (select (unreachable)  (i32.const 11) (unreachable))
    (select (i32.const 12) (unreachable)  (unreachable))
    (select (unreachable)  (unreachable)  (unreachable))

    (select (i32.const 13) (i32.const 14) (i32.const 15))
  )
  (func $block-to-one
    (block
      (nop) (nop)
    )
    (block
      (nop) (unreachable)
    )
    (block
      (nop) (unreachable) (nop)
    )
    (block
      (unreachable) (nop)
    )
    (block
      (unreachable)
    )
  )
  (func $recurse
    (nop)
    (f32.abs (f32.abs (f32.abs (f32.abs (f32.abs (f32.abs (f32.const 1.0) ) ) ) ) ) )
  )
  (func $func-block
    (f32.abs (f32.abs (f32.abs (f32.abs (f32.abs (f32.abs (f32.const 1.0) ) ) ) ) ) )
  )
  (func $Gu (param $b i32) (param $e f64) (param $l i32) (param $d i32)
    (if ;; if condition must remain valid
      (if
        (get_local $d)
        (block
          (nop)
          (f64.ne
            (f64.promote/f32
              (f32.load
                (set_local $l
                  (i32.add
                    (get_local $b)
                    (i32.const 60)
                  )
                )
              )
            )
            (get_local $e)
          )
        )
        (i32.const 0)
      )
      (unreachable)
    )
  )
)

