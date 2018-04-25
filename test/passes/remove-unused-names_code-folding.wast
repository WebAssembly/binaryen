(module
  (func $ifs
    (if (i32.const 0) (nop))
    (if (i32.const 0) (nop) (nop))
    (if (i32.const 0) (nop) (unreachable))
    (drop
      (if (result i32) (i32.const 0)
        (i32.add (i32.const 1) (i32.const 2))
        (i32.add (i32.const 1) (i32.const 2))
      )
    )
    (drop
      (if (result i32) (i32.const 0)
        (i32.add (i32.const 1) (i32.const 2))
        (i32.add (i32.const 1) (i32.const 333333333))
      )
    )
  )
  (func $ifs-blocks
    (if (i32.const 0)
      (block
        (nop)
      )
      (block
        (nop)
      )
    )
    (if (i32.const 0)
      (block
        (unreachable)
        (nop)
      )
      (block
        (nop)
      )
    )
    (if (i32.const 0)
      (block
        (nop)
      )
      (block
        (unreachable)
        (nop)
      )
    )
    (if (i32.const 0)
      (block
        (nop)
        (unreachable)
      )
      (block
        (nop)
      )
    )
    (if (i32.const 0)
      (block
        (nop)
      )
      (block
        (nop)
        (unreachable)
      )
    )
  )
  (func $ifs-blocks-big
    (if (i32.const 0)
      (block
        (drop (i32.add (i32.const 1) (i32.const 2)))
      )
      (block
        (drop (i32.add (i32.const 1) (i32.const 2)))
      )
    )
    (if (i32.const 0)
      (block
        (unreachable)
        (drop (i32.add (i32.const 1) (i32.const 2)))
      )
      (block
        (drop (i32.add (i32.const 1) (i32.const 2)))
      )
    )
    (if (i32.const 0)
      (block
        (drop (i32.add (i32.const 1) (i32.const 2)))
      )
      (block
        (unreachable)
        (drop (i32.add (i32.const 1) (i32.const 2)))
      )
    )
    (if (i32.const 0)
      (block
        (drop (i32.add (i32.const 1) (i32.const 2)))
        (unreachable)
      )
      (block
        (drop (i32.add (i32.const 1) (i32.const 2)))
      )
    )
    (if (i32.const 0)
      (block
        (drop (i32.add (i32.const 1) (i32.const 2)))
      )
      (block
        (drop (i32.add (i32.const 1) (i32.const 2)))
        (unreachable)
      )
    )
  )
  (func $ifs-blocks-long
    (if (i32.const 1)
      (block
        (drop (i32.const -1234))
        (drop (i32.const -1000))
        (drop (i32.const 1))
        (nop)
        (unreachable)
      )
      (block
        (drop (i32.const 999))
        (drop (i32.const 1))
        (nop)
        (unreachable)
      )
    )
    (drop
      (if (result i32) (i32.const 2)
        (block (result i32)
          (drop (i32.const -1234))
          (drop (i32.const -1000))
          (drop (i32.const 1))
          (nop)
          (unreachable)
          (i32.const 2)
        )
        (block (result i32)
          (drop (i32.const 999))
          (drop (i32.const 1))
          (nop)
          (unreachable)
          (i32.const 2)
        )
      )
    )
    (drop
      (if (result i32) (i32.const 3)
        (block (result i32)
          (drop (i32.const -1234))
          (drop (i32.const -1000))
          (drop (i32.const 1))
          (nop)
          (i32.const 2)
        )
        (block (result i32)
          (drop (i32.const 999))
          (drop (i32.const 1))
          (nop)
          (i32.const 2)
        )
      )
    )
  )
  (func $if-worth-it-i-dunno
    ;; just 2, so not worth it
    (if (i32.const 0) ;; (put them in ifs, so no block outside which would make us more confident in creating a block in hopes it would vanish)
      (if (i32.const 0)
        (block
          (drop (i32.const -1234))
          (drop (i32.const -1000))
          (unreachable)
          (unreachable)
        )
        (block
          (drop (i32.const 999))
          (drop (i32.const 1))
          (unreachable)
          (unreachable)
        )
      )
    )
    ;; 3, so why not
    (if (i32.const 0) ;; (put them in ifs, so no block outside which would make us more confident in creating a block in hopes it would vanish)
      (if (i32.const 0)
        (block
          (drop (i32.const -1234))
          (drop (i32.const -1000))
          (unreachable)
          (unreachable)
          (unreachable)
        )
        (block
          (drop (i32.const 999))
          (drop (i32.const 1))
          (unreachable)
          (unreachable)
          (unreachable)
        )
      )
    )
    ;; just 2, but we'll empty out a block
    (if (i32.const 0) ;; (put them in ifs, so no block outside which would make us more confident in creating a block in hopes it would vanish)
      (if (i32.const 0)
        (block
          (unreachable)
          (unreachable)
        )
        (block
          (drop (i32.const 999))
          (drop (i32.const 1))
          (unreachable)
          (unreachable)
        )
      )
    )
    ;; just 2, but we'll empty out a block
    (if (i32.const 0) ;; (put them in ifs, so no block outside which would make us more confident in creating a block in hopes it would vanish)
      (if (i32.const 0)
        (block
          (drop (i32.const -1234))
          (drop (i32.const -1000))
          (unreachable)
          (unreachable)
        )
        (block
          (unreachable)
          (unreachable)
        )
      )
    )
    ;; just two, but on a block, so we hope to merge, and can optimize here
    (block $a-holding-block
      (if (i32.const 9999)
        (block
          (drop (i32.const -51234))
          (drop (i32.const -51000))
          (unreachable)
          (unreachable)
        )
        (block
          (drop (i32.const 5999))
          (drop (i32.const 51))
          (unreachable)
          (unreachable)
        )
      )
    )
    ;; with value
    (drop
      (block $b-holding-block (result i32)
        (if (result i32) (i32.const 9999)
          (block (result i32)
            (drop (i32.const -51234))
            (drop (i32.const -51000))
            (unreachable)
            (i32.const 10)
          )
          (block (result i32)
            (drop (i32.const 5999))
            (drop (i32.const 51))
            (unreachable)
            (i32.const 10)
          )
        )
      )
    )
    ;; oops, something in between
    (block $c-holding-block
      (drop
        (if (result i32) (i32.const 9999)
          (block (result i32)
            (drop (i32.const -51234))
            (drop (i32.const -51000))
            (unreachable)
            (i32.const 10)
          )
          (block (result i32)
            (drop (i32.const 5999))
            (drop (i32.const 51))
            (unreachable)
            (i32.const 10)
          )
        )
      )
    )
  )
  (func $no-grandparent
    ;; if we had a parent block, we might optimize this
    (if (i32.const 9999)
      (block
        (drop (i32.const -51234))
        (drop (i32.const -51000))
        (unreachable)
        (unreachable)
      )
      (block
        (drop (i32.const 5999))
        (drop (i32.const 51))
        (unreachable)
        (unreachable)
      )
    )
  )
  (func $yes-grandparent
    (block
      (if (i32.const 9999)
        (block
          (drop (i32.const -51234))
          (drop (i32.const -51000))
          (unreachable)
          (unreachable)
        )
        (block
          (drop (i32.const 5999))
          (drop (i32.const 51))
          (unreachable)
          (unreachable)
        )
      )
    )
  )
  (func $ifs-named-block (param $x i32) (param $y i32) (result i32)
    (block $out
      (block $out2
        (if (get_local $x)
          (block
            (br_if $out (get_local $y i32))
            (nop)
          )
          (block
            (br_if $out (get_local $y i32))
            (nop)
          )
        )
        (if (get_local $x)
          (block
            (br_if $out (get_local $y i32))
            (nop)
          )
          (block
            (br_if $out2 (get_local $y i32))
            (nop)
          )
        )
        (if (i32.const 1234)
          (if (get_local $x)
            (block
              (nop)
              (br_if $out (get_local $y i32))
              (nop)
            )
            (block
              (nop)
              (br_if $out2 (get_local $y i32))
              (nop)
            )
          )
        )
        (if (get_local $x)
          (block $left
            (br_if $left (get_local $y i32))
            (nop)
          )
          (block
            (br_if $out (get_local $y i32))
            (nop)
          )
        )
        (if (get_local $x)
          (block
            (br_if $out (get_local $y i32))
            (nop)
          )
          (block $right
            (br_if $right (get_local $y i32))
            (nop)
          )
        )
      )
      (return (i32.const 10))
    )
    (return (i32.const 20))
  )
  (func $block
    (block $x
      (if (i32.const 0)
        (block
          (drop (i32.const 1))
          (drop (i32.const 2))
          (br $x)
        )
      )
      (if (i32.const 0)
        (block
          (drop (i32.const 1))
          (drop (i32.const 2))
          (br $x)
        )
      )
      ;; no fallthrough, another thing to merge
      (drop (i32.const 1))
      (drop (i32.const 2))
      (br $x)
    )
  )
  (func $block2
    (block $x
      (if (i32.const 0)
        (block
          (drop (i32.const 1))
          (drop (i32.const 333333))
          (br $x)
        )
      )
      (if (i32.const 0)
        (block
          (drop (i32.const 1))
          (drop (i32.const 2))
          (br $x)
        )
      )
      ;; no fallthrough, another thing to merge
      (drop (i32.const 1))
      (drop (i32.const 2))
      (br $x)
    )
  )
  (func $block3
    (block $x
      (if (i32.const 0)
        (block
          (drop (i32.const 1000))
          (drop (i32.const 1))
          (drop (i32.const 2))
          (br $x)
        )
      )
      (if (i32.const 0)
        (block
          (drop (i32.const 2000))
          (drop (i32.const 3000))
          (drop (i32.const 1))
          (drop (i32.const 2))
          (br $x)
        )
      )
      (drop (i32.const 4000))
      (drop (i32.const 5000))
      (drop (i32.const 6000))
      ;; no fallthrough, another thing to merge
      (drop (i32.const 1))
      (drop (i32.const 2))
      (br $x)
    )
  )
  (func $mixture
    (block $out ;; then we reach the block, and the tail infos are stale, should ignore
      (if (i32.const 1) ;; then we optimize the if, pushing those brs outside!
        (block
          (drop (i32.const 2)) ;; first we note the block tails for $out
          (nop) (nop) (nop) (nop) (nop) (nop) ;; totally worth it
          (br $out)
        )
        (block
          (drop (i32.const 2))
          (nop) (nop) (nop) (nop) (nop) (nop)
          (br $out)
        )
      )
    )
    (block $out2
      (if (i32.const 1)
        (block
          (drop (i32.const 3)) ;; leave something
          (drop (i32.const 2))
          (nop) (nop) (nop) (nop) (nop) (nop)
          (br $out2)
        )
        (block
          (drop (i32.const 4)) ;; leave something
          (drop (i32.const 5)) ;; leave something
          (drop (i32.const 2))
          (nop) (nop) (nop) (nop) (nop) (nop)
          (br $out2)
        )
      )
    )
    ;; now a case where do **do** want to fold for the block (which we can only do in a later pass)
    (block $out3
      (if (i32.const 1)
        (block
          (drop (i32.const 2))
          (nop) (nop) (nop) (nop) (nop) (nop)
          (br $out3)
        )
        (block
          (drop (i32.const 2))
          (nop) (nop) (nop) (nop) (nop) (nop)
          (br $out3)
        )
      )
      (if (i32.const 1)
        (block
          (drop (i32.const 2))
          (nop) (nop) (nop) (nop) (nop) (nop)
          (br $out3)
        )
        (block
          (drop (i32.const 2))
          (nop) (nop) (nop) (nop) (nop) (nop)
          (br $out3)
        )
      )
      (drop (i32.const 2))
      (nop) (nop) (nop) (nop) (nop) (nop)
      (br $out3)
    )
  )
  (func $block-corners
    ;; these should be merged
    (block $x
      (if (i32.const 0)
        (block
          (drop (i32.const 1))
          (drop (i32.const 2))
          (br $x)
        )
      )
      (drop (i32.const 1))
      (drop (i32.const 2))
    )
    ;; these should not
    ;; values
    (drop
      (block $y (result i32)
        (if (i32.const 0)
          (block
            (drop (i32.const 1))
            (drop (i32.const 2))
            (br $y (i32.const 3))
          )
        )
        (drop (i32.const 1))
        (drop (i32.const 2))
        (br $y (i32.const 3))
      )
    )
    (drop
      (block $z (result i32)
        (if (i32.const 0)
          (block
            (drop (i32.const 1))
            (drop (i32.const 2))
            (br $z (i32.const 2))
          )
        )
        (drop (i32.const 1))
        (drop (i32.const 2))
        (i32.const 3)
      )
    )
    ;; condition
    (block $w
      (if (i32.const 0)
        (block
          (drop (i32.const 1))
          (drop (i32.const 2))
          (br_if $w (i32.const 3))
        )
      )
      (drop (i32.const 1))
      (drop (i32.const 2))
    )
    ;; not at the end
    (block $x1
      (if (i32.const 0)
        (block
          (drop (i32.const 1))
          (drop (i32.const 2))
          (br $x1)
          (nop)
        )
      )
      (drop (i32.const 1))
      (drop (i32.const 2))
    )
    ;; switches
    (block $side
      (block $x2
        (br_table $x2 $side (i32.const 0))
        (if (i32.const 0)
          (block
            (drop (i32.const 1))
            (drop (i32.const 2))
            (br $x2)
          )
        )
        (drop (i32.const 1))
        (drop (i32.const 2))
      )
      (block $x3
        (br_table $side $x3 (i32.const 0))
        (if (i32.const 0)
          (block
            (drop (i32.const 1))
            (drop (i32.const 2))
            (br $x3)
          )
        )
        (drop (i32.const 1))
        (drop (i32.const 2))
      )
    )
  )
  (func $terminating
    (if (i32.const 1)
      (block
        (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop)
        (unreachable)
      )
    )
    (if (i32.const 2)
      (block
        (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop)
        (unreachable)
      )
    )
    (if (i32.const 3)
      (block
        (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop)
        (unreachable)
      )
    )
  )
  (func $terminating-unreachable
    (if (i32.const 1)
      (block
        (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop)
        (unreachable)
      )
    )
    (if (i32.const 2)
      (block
        (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop)
        (unreachable)
      )
    )
    (if (i32.const 3)
      (block
        (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop)
        (unreachable)
      )
    )
    (unreachable)
  )
  (func $terminating-value (result i32)
    (if (i32.const 1)
      (block
        (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop)
        (unreachable)
      )
    )
    (if (i32.const 2)
      (block
        (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop)
        (unreachable)
      )
    )
    (if (i32.const 3)
      (block
        (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop)
        (unreachable)
      )
    )
    (i32.const 4)
  )
  (func $terminating-just-2
    (if (i32.const 1)
      (block
        (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop)
        (unreachable)
      )
    )
    (if (i32.const 2)
      (block
        (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop)
        (unreachable)
      )
    )
    (if (i32.const 3)
      (block
        (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop)
        (drop (i32.const 10))
        (unreachable)
      )
    )
  )
  (func $terminating-shortness
    (if (i32.const 1)
      (block
        (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop)
        (unreachable)
      )
    )
    (if (i32.const 2)
      (block
        (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop) ;; shorter. we do the two long ones greedily, then the merged one and this can also be opted
        (unreachable)
      )
    )
    (if (i32.const 3)
      (block
        (drop (i32.const 10))
        (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop)
        (unreachable)
      )
    )
  )
  (func $terminating-multiple-separate
    (if (i32.const 1)
      (block
        (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop)
        (drop (i32.const 1))
        (unreachable)
      )
    )
    (if (i32.const 1)
      (block
        (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop)
        (drop (i32.const 1))
        (unreachable)
      )
    )
    (if (i32.const 1)
      (block
        (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop)
        (drop (i32.const 2))
        (unreachable)
      )
    )
    (if (i32.const 1)
      (block
        (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop)
        (drop (i32.const 2))
        (unreachable)
      )
    )
  )
  (func $terminating-just-worth-it
    (if (i32.const 1)
      (block
        (nop) (nop) (nop)
        (unreachable)
      )
    )
    (if (i32.const 2)
      (block
        (nop) (nop) (nop)
        (unreachable)
      )
    )
    (if (i32.const 3)
      (block
        (nop) (nop) (nop)
        (unreachable)
      )
    )
  )
  (func $terminating-not-worth-it
    (if (i32.const 1)
      (block
        (nop) (nop)
        (unreachable)
      )
    )
    (if (i32.const 2)
      (block
        (nop) (nop)
        (unreachable)
      )
    )
    (if (i32.const 3)
      (block
        (nop) (nop)
        (unreachable)
      )
    )
  )
  (func $terminating-return
    (if (i32.const 1)
      (block
        (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop)
        (return)
      )
    )
    (if (i32.const 2)
      (block
        (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop)
        (return)
      )
    )
    (if (i32.const 3)
      (block
        (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop) (nop)
        (return)
      )
    )
  )
  (func $terminating-return-value (result i32)
    (if (i32.const 1)
      (block
        (nop)
        (return (i32.add (i32.const 1) (i32.const 2)))
      )
    )
    (if (i32.const 2)
      (block
        (nop)
        (return (i32.add (i32.const 1) (i32.const 2)))
      )
    )
    (if (i32.const 3)
      (block
        (nop)
        (return (i32.add (i32.const 1) (i32.const 2)))
      )
    )
    (if (i32.const 3)
      (block
        (nop)
        (return (i32.add (i32.const 111111111) (i32.const 2222222)))
      )
    )
    (return (i32.const 1234))
  )
  (func $terminating-fallthrough-value (result i32)
    (if (i32.const 1)
      (block
        (nop)
        (return (i32.add (i32.const 1) (i32.const 2)))
      )
    )
    (if (i32.const 2)
      (block
        (nop)
        (return (i32.add (i32.const 1) (i32.const 2)))
      )
    )
    (if (i32.const 3)
      (block
        (nop)
        (return (i32.add (i32.const 1) (i32.const 2)))
      )
    )
    (if (i32.const 3)
      (block
        (nop)
        (return (i32.add (i32.const 111111111) (i32.const 2222222)))
      )
    )
    (i32.const 1234)
  )
  (func $big-return (result i32)
    (if (i32.const 1) (return (i32.add (i32.const 1) (i32.const 2))))
    (if (i32.const 2) (return (i32.add (i32.const 1) (i32.const 2))))
    (if (i32.const 3) (return (i32.add (i32.const 1) (i32.const 2))))
    (if (i32.const 4) (return (i32.add (i32.const 1) (i32.const 2))))
    (if (i32.const 5) (return (i32.add (i32.const 1) (i32.const 2))))
    (if (i32.const 6) (return (i32.add (i32.const 1) (i32.const 2))))
    (unreachable)
  )
  (func $return-mix (result i32)
    (if (i32.const 1) (return (i32.add (i32.const 1) (i32.const 2))))
    (if (i32.const 2) (return (i32.add (i32.const 1) (i32.const 2))))
    (if (i32.const 3) (return (i32.add (i32.const 1) (i32.const 2))))
    (if (i32.const 4) (return (i32.add (i32.const 1) (i32.const 2))))
    (if (i32.const 3) (return (i32.add (i32.const 1) (i32.const 234567))))
    (return (i32.add (i32.const 1) (i32.const 2))) ;; on a block, and the toplevel in fact
  )
  (func $just-unreachable
    (unreachable)
  )
  (func $just-return (result i32)
    (return (i32.add (i32.const 1) (i32.const 2))) ;; on a block, and the toplevel in fact
  )
  (func $drop-if-with-value-but-unreachable
   (block $label$0
    (if
     (i32.const 0)
     (block $label$1
      (nop)
     )
    )
    (if
     (i32.const 0)
     (block $label$2
      (nop)
     )
     (block $label$3
      (nop)
     )
    )
    (if
     (i32.const 0)
     (block $label$4
      (nop)
     )
     (block $label$5
      (unreachable)
     )
    )
    (nop)
    (drop
     (if (result i32) ;; we replace this if, must replace with same type!
      (unreachable)
      (block $label$6 (result i32)
       (i32.add
        (i32.const 1)
        (i32.const 2)
       )
      )
      (block $label$7 (result i32)
       (i32.add
        (i32.const 1)
        (i32.const 2)
       )
      )
     )
    )
    (drop
     (if (result i32)
      (i32.const 0)
      (block $label$8 (result i32)
       (i32.add
        (i32.const 1)
        (i32.const 2)
       )
      )
      (block $label$9 (result i32)
       (i32.add
        (i32.const 1)
        (i32.const 333333333)
       )
      )
     )
    )
   )
  )
  (func $nested-control-flow
    (block $out
      (block $x
        (if (i32.const 0)
          (block
            (if (i32.const 1)
              (br $out)
            )
            (drop (i32.const 1))
            (drop (i32.const 2))
            (br $x)
          )
        )
        (if (i32.const 0)
          (block
            (if (i32.const 1)
              (br $out)
            )
            (drop (i32.const 1))
            (drop (i32.const 2))
            (br $x)
          )
        )
        ;; no fallthrough, another thing to merge
        (if (i32.const 1)
          (br $out)
        )
        (drop (i32.const 1))
        (drop (i32.const 2))
        (br $x)
      )
      (drop (i32.const 3))
    )
  )
  (func $nested-control-flow-dangerous
    (block $out
      (block $x
        (if (i32.const 0)
          (block
            (if (i32.const 1)
              (br $out) ;; this br cannot be moved out of the $out block!
            )
            (drop (i32.const 1))
            (drop (i32.const 2))
            (return)
          )
        )
        (if (i32.const 0)
          (block
            (if (i32.const 1)
              (br $out)
            )
            (drop (i32.const 1))
            (drop (i32.const 2))
            (return)
          )
        )
        ;; no fallthrough, another thing to merge
        (if (i32.const 1)
          (br $out)
        )
        (drop (i32.const 1))
        (drop (i32.const 2))
        (return)
      )
      (drop (i32.const 3))
    )
  )
  (func $nested-control-flow-dangerous-but-ok
    (block $out
      (block $middle
        (block $x
          (if (i32.const 0)
            (block
              (if (i32.add (i32.const 0) (i32.const 1))
                (br $middle)
              )
              (drop (i32.const 1))
              (drop (i32.const 2))
              (return)
            )
          )
          (if (i32.const 0)
            (block
              (if (i32.add (i32.const 0) (i32.const 1))
                (br $middle)
              )
              (drop (i32.const 1))
              (drop (i32.const 2))
              (return)
            )
          )
          ;; no fallthrough, another thing to merge
          (if (i32.add (i32.const 0) (i32.const 1))
            (br $middle)
          )
          (drop (i32.const 1))
          (drop (i32.const 2))
          (return)
        )
      )
      (drop (i32.const 3))
    )
  )
  (func $nested-control-flow-dangerous-but-ok-b
    (block $out
      (block $middle
        (block $x
          (if (i32.const 0)
            (block
              (if (i32.add (i32.const 0) (i32.const 1))
                (br $middle) ;; this is dangerous - we branch to middle with is inside out, so we can't move this out of out
              )
              (drop (i32.const 1))
              (drop (i32.const 2))
              (drop (i32.const 3))
              (drop (i32.const 4))
              (drop (i32.const 1))
              (drop (i32.const 2))
              (drop (i32.const 3))
              (drop (i32.const 4))
              (br $out)
            )
          )
          (if (i32.const 0)
            (block
              (if (i32.add (i32.const 0) (i32.const 1))
                (br $middle)
              )
              (drop (i32.const 1))
              (drop (i32.const 2))
              (drop (i32.const 3))
              (drop (i32.const 4))
              (drop (i32.const 1))
              (drop (i32.const 2))
              (drop (i32.const 3))
              (drop (i32.const 4))
              (br $out)
            )
          )
          ;; no fallthrough, another thing to merge
          (if (i32.add (i32.const 0) (i32.const 1))
            (br $middle)
          )
        )
      )
      (unreachable) ;; no fallthrough
    )
  )
  (func $nested-control-flow-dangerous-but-ok-c
    (block $x
      (block $out
        (block $middle
          (if (i32.const 0)
            (block
              (if (i32.add (i32.const 0) (i32.const 1))
                (br $x) ;; this is ok - we branch to x which is outside of out
              )
              (drop (i32.const 1))
              (drop (i32.const 2))
              (br $out)
            )
          )
          (if (i32.const 0)
            (block
              (if (i32.add (i32.const 0) (i32.const 1))
                (br $x)
              )
              (drop (i32.const 1))
              (drop (i32.const 2))
              (br $out)
            )
          )
          ;; no fallthrough, another thing to merge
          (if (i32.add (i32.const 0) (i32.const 1))
            (br $x)
          )
          (drop (i32.const 1))
          (drop (i32.const 2))
          (br $out)
        )
        (unreachable) ;; no fallthrough
      )
      (unreachable) ;; no fallthrough
    )
    (drop (i32.const 5))
  )
  (func $nested-control-flow-dangerous-but-ok-d
    (block $out
      (block $middle
        (if (i32.const 0)
          (block
            (block $x
              (if (i32.add (i32.const 0) (i32.const 1))
                (br $x) ;; this is ok - we branch to x which is nested in us
              )
            )
            (drop (i32.const 1))
            (drop (i32.const 2))
            (br $out)
          )
        )
        (if (i32.const 0)
          (block
            (block $x
              (if (i32.add (i32.const 0) (i32.const 1))
                (br $x) ;; this is ok - we branch to x which is nested in us
              )
            )
            (drop (i32.const 1))
            (drop (i32.const 2))
            (br $out)
          )
        )
        ;; no fallthrough, another thing to merge
        (block $x
          (if (i32.add (i32.const 0) (i32.const 1))
            (br $x) ;; this is ok - we branch to x which is nested in us
          )
        )
        (drop (i32.const 1))
        (drop (i32.const 2))
        (br $out)
      )
    )
    (drop (i32.const 3))
  )
  (func $if-suffix (param $x i32) (result i32)
    (if
      (get_local $x)
      (set_local $x (i32.const 1))
      (block
        (drop (call $if-suffix (i32.const -1)))
        (set_local $x (i32.const 1))
      )
    )
    (if (result i32)
      (get_local $x)
      (i32.const 2)
      (block (result i32)
        (drop (call $if-suffix (i32.const -2)))
        (i32.const 2)
      )
    )
  )
)
