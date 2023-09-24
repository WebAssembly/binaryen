(module
 (tag $t (param i32) (result i64))

 (func $f (result i64)
   (suspend $t (i32.const 123))
   ;;(i64.const 123)
 )
)
