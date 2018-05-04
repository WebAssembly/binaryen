(module
 (func "if-select"
  (local $var$0 i32)
  (nop)
  (drop
   (if (result i32)
    (select
     (i32.const 65473)
     (i32.const 1)
     (get_local $var$0)
    )
    (i32.const -2405046)
    (i32.const 1)
   )
  )
 )
 (func "unreachable-body-update-zext" (result f64)
  (if
   (i32.eqz
    (i32.const 0)
   )
   (unreachable)
  )
  (f64.const -9223372036854775808)
 )
 (func "ssa-const" (param $var$0 i32) (param $var$1 f64) (param $var$2 f64) (result i32)
  (block $label$1 (result i32)
   (block $label$2
    (if
     (i32.const 1)
     (block
      (drop
       (loop $label$5 (result i64)
        (if (result i64)
         (i32.const 0)
         (i64.load offset=22
          (i32.and
           (br_if $label$1
            (i32.const 0)
            (i32.const 0)
           )
           (i32.const 15)
          )
          (i64.const 1)
         )
         (i64.const 1)
        )
       )
      )
     )
    )
    (unreachable)
   )
  )
 )
 (func "if-nothing" (param $var$0 i64)
  (local $var$1 i32)
  (local $var$2 i32)
  (block $label$1
   (loop $label$2
    (block $label$3
     (block $label$4
      (br_if $label$3
       (i32.eqz
        (if (result i32)
         (i32.const 0)
         (i32.const 0)
         (get_local $var$2)
        )
       )
      )
      (unreachable)
     )
     (unreachable)
    )
   )
   (unreachable)
  )
 )
 (func "only-dfo" (param $var$0 f64) (result i32)
  (local $var$1 i32)
  (local $var$2 i32)
  (local $var$3 i32)
  (local $var$4 i32)
  (loop $label$1
   (set_local $var$3
    (tee_local $var$1
     (tee_local $var$2
      (get_local $var$1)
     )
    )
   )
   (if
    (i32.eqz
     (get_local $var$4)
    )
    (block
     (set_local $var$4
      (select
       (get_local $var$3)
       (i32.const -2147483648)
       (get_local $var$2)
      )
     )
     (br $label$1)
    )
   )
  )
  (i32.const -2766)
 )
)

