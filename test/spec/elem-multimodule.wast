(module $module1
  (type $out-i32 (func (result i32)))
  (table (export "shared-table") 10 funcref)
  (elem (i32.const 8) $const-i32-a)
  (elem (i32.const 9) $const-i32-b)
  (func $const-i32-a (type $out-i32) (i32.const 65))
  (func $const-i32-b (type $out-i32) (i32.const 66))
  (func (export "call-7") (type $out-i32)
    (call_indirect (type $out-i32) (i32.const 7))
  )
  (func (export "call-8") (type $out-i32)
    (call_indirect (type $out-i32) (i32.const 8))
  )
  (func (export "call-9") (type $out-i32)
    (call_indirect (type $out-i32) (i32.const 9))
  )
)

(register "module1" $module1)

(assert_trap (invoke $module1 "call-7") "uninitialized element")
(assert_return (invoke $module1 "call-8") (i32.const 65))
(assert_return (invoke $module1 "call-9") (i32.const 66))

(module $module2
  (type $out-i32 (func (result i32)))
  (import "module1" "shared-table" (table 10 funcref))
  (elem (i32.const 7) $const-i32-c)
  (elem (i32.const 8) $const-i32-d)
  (func $const-i32-c (type $out-i32) (i32.const 67))
  (func $const-i32-d (type $out-i32) (i32.const 68))
)

(assert_return (invoke $module1 "call-7") (i32.const 67))
(assert_return (invoke $module1 "call-8") (i32.const 68))
(assert_return (invoke $module1 "call-9") (i32.const 66))

(module $module3
  (type $out-i32 (func (result i32)))
  (import "module1" "shared-table" (table 10 funcref))
  (elem (i32.const 8) $const-i32-e)
  (elem (i32.const 9) $const-i32-f)
  (func $const-i32-e (type $out-i32) (i32.const 69))
  (func $const-i32-f (type $out-i32) (i32.const 70))
)

(assert_return (invoke $module1 "call-7") (i32.const 67))
(assert_return (invoke $module1 "call-8") (i32.const 69))
(assert_return (invoke $module1 "call-9") (i32.const 70))
