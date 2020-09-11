(module
 (global $global$0 (mut i32) (i32.const 10))
 (func $test (param $x $i32) (param $y i32) (result i32)
  (drop
   (if (result i32)
    (local.tee $x
     (local.get $y)
    )
    (i32.const 100)
    (local.get $x)
   )
  )
  (local.get $y) ;; turn this into $x
 )
 (func $test2 (param $x $i32) (param $y i32) (result i32)
  (drop
   (if (result i32)
    (local.tee $x
     (local.get $y)
    )
    (i32.const 100)
    (local.get $x)
   )
  )
  (local.get $x)
 )
 (func $test-multiple (param $x $i32) (param $y i32) (result i32)
  (drop
   (if (result i32)
    (local.tee $x
     (local.get $y)
    )
    (i32.const 100)
    (local.get $x)
   )
  )
  (drop (local.get $y)) ;; turn this into $x
  (local.get $y) ;; turn this into $x
 )
 (func $test-just-some (param $x $i32) (param $y i32) (result i32)
  (drop
   (if (result i32)
    (local.tee $x
     (local.get $y)
    )
    (i32.const 100)
    (local.get $x)
   )
  )
  (drop (local.get $y)) ;; turn this into $x
  (local.set $y (i32.const 200))
  (local.get $y) ;; but not this one!
 )
 (func $test-just-some2 (param $x $i32) (param $y i32) (result i32)
  (drop
   (if (result i32)
    (local.tee $x
     (local.get $y)
    )
    (i32.const 100)
    (local.get $x)
   )
  )
  (if
   (i32.const 300)
   (local.set $y (i32.const 400))
   (drop (local.get $y)) ;; turn this into $x
  )
  (i32.const 500)
 )
 (func $test-just-some3 (param $x $i32) (param $y i32) (result i32)
  (drop
   (if (result i32)
    (local.tee $x
     (local.get $y)
    )
    (i32.const 100)
    (i32.const 200)
   )
  )
  (if
   (i32.const 300)
   (local.set $y (i32.const 400))
   (drop (local.get $y)) ;; can turn this into $x, but another exists we can't, so do nothing
  )
  (local.get $y) ;; but not this one!
 )
 (func $silly-self (param $x $i32) (param $y i32) (result i32)
  (drop
   (if (result i32)
    (local.tee $x
     (local.get $x)
    )
    (i32.const 100)
    (local.get $x)
   )
  )
  (local.get $y) ;; turn this into $x
 )
 (func $silly-multi (param $x $i32) (param $y i32) (result i32)
  (drop
   (if (result i32)
    (local.tee $x
     (local.tee $y
      (local.get $x)
     )
    )
    (i32.const 100)
    (local.get $x)
   )
  )
  (local.get $y) ;; turn this into $x
 )
 (func $undo-1 (param $var$1 i32) (param $var$2 i32)
  (local $var$5 i32)
  (local.set $var$2 ;; copy 1 to 2
   (local.get $var$1)
  )
  (local.set $var$2 ;; overwrite 2
   (i32.const 1)
  )
  (drop
   (local.get $var$1) ;; can't be changed to $var$2, as it changes
  )
 )
 (func $undo-2 (param $var$1 i32) (param $var$2 i32)
  (local $var$5 i32)
  (local.set $var$2 ;; copy 1 to 2
   (local.get $var$1)
  )
  (if (local.get $var$1)
   (local.set $var$2 ;; conditional overwrite 2
    (i32.const 1)
   )
  )
  (drop
   (local.get $var$1) ;; can't be changed to $var$2, as it changes
  )
 )
 (func $reverse (param $x $i32) (param $y i32)
  (drop
   (if (result i32)
    (local.tee $x
     (local.get $y)
    )
    (i32.const 100)
    (local.get $x)
   )
  )
  (drop (local.get $x)) ;; (read lower down first) but the reverse can work!
  (if (i32.const 1)
   (local.set $y (i32.const 200))
  )
  (drop (local.get $y)) ;; cannot this into $x, since this $y has multiple sources
 )
 (func $reverse-end (param $x $i32) (param $y i32)
  (drop
   (if (result i32)
    (local.tee $x
     (local.get $y)
    )
    (i32.const 100)
    (local.get $x) ;; don't change to $y, as its lifetime ended. leave it ended
   )
  )
 )
 (func $reverse-lone-end-2 (param $x $i32) (param $y i32)
  (drop
   (if (result i32)
    (local.tee $x
     (local.get $y)
    )
    (i32.const 100)
    (local.get $x) ;; don't change to $y, as its lifetime ended. leave it ended
   )
  )
  (local.set $y (i32.const 200))
  (drop (local.get $y)) ;; cannot this into $x, since this $y has multiple sources
 )
 (func $reverse-undo (param $x $i32) (param $y i32)
  (drop
   (if (result i32)
    (local.tee $x
     (local.get $y)
    )
    (i32.const 100)
    (local.get $x) ;; can optimize this ($y lives on)
   )
  )
  (local.set $x (i32.const 300)) ;; force an undo
  (drop (local.get $x)) ;; (read lower down first) but the reverse can almost work
  (if (i32.const 1)
   (local.set $y (i32.const 200))
  )
  (drop (local.get $y)) ;; cannot this into $x, since this $y has multiple sources
 )
 (func $reverse-undo2 (param $x $i32) (param $y i32)
  (drop
   (if (result i32)
    (local.tee $x
     (local.get $y)
    )
    (i32.const 100)
    (i32.const 150)
   )
  )
  (local.set $x (i32.const 300)) ;; force an undo
  (drop (local.get $x)) ;; (read lower down first) but the reverse can almost work
  (if (i32.const 1)
   (local.set $y (i32.const 200))
  )
  (drop (local.get $y)) ;; cannot this into $x, since this $y has multiple sources
 )
 (func $reverse-undo3-conditional (param $x $i32) (param $y i32)
  (drop
   (if (result i32)
    (local.tee $x
     (local.get $y)
    )
    (i32.const 100)
    (i32.const 150)
   )
  )
  (if (i32.const 1)
   (local.set $x (i32.const 300)) ;; force an undo
  )
  (drop (local.get $x)) ;; (read lower down first) but the reverse can almost work
  (if (i32.const 1)
   (local.set $y (i32.const 200))
  )
  (drop (local.get $y)) ;; cannot this into $x, since this $y has multiple sources
 )
 (func $reverse-undo3-conditional-b (param $x $i32) (param $y i32)
  (drop
   (if (result i32)
    (local.tee $x
     (local.get $y)
    )
    (i32.const 100)
    (local.get $x)
   )
  )
  (if (i32.const 1)
   (local.set $x (i32.const 300)) ;; force an undo
  )
  (drop (local.get $x)) ;; (read lower down first) but the reverse can almost work
  (if (i32.const 1)
   (local.set $y (i32.const 200))
  )
  (drop (local.get $y)) ;; cannot this into $x, since this $y has multiple sources
 )
 (func $reverse-undo3-conditional-c (param $x $i32) (param $y i32)
  (drop
   (if (result i32)
    (local.tee $x
     (local.get $y)
    )
    (i32.const 100)
    (i32.const 150)
   )
  )
  (if (i32.const 1)
   (drop (local.get $x))
   (block
    (if (i32.const 1)
     (local.set $x (i32.const 300)) ;; force an undo
    )
    (drop (local.get $x)) ;; (read lower down first) but the reverse can almost work
   )
  )
  (if (i32.const 1)
   (local.set $y (i32.const 200))
  )
  (drop (local.get $y)) ;; cannot this into $x, since this $y has multiple sources
 )
 (func $fuzz (param $var$0 i32) (param $var$1 f32) (param $var$2 f32) (result i64)
  (local $var$3 i32)
  (global.set $global$0
   (i32.sub
    (global.get $global$0)
    (i32.const 1)
   )
  )
  (loop $label$1 (result i64)
   (global.set $global$0
    (i32.sub
     (global.get $global$0)
     (i32.const 1)
    )
   )
   (br_if $label$1
    (block $label$2 (result i32)
     (drop
      (if (result i32)
       (block $label$3 (result i32)
        (global.set $global$0
         (i32.sub
          (global.get $global$0)
          (i32.const 3)
         )
        )
        (local.set $var$3
         (i32.const 1)
        )
        (local.tee $var$3
         (local.get $var$0)
        )
       )
       (i32.const 0)
       (block (result i32)
        (local.set $var$3
         (if (result i32)
          (i32.const 0)
          (block (result i32)
           (block $label$7
            (block $label$8
             (local.set $var$0
              (i32.const 34738786)
             )
            )
           )
           (local.get $var$3)
          )
          (block (result i32)
           (if
            (i32.eqz
             (global.get $global$0)
            )
            (return
             (i64.const 137438953472)
            )
           )
           (global.set $global$0
            (i32.sub
             (global.get $global$0)
             (i32.const 1)
            )
           )
           (br_if $label$1
            (i32.eqz
             (local.get $var$3)
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
     (local.get $result)
    )
   )
   (local.set $result ;; vanishes
    (local.get $param)
   )
   (br_if $label$1
    (local.tee $unused ;; unused, but forms part of a copy, with $result - the trivial tee we add here should not confuse us
     (local.get $result) ;; flips
    )
   )
  )
 )
 (func $subtype-test
  (local $0 anyref)
  (local $1 funcref)
  (local $2 funcref)
  (local.set $0
   (local.get $1)
  )
  (local.set $2
    ;; This should NOT become $0, because types of $0 and $1 are different
   (local.get $1)
  )
 )
)
