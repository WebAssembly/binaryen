(module
 (global $global$0 (mut i32) (i32.const 10))
 (func $test (param $x $i32) (param $y i32) (result i32)
  (drop
   (if (result i32)
    (tee_local $x
     (get_local $y)
    )
    (i32.const 100)
    (get_local $x)
   )
  )
  (get_local $y) ;; turn this into $x
 )
 (func $test2 (param $x $i32) (param $y i32) (result i32)
  (drop
   (if (result i32)
    (tee_local $x
     (get_local $y)
    )
    (i32.const 100)
    (get_local $x)
   )
  )
  (get_local $x)
 )
 (func $test-multiple (param $x $i32) (param $y i32) (result i32)
  (drop
   (if (result i32)
    (tee_local $x
     (get_local $y)
    )
    (i32.const 100)
    (get_local $x)
   )
  )
  (drop (get_local $y)) ;; turn this into $x
  (get_local $y) ;; turn this into $x
 )
 (func $test-just-some (param $x $i32) (param $y i32) (result i32)
  (drop
   (if (result i32)
    (tee_local $x
     (get_local $y)
    )
    (i32.const 100)
    (get_local $x)
   )
  )
  (drop (get_local $y)) ;; turn this into $x
  (set_local $y (i32.const 200))
  (get_local $y) ;; but not this one!
 )
 (func $test-just-some2 (param $x $i32) (param $y i32) (result i32)
  (drop
   (if (result i32)
    (tee_local $x
     (get_local $y)
    )
    (i32.const 100)
    (get_local $x)
   )
  )
  (if
   (i32.const 300)
   (set_local $y (i32.const 400))
   (drop (get_local $y)) ;; turn this into $x
  )
  (i32.const 500)
 )
 (func $test-just-some3 (param $x $i32) (param $y i32) (result i32)
  (drop
   (if (result i32)
    (tee_local $x
     (get_local $y)
    )
    (i32.const 100)
    (i32.const 200)
   )
  )
  (if
   (i32.const 300)
   (set_local $y (i32.const 400))
   (drop (get_local $y)) ;; can turn this into $x, but another exists we can't, so do nothing
  )
  (get_local $y) ;; but not this one!
 )
 (func $silly-self (param $x $i32) (param $y i32) (result i32)
  (drop
   (if (result i32)
    (tee_local $x
     (get_local $x)
    )
    (i32.const 100)
    (get_local $x)
   )
  )
  (get_local $y) ;; turn this into $x
 )
 (func $silly-multi (param $x $i32) (param $y i32) (result i32)
  (drop
   (if (result i32)
    (tee_local $x
     (tee_local $y
      (get_local $x)
     )
    )
    (i32.const 100)
    (get_local $x)
   )
  )
  (get_local $y) ;; turn this into $x
 )
 (func $undo-1 (param $var$1 i32) (param $var$2 i32)
  (local $var$5 i32)
  (set_local $var$2 ;; copy 1 to 2
   (get_local $var$1)
  )
  (set_local $var$2 ;; overwrite 2
   (i32.const 1)
  )
  (drop
   (get_local $var$1) ;; can't be changed to $var$2, as it changes
  )
 )
 (func $undo-2 (param $var$1 i32) (param $var$2 i32)
  (local $var$5 i32)
  (set_local $var$2 ;; copy 1 to 2
   (get_local $var$1)
  )
  (if (get_local $var$1)
   (set_local $var$2 ;; conditional overwrite 2
    (i32.const 1)
   )
  )
  (drop
   (get_local $var$1) ;; can't be changed to $var$2, as it changes
  )
 )
 (func $reverse (param $x $i32) (param $y i32)
  (drop
   (if (result i32)
    (tee_local $x
     (get_local $y)
    )
    (i32.const 100)
    (get_local $x)
   )
  )
  (drop (get_local $x)) ;; (read lower down first) but the reverse can work!
  (if (i32.const 1)
   (set_local $y (i32.const 200))
  )
  (drop (get_local $y)) ;; cannot this into $x, since this $y has multiple sources
 )
 (func $reverse-end (param $x $i32) (param $y i32)
  (drop
   (if (result i32)
    (tee_local $x
     (get_local $y)
    )
    (i32.const 100)
    (get_local $x) ;; don't change to $y, as its lifetime ended. leave it ended
   )
  )
 )
 (func $reverse-lone-end-2 (param $x $i32) (param $y i32)
  (drop
   (if (result i32)
    (tee_local $x
     (get_local $y)
    )
    (i32.const 100)
    (get_local $x) ;; don't change to $y, as its lifetime ended. leave it ended
   )
  )
  (set_local $y (i32.const 200))
  (drop (get_local $y)) ;; cannot this into $x, since this $y has multiple sources
 )
 (func $reverse-undo (param $x $i32) (param $y i32)
  (drop
   (if (result i32)
    (tee_local $x
     (get_local $y)
    )
    (i32.const 100)
    (get_local $x) ;; can optimize this ($y lives on)
   )
  )
  (set_local $x (i32.const 300)) ;; force an undo
  (drop (get_local $x)) ;; (read lower down first) but the reverse can almost work
  (if (i32.const 1)
   (set_local $y (i32.const 200))
  )
  (drop (get_local $y)) ;; cannot this into $x, since this $y has multiple sources
 )
 (func $reverse-undo2 (param $x $i32) (param $y i32)
  (drop
   (if (result i32)
    (tee_local $x
     (get_local $y)
    )
    (i32.const 100)
    (i32.const 150)
   )
  )
  (set_local $x (i32.const 300)) ;; force an undo
  (drop (get_local $x)) ;; (read lower down first) but the reverse can almost work
  (if (i32.const 1)
   (set_local $y (i32.const 200))
  )
  (drop (get_local $y)) ;; cannot this into $x, since this $y has multiple sources
 )
 (func $reverse-undo3-conditional (param $x $i32) (param $y i32)
  (drop
   (if (result i32)
    (tee_local $x
     (get_local $y)
    )
    (i32.const 100)
    (i32.const 150)
   )
  )
  (if (i32.const 1)
   (set_local $x (i32.const 300)) ;; force an undo
  )
  (drop (get_local $x)) ;; (read lower down first) but the reverse can almost work
  (if (i32.const 1)
   (set_local $y (i32.const 200))
  )
  (drop (get_local $y)) ;; cannot this into $x, since this $y has multiple sources
 )
 (func $reverse-undo3-conditional-b (param $x $i32) (param $y i32)
  (drop
   (if (result i32)
    (tee_local $x
     (get_local $y)
    )
    (i32.const 100)
    (get_local $x)
   )
  )
  (if (i32.const 1)
   (set_local $x (i32.const 300)) ;; force an undo
  )
  (drop (get_local $x)) ;; (read lower down first) but the reverse can almost work
  (if (i32.const 1)
   (set_local $y (i32.const 200))
  )
  (drop (get_local $y)) ;; cannot this into $x, since this $y has multiple sources
 )
 (func $reverse-undo3-conditional-c (param $x $i32) (param $y i32)
  (drop
   (if (result i32)
    (tee_local $x
     (get_local $y)
    )
    (i32.const 100)
    (i32.const 150)
   )
  )
  (if (i32.const 1)
   (drop (get_local $x))
   (block
    (if (i32.const 1)
     (set_local $x (i32.const 300)) ;; force an undo
    )
    (drop (get_local $x)) ;; (read lower down first) but the reverse can almost work
   )
  )
  (if (i32.const 1)
   (set_local $y (i32.const 200))
  )
  (drop (get_local $y)) ;; cannot this into $x, since this $y has multiple sources
 )
 (func $fuzz (param $var$0 i32) (param $var$1 f32) (param $var$2 f32) (result i64)
  (local $var$3 i32)
  (set_global $global$0
   (i32.sub
    (get_global $global$0)
    (i32.const 1)
   )
  )
  (loop $label$1 (result i64)
   (set_global $global$0
    (i32.sub
     (get_global $global$0)
     (i32.const 1)
    )
   )
   (br_if $label$1
    (block $label$2 (result i32)
     (drop
      (if (result i32)
       (block $label$3 (result i32)
        (set_global $global$0
         (i32.sub
          (get_global $global$0)
          (i32.const 3)
         )
        )
        (set_local $var$3
         (i32.const 1)
        )
        (tee_local $var$3
         (get_local $var$0)
        )
       )
       (i32.const 0)
       (block (result i32)
        (set_local $var$3
         (if (result i32)
          (i32.const 0)
          (block (result i32)
           (block $label$7
            (block $label$8
             (set_local $var$0
              (i32.const 34738786)
             )
            )
           )
           (get_local $var$3)
          )
          (block (result i32)
           (if
            (i32.eqz
             (get_global $global$0)
            )
            (return
             (i64.const 137438953472)
            )
           )
           (set_global $global$0
            (i32.sub
             (get_global $global$0)
             (i32.const 1)
            )
           )
           (br_if $label$1
            (i32.eqz
             (get_local $var$3)
            )
           )
           (return
            (i64.const 44125)
           )
          )
         )
        )
        (i32.const -129)
       )
      )
     )
     (i32.const 0)
    )
   )
   (i64.const -36028797018963968)
  )
 )
 (func $trivial-confusion (param $unused i32) (param $param i32) (param $result i32)
  (loop $label$1
   (if
    (i32.const 1)
    (drop
     (get_local $result)
    )
   )
   (set_local $result ;; vanishes
    (get_local $param)
   )
   (br_if $label$1
    (tee_local $unused ;; unused, but forms part of a copy, with $result - the trivial tee we add here should not confuse us
     (get_local $result) ;; flips
    )
   )
  )
 )
)

