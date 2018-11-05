(module
 (memory $0 (shared 1 1))
 (func "one"
  (loop $label$2
   (br_if $label$2
    (block $label$3 (result i32)
     (drop
      (br_if $label$3
       (i32.const 0)
       (i32.load
        (i32.const 3060)
       )
      )
     )
     (i32.const 0)
    )
   )
  )
  (unreachable)
 )
 (func "two" (param $var$0 i32) (param $var$1 i32) (result i32)
  (nop)
  (nop)
  (nop)
  (nop)
  (nop)
  (if
   (i32.const 0)
   (i32.store8
    (i32.const 8)
    (block $label$2 (result i32)
     (drop
      (br_if $label$2
       (i32.const 1)
       (i32.const 0)
      )
     )
     (if
      (i32.const 0)
      (drop
       (br_if $label$2
        (i32.const 1)
        (i32.const 1)
       )
      )
     )
     (block $label$4
      (br_if $label$4
       (i32.const 0)
      )
      (br_if $label$4
       (i32.const 0)
      )
      (drop
       (br_if $label$2
        (i32.const 1)
        (i32.const 0)
       )
      )
     )
     (i32.const 6704)
    )
   )
  )
  (nop)
  (i32.const 0)
 )
 (func "use-var" (param $var$0 i64) (param $var$1 i32) (result f64)
  (local $var$2 i32)
  (block $label$1
   (br_table $label$1 $label$1 $label$1 $label$1 $label$1 $label$1 $label$1 $label$1 $label$1 $label$1
    (i32.wrap/i64
     (if (result i64)
      (i32.const 0)
      (i64.const 1)
      (if (result i64)
       (if (result i32)
        (i32.const 0)
        (unreachable)
        (block $label$6 (result i32)
         (block $label$7
          (loop $label$8
           (br_if $label$8
            (br_if $label$6
             (tee_local $var$2
              (block $label$9 (result i32)
               (get_local $var$1)
              )
             )
             (i32.const 0)
            )
           )
           (loop $label$10
            (if
             (i32.const 0)
             (set_local $var$2
              (get_local $var$1)
             )
            )
           )
           (drop
            (i32.eqz
             (get_local $var$2)
            )
           )
          )
         )
         (unreachable)
        )
       )
       (unreachable)
       (i64.const 1)
      )
     )
    )
   )
  )
  (unreachable)
 )
 (func "bad1"
  (local $var$2 i32)
  (local $var$4 i32)
  (block $label$1
   (loop $label$2
    (set_local $var$4
     (if (result i32)
      (i32.const 0)
      (block (result i32)
       (set_local $var$4
        (tee_local $var$2
         (i32.xor
          (i32.const 0)
          (i32.const -1)
         )
        )
       )
       (i32.const 0)
      )
      (block (result i32)
       (set_local $var$4
        (tee_local $var$2
         (i32.xor
          (i32.const 0)
          (i32.const -1)
         )
        )
       )
       (i32.const 0)
      )
     )
    )
    (i32.store
     (i32.const 1)
     (i32.shl
      (get_local $var$2)
      (i32.const 14)
     )
    )
   )
  )
 )
 (func "only-dfo" (param $var$0 f64) (result f64)
  (local $var$1 i32)
  (local $var$2 i32)
  (loop $label$1
   (if
    (tee_local $var$1
     (tee_local $var$2
      (get_local $var$1)
     )
    )
    (if
     (get_local $var$2)
     (i64.atomic.store32 offset=3
      (i32.and
       (get_local $var$1) ;; only dfo can figure out that this is 0
       (i32.const 15)
      )
      (i64.const -32768)
     )
    )
   )
   (br $label$1)
  )
 )
 (func "dfo-tee-get" (result i32)
  (local $0 i32)
  (if (result i32)
   (tee_local $0
    (i32.const 1)
   )
   (loop $label$2 (result i32)
    (select
     (i32.const 1)
     (i32.const -1709605511)
     (get_local $0)
    )
   )
   (unreachable)
  )
 )
)

