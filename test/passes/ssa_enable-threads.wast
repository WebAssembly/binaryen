(module
  (global $global$0 (mut i32) (i32.const 1))
  (func $basics (param $x i32)
    (local $y i32)
    (local $z f32)
    (local $w i64)
    (local $t f64)
    (drop (local.get $x)) ;; keep as param get
    (drop (local.get $y)) ;; turn into get of 0-init
    (drop (local.get $z))
    (drop (local.get $w))
    (drop (local.get $t))
    (local.set $x (i32.const 100)) ;; overwrite param
    (drop (local.get $x)) ;; no longer a param!
    (local.set $t (f64.const 2)) ;; overwrite local
    (drop (local.get $t))
    (local.set $t (f64.const 33)) ;; overwrite local AGAIN
    (drop (local.get $t))
    (drop (local.get $t)) ;; use twice
  )
  (func $if (param $p i32)
    (local $x i32)
    (local $y i32)
    (drop
      (if i32
        (i32.const 1)
        (local.get $x)
        (local.get $y)
      )
    )
    (if
      (i32.const 1)
      (local.set $x (i32.const 1))
    )
    (drop (local.get $x))
    ;; same but with param
    (if
      (i32.const 1)
      (local.set $p (i32.const 1))
    )
    (drop (local.get $p))
    ;; if-else
    (if
      (i32.const 1)
      (local.set $x (i32.const 2))
      (nop)
    )
    (drop (local.get $x))
    (if
      (i32.const 1)
      (nop)
      (local.set $x (i32.const 3))
    )
    (drop (local.get $x))
    (if
      (i32.const 1)
      (local.set $x (i32.const 4))
      (local.set $x (i32.const 5))
    )
    (drop (local.get $x))
    (if
      (i32.const 1)
      (local.set $x (i32.const 6))
      (block
        (local.set $x (i32.const 7))
        (local.set $x (i32.const 8))
      )
    )
    (drop (local.get $x))
  )
  (func $if2 (param $x i32)
    (if
      (i32.const 1)
      (block
        (local.set $x (i32.const 1))
        (drop (local.get $x)) ;; use between phi set and use
      )
    )
    (drop (local.get $x))
  )
  (func $block (param $x i32)
    (block $out
      (br_if $out (i32.const 2))
      (local.set $x (i32.const 1))
    )
    (drop (local.get $x))
  )
  (func $block2 (param $x i32)
    (block $out
      (local.set $x (i32.const 1))
      (drop (local.get $x))
      (br_if $out (i32.const 2))
      (drop (local.get $x))
      (if (i32.const 3)
        (block
          (local.set $x (i32.const 1))
          (drop (local.get $x))
          (br $out)
        )
      )
      (drop (local.get $x))
      (local.set $x (i32.const 4))
      (drop (local.get $x))
      (if (i32.const 5)
        (br $out)
      )
      (drop (local.get $x))
      (if (i32.const 6)
        (nop)
      )
      (if (i32.const 7)
        (nop)
        (nop)
      )
      ;; finally, switching
      (block $in
        (local.set $x (i32.const 8))
        (drop (local.get $x))
        (br_table $in $out (i32.const 9))
      )
      (drop (local.get $x))
      (block $in2
        (local.set $x (i32.const 10))
        (drop (local.get $x))
        (br_table $out $in2 (i32.const 11))
      )
      (drop (local.get $x))
    )
    (drop (local.get $x))
  )
  (func $loop (param $x i32)
    (drop (local.get $x))
    (loop $moar
      (drop (local.get $x))
      (local.set $x (i32.const 1))
      (br_if $moar (i32.const 2))
    )
    (drop (local.get $x))
  )
  (func $loop2 (param $x i32)
    (drop (local.get $x))
    (loop $moar
      (drop (local.get $x))
      (local.set $x (i32.const 1))
      (drop (local.get $x))
      (local.set $x (i32.const 123))
      (drop (local.get $x))
      (br_if $moar (i32.const 2))
      (drop (local.get $x)) ;; add use in loop before it ends, we should update this to the phi
      (local.set $x (i32.const 3))
      (drop (local.get $x)) ;; another use, but should *not* be phi'd
    )
    (drop (local.get $x))
  )
  (func $loop2-zeroinit
    (local $x i32)
    (drop (local.get $x))
    (loop $moar
      (drop (local.get $x))
      (local.set $x (i32.const 1))
      (drop (local.get $x))
      (local.set $x (i32.const 123))
      (drop (local.get $x))
      (br_if $moar (i32.const 2))
      (drop (local.get $x)) ;; add use in loop before it ends, we should update this to the phi
      (local.set $x (i32.const 3))
      (drop (local.get $x)) ;; another use, but should *not* be phi'd
    )
    (drop (local.get $x))
  )
  (func $real-loop
    (param $param i32)
    (local $loopvar i32)
    (local $inc i32)
    (local.set $loopvar
     (local.get $param)
    )
    (loop $more
     (block $stop
      (if
       (i32.const 1)
       (br $stop)
      )
      (local.set $inc
       (i32.add
        (local.get $loopvar) ;; this var should be written to from before the loop and the inc at the end
        (i32.const 1)
       )
      )
      (local.set $loopvar
       (local.get $inc)
      )
      (br $more)
     )
    )
    (drop (local.get $loopvar))
  )
  (func $real-loop-outblock
    (param $param i32)
    (local $loopvar i32)
    (local $inc i32)
    (local.set $loopvar
     (local.get $param)
    )
    (block $stop
     (loop $more
      (if
       (i32.const 1)
       (br $stop)
      )
      (local.set $inc
       (i32.add
        (local.get $loopvar) ;; this var should be written to from before the loop and the inc at the end
        (i32.const 1)
       )
      )
      (local.set $loopvar
       (local.get $inc)
      )
      (br $more)
     )
    )
    (drop (local.get $loopvar))
  )
  (func $loop-loop-param
    (param $param i32)
    (loop $loop1
      (block $out1
        (if
          (local.get $param)
          (br $out1)
        )
        (local.set $param (i32.const 1))
        (br $loop1)
      )
    )
    (loop $loop2
      (block $out2
        (if
          (local.get $param)
          (br $out2)
        )
        (local.set $param (i32.const 2))
        (br $loop2)
      )
    )
  )
  (func $loop-loop-param-nomerge
    (param $param i32)
    (loop $loop1
      (block $out1
        (local.set $param (i32.const 1))
        (if
          (local.get $param)
          (br $out1)
        )
        (br $loop1)
      )
    )
    (loop $loop2
      (block $out2
        (if
          (local.get $param)
          (br $out2)
        )
        (local.set $param (i32.const 2))
        (br $loop2)
      )
    )
  )
  (func $loop-nesting
    (param $x i32)
    (block $out
      (loop $loop1
        (if
          (local.get $x)
          (br $out)
        )
        (loop $loop2
          (if
            (local.get $x)
            (br $out)
          )
          (local.set $x (i32.const 1))
          (br $loop2)
        )
        (local.set $x (i32.const 2))
        (br $loop1)
      )
    )
    (drop (local.get $x)) ;; can receive from either set, or input param
  )
  (func $loop-nesting-2
    (param $x i32)
    (block $out
      (loop $loop1
        (if
          (local.get $x)
          (br $out)
        )
        (loop $loop2
          (if
            (local.get $x)
            (br $out)
          )
          (local.set $x (i32.const 1))
          (br_if $loop2 (i32.const 3)) ;; add fallthrough
        )
        (local.set $x (i32.const 2))
        (br $loop1)
      )
    )
    (drop (local.get $x)) ;; can receive from either set, or input param
  )
  (func $func_6 (result i32)
   (local $result i32)
   (local $zero i32)
   (loop $label$1
    (if
     (i32.eqz
      (global.get $global$0)
     )
     (return
      (local.get $result) ;; we eventually reach here
     )
    )
    (global.set $global$0
     (i32.const 0) ;; tell next iteration to return
    )
    (local.set $result
     (i32.const 1) ;; set the return value to 1, temporarily
    )
    (br_if $label$1
     (i32.const 0) ;; don't do anything here
    )
    (local.set $result
     (local.get $zero) ;; set it to zero instead
    )
    (br $label$1) ;; back to the top, where we will return the zero
   )
  )
  (func $ssa-merge-tricky (result i32)
   (local $var$0 i32)
   (local $var$1 i32)
   (local.set $var$1
    (local.tee $var$0
     (i32.const 0) ;; both vars start out identical
    )
   )
   (loop $label$1
    (if
     (i32.eqz
      (global.get $global$0)
     )
     (return
      (i32.const 12345)
     )
    )
    (global.set $global$0
     (i32.const 0)
    )
    (if
     (i32.eqz
      (local.get $var$0) ;; check $0 here. this will get a phi var
     )
     (br_if $label$1
      (i32.eqz
       (local.tee $var$0 ;; set $0 to 1. here the two diverge. for the phi, we'll get a set here and above
        (i32.const 1)
       )
      )
     )
    )
    (br_if $label$1
     (i32.eqz ;; indeed equal, enter loop again, and then hang prevention kicks in
      (local.tee $var$1 ;; set them all to 0
       (local.tee $var$0
        (local.get $var$1) ;; this must get $1, not the phis, as even though the sets appear in both sources, we only execute 1.
       )
      )
     )
    )
   )
   (i32.const -54)
  )
)

