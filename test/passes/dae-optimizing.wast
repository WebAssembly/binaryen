(module
 (type $0 (func (param f32) (result f32)))
 (type $1 (func (param f64 f32 f32 f64 f32 i64 f64) (result i32)))
 (type $2 (func (param f64 f32 f32 f64 f32 i32 i32 f64) (result i32)))
 (global $global$0 (mut i32) (i32.const 10))
 (func $0 (; 0 ;) (type $1) (param $0 f64) (param $1 f32) (param $2 f32) (param $3 f64) (param $4 f32) (param $5 i64) (param $6 f64) (result i32)
  (local $7 i32)
  (local $8 i32)
  (if
   (local.tee $7
    (i32.const 33554432)
   )
   (drop
    (loop $label$2 (result f32)
     (if
      (global.get $global$0)
      (return
       (local.get $7)
      )
     )
     (local.set $8
      (block $label$4 (result i32)
       (drop
        (local.tee $7
         (local.get $8)
        )
       )
       (i32.const 0)
      )
     )
     (br_if $label$2
      (local.get $7)
     )
     (f32.const 1)
    )
   )
   (drop
    (call $1
     (f32.const 1)
    )
   )
  )
  (i32.const -11)
 )
 (func $1 (; 1 ;) (type $0) (param $0 f32) (result f32)
  (f32.const 0)
 )
 (func $2 (; 2 ;) (type $2) (param $0 f64) (param $1 f32) (param $2 f32) (param $3 f64) (param $4 f32) (param $5 i32) (param $6 i32) (param $7 f64) (result i32)
  (call $0
   (f64.const 1)
   (f32.const 1)
   (f32.const 1)
   (f64.const 1)
   (f32.const 1)
   (i64.const 1)
   (f64.const 1)
  )
 )
)

