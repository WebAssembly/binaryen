(module
 (type $0 (func (param i64) (result i64)))
 (export "fac-expr" (func $0))
 (export "fac-stack" (func $1))
 (export "fac-stack-raw" (func $2))
 (export "fac-mixed" (func $3))
 (export "fac-mixed-raw" (func $4))
 (func $0 (; 0 ;) (type $0) (param $var$0 i64) (result i64)
  (local $var$1 i64)
  (local $var$2 i64)
  (set_local $var$1
   (get_local $var$0)
  )
  (set_local $var$2
   (i64.const 1)
  )
  (block $label$1
   (loop $label$2
    (if
     (i64.eq
      (get_local $var$1)
      (i64.const 0)
     )
     (br $label$1)
     (block $label$5
      (set_local $var$2
       (i64.mul
        (get_local $var$1)
        (get_local $var$2)
       )
      )
      (set_local $var$1
       (i64.sub
        (get_local $var$1)
        (i64.const 1)
       )
      )
     )
    )
    (br $label$2)
   )
  )
  (get_local $var$2)
 )
 (func $1 (; 1 ;) (type $0) (param $var$0 i64) (result i64)
  (local $var$1 i64)
  (local $var$2 i64)
  (set_local $var$1
   (get_local $var$0)
  )
  (set_local $var$2
   (i64.const 1)
  )
  (block $label$1
   (loop $label$2
    (if
     (i64.eq
      (get_local $var$1)
      (i64.const 0)
     )
     (br $label$1)
     (block
      (set_local $var$2
       (i64.mul
        (get_local $var$1)
        (get_local $var$2)
       )
      )
      (set_local $var$1
       (i64.sub
        (get_local $var$1)
        (i64.const 1)
       )
      )
     )
    )
    (br $label$2)
   )
  )
  (get_local $var$2)
 )
 (func $2 (; 2 ;) (type $0) (param $var$0 i64) (result i64)
  (local $var$1 i64)
  (local $var$2 i64)
  (set_local $var$1
   (get_local $var$0)
  )
  (set_local $var$2
   (i64.const 1)
  )
  (block $label$1
   (loop $label$2
    (if
     (i64.eq
      (get_local $var$1)
      (i64.const 0)
     )
     (br $label$1)
     (block
      (set_local $var$2
       (i64.mul
        (get_local $var$1)
        (get_local $var$2)
       )
      )
      (set_local $var$1
       (i64.sub
        (get_local $var$1)
        (i64.const 1)
       )
      )
     )
    )
    (br $label$2)
   )
  )
  (get_local $var$2)
 )
 (func $3 (; 3 ;) (type $0) (param $var$0 i64) (result i64)
  (local $var$1 i64)
  (local $var$2 i64)
  (set_local $var$1
   (get_local $var$0)
  )
  (set_local $var$2
   (i64.const 1)
  )
  (block $label$1
   (loop $label$2
    (if
     (i64.eq
      (get_local $var$1)
      (i64.const 0)
     )
     (br $label$1)
     (block
      (set_local $var$2
       (i64.mul
        (get_local $var$1)
        (get_local $var$2)
       )
      )
      (set_local $var$1
       (i64.sub
        (get_local $var$1)
        (i64.const 1)
       )
      )
     )
    )
    (br $label$2)
   )
  )
  (get_local $var$2)
 )
 (func $4 (; 4 ;) (type $0) (param $var$0 i64) (result i64)
  (local $var$1 i64)
  (local $var$2 i64)
  (set_local $var$1
   (get_local $var$0)
  )
  (set_local $var$2
   (i64.const 1)
  )
  (block $label$1
   (loop $label$2
    (if
     (i64.eq
      (get_local $var$1)
      (i64.const 0)
     )
     (br $label$1)
     (block
      (set_local $var$2
       (i64.mul
        (get_local $var$1)
        (get_local $var$2)
       )
      )
      (set_local $var$1
       (i64.sub
        (get_local $var$1)
        (i64.const 1)
       )
      )
     )
    )
    (br $label$2)
   )
  )
  (get_local $var$2)
 )
)


(assert_return (invoke "fac-expr" (i64.const 25)) (i64.const 7034535277573963776))
(assert_return (invoke "fac-stack" (i64.const 25)) (i64.const 7034535277573963776))
(assert_return (invoke "fac-mixed" (i64.const 25)) (i64.const 7034535277573963776))
