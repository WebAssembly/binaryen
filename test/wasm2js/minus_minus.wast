(module
 (type $0 (func (result i32)))
 (type $1 (func))
 (export "func_44_invoker" (func $1))
 (func $0 (; 0 ;) (type $0) (result i32)
  (i32.trunc_f64_s
   (f64.neg
    (f64.const -7094) ;; negation of a negative must not be emitted as "--" in js, that will not parse
   )
  )
 )
 (func $1 (; 1 ;) (type $1)
  (drop
   (call $0)
  )
 )
)

