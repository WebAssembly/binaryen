(module
 (type $13 (func (param f32)))
 (table 282 282 anyfunc)
 (memory $0 1 1)
 (func $0
  (block $label$1
   (if
    (i32.const 1)
    (block $label$3
     (call_indirect $13
      (block $label$4 (result f32) ;; but this type may change dangerously
       (nop) ;; fold this
       (br $label$3)
      )
      (i32.const 105)
     )
     (nop) ;; with this
    )
   )
  )
 )
)

