(module
  (memory 16777216 16777216)
  (import $f64-rem "asm2wasm" "f64-rem"  (param f64 f64) (result f64))
  (export "big_negative" $big_negative)
  (table $z $big_negative $z $z $w $w $importedDoubles $w)
  (func $big_negative
    (local $temp f64)
    (block
      (set_local $temp
        (f64.convert_s/i32
          (i32.const -2147483648)
        )
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
              (f64.load align=8
                (i32.const 8)
              )
              (f64.load align=8
                (i32.const 16)
              )
            )
            (f64.neg
              (f64.load align=8
                (i32.const 16)
              )
            )
          )
          (f64.neg
            (f64.load align=8
              (i32.const 8)
            )
          )
        )
      )
      (if
        (i32.gt_s
          (i32.load align=4
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
          (f64.load align=8
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
  (func $conversions
    (local $i i32)
    (local $d f64)
    (block
      (set_local $i
        (i32.trunc_s/f64
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
        (block
          (f64.const 0.1)
          (f64.const 5.1)
        )
        (block
          (f64.const 3.2)
          (f64.const 4.2)
        )
      )
    )
  )
  (func $switcher (param $x i32) (result i32)
    (block $topmost
      (tableswitch $switch$0
        (i32.sub
          (get_local $x)
          (i32.const 1)
        )
        (table (case $switch-case$1) (case $switch-case$2)) (case $switch-default$3)
        (case switch-case$1
          (br $topmost
            (i32.const 1)
          )
        )
        (case switch-case$2
          (br $topmost
            (i32.const 2)
          )
        )
        (case switch-default$3
          (nop)
        )
      )
      (tableswitch $switch$4
        (i32.sub
          (get_local $x)
          (i32.const 5)
        )
        (table (case $switch-case$6) (case $switch-default$7) (case $switch-default$7) (case $switch-default$7) (case $switch-default$7) (case $switch-default$7) (case $switch-default$7) (case $switch-case$5)) (case $switch-default$7)
        (case switch-case$5
          (br $topmost
            (i32.const 121)
          )
        )
        (case switch-case$6
          (br $topmost
            (i32.const 51)
          )
        )
        (case switch-default$7
          (nop)
        )
      )
    )
  )
  (func $frem (result f64)
    (call_import $f64-rem
      (f64.const 5.5)
      (f64.const 1.2)
    )
  )
  (func $z
    (nop)
  )
  (func $w
    (nop)
  )
)
