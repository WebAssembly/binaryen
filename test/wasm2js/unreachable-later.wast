(module
 (type $0 (func (param i32) (result i32)))
 (global $global$0 (mut i32) (i32.const 10))
 (export "func_50" (func $0))
 (func $0 (; 0 ;) (type $0) (param $0 i32) (result i32)
  (if
   (global.get $global$0)
   (then
    (return
     (local.get $0)
    )
   )
  )
  (if
   (global.get $global$0)
   (then
    (return
     (local.get $0)
    )
   )
  )
  (global.set $global$0
   (i32.const 0)
  )
  (if
   (i32.eqz
    (if (result i32)
     (i32.eqz
      (loop $label$3 (result i32)
       (br_if $label$3
        (i32.eqz
         (if (result i32)
          (block $label$4 (result i32)
           (if
            (global.get $global$0)
            (then
             (return
              (local.get $0)
             )
            )
           )
           (drop
            (if (result f32)
             (block $label$6 (result i32)
              (if
               (global.get $global$0)
               (then
                (return
                 (local.get $0)
                )
               )
              )
              (i32.const 65445)
             )
             (then
              (block (result f32)
               (if
                (global.get $global$0)
                (then
                 (return
                  (local.get $0)
                 )
                )
               )
               (f32.const 0)
              )
             )
             (else
              (f32.const 1)
             )
            )
           )
           (if
            (global.get $global$0)
            (then
             (return
              (local.get $0)
             )
            )
           )
           (i32.const 1)
          )
          (then
           (i32.const 32)
          )
          (else
           (i32.const 0)
          )
         )
        )
       )
       (i32.const 1)
      )
     )
     (then
      (i32.const 0)
     )
     (else
      (i32.const 1)
     )
    )
   )
   (then
    (return
     (i32.const -255)
    )
   )
   (else
    (unreachable)
   )
  )
 )
)

