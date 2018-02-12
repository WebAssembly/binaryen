(module
  (global $global$0 (mut i32) (i32.const 1))
  (func $basics (param $x i32)
    (local $y i32)
    (local $z f32)
    (local $w i64)
    (local $t f64)
    (drop (get_local $x)) ;; keep as param get
    (drop (get_local $y)) ;; turn into get of 0-init
    (drop (get_local $z))
    (drop (get_local $w))
    (drop (get_local $t))
    (set_local $x (i32.const 100)) ;; overwrite param
    (drop (get_local $x)) ;; no longer a param!
    (set_local $t (f64.const 2)) ;; overwrite local
    (drop (get_local $t))
    (set_local $t (f64.const 33)) ;; overwrite local AGAIN
    (drop (get_local $t))
    (drop (get_local $t)) ;; use twice
  )
  (func $if (param $p i32)
    (local $x i32)
    (local $y i32)
    (drop
      (if i32
        (i32.const 1)
        (get_local $x)
        (get_local $y)
      )
    )
    (if
      (i32.const 1)
      (set_local $x (i32.const 1))
    )
    (drop (get_local $x))
    ;; same but with param
    (if
      (i32.const 1)
      (set_local $p (i32.const 1))
    )
    (drop (get_local $p))
    ;; if-else
    (if
      (i32.const 1)
      (set_local $x (i32.const 2))
      (nop)
    )
    (drop (get_local $x))
    (if
      (i32.const 1)
      (nop)
      (set_local $x (i32.const 3))
    )
    (drop (get_local $x))
    (if
      (i32.const 1)
      (set_local $x (i32.const 4))
      (set_local $x (i32.const 5))
    )
    (drop (get_local $x))
    (if
      (i32.const 1)
      (set_local $x (i32.const 6))
      (block
        (set_local $x (i32.const 7))
        (set_local $x (i32.const 8))
      )
    )
    (drop (get_local $x))
  )
  (func $if2 (param $x i32)
    (if
      (i32.const 1)
      (block
        (set_local $x (i32.const 1))
        (drop (get_local $x)) ;; use between phi set and use
      )
    )
    (drop (get_local $x))
  )
  (func $block (param $x i32)
    (block $out
      (br_if $out (i32.const 2))
      (set_local $x (i32.const 1))
    )
    (drop (get_local $x))
  )
  (func $block2 (param $x i32)
    (block $out
      (set_local $x (i32.const 1))
      (drop (get_local $x))
      (br_if $out (i32.const 2))
      (drop (get_local $x))
      (if (i32.const 3)
        (block
          (set_local $x (i32.const 1))
          (drop (get_local $x))
          (br $out)
        )
      )
      (drop (get_local $x))
      (set_local $x (i32.const 4))
      (drop (get_local $x))
      (if (i32.const 5)
        (br $out)
      )
      (drop (get_local $x))
      (if (i32.const 6)
        (nop)
      )
      (if (i32.const 7)
        (nop)
        (nop)
      )
      ;; finally, switching
      (block $in
        (set_local $x (i32.const 8))
        (drop (get_local $x))
        (br_table $in $out (i32.const 9))
      )
      (drop (get_local $x))
      (block $in2
        (set_local $x (i32.const 10))
        (drop (get_local $x))
        (br_table $out $in2 (i32.const 11))
      )
      (drop (get_local $x))
    )
    (drop (get_local $x))
  )
  (func $loop (param $x i32)
    (drop (get_local $x))
    (loop $moar
      (drop (get_local $x))
      (set_local $x (i32.const 1))
      (br_if $moar (i32.const 2))
    )
    (drop (get_local $x))
  )
  (func $loop2 (param $x i32)
    (drop (get_local $x))
    (loop $moar
      (drop (get_local $x))
      (set_local $x (i32.const 1))
      (drop (get_local $x))
      (set_local $x (i32.const 123))
      (drop (get_local $x))
      (br_if $moar (i32.const 2))
      (drop (get_local $x)) ;; add use in loop before it ends, we should update this to the phi
      (set_local $x (i32.const 3))
      (drop (get_local $x)) ;; another use, but should *not* be phi'd
    )
    (drop (get_local $x))
  )
  (func $loop2-zeroinit
    (local $x i32)
    (drop (get_local $x))
    (loop $moar
      (drop (get_local $x))
      (set_local $x (i32.const 1))
      (drop (get_local $x))
      (set_local $x (i32.const 123))
      (drop (get_local $x))
      (br_if $moar (i32.const 2))
      (drop (get_local $x)) ;; add use in loop before it ends, we should update this to the phi
      (set_local $x (i32.const 3))
      (drop (get_local $x)) ;; another use, but should *not* be phi'd
    )
    (drop (get_local $x))
  )
  (func $real-loop
    (param $param i32)
    (local $loopvar i32)
    (local $inc i32)
    (set_local $loopvar
     (get_local $param)
    )
    (loop $more
     (block $stop
      (if
       (i32.const 1)
       (br $stop)
      )
      (set_local $inc
       (i32.add
        (get_local $loopvar) ;; this var should be written to from before the loop and the inc at the end
        (i32.const 1)
       )
      )
      (set_local $loopvar
       (get_local $inc)
      )
      (br $more)
     )
    )
    (drop (get_local $loopvar))
  )
  (func $real-loop-outblock
    (param $param i32)
    (local $loopvar i32)
    (local $inc i32)
    (set_local $loopvar
     (get_local $param)
    )
    (block $stop
     (loop $more
      (if
       (i32.const 1)
       (br $stop)
      )
      (set_local $inc
       (i32.add
        (get_local $loopvar) ;; this var should be written to from before the loop and the inc at the end
        (i32.const 1)
       )
      )
      (set_local $loopvar
       (get_local $inc)
      )
      (br $more)
     )
    )
    (drop (get_local $loopvar))
  )
  (func $loop-loop-param
    (param $param i32)
    (loop $loop1
      (block $out1
        (if
          (get_local $param)
          (br $out1)
        )
        (set_local $param (i32.const 1))
        (br $loop1)
      )
    )
    (loop $loop2
      (block $out2
        (if
          (get_local $param)
          (br $out2)
        )
        (set_local $param (i32.const 2))
        (br $loop2)
      )
    )
  )
  (func $loop-loop-param-nomerge
    (param $param i32)
    (loop $loop1
      (block $out1
        (set_local $param (i32.const 1))
        (if
          (get_local $param)
          (br $out1)
        )
        (br $loop1)
      )
    )
    (loop $loop2
      (block $out2
        (if
          (get_local $param)
          (br $out2)
        )
        (set_local $param (i32.const 2))
        (br $loop2)
      )
    )
  )
  (func $loop-nesting
    (param $x i32)
    (block $out
      (loop $loop1
        (if
          (get_local $x)
          (br $out)
        )
        (loop $loop2
          (if
            (get_local $x)
            (br $out)
          )
          (set_local $x (i32.const 1))
          (br $loop2)
        )
        (set_local $x (i32.const 2))
        (br $loop1)
      )
    )
    (drop (get_local $x)) ;; can receive from either set, or input param
  )
  (func $loop-nesting-2
    (param $x i32)
    (block $out
      (loop $loop1
        (if
          (get_local $x)
          (br $out)
        )
        (loop $loop2
          (if
            (get_local $x)
            (br $out)
          )
          (set_local $x (i32.const 1))
          (br_if $loop2 (i32.const 3)) ;; add fallthrough
        )
        (set_local $x (i32.const 2))
        (br $loop1)
      )
    )
    (drop (get_local $x)) ;; can receive from either set, or input param
  )
  (func $func_6 (result i32)
   (local $result i32)
   (local $zero i32)
   (loop $label$1
    (if
     (i32.eqz
      (get_global $global$0)
     )
     (return
      (get_local $result) ;; we eventually reach here
     )
    )
    (set_global $global$0
     (i32.const 0) ;; tell next iteration to return
    )
    (set_local $result
     (i32.const 1) ;; set the return value to 1, temporarily
    )
    (br_if $label$1
     (i32.const 0) ;; don't do anything here
    )
    (set_local $result
     (get_local $zero) ;; set it to zero instead
    )
    (br $label$1) ;; back to the top, where we will return the zero
   )
  )
  (func $ssa-merge-tricky (result i32)
   (local $var$0 i32)
   (local $var$1 i32)
   (set_local $var$1
    (tee_local $var$0
     (i32.const 0) ;; both vars start out identical
    )
   )
   (loop $label$1
    (if
     (i32.eqz
      (get_global $global$0)
     )
     (return
      (i32.const 12345)
     )
    )
    (set_global $global$0
     (i32.const 0)
    )
    (if
     (i32.eqz
      (get_local $var$0) ;; check $0 here. this will get a phi var
     )
     (br_if $label$1
      (i32.eqz
       (tee_local $var$0 ;; set $0 to 1. here the two diverge. for the phi, we'll get a set here and above
        (i32.const 1)
       )
      )
     )
    )
    (br_if $label$1
     (i32.eqz ;; indeed equal, enter loop again, and then hang prevention kicks in
      (tee_local $var$1 ;; set them all to 0
       (tee_local $var$0
        (get_local $var$1) ;; this must get $1, not the phis, as even though the sets appear in both sources, we only execute 1.
       )
      )
     )
    )
   )
   (i32.const -54)
  )
)

