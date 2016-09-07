(module
  (memory 256 256)
  (type $0 (func))
  (type $1 (func (param i32)))
  (type $2 (func (result f32)))
  (type $3 (func (result i32)))
  (type $4 (func (param i32 f64 i32 i32)))
  (import $int "env" "int" (result i32))
  (func $b (type $0)
    (drop
      (i32.const 50)
    )
    (nop)
    (drop
      (i32.const 51)
    )
    (nop)
    (nop)
    (drop
      (i32.const 52)
    )
    (block $waka1
      (drop
        (i32.const 53)
      )
      (br $waka1)
      (drop
        (i32.const 54)
      )
    )
    (block $waka2
      (nop)
      (br $waka2)
      (drop
        (i32.const 56)
      )
    )
    (block $waka3
      (br_table $waka3 $waka3 $waka3
        (i32.const 57)
      )
      (drop
        (i32.const 58)
      )
    )
    (if
      (i32.const 100)
      (nop)
      (drop
        (i32.const 101)
      )
    )
    (if
      (i32.const 102)
      (drop
        (i32.const 103)
      )
      (nop)
    )
    (if
      (i32.const 104)
      (nop)
      (nop)
    )
  )
  (func $l (type $0)
    (local $x i32)
    (local $y i32)
    (drop
      (get_local $x)
    )
    (set_local $x
      (get_local $x)
    )
    (block $in-a-block
      (drop
        (get_local $x)
      )
    )
    (block $two-in-a-block
      (drop
        (get_local $x)
      )
      (drop
        (get_local $y)
      )
    )
    (set_local $x
      (block $result-used
        (get_local $x)
      )
    )
    (set_local $x
      (block $two-and-result-used
        (drop
          (get_local $x)
        )
        (get_local $y)
      )
    )
  )
  (func $loopy (type $1) (param $0 i32)
    (loop $loop-in1
      (nop)
    )
    (loop $loop-in3
      (nop)
      (nop)
    )
    (drop
      (loop $loop-in5
        (drop
          (get_local $0)
        )
        (i32.const 20)
      )
    )
  )
  (func $unary (type $2) (result f32)
    (drop
      (f32.abs
        (f32.const 1)
      )
    )
    (f32.abs
      (unreachable)
    )
    (f32.abs
      (f32.const 2)
    )
  )
  (func $binary (type $2) (result f32)
    (drop
      (f32.add
        (f32.const 1)
        (f32.const 2)
      )
    )
    (drop
      (f32.add
        (unreachable)
        (f32.const 3)
      )
    )
    (drop
      (f32.add
        (f32.const 4)
        (unreachable)
      )
    )
    (f32.add
      (unreachable)
      (unreachable)
    )
    (f32.add
      (f32.const 5)
      (f32.const 6)
    )
  )
  (func $select (type $3) (result i32)
    (drop
      (select
        (i32.const 1)
        (i32.const 2)
        (i32.const 3)
      )
    )
    (drop
      (select
        (unreachable)
        (i32.const 4)
        (i32.const 5)
      )
    )
    (drop
      (select
        (i32.const 6)
        (unreachable)
        (i32.const 7)
      )
    )
    (drop
      (select
        (i32.const 8)
        (i32.const 9)
        (unreachable)
      )
    )
    (select
      (unreachable)
      (unreachable)
      (i32.const 10)
    )
    (drop
      (select
        (unreachable)
        (i32.const 11)
        (unreachable)
      )
    )
    (drop
      (select
        (i32.const 12)
        (unreachable)
        (unreachable)
      )
    )
    (select
      (unreachable)
      (unreachable)
      (unreachable)
    )
    (select
      (i32.const 13)
      (i32.const 14)
      (i32.const 15)
    )
  )
  (func $block-to-one (type $0)
    (block $block0
      (nop)
      (nop)
    )
    (block $block1
      (nop)
      (unreachable)
    )
    (block $block2
      (nop)
      (unreachable)
      (nop)
    )
    (block $block3
      (unreachable)
      (nop)
    )
    (block $block4
      (unreachable)
    )
  )
  (func $recurse (type $0)
    (nop)
    (drop
      (f32.abs
        (f32.abs
          (f32.abs
            (f32.abs
              (f32.abs
                (f32.abs
                  (f32.const 1)
                )
              )
            )
          )
        )
      )
    )
  )
  (func $func-block (type $0)
    (drop
      (f32.abs
        (f32.abs
          (f32.abs
            (f32.abs
              (f32.abs
                (f32.abs
                  (f32.const 1)
                )
              )
            )
          )
        )
      )
    )
  )
  (func $Gu (type $4) (param $b i32) (param $e f64) (param $l i32) (param $d i32)
    (if
      (if
        (get_local $d)
        (block $block1
          (nop)
          (f64.ne
            (f64.promote/f32
              (f32.load
                (tee_local $l
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
  (func $if-drop
    (block $out
      (drop
        (if (i32.const 0)
          (call_import $int)
          (br $out)
        )
      )
      (drop
        (if (i32.const 1)
          (br $out)
          (call_import $int)
        )
      )
    )
  )
)
