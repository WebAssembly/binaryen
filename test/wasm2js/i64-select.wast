;; Testing i64 select

(module
 (func $p (param $i i32) (result i32) (local.get $i))
 (func (param i32) (result i32)
  (return
   (select
    (call $p (i32.const -1))
    (call $p (i32.const 0))
    (i32.const 1)
   )
  )
 )
 (func (result i64)
  (return
   (select
    (i64.const -1)
    (i64.const 0)
    (i32.const 1)
   )   
  )    
 )
)
