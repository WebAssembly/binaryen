(module
  (memory 256 256)
  (type $0 (func))
  (type $1 (func (param i32)))
  (type $2 (func (result f32)))
  (type $3 (func (result i32)))
  (type $4 (func (param i32 f64 i32 i32)))
  (import $int "env" "int" (result i32))
  (global $Int i32 (i32.const 0))
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
      (block $result-used (result i32)
        (get_local $x)
      )
    )
    (set_local $x
      (block $two-and-result-used (result i32)
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
      (loop $loop-in5 (result i32)
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
      (if (result i32)
        (get_local $d)
        (block $block1 (result i32)
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
  (func $if-drop (result i32)
    (block $out
      (drop
        (if (result i32)
          (call $if-drop)
          (call $int)
          (br $out)
        )
      )
      (drop
        (if (result i32)
          (call $if-drop)
          (br $out)
          (call $int)
        )
      )
    )
    (i32.const 1)
  )
  (func $drop-silly
    (drop
      (i32.eqz
        (i32.eqz
          (i32.const 1)
        )
      )
    )
    (drop
      (i32.eqz
        (i32.eqz
          (call $int)
        )
      )
    )
    (drop
      (i32.add
        (i32.const 2)
        (i32.const 3)
      )
    )
    (drop
      (i32.add
        (i32.const 4)
        (call $int)
      )
    )
    (drop
      (i32.add
        (call $int)
        (i32.const 5)
      )
    )
    (drop
      (i32.add
        (call $int)
        (call $int)
      )
    )
  )
  (func $drop-get-global
    (drop
      (block (result i32)
        (call $drop-get-global)
        (get_global $Int) ;; this is not needed due to the block being drop'd, but make sure the call is not then dropped either
      )
    )
  )
  (func $relooperJumpThreading1
    (local $$vararg_ptr5 i32)
    (local $$11 i32)
    (loop $while-in$1
      (drop
        (block $jumpthreading$outer$8 (result i32)
          (block $jumpthreading$inner$8
            (br $jumpthreading$outer$8 ;; the rest is dead in the outer block, but be careful to leave the return value!
              (i32.const 0)
            )
          )
          (i32.store
            (get_local $$vararg_ptr5)
            (get_local $$11)
          )
          (i32.const 0)
        )
      )
    )
  )
  (func $relooperJumpThreading2
    (loop $while-in$1
      (drop
        (block $jumpthreading$outer$8 (result i32)
          (block $jumpthreading$inner$8
            (br $jumpthreading$outer$8
              (i32.const 0)
            )
          )
          (i32.const 0)
        )
      )
    )
  )
  (func $relooperJumpThreading3
    (loop $while-in$1
      (drop
        (block $jumpthreading$outer$8 (result i32)
          (br $jumpthreading$outer$8 ;; code after this is dead, can kill it, but preserve the return value at the end!
            (i32.const 0)
          )
          (drop (i32.const 3))
          (drop (i32.const 2))
          (drop (i32.const 1))
          (i32.const 0)
        )
      )
    )
  )
  (func $if2drops (result i32)
    (if
      (call $if2drops)
      (drop
        (call $if2drops)
      )
      (drop
        (call $if2drops)
      )
    )
    (i32.const 2)
  )
  (func $if2drops-different (result i32)
    (if
      (call $if2drops)
      (drop
        (call $if2drops) ;; i32
      )
      (drop
        (call $unary) ;; f32!
      )
    )
    (i32.const 2)
  )
  (func $if-const (param $x i32)
    (if (i32.const 0) (call $if-const (i32.const 1)))
    (if (i32.const 2) (call $if-const (i32.const 3)))
    (if (i32.const 0) (call $if-const (i32.const 4)) (call $if-const (i32.const 5)))
    (if (i32.const 6) (call $if-const (i32.const 7)) (call $if-const (i32.const 8)))
  )
  (func $drop-if-both-unreachable (param $0 i32)
    (block $out
      (drop
        (if (result i32)
          (get_local $0)
          (br $out)
          (br $out)
        )
      )
    )
    (drop
      (if (result i32)
        (get_local $0)
        (unreachable)
        (unreachable)
      )
    )
  )
  (func $if-1-block (param $x i32)
   (block $out
    (if
     (get_local $x)
     (block
      (if
       (i32.const 1)
       (block
        (set_local $x
         (get_local $x)
        )
        (br $out)
       )
      )
     )
    )
   )
  )
  (func $block-resize-br-gone
    (block $out
      (block $in
        (call $block-resize-br-gone)
        (br $in)
        (br $out)
      )
      (return)
    )
    (block $out2
      (block $in2
        (br $in2)
        (br $out2)
      )
      (return)
    )
  )
  (func $block-unreachable-but-last-element-concrete
   (local $2 i32)
   (block $label$0
    (drop
     (block
      (br $label$0)
      (get_local $2)
     )
    )
   )
  )
)
