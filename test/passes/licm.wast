(module
  (func $loop1
    (loop $loop
      (drop (i32.const 10))
      (br_if $loop (i32.const 1))
    )
  )
  (func $loop2
    (loop $loop
      (drop (i32.const 10))
      (drop (i32.const 20))
      (br_if $loop (i32.const 1))
    )
  )
  (func $loop3
    (loop $loop
      (drop (i32.const 10))
      (call $loop2)
      (drop (i32.const 20))
      (br_if $loop (i32.const 1))
    )
  )
  (func $loop4
    (loop $loop
      (drop (i32.load (i32.const 1)))
      (br_if $loop (i32.const 1))
    )
  )
  (func $loop3-4
    (loop $loop
      (drop (i32.load (i32.const 10)))
      (call $loop2) ;; may have global side effects which alter a load!
      (drop (i32.load (i32.const 20))) ;; this load must stay put
      (br_if $loop (i32.const 1))
    )
  )
 (func $loop3-4-b (; 4 ;) (type $0)
  (loop $loop
   (drop
    (i32.load
     (i32.const 10)
    )
   )
   (drop
    (i32.load
     (i32.const 20)
    )
   )
   (br_if $loop
    (i32.const 1)
   )
  )
 )
  (func $loop5
    (loop $loop
      (i32.store (i32.const 1) (i32.const 2))
      (br_if $loop (i32.const 1))
    )
  )
  (func $loop6
    (loop $loop
      (i32.store (i32.const 1) (i32.const 2))
      (i32.store (i32.const 2) (i32.const 3))
    )
  )
  (func $loop7
    (loop $loop
      (i32.store (i32.const 1) (i32.const 2))
      (i32.store (i32.const 2) (i32.const 3))
      (br_if $loop (i32.const 1))
    )
  )
  (func $loop8
    (loop $loop
      (i32.store (i32.const 1) (i32.const 2))
      (br_if $loop (i32.const 1))
    )
  )
  (func $loop9
    (loop $loop
      (drop (i32.load (i32.const 1)))
      (i32.store (i32.const 1) (i32.const 2))
      (br_if $loop (i32.const 1))
    )
  )
  (func $loop10
    (loop $loop
      (drop (i32.load (i32.const 1)))
      (drop (i32.load (i32.const 2)))
      (br_if $loop (i32.const 1))
    )
  )
  (func $loop11
    (local $x i32)
    (local $y i32)
    (loop $loop
      (drop (get_local $x))
      (br_if $loop (tee_local $x (i32.const 2)))
    )
  )
  (func $loop12
    (local $x i32)
    (local $y i32)
    (loop $loop
      (drop (get_local $x))
      (br_if $loop (tee_local $y (i32.const 2)))
    )
  )
  (func $loop13
    (local $x i32)
    (local $y i32)
    (loop $loop
      (set_local $x (i32.eqz (get_local $y)))
      (call $loop12)
      (br_if $loop (i32.const 1))
    )
  )
  (func $loop14
    (local $x i32)
    (local $y i32)
    (loop $loop
      (set_local $x (i32.eqz (get_local $y)))
      (call $loop12)
      (br_if $loop (i32.const 1))
      (set_local $y (get_local $x)) ;; not actually in the loop!
    )
  )
  (func $loop14-1
    (local $x i32)
    (local $y i32)
    (loop $loop
      (set_local $x (i32.eqz (get_local $y)))
      (call $loop12)
      (set_local $y (get_local $x)) ;; in the loop
      (br_if $loop (i32.const 1))
    )
  )
  (func $loop15
    (local $x i32)
    (local $y i32)
    (loop $loop
      (set_local $x (i32.eqz (get_local $y)))
      (call $loop12)
      (br_if $loop (i32.const 1))
      (drop (get_local $y))
    )
  )
  (func $loop15-1
    (local $x i32)
    (local $y i32)
    (loop $loop
      (set_local $x (i32.eqz (get_local $y)))
      (call $loop12)
      (drop (get_local $y))
      (br_if $loop (i32.const 1))
    )
  )
  (func $loop16
    (local $x i32)
    (local $y i32)
    (loop $loop
      (set_local $x (i32.eqz (get_local $y)))
      (call $loop12)
      (br_if $loop (i32.const 1))
      (drop (get_local $x))
    )
  )
  (func $loop16-1
    (local $x i32)
    (local $y i32)
    (loop $loop
      (set_local $x (i32.eqz (get_local $y)))
      (call $loop12)
      (drop (get_local $x))
      (br_if $loop (i32.const 1))
    )
  )
  (func $loop16-2
    (local $x i32)
    (local $y i32)
    (set_local $x (i32.const 2))
    (loop $loop
      (set_local $x (i32.eqz (get_local $y)))
      (call $loop12)
      (drop (get_local $x))
      (br_if $loop (i32.const 1))
    )
  )
  (func $loop16-3
    (local $x i32)
    (local $y i32)
    (set_local $y (i32.const 2))
    (loop $loop
      (set_local $x (i32.eqz (get_local $y)))
      (call $loop12)
      (drop (get_local $x))
      (br_if $loop (i32.const 1))
    )
  )
  (func $nop
    (loop $loop
      (nop)
      (br_if $loop (i32.const 1))
    )
  )
  (func $nested-blocks
    (loop $loop
      (block
        (nop)
      )
      (block $x
        (nop)
      )
      (block $a
        (block $b
          (block $c
            (nop)
          )
        )
      )
      (br_if $loop (i32.const 1))
    )
  )
  (func $nested-unhoistable-blocks
    (loop $loop
      (block
        (call $nested-unhoistable-blocks)
      )
      (block $x
        (call $nested-unhoistable-blocks)
      )
      (block $a
        (block $b
          (block $c
            (call $nested-unhoistable-blocks)
          )
        )
      )
      (br_if $loop (i32.const 1))
    )
  )
  (func $conditional
    (loop $loop
      (if (i32.const 0)
        (drop (i32.const 10)) ;; cannot be hoisted - might never be reached
      )
      (br_if $loop (i32.const 1))
    )
  )
  (func $conditional1 (result i32)
    (loop $loop
      (if (call $conditional1)
        (drop (i32.const 10)) ;; cannot be hoisted - might never be reached
                              ;; also anyhow the whole if also cannot, due to the call
      )
      (br_if $loop (i32.const 1))
    )
    (unreachable)
  )
  (func $conditional2
    (block $out
      (loop $loop
        (br_if $out (i32.const 1))
        (drop (i32.const 10)) ;; cannot be hoisted - might never be reached
        (br_if $loop (i32.const 1))
      )
    )
  )
  (func $conditional3
    (block $out
      (loop $loop
        (drop (i32.const 10)) ;; *CAN* be hoisted - will definitely be reached
        (br_if $out (i32.const 1))
        (br_if $loop (i32.const 1))
      )
    )
  )
  (func $after
    (loop $loop)
    (drop (i32.const 10)) ;; may be part of the loop's basic block, logically, but is not nested in it
  )
  (func $loops
    (loop $loop2
      (loop $loop1
        (drop (i32.const 10))
        (br_if $loop1 (i32.const 1))
      )
    )
  )
  (func $loops2
    (loop $loop2
      (loop $loop1
        (drop (i32.const 10))
        (br_if $loop2 (i32.const 1))
      )
    )
  )
  (func $fuzz1 (result i64)
   (local $var$1 i64)
   (loop $label$1 (result i64) ;; multiple loops here require us to be careful not to Nop out stuff before we finalize things
    (block $label$2
     (block $label$3
      (drop
       (loop $label$4 (result i32)
        (set_local $var$1
         (block $label$5 (result i64)
          (set_local $var$1
           (i64.const -29585)
          )
          (i64.const -70)
         )
        )
        (i32.const 1)
       )
      )
      (br $label$2)
     )
     (unreachable)
    )
    (get_local $var$1)
   )
  )
  (func $self (result i32)
    (local $x i32)
    (loop $loop
      (set_local $x (i32.add (get_local $x) (i32.const 1)))
      (br_if $loop (i32.const 1))
    )
    (get_local $x)
  )
  (func $nested-set
   (local $var$0 i32)
   (local $var$1 i64)
   (loop $label$1
    (set_local $var$0
     (block $label$3 (result i32)
      (set_local $var$1 ;; cannot be moved out (in current position - other opts would help), and invalidates moving out the set below
       (i64.const 0)
      )
      (get_local $var$0)
     )
    )
    (set_local $var$1
     (i64.const 1)
    )
    (br_if $label$1
     (i32.const 0)
    )
   )
  )
  (func $load-store (param $x i32)
    (loop $loop
      (drop (i32.load (i32.const 0))) ;; can't move this out, the store might affect it for later iterations
      (i32.store (get_local $x) (get_local $x))
      (br_if $loop (i32.const 1))
    )
  )
  (func $set-set (param $x i32) (result i32)
    (loop $loop
      (set_local $x (i32.const 1))
      (br_if $loop (i32.const 2))
      (set_local $x (i32.const 3))
      (br_if $loop (i32.const 4))
    )
    (get_local $x)
  )
  (func $copies-no
    (local $x i32)
    (local $y i32)
    (local $z i32)
    (local $a i32)
    (local $b i32)
    (local $c i32)
    (loop $loop
      (set_local $x (get_local $x))
      (set_local $y (get_local $z))
      (set_local $a (tee_local $b (get_local $c)))
      (br_if $loop (i32.const 1))
    )
  )
  (func $consts-no
    (local $x i32)
    (local $a i32)
    (local $b i32)
    (loop $loop
      (set_local $x (i32.const 0))
      (set_local $a (tee_local $b (i32.const 1)))
      (br_if $loop (i32.const 1))
    )
  )
)

