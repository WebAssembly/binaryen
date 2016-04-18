(module
  (memory 4096 4096
    (segment 1026 "\14\00")
  )
  (type $FUNCSIG$vf (func (param f32)))
  (type $FUNCSIG$v (func))
  (type $FUNCSIG$id (func (param f64) (result i32)))
  (type $FUNCSIG$ddd (func (param f64 f64) (result f64)))
  (import $_emscripten_asm_const_vi "env" "_emscripten_asm_const_vi")
  (import $f64-to-int "asm2wasm" "f64-to-int" (param f64) (result i32))
  (import $f64-rem "asm2wasm" "f64-rem" (param f64 f64) (result f64))
  (export "big_negative" $big_negative)
  (table $z $big_negative $z $z $w $w $importedDoubles $w $z $cneg)
  (func $big_negative
    (local $temp f64)
    (block $block0
      (set_local $temp
        (f64.const -2147483648)
      )
      (set_local $temp
        (f64.const -2147483648)
      )
      (set_local $temp
        (f64.const -21474836480)
      )
      (set_local $temp
        (f64.const 0.039625)
      )
      (set_local $temp
        (f64.const -0.039625)
      )
    )
  )
  (func $importedDoubles (result f64)
    (local $temp f64)
    (block $topmost
      (set_local $temp
        (f64.add
          (f64.add
            (f64.add
              (f64.load
                (i32.const 8)
              )
              (f64.load
                (i32.const 16)
              )
            )
            (f64.neg
              (f64.load
                (i32.const 16)
              )
            )
          )
          (f64.neg
            (f64.load
              (i32.const 8)
            )
          )
        )
      )
      (if
        (i32.gt_s
          (i32.load
            (i32.const 24)
          )
          (i32.const 0)
        )
        (br $topmost
          (f64.const -3.4)
        )
      )
      (if
        (f64.gt
          (f64.load
            (i32.const 32)
          )
          (f64.const 0)
        )
        (br $topmost
          (f64.const 5.6)
        )
      )
      (f64.const 1.2)
    )
  )
  (func $doubleCompares (param $x f64) (param $y f64) (result f64)
    (local $t f64)
    (local $Int f64)
    (local $Double i32)
    (block $topmost
      (if
        (f64.gt
          (get_local $x)
          (f64.const 0)
        )
        (br $topmost
          (f64.const 1.2)
        )
      )
      (if
        (f64.gt
          (get_local $Int)
          (f64.const 0)
        )
        (br $topmost
          (f64.const -3.4)
        )
      )
      (if
        (i32.gt_s
          (get_local $Double)
          (i32.const 0)
        )
        (br $topmost
          (f64.const 5.6)
        )
      )
      (if
        (f64.lt
          (get_local $x)
          (get_local $y)
        )
        (br $topmost
          (get_local $x)
        )
      )
      (get_local $y)
    )
  )
  (func $intOps (result i32)
    (local $x i32)
    (i32.eq
      (get_local $x)
      (i32.const 0)
    )
  )
  (func $hexLiterals
    (i32.add
      (i32.add
        (i32.const 0)
        (i32.const 313249263)
      )
      (i32.const -19088752)
    )
  )
  (func $conversions
    (local $i i32)
    (local $d f64)
    (block $block0
      (set_local $i
        (call_import $f64-to-int
          (get_local $d)
        )
      )
      (set_local $d
        (f64.convert_s/i32
          (get_local $i)
        )
      )
      (set_local $d
        (f64.convert_u/i32
          (i32.shr_u
            (get_local $i)
            (i32.const 0)
          )
        )
      )
    )
  )
  (func $seq
    (local $J f64)
    (set_local $J
      (f64.sub
        (block $block0
          (f64.const 0.1)
          (f64.const 5.1)
        )
        (block $block1
          (f64.const 3.2)
          (f64.const 4.2)
        )
      )
    )
  )
  (func $switcher (param $x i32) (result i32)
    (block $topmost
      (block $switch$0
        (block $switch-default$3
          (block $switch-case$2
            (block $switch-case$1
              (br_table $switch-case$1 $switch-case$2 $switch-default$3
                (i32.sub
                  (get_local $x)
                  (i32.const 1)
                )
              )
            )
            (br $topmost
              (i32.const 1)
            )
          )
          (br $topmost
            (i32.const 2)
          )
        )
        (nop)
      )
      (block $switch$4
        (block $switch-default$7
          (block $switch-case$6
            (block $switch-case$5
              (br_table $switch-case$6 $switch-default$7 $switch-default$7 $switch-default$7 $switch-default$7 $switch-default$7 $switch-default$7 $switch-case$5 $switch-default$7
                (i32.sub
                  (get_local $x)
                  (i32.const 5)
                )
              )
            )
            (br $topmost
              (i32.const 121)
            )
          )
          (br $topmost
            (i32.const 51)
          )
        )
        (nop)
      )
      (block $label$break$Lout
        (block $switch-default$16
          (block $switch-case$15
            (block $switch-case$12
              (block $switch-case$9
                (block $switch-case$8
                  (br_table $switch-case$15 $switch-default$16 $switch-default$16 $switch-case$12 $switch-default$16 $switch-default$16 $switch-default$16 $switch-default$16 $switch-case$9 $switch-default$16 $switch-case$8 $switch-default$16
                    (i32.sub
                      (get_local $x)
                      (i32.const 2)
                    )
                  )
                )
                (br $label$break$Lout)
              )
              (br $label$break$Lout)
            )
            (block $block0
              (loop $while-out$10 $while-in$11
                (block $block1
                  (br $while-out$10)
                  (br $while-in$11)
                )
              )
              (br $label$break$Lout)
            )
          )
          (block $block2
            (loop $while-out$13 $while-in$14
              (block $block3
                (br $label$break$Lout)
                (br $while-in$14)
              )
            )
            (br $label$break$Lout)
          )
        )
        (nop)
      )
      (i32.const 0)
    )
  )
  (func $blocker
    (block $label$break$L
      (br $label$break$L)
    )
  )
  (func $frem (result f64)
    (call_import $f64-rem
      (f64.const 5.5)
      (f64.const 1.2)
    )
  )
  (func $big_uint_div_u (result i32)
    (local $x i32)
    (block $topmost
      (set_local $x
        (i32.and
          (i32.div_u
            (i32.const -1)
            (i32.const 2)
          )
          (i32.const -1)
        )
      )
      (get_local $x)
    )
  )
  (func $fr (param $x f32)
    (local $y f32)
    (local $z f64)
    (block $block0
      (f32.demote/f64
        (get_local $z)
      )
      (get_local $y)
      (f32.const 5)
      (f32.const 0)
      (f32.const 5)
      (f32.const 0)
    )
  )
  (func $negZero (result f64)
    (f64.const -0)
  )
  (func $abs
    (local $x i32)
    (local $y f64)
    (local $z f32)
    (local $asm2wasm_i32_temp i32)
    (block $block0
      (set_local $x
        (block $block1
          (set_local $asm2wasm_i32_temp
            (i32.const 0)
          )
          (select
            (i32.sub
              (i32.const 0)
              (get_local $asm2wasm_i32_temp)
            )
            (get_local $asm2wasm_i32_temp)
            (i32.lt_s
              (get_local $asm2wasm_i32_temp)
              (i32.const 0)
            )
          )
        )
      )
      (set_local $y
        (f64.abs
          (f64.const 0)
        )
      )
      (set_local $z
        (f32.abs
          (f32.const 0)
        )
      )
    )
  )
  (func $neg
    (local $x f32)
    (block $block0
      (set_local $x
        (f32.neg
          (get_local $x)
        )
      )
      (call_indirect $FUNCSIG$vf
        (i32.add
          (i32.and
            (i32.const 1)
            (i32.const 7)
          )
          (i32.const 8)
        )
        (get_local $x)
      )
    )
  )
  (func $cneg (param $x f32)
    (call_indirect $FUNCSIG$vf
      (i32.add
        (i32.and
          (i32.const 1)
          (i32.const 7)
        )
        (i32.const 8)
      )
      (get_local $x)
    )
  )
  (func $___syscall_ret
    (local $$0 i32)
    (i32.gt_u
      (i32.shr_u
        (get_local $$0)
        (i32.const 0)
      )
      (i32.const -4096)
    )
  )
  (func $z
    (nop)
  )
  (func $w
    (nop)
  )
  (func $block_and_after (result i32)
    (block $waka
      (i32.const 1)
      (br $waka)
    )
    (i32.const 0)
  )
)
