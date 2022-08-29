(module
 (type $0 (func (result i32)))
 (type $1 (func))
 (table 0 0 funcref)
 (memory $0 (shared 1 1))
 (export "func_0" (func $0))
 (func $0 (; 0 ;) (type $0) (result i32)
  (local $var$0 i32)
  (local $var$1 i32)
  (local $var$2 i32)
  (local $var$3 f64)
  (block $label$1 (result i32)
   (if (result i32)
    (i32.const 0)
    (unreachable)
    (block $label$4 (result i32)
     (loop $label$5
      (block $label$6
       (block $label$7
        (local.set $var$0
         (if (result i32)
          (local.get $var$2)
          (select
           (loop $label$9 (result i32)
            (if (result i32)
             (local.tee $var$2
              (i32.const 16384)
             )
             (i32.const 1)
             (i32.const 0)
            )
           )
           (br_if $label$4
            (i32.const 0)
            (local.tee $var$1
             (local.tee $var$2
              (block $label$12 (result i32)
               (br_if $label$5
                (br $label$6)
               )
               (unreachable)
              )
             )
            )
           )
           (i32.const 1)
          )
          (block (result i32)
           (loop $label$15
            (if
             (i32.const 0)
             (return
              (local.get $var$2)
             )
            )
            (if
             (local.tee $var$1
              (local.tee $var$2
               (i32.const 0)
              )
             )
             (block
              (br_if $label$15
               (i32.const 0)
              )
             )
            )
            (br_if $label$15
             (i32.eqz
              (local.tee $var$2
               (i32.const 129)
              )
             )
            )
           )
           (i32.const -5742806)
          )
         )
        )
       )
       (br_if $label$6
        (if (result i32)
         (local.get $var$1)
         (unreachable)
         (block $label$25 (result i32)
          (local.set $var$3
           (block $label$26 (result f64)
            (drop
             (br_if $label$4
              (br_if $label$25
               (br $label$5)
               (i32.const 0)
              )
              (i32.const 0)
             )
            )
            (f64.const 1)
           )
          )
          (i32.const 0)
         )
        )
       )
      )
     )
     (local.get $var$2)
    )
   )
  )
 )
)

