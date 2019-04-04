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
      (local.get $x)
    )
    (local.set $x
      (local.get $x)
    )
    (block $in-a-block
      (drop
        (local.get $x)
      )
    )
    (block $two-in-a-block
      (drop
        (local.get $x)
      )
      (drop
        (local.get $y)
      )
    )
    (local.set $x
      (block $result-used (result i32)
        (local.get $x)
      )
    )
    (local.set $x
      (block $two-and-result-used (result i32)
        (drop
          (local.get $x)
        )
        (local.get $y)
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
          (local.get $0)
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
        (local.get $d)
        (block $block1 (result i32)
          (nop)
          (f64.ne
            (f64.promote_f32
              (f32.load
                (local.tee $l
                  (i32.add
                    (local.get $b)
                    (i32.const 60)
                  )
                )
              )
            )
            (local.get $e)
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
        (global.get $Int) ;; this is not needed due to the block being drop'd, but make sure the call is not then dropped either
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
            (local.get $$vararg_ptr5)
            (local.get $$11)
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
          (local.get $0)
          (br $out)
          (br $out)
        )
      )
    )
    (drop
      (if (result i32)
        (local.get $0)
        (unreachable)
        (unreachable)
      )
    )
  )
  (func $if-1-block (param $x i32)
   (block $out
    (if
     (local.get $x)
     (block
      (if
       (i32.const 1)
       (block
        (local.set $x
         (local.get $x)
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
     (block (result i32)
      (br $label$0)
      (local.get $2)
     )
    )
   )
  )
  (func $a
    (block
      (i32.store (i32.const 1) (i32.const 2))
      (f64.div
        (f64.const -nan:0xfffffffffa361)
        (loop $label$1 ;; unreachable, so the div is too. keep
          (br $label$1)
        )
      )
    )
  )
  (func $leave-block-even-if-br-not-taken (result f64)
   (block $label$0 (result f64)
    (f64.store align=1
     (i32.const 879179022)
     (br_if $label$0
      (loop $label$9
       (br $label$9)
      )
      (i32.const 677803374)
     )
    )
    (f64.const 2097914503796645752267195e31)
   )
  )
  (func $executed-if-in-block
    (block $label$0
     (if
      (i32.const 170996275)
      (unreachable)
      (br $label$0)
     )
    )
    (unreachable)
  )
  (func $executed-if-in-block2
    (block $label$0
     (if
      (i32.const 170996275)
      (nop)
      (br $label$0)
     )
    )
    (unreachable)
  )
  (func $executed-if-in-block3
    (block $label$0
     (if
      (i32.const 170996275)
      (br $label$0)
      (nop)
     )
    )
    (unreachable)
  )
  (func $load-may-have-side-effects (result i32)
   (i64.ge_s
    (block (result i64)
     (drop
      (i64.eq
       (i64.load32_s
        (i32.const 678585719)
       )
       (i64.const 8097879367757079605)
      )
     )
     (i64.const 2912825531628789796)
    )
    (i64.const 0)
   )
  )
  (func $unary-binary-may-trap
   (drop
    (i64.div_s
     (i64.const -1)
     (i64.const 729618461987467893)
    )
   )
   (drop
    (i64.trunc_f32_u
     (f32.const 70847791997969805621592064)
    )
   )
  )
  (func $unreachable-if-with-nop-arm-that-leaves-a-concrete-value-if-nop-is-removed
   (block $label$0
    (loop $label$1
     (drop
      (if (result i32)
       (br_if $label$0
        (loop $label$9
         (br $label$9)
        )
       )
       (unreachable)
       (i32.const 1920103026)
      )
     )
    )
   )
  )
  (func $if-arm-vanishes (result i32)
   (block $label$0 (result i32)
    (block $label$1
     (if
      (br $label$0
       (i32.const 1)
      )
      (br $label$1)
     )
    )
    (i32.const 1579493952)
   )
  )
  (func $if-arm-vanishes-2 (result i32)
   (block $label$0 (result i32)
    (block $label$1
     (if
      (br $label$0
       (i32.const 1)
      )
      (br $label$1)
     )
    )
    (i32.const 1579493952)
   )
  )
  (func $nop-if-type-changes (type $0)
   (local $0 i32)
   (block $label$0
    (if
     (i32.eqz
      (local.get $0)
     )
     (block $label$1
      (block
       (if ;; we nop this if, which has a type change for block $label$1, no more brs to it
        (i32.const 0)
        (br_if $label$1
          (i32.const 1717966400)
        )
       )
       (drop
        (br $label$0)
       )
      )
     )
    )
   )
  )
)
(module ;; a child with a different type, cannot simply replace the parent with it
 (type $0 (func (param i64)))
 (type $1 (func (param f32 i32) (result i32)))
 (func $0 (; 0 ;) (type $0) (param $0 i64)
  (nop)
 )
 (func $1 (; 1 ;) (type $1) (param $0 f32) (param $1 i32) (result i32)
  (drop
   (block $label$1 (result i32)
    (i32.wrap_i64
     (block $label$2 (result i64)
      (call $0
       (br_if $label$2
        (i64.const -137438953472)
        (i32.const 1)
       )
      )
      (unreachable)
     )
    )
   )
  )
  (unreachable)
 )
)
(module ;; vacuum away a drop on an if where both arms can be vacuumed
 (memory 1 1)
 (global $global$1 (mut i32) (i32.const 0))
 (func $_deflate (param i32) (result i32)
  (call $_deflate (local.get $0))
 )
 (func $_deflateInit2_ (param i32) (result i32)
  (call $_deflateInit2_ (local.get $0))
 )
 (func $_deflateEnd (param i32) (result i32)
  (call $_deflateEnd (local.get $0))
 )
 (func "compress" (param $0 i32) (param $1 i32) (param $2 i32)
  (local $3 i32)
  (local.set $3
   (global.get $global$1)
  )
  (global.set $global$1
   (i32.sub
    (global.get $global$1)
    (i32.const -64)
   )
  )
  (i32.store
   (local.get $3)
   (local.get $2)
  )
  (i32.store offset=4
   (local.get $3)
   (i32.const 100000)
  )
  (i32.store offset=12
   (local.get $3)
   (local.get $0)
  )
  (i32.store offset=16
   (local.get $3)
   (i32.load
    (local.get $1)
   )
  )
  (i32.store offset=32
   (local.get $3)
   (i32.const 0)
  )
  (i32.store offset=36
   (local.get $3)
   (i32.const 0)
  )
  (i32.store offset=40
   (local.get $3)
   (i32.const 0)
  )
  (if
   (call $_deflateInit2_
    (local.get $3)
   )
   (block
    (global.set $global$1
     (local.get $3)
    )
    (return)
   )
  )
  (drop
   (if (result i32)
    (i32.eq
     (local.tee $0
      (call $_deflate
       (local.get $3)
      )
     )
     (i32.const 1)
    )
    (block (result i32)
     (i32.store
      (local.get $1)
      (i32.load offset=20
       (local.get $3)
      )
     )
     (local.set $0
      (call $_deflateEnd
       (local.get $3)
      )
     )
     (global.set $global$1
      (local.get $3)
     )
     (local.get $0)
    )
    (block (result i32)
     (drop
      (call $_deflateEnd
       (local.get $3)
      )
     )
     (global.set $global$1
      (local.get $3)
     )
     (select
      (local.get $0)
      (i32.const -5)
      (local.get $0)
     )
    )
   )
  )
 )
)
