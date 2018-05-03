(module
 (func $if-select
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
 (func $unreachable-body-update-zext (result f64)
  (if
   (i32.eqz
    (i32.const 0)
   )
   (unreachable)
  )
  (f64.const -9223372036854775808)
 )
 (func $ssa-const (param $var$0 i32) (param $var$1 f64) (param $var$2 f64) (result i32)
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
)

