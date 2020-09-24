(module
  (import "spectest" "print" (func $print (param i32)))

  (memory i64 1)
  (data (i32.const 0) "abcdefghijklmnopqrstuvwxyz")

  (func (export "good") (param $i i64)
    (call $print (i32.load8_u offset=0 (local.get $i)))  ;; 97 'a'
    (call $print (i32.load8_u offset=1 (local.get $i)))  ;; 98 'b'
    (call $print (i32.load8_u offset=2 (local.get $i)))  ;; 99 'c'
    (call $print (i32.load8_u offset=25 (local.get $i))) ;; 122 'z'

    (call $print (i32.load16_u offset=0 (local.get $i)))          ;; 25185 'ab'
    (call $print (i32.load16_u align=1 (local.get $i)))           ;; 25185 'ab'
    (call $print (i32.load16_u offset=1 align=1 (local.get $i)))  ;; 25442 'bc'
    (call $print (i32.load16_u offset=2 (local.get $i)))          ;; 25699 'cd'
    (call $print (i32.load16_u offset=25 align=1 (local.get $i))) ;; 122 'z\0'

    (call $print (i32.load offset=0 (local.get $i)))          ;; 1684234849 'abcd'
    (call $print (i32.load offset=1 align=1 (local.get $i)))  ;; 1701077858 'bcde'
    (call $print (i32.load offset=2 align=2 (local.get $i)))  ;; 1717920867 'cdef'
    (call $print (i32.load offset=25 align=1 (local.get $i))) ;; 122 'z\0\0\0'
  )

  (func (export "bad") (param $i i64)
    (drop (i32.load offset=4294967295 (local.get $i)))
  )
)

(invoke "good" (i64.const 0))
(invoke "good" (i64.const 65507))
(assert_trap (invoke "good" (i64.const 65508)) "out of bounds memory access")
(assert_trap (invoke "bad" (i64.const 0)) "out of bounds memory access")
(assert_trap (invoke "bad" (i64.const 1)) "out of bounds memory access")
