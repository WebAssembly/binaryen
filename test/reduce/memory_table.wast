(module
 (type $i (func (result i32)))
 (memory $0 256 256)
 (table 481 481 anyfunc)
 (elem (i32.const 0) $f0 $f0 $f1 $f2 $f0 $f3 $f0)
 (data (i32.const 0) "p\0bflkj")
 (data (i32.const 10960) "1234hello")
 (export "f1" (func $f1))
 (export "f2" (func $f2))
 (export "f4" (func $f4))
 (func $f0 (result i32)
  (i32.const 1234)
 )
 (func $f1
  (i32.store (i32.const 1000) (i32.const 65530)) ;; dead store
 )
 (func $f2 (result i32)
  (i32.store (i32.const 0) (i32.const 65530))
  (i32.load (i32.const 0)) ;; load the written stuff
 )
 (func $f3 (result i32)
  (i32.load (i32.const 10964)) ;; load the 'hell'
 )
 (func $f4 (result i32)
  (i32.add
   (call_indirect (type $i) (i32.const 3))
   (call_indirect (type $i) (i32.const 0))
  )
 )
)

