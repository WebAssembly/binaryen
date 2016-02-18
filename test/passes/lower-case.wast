(module
  (func $switcher (param $x i32) (result i32)
    (tableswitch $switch$0
      (i32.sub
        (get_local $x)
        (i32.const 1)
      )
      (table (case $switch-case$1) (case $switch-case$2)) (case $switch-default$3)
      (case $switch-case$1
        (return
          (i32.const 1)
        )
      )
      (case $switch-case$2
        (return
          (i32.const 2)
        )
      )
      (case $switch-default$3
        (nop)
      )
    )
    (tableswitch $switch$4
      (i32.sub
        (get_local $x)
        (i32.const 5)
      )
      (table (case $switch-case$6) (case $switch-default$7) (case $switch-default$7) (case $switch-default$7) (case $switch-default$7) (case $switch-default$7) (case $switch-default$7) (case $switch-case$5)) (case $switch-default$7)
      (case $switch-case$5
        (return
          (i32.const 121)
        )
      )
      (case $switch-case$6
        (return
          (i32.const 51)
        )
      )
      (case $switch-default$7
        (nop)
      )
    )
    (tableswitch $label$break$Lout
      (i32.sub
        (get_local $x)
        (i32.const 2)
      )
      (table (case $switch-case$15) (case $switch-default$16) (case $switch-default$16) (case $switch-case$12) (case $switch-default$16) (case $switch-default$16) (case $switch-default$16) (case $switch-default$16) (case $switch-case$9) (case $switch-default$16) (case $switch-case$8)) (case $switch-default$16)
      (case $switch-case$8
        (br $label$break$Lout)
      )
      (case $switch-case$9
        (br $label$break$Lout)
      )
      (case $switch-case$12
        (block
          (loop $while-out$10 $while-in$11
            (br $while-out$10)
            (br $while-in$11)
          )
          (br $label$break$Lout)
        )
      )
      (case $switch-case$15
        (block
          (loop $while-out$13 $while-in$14
            (br $label$break$Lout)
            (br $while-in$14)
          )
          (br $label$break$Lout)
        )
      )
      (case $switch-default$16
        (nop)
      )
    )
    (return
      (i32.const 0)
    )
  )
)
