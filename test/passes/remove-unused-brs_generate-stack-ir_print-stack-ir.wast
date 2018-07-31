(module
 (type $0 (func (param i64)))
 (func $0 (; 0 ;) (type $0) (param $var$0 i64)
  (block $label$1
   (br_if $label$1
    (block $label$2 (result i32)
     (loop $label$3
      (set_local $var$0
       (block $label$4 (result i64)
        (unreachable)
       )
      )
     )
     (unreachable)
    )
   )
   (nop)
  )
 )
)

