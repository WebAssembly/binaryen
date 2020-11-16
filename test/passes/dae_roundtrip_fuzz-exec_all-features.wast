(module
 (export "func_47" (func $1))
 (func $0 (param $0 funcref) (param $1 i32) (param $2 f64) (result i64)
  (nop)
  (unreachable)
 )
 (func $1 (param $0 f32) (result funcref)
  ;; This function reference has the type of the signature of $0. Note that that
  ;; is also the signature of $2. DAE will change the signature of the former,
  ;; and we should update properly, even through a round trip, to have the
  ;; correct type - if we do not have the correct type, then fuzz-exec will see
  ;; differently-typed values, and error
  (ref.func $0)
 )
 (func $2 (param $0 funcref) (param $1 i32) (param $2 f64) (result i32)
  (drop
   (i32.wrap_i64
    (call $0
     (ref.null func)
     (i32.const 0)
     (f64.const 0)
    )
   )
  )
  (i32.const 0)
 )
)

