(module
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
)
(module
 (type $0 (func (param i32)))
 (type $1 (func (param i32 i32 i32) (result i32)))
 (type $2 (func (param i32 i32) (result i32)))
 (table 89 89 anyfunc)
 (memory $0 17)
 (func $0 (; 0 ;) (type $2) (param $var$0 i32) (param $var$1 i32) (result i32)
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
)

