(module
  (memory 0)
  (type $0 (func (param i32)))
  (func $x (type $0) (param $x i32)
    (call $x
      (i32.add
        (i32.const 100)
        (i32.const 2200)
      )
    )
    (drop
      (i32.add
        (i32.const 1)
        (i32.const 2)
      )
    )
    (drop
      (i32.add
        (i32.const 1)
        (get_local $x)
      )
    )
    (drop
      (i32.add
        (i32.const 1)
        (i32.add
          (i32.const 2)
          (i32.const 3)
        )
      )
    )
    (drop
      (i32.sub
        (i32.const 1)
        (i32.const 2)
      )
    )
    (drop
      (i32.sub
        (i32.add
          (i32.const 0)
          (i32.const 4)
        )
        (i32.const 1)
      )
    )
    (loop $in
      (br $in)
    )
    (block $b
      (br_if $b (i32.const 0))
      (br_if $b (i32.const 1))
      (call $x (i32.const 4))
    )
    (block $c
      (br_if $c (i32.const 0))
      (call $x (i32.const 4))
      (br_if $c (i32.const 1))
      (br $c)
    )
    (drop
      (block $val (result i32)
        (drop (br_if $val (i32.const 100) (i32.const 0)))
        (call $x (i32.const 4))
        (drop (br_if $val (i32.const 101) (i32.const 1)))
        (br $val (i32.const 102))
      )
    )
    (block $d
      (block $e
        (br_if $d (br $e))
        (call $x (i32.const 4))
        (br_if $e (br $d))
      )
    )
    (drop
      (block $d (result i32)
        (call $x (i32.const 5))
        (block $e
          (drop (br_if $d (br $e) (i32.const 1)))
          (drop (br_if $d (br $e) (i32.const 0)))
          (drop (br_if $d (i32.const 1) (br $e)))
          (drop (br_if $d (i32.const 0) (br $e)))
          (unreachable)
        )
        (i32.const 1)
      )
    )
    (drop
      (block $d (result i32)
        (call $x (i32.const 6))
        (block $e
          (drop (br_if $d (br $e) (i32.const 0)))
          (drop (br_if $d (i32.const 1) (br $e)))
          (drop (br_if $d (i32.const 0) (br $e)))
          (unreachable)
        )
        (i32.const 1)
      )
    )
    (drop
      (block $d (result i32)
        (call $x (i32.const 7))
        (block $e
          (drop (br_if $d (i32.const 1) (br $e)))
        )
        (i32.const 2)
      )
    )
    (call $x
      (block $out (result i32)
        (block $waka1
          (block $waka2
            (block $waka3
              (br_table $waka1 $waka2 $waka3
                (i32.const 0)
              )
            )
            (br $out (i32.const 0))
          )
          (br $out (i32.const 1))
        )
        (br $out (i32.const 2))
      )
    )
    (call $x
      (block $out (result i32)
        (block $waka1
          (block $waka2
            (block $waka3
              (br_table $waka1 $waka2 $waka3
                (i32.const 1)
              )
            )
            (br $out (i32.const 0))
          )
          (br $out (i32.const 1))
        )
        (br $out (i32.const 2))
      )
    )
    (call $x
      (block $out (result i32)
        (block $waka1
          (block $waka2
            (block $waka3
              (br_table $waka1 $waka2 $waka3
                (i32.const 2)
              )
            )
            (br $out (i32.const 0))
          )
          (br $out (i32.const 1))
        )
        (br $out (i32.const 2))
      )
    )
    (call $x
      (block $out (result i32)
        (block $waka1
          (block $waka2
            (block $waka3
              (br_table $waka1 $waka2 $waka3
                (i32.const 3)
              )
            )
            (br $out (i32.const 0))
          )
          (br $out (i32.const 1))
        )
        (br $out (i32.const 2))
      )
    )
  )
  (func $ret (result i32)
    (if (call $ret)
      (return (i32.const 0))
    )
    (if (call $ret)
      (return (return (i32.const 1)))
    )
    (i32.const 1)
  )
  (func $noret
    (if (call $ret)
      (return)
    )
  )
  (func $refinalize-br-condition-unreachable
   (block $label$1
    (drop
     (br_if $label$1
      (unreachable)
     )
    )
   )
  )
  (func $br_if-condition-is-block-i32-but-unreachable-so-refinalize-tricky
   (drop
    (block $label$1 (result i32)
     (drop
      (br_if $label$1
       (i32.const 100)
       (block $label$3 (result i32)
        (unreachable)
       )
      )
     )
     (i32.const 0)
    )
   )
  )
)
