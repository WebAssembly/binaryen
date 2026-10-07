;; Current Syntax: (type $i8_array)
;;
;; (func $test2 (export "test2")
;;   (i32.store (type $typeIdx)
;;     (global.get $arr_4)
;;     (i32.const 1)
;;     (i32.const 1337)
;;   )
;; )

;; Alternative Syntax 1: type=array
;;
;; (func $test2 (export "test2")
;;   (i32.store type=array
;;     (global.get $arr_4)
;;     (i32.const 1)
;;     (i32.const 1337)
;;   )
;; )

;; Alternative Syntax 2: array
;;
;; (func $test2 (export "test2")
;;   (i32.store array
;;     (global.get $arr_4)
;;     (i32.const 1)
;;     (i32.const 1337)
;;   )
;; )

;; Alternative Syntax 3: new opcodes
;;
;; (func $test2 (export "test2")
;;   (i32.array.store
;;     (global.get $arr_4)
;;     (i32.const 1)
;;     (i32.const 1337)
;;   )
;; )

(module
  (type $i8_array (array (mut i8)))

  (global $arr_4 (ref $i8_array)
    (array.new_default $i8_array (i32.const 4))
  )

  (global $arr_8 (ref $i8_array)
    (array.new_default $i8_array (i32.const 8))
  )

  (func $get_array_4_byte (export "get_array_4_byte") (param $idx i32) (result i32)
    (array.get_u $i8_array (global.get $arr_4) (local.get $idx))
  )

  (func $get_array_8_byte (export "get_array_8_byte") (param $idx i32) (result i32)
    (array.get_u $i8_array (global.get $arr_8) (local.get $idx))
  )

  (func $i32_set_i8 (export "i32_set_i8") (param $index i32) (param $value i32)
    (i32.store8 (type $i8_array)
      (global.get $arr_4)
      (local.get $index)
      (local.get $value)
    )
  )

  (func $i32_set_i16 (export "i32_set_i16") (param $index i32) (param $value i32)
    (i32.store16 (type $i8_array)
      (global.get $arr_4)
      (local.get $index)
      (local.get $value)
    )
  )

  (func $i32_set_i32 (export "i32_set_i32") (param $index i32) (param $value i32)
    (i32.store (type $i8_array)
      (global.get $arr_4)
      (local.get $index)
      (local.get $value)
    )
  )

  (func $f32_set (export "f32_set") (param $index i32) (param $value f32)
    (f32.store (type $i8_array)
      (global.get $arr_4)
      (local.get $index)
      (local.get $value)
    )
  )

  (func $i64_set_i8 (export "i64_set_i8") (param $index i32) (param $value i64)
    (i64.store8 (type $i8_array)
      (global.get $arr_8)
      (local.get $index)
      (local.get $value)
    )
  )

  (func $i64_set_i16 (export "i64_set_i16") (param $index i32) (param $value i64)
    (i64.store16 (type $i8_array)
      (global.get $arr_8)
      (local.get $index)
      (local.get $value)
    )
  )

  (func $i64_set_i32 (export "i64_set_i32") (param $index i32) (param $value i64)
    (i64.store32 (type $i8_array)
      (global.get $arr_8)
      (local.get $index)
      (local.get $value)
    )
  )

  (func $i64_set_i64 (export "i64_set_i64") (param $index i32) (param $value i64)
    (i64.store (type $i8_array)
      (global.get $arr_8)
      (local.get $index)
      (local.get $value)
    )
  )

  (func $f64_set (export "f64_set") (param $index i32) (param $value f64)
    (f64.store (type $i8_array)
      (global.get $arr_8)
      (local.get $index)
      (local.get $value)
    )
  )

  ;; TODO: Do we even want to spec out this instruction since array.set is the
  ;; same thing? See
  ;; https://github.com/WebAssembly/multibyte-array-access/issues/2
  (func $i32_set_and_get_i8 (export "i32_set_and_get_i8") (param $value i32) (result i32)
    (i32.store8 (type $i8_array)
      (global.get $arr_4)
      (i32.const 0)
      (local.get $value)
    )
    (i32.load8_u (type $i8_array) (global.get $arr_4) (i32.const 0))
  )

  (func $i32_set_and_get_i16 (export "i32_set_and_get_i16") (param $value i32) (result i32)
    (i32.store16 (type $i8_array)
      (global.get $arr_4)
      (i32.const 0)
      (local.get $value)
    )
    (i32.load16_u (type $i8_array) (global.get $arr_4) (i32.const 0))
  )

  (func $i32_set_and_get_i32 (export "i32_set_and_get_i32") (param $value i32) (result i32)
    (i32.store (type $i8_array)
      (global.get $arr_4)
      (i32.const 0)
      (local.get $value)
    )
    (i32.load (type $i8_array) (global.get $arr_4) (i32.const 0))
  )

  (func $set_and_get_f32 (export "set_and_get_f32") (param $value f32) (result f32)
    (f32.store (type $i8_array)
      (global.get $arr_4)
      (i32.const 0)
      (local.get $value)
    )
    (i32.load (type $i8_array) (global.get $arr_4) (i32.const 0))
    (f32.reinterpret_i32)
  )

  (func $i64_set_and_get_i8 (export "i64_set_and_get_i8") (param $value i64) (result i64)
    (i64.store8 (type $i8_array)
      (global.get $arr_8)
      (i32.const 0)
      (local.get $value)
    )
    (i64.load8_u (type $i8_array) (global.get $arr_8) (i32.const 0))
  )

  (func $i64_set_and_get_i16 (export "i64_set_and_get_i16") (param $value i64) (result i64)
    (i64.store16 (type $i8_array)
      (global.get $arr_8)
      (i32.const 0)
      (local.get $value)
    )
    (i64.load16_u (type $i8_array) (global.get $arr_8) (i32.const 0))
  )

  (func $i64_set_and_get_i32 (export "i64_set_and_get_i32") (param $value i64) (result i64)
    (i64.store32 (type $i8_array)
      (global.get $arr_8)
      (i32.const 0)
      (local.get $value)
    )
    (i64.load32_u (type $i8_array) (global.get $arr_8) (i32.const 0))
  )

  (func $i64_set_and_get_i64 (export "i64_set_and_get_i64") (param $value i64) (result i64)
    (i64.store (type $i8_array)
      (global.get $arr_8)
      (i32.const 0)
      (local.get $value)
    )
    (i64.load (type $i8_array) (global.get $arr_8) (i32.const 0))
  )

  (func $set_and_get_f64 (export "set_and_get_f64") (param $value f64) (result f64)
    (f64.store (type $i8_array)
      (global.get $arr_8)
      (i32.const 0)
      (local.get $value)
    )
    (i64.load (type $i8_array) (global.get $arr_8) (i32.const 0))
    (f64.reinterpret_i64)
  )
  (func $load_i32_16_u (export "load_i32_16_u") (param $idx i32) (result i32)
    (i32.load16_u (type $i8_array) (global.get $arr_4) (local.get $idx))
  )

  (func $load_i32_16_s (export "load_i32_16_s") (param $idx i32) (result i32)
    (i32.load16_s (type $i8_array) (global.get $arr_4) (local.get $idx))
  )

  (func $load_i32 (export "load_i32") (param $idx i32) (result i32)
    (i32.load (type $i8_array) (global.get $arr_4) (local.get $idx))
  )
  (func $load_i64 (export "load_i64") (param $idx i32) (result i64)
    (i64.load (type $i8_array) (global.get $arr_8) (local.get $idx))
  )

  (func $load_null (export "load_null") (result i32)
    (local $null (ref null $i8_array))
    (i32.load (type $i8_array) (local.get $null) (i32.const 0))
  )
)

;;
;; 32 bit round trip tests
;;

(assert_return (invoke "i32_set_and_get_i8" (i32.const 0)) (i32.const 0))
(assert_return (invoke "i32_set_and_get_i8" (i32.const 0xFF)) (i32.const 0xFF))
;; ensure high bits are ignored
(assert_return (invoke "i32_set_and_get_i8" (i32.const 0xFFFFFF12)) (i32.const 0x12))

(assert_return (invoke "i32_set_and_get_i16" (i32.const 0)) (i32.const 0))
(assert_return (invoke "i32_set_and_get_i16" (i32.const 0xFFFF)) (i32.const 0xFFFF))
;; ensure high bits are ignored
(assert_return (invoke "i32_set_and_get_i16" (i32.const 0xFFFF1234)) (i32.const 0x1234))

(assert_return (invoke "i32_set_and_get_i32" (i32.const 0)) (i32.const 0))
(assert_return (invoke "i32_set_and_get_i32" (i32.const 1)) (i32.const 1))
(assert_return (invoke "i32_set_and_get_i32" (i32.const 256)) (i32.const 256))
(assert_return (invoke "i32_set_and_get_i32" (i32.const -1)) (i32.const -1))
(assert_return (invoke "i32_set_and_get_i32" (i32.const 2147483647)) (i32.const 2147483647))
(assert_return (invoke "i32_set_and_get_i32" (i32.const -2147483648)) (i32.const -2147483648))

(assert_return (invoke "set_and_get_f32" (f32.const 0)) (f32.const 0))
(assert_return (invoke "set_and_get_f32" (f32.const -1)) (f32.const -1))
(assert_return (invoke "set_and_get_f32" (f32.const 3.3)) (f32.const 3.3))
(assert_return (invoke "set_and_get_f32" (f32.const -2.000000238418579)) (f32.const -2.000000238418579))
(assert_return (invoke "set_and_get_f32" (f32.const nan)) (f32.const nan))
(assert_return (invoke "set_and_get_f32" (f32.const nan:0x123456)) (f32.const nan:0x123456))
(assert_return (invoke "set_and_get_f32" (f32.const -nan:0x654321)) (f32.const -nan:0x654321))

;;
;; 64 bit round trip tests
;;

(assert_return (invoke "i64_set_and_get_i8" (i64.const 0)) (i64.const 0))
(assert_return (invoke "i64_set_and_get_i8" (i64.const 0xFF)) (i64.const 0xFF))
;; ensure high bits are ignored
(assert_return (invoke "i64_set_and_get_i8" (i64.const 0xFFFFFFFFFFFFFF12)) (i64.const 0x12))

(assert_return (invoke "i64_set_and_get_i16" (i64.const 0)) (i64.const 0))
(assert_return (invoke "i64_set_and_get_i16" (i64.const 0xFFFF)) (i64.const 0xFFFF))
;; ensure high bits are ignored
(assert_return (invoke "i64_set_and_get_i16" (i64.const 0xFFFFFFFFFFFF1234)) (i64.const 0x1234))

(assert_return (invoke "i64_set_and_get_i32" (i64.const 0)) (i64.const 0))
(assert_return (invoke "i64_set_and_get_i32" (i64.const 0x7FFFFFFF)) (i64.const 0x7FFFFFFF))
;; unsigned extend
(assert_return (invoke "i64_set_and_get_i32" (i64.const 0xFFFFFFFF80000000)) (i64.const 0x0000000080000000))
;; ensure high bits are ignored
(assert_return (invoke "i64_set_and_get_i32" (i64.const 0xFFFFFFFF12345678)) (i64.const 0x12345678))

(assert_return (invoke "i64_set_and_get_i64" (i64.const 0)) (i64.const 0))
(assert_return (invoke "i64_set_and_get_i64" (i64.const 9223372036854775807)) (i64.const 9223372036854775807))
(assert_return (invoke "i64_set_and_get_i64" (i64.const -9223372036854775808)) (i64.const -9223372036854775808))

(assert_return (invoke "set_and_get_f64" (f64.const 0)) (f64.const 0))
(assert_return (invoke "set_and_get_f64" (f64.const -1)) (f64.const -1))
(assert_return (invoke "set_and_get_f64" (f64.const 3.3)) (f64.const 3.3))
(assert_return (invoke "set_and_get_f64" (f64.const -2.00000000000000044409)) (f64.const -2.00000000000000044409))
(assert_return (invoke "set_and_get_f64" (f64.const nan)) (f64.const nan))
(assert_return (invoke "set_and_get_f64" (f64.const nan:0x123456789abcd)) (f64.const nan:0x123456789abcd))
(assert_return (invoke "set_and_get_f64" (f64.const -nan:0xedcba98765432)) (f64.const -nan:0xedcba98765432))

;;
;; Byte-wise store and unaligned store tests (32 bit)
;;

(invoke "i32_set_i32" (i32.const 0) (i32.const 0x00000000)) ;; clear
(invoke "i32_set_i16" (i32.const 0) (i32.const 0x1234))
(assert_return (invoke "get_array_4_byte" (i32.const 0)) (i32.const 0x34))
(assert_return (invoke "get_array_4_byte" (i32.const 1)) (i32.const 0x12))
(assert_return (invoke "get_array_4_byte" (i32.const 2)) (i32.const 0x00))
(assert_return (invoke "get_array_4_byte" (i32.const 3)) (i32.const 0x00))

(invoke "i32_set_i32" (i32.const 0) (i32.const 0x12345678))
(assert_return (invoke "get_array_4_byte" (i32.const 0)) (i32.const 0x78))
(assert_return (invoke "get_array_4_byte" (i32.const 1)) (i32.const 0x56))
(assert_return (invoke "get_array_4_byte" (i32.const 2)) (i32.const 0x34))
(assert_return (invoke "get_array_4_byte" (i32.const 3)) (i32.const 0x12))

(invoke "i32_set_i16" (i32.const 1) (i32.const 0xABCD))
(assert_return (invoke "get_array_4_byte" (i32.const 0)) (i32.const 0x78))
(assert_return (invoke "get_array_4_byte" (i32.const 1)) (i32.const 0xCD))
(assert_return (invoke "get_array_4_byte" (i32.const 2)) (i32.const 0xAB))
(assert_return (invoke "get_array_4_byte" (i32.const 3)) (i32.const 0x12))

;;
;; Byte-wise store and unaligned store tests (64 bit)
;;

(invoke "i64_set_i64" (i32.const 0) (i64.const 0x123456789ABCDEF0))
(assert_return (invoke "get_array_8_byte" (i32.const 0)) (i32.const 0xF0))
(assert_return (invoke "get_array_8_byte" (i32.const 1)) (i32.const 0xDE))
(assert_return (invoke "get_array_8_byte" (i32.const 2)) (i32.const 0xBC))
(assert_return (invoke "get_array_8_byte" (i32.const 3)) (i32.const 0x9A))
(assert_return (invoke "get_array_8_byte" (i32.const 4)) (i32.const 0x78))
(assert_return (invoke "get_array_8_byte" (i32.const 5)) (i32.const 0x56))
(assert_return (invoke "get_array_8_byte" (i32.const 6)) (i32.const 0x34))
(assert_return (invoke "get_array_8_byte" (i32.const 7)) (i32.const 0x12))

(invoke "i64_set_i32" (i32.const 3) (i64.const 0x11223344))
(assert_return (invoke "get_array_8_byte" (i32.const 0)) (i32.const 0xF0))
(assert_return (invoke "get_array_8_byte" (i32.const 1)) (i32.const 0xDE))
(assert_return (invoke "get_array_8_byte" (i32.const 2)) (i32.const 0xBC))
(assert_return (invoke "get_array_8_byte" (i32.const 3)) (i32.const 0x44))
(assert_return (invoke "get_array_8_byte" (i32.const 4)) (i32.const 0x33))
(assert_return (invoke "get_array_8_byte" (i32.const 5)) (i32.const 0x22))
(assert_return (invoke "get_array_8_byte" (i32.const 6)) (i32.const 0x11))
(assert_return (invoke "get_array_8_byte" (i32.const 7)) (i32.const 0x12))

;;
;; Byte-wise load tests
;;

(invoke "i32_set_i8" (i32.const 0) (i32.const 0x12))
(invoke "i32_set_i8" (i32.const 1) (i32.const 0x34))
(invoke "i32_set_i8" (i32.const 2) (i32.const 0x56))
(invoke "i32_set_i8" (i32.const 3) (i32.const 0x78))

(assert_return (invoke "load_i32_16_u" (i32.const 0)) (i32.const 0x3412))
(assert_return (invoke "load_i32_16_s" (i32.const 0)) (i32.const 0x3412))

;; Test sign extension
(invoke "i32_set_i8" (i32.const 0) (i32.const 0xFF))
(invoke "i32_set_i8" (i32.const 1) (i32.const 0x7F))
(assert_return (invoke "load_i32_16_u" (i32.const 0)) (i32.const 0x7FFF))
(assert_return (invoke "load_i32_16_s" (i32.const 0)) (i32.const 0x7FFF))

(invoke "i32_set_i8" (i32.const 0) (i32.const 0xFF))
(invoke "i32_set_i8" (i32.const 1) (i32.const 0xFF))
(invoke "i32_set_i8" (i32.const 2) (i32.const 0x56))
(invoke "i32_set_i8" (i32.const 3) (i32.const 0x78))
(assert_return (invoke "load_i32_16_u" (i32.const 0)) (i32.const 0x0000FFFF))
(assert_return (invoke "load_i32_16_s" (i32.const 0)) (i32.const 0xFFFFFFFF))

(assert_return (invoke "load_i32" (i32.const 0)) (i32.const 0x7856FFFF))

;;
;; Bounds checks (32 bit with a 4-byte array)
;;

(invoke "i32_set_i32" (i32.const 0) (i32.const 0))

;; i32_set_i8: Writes 1 byte
;; Valid range: [0, 3]
(assert_trap (invoke "i32_set_i8" (i32.const -1) (i32.const 0)) "out of bounds")
(assert_return (invoke "i32_set_i8" (i32.const 0) (i32.const 0)))
(assert_return (invoke "i32_set_i8" (i32.const 1) (i32.const 0)))
(assert_return (invoke "i32_set_i8" (i32.const 2) (i32.const 0)))
(assert_return (invoke "i32_set_i8" (i32.const 3) (i32.const 0)))
(assert_trap (invoke "i32_set_i8" (i32.const 4) (i32.const 0xFFFF)) "out of bounds")

;; i32_set_i16: Writes 2 bytes
;; Valid range: offset + 2 <= 4 -> Max offset 2
(invoke "i32_set_i32" (i32.const 0) (i32.const 0))
(assert_trap (invoke "i32_set_i16" (i32.const -1) (i32.const 0)) "out of bounds")
(assert_return (invoke "i32_set_i16" (i32.const 0) (i32.const 0)))
(assert_return (invoke "i32_set_i16" (i32.const 1) (i32.const 0)))
(assert_return (invoke "i32_set_i16" (i32.const 2) (i32.const 0)))
(assert_trap (invoke "i32_set_i16" (i32.const 3) (i32.const 0xFFFF)) "out of bounds")
(assert_return (invoke "get_array_4_byte" (i32.const 3)) (i32.const 0))

;; i32_set_i32: Writes 4 bytes
;; Valid range: offset + 4 <= 4 -> Max offset 0
(invoke "i32_set_i32" (i32.const 0) (i32.const 0))
(assert_trap (invoke "i32_set_i32" (i32.const -1) (i32.const 0)) "out of bounds")
(assert_return (invoke "i32_set_i32" (i32.const 0) (i32.const 0)))
(assert_trap (invoke "i32_set_i32" (i32.const 1) (i32.const 0xFFFFFFFF)) "out of bounds")
(assert_return (invoke "get_array_4_byte" (i32.const 1)) (i32.const 0))

;; f32_set: Writes 4 bytes
;; Valid range: offset + 4 <= 4 -> Max offset 0
(invoke "i32_set_i32" (i32.const 0) (i32.const 0))
(assert_trap (invoke "f32_set" (i32.const -1) (f32.const 0)) "out of bounds")
(assert_return (invoke "f32_set" (i32.const 0) (f32.const 0)))
(assert_trap (invoke "f32_set" (i32.const 1) (f32.const 1.0)) "out of bounds")
(assert_return (invoke "get_array_4_byte" (i32.const 1)) (i32.const 0))

;;
;; Bounds checks (64 bit with an 8-byte array)
;;

(invoke "i64_set_i64" (i32.const 0) (i64.const 0))

;; i64_set_i8: Writes 1 byte
;; Valid range: [0, 7]
(assert_trap (invoke "i64_set_i8" (i32.const -1) (i64.const 0)) "out of bounds")
(assert_return (invoke "i64_set_i8" (i32.const 0) (i64.const 0)))
(assert_return (invoke "i64_set_i8" (i32.const 1) (i64.const 0)))
(assert_return (invoke "i64_set_i8" (i32.const 6) (i64.const 0)))
(assert_return (invoke "i64_set_i8" (i32.const 7) (i64.const 0)))
(assert_trap (invoke "i64_set_i8" (i32.const 8) (i64.const 0xFFFF)) "out of bounds")

;; i64_set_i16: Writes 2 bytes
;; Valid range: offset + 2 <= 8 -> Max offset 6
(invoke "i64_set_i64" (i32.const 0) (i64.const 0))
(assert_trap (invoke "i64_set_i16" (i32.const -1) (i64.const 0)) "out of bounds")
(assert_return (invoke "i64_set_i16" (i32.const 0) (i64.const 0)))
(assert_return (invoke "i64_set_i16" (i32.const 1) (i64.const 0)))
(assert_return (invoke "i64_set_i16" (i32.const 5) (i64.const 0)))
(assert_return (invoke "i64_set_i16" (i32.const 6) (i64.const 0)))
(assert_trap (invoke "i64_set_i16" (i32.const 7) (i64.const 0xFFFF)) "out of bounds")
(assert_return (invoke "get_array_8_byte" (i32.const 7)) (i32.const 0))

;; i64_set_i32: Writes 4 bytes
;; Valid range: offset + 4 <= 8 -> Max offset 4
(invoke "i64_set_i64" (i32.const 0) (i64.const 0))
(assert_trap (invoke "i64_set_i32" (i32.const -1) (i64.const 0)) "out of bounds")
(assert_return (invoke "i64_set_i32" (i32.const 0) (i64.const 0)))
(assert_return (invoke "i64_set_i32" (i32.const 1) (i64.const 0)))
(assert_return (invoke "i64_set_i32" (i32.const 3) (i64.const 0)))
(assert_return (invoke "i64_set_i32" (i32.const 4) (i64.const 0)))
(assert_trap (invoke "i64_set_i32" (i32.const 5) (i64.const 0xFFFFFFFF)) "out of bounds")
(assert_return (invoke "get_array_8_byte" (i32.const 5)) (i32.const 0))

;; i64_set_i64: Writes 8 bytes
;; Valid range: offset + 8 <= 8 -> Max offset 0
(invoke "i64_set_i64" (i32.const 0) (i64.const 0))
(assert_trap (invoke "i64_set_i64" (i32.const -1) (i64.const 0)) "out of bounds")
(assert_return (invoke "i64_set_i64" (i32.const 0) (i64.const 0)))
(assert_trap (invoke "i64_set_i64" (i32.const 1) (i64.const 0xFFFFFFFFFFFFFFFF)) "out of bounds")
(assert_return (invoke "get_array_8_byte" (i32.const 1)) (i32.const 0))

;; f64_set: Writes 8 bytes
;; Valid range: offset + 8 <= 8 -> Max offset 0
(invoke "i64_set_i64" (i32.const 0) (i64.const 0))
(assert_trap (invoke "f64_set" (i32.const -1) (f64.const 0)) "out of bounds")
(assert_return (invoke "f64_set" (i32.const 0) (f64.const 0)))
(assert_trap (invoke "f64_set" (i32.const 1) (f64.const 1.0)) "out of bounds")
(assert_return (invoke "get_array_8_byte" (i32.const 1)) (i32.const 0))


(assert_invalid
  (module
    (type $a (array i8))
    (func (export "i32_set_immutable") (param $a (ref $a))
      (i32.store (type $a) (local.get $a) (i32.const 0) (i32.const 1))
    )
  )
  "array is immutable"
)

(assert_invalid
  (module
    (type $a (array (mut anyref)))
    (func (export "i32_set_non_numeric") (param $a (ref $a))
      (i32.store (type $a) (local.get $a) (i32.const 0) (i32.const 1))
    )
  )
  "array element type must be numeric"
)

;; New OOB Load Tests
(assert_trap (invoke "load_i32_16_u" (i32.const 3)) "out of bounds")
(assert_trap (invoke "load_i32" (i32.const 1)) "out of bounds")
(assert_trap (invoke "load_i64" (i32.const 1)) "out of bounds")

;; Null reference for load
(assert_trap (invoke "load_null") "null array")

;; Unaligned reads
(invoke "i32_set_i8" (i32.const 0) (i32.const 0x12))
(invoke "i32_set_i8" (i32.const 1) (i32.const 0x34))
(invoke "i32_set_i8" (i32.const 2) (i32.const 0x56))
(invoke "i32_set_i8" (i32.const 3) (i32.const 0x78))

(assert_return (invoke "load_i32_16_u" (i32.const 1)) (i32.const 0x5634))
(assert_return (invoke "load_i32_16_u" (i32.const 2)) (i32.const 0x7856))

;; Null dereference

(module
  (type $t (array (mut i8)))
  ;; (func (export "array.get-null")
  ;;   (local (ref null $t)) (drop (array.get $t (local.get 0) (i32.const 0)))
  ;; )
  (func (export "i32.store_array_null")
    (local (ref null $t)) (i32.store (type $t) (local.get 0) (i32.const 0) (i32.const 0))
  )
)

;; (assert_trap (invoke "array.get-null") "null array")
(assert_trap (invoke "i32.store_array_null") "null array")

;; ============================================================================
;; Multibyte accesses on arrays of every numeric element type.
;;
;; The accesses operate on the array's payload bytes, so the element type of
;; the array is independent of the type and the size of the access. Each of the
;; arrays below has a 16-byte payload, so the same accesses and the same bounds
;; apply to all of them.
;; ============================================================================

(module
  (type $i8_array (array (mut i8)))
  (type $i16_array (array (mut i16)))
  (type $i32_array (array (mut i32)))
  (type $i64_array (array (mut i64)))
  (type $f32_array (array (mut f32)))
  (type $f64_array (array (mut f64)))
  (type $v128_array (array (mut v128)))
  (type $imm_i32_array (array i32))

  (global $i8 (ref $i8_array) (array.new_default $i8_array (i32.const 16)))
  (global $i16 (ref $i16_array) (array.new_default $i16_array (i32.const 8)))
  (global $i32 (ref $i32_array) (array.new_default $i32_array (i32.const 4)))
  (global $i64 (ref $i64_array) (array.new_default $i64_array (i32.const 2)))
  (global $f32 (ref $f32_array) (array.new_default $f32_array (i32.const 4)))
  (global $f64 (ref $f64_array) (array.new_default $f64_array (i32.const 2)))
  (global $v128 (ref $v128_array) (array.new_default $v128_array (i32.const 1)))
  (global $v128_2 (ref $v128_array) (array.new_default $v128_array (i32.const 2)))
  (global $imm_i32 (ref $imm_i32_array)
    (array.new_fixed $imm_i32_array 2 (i32.const 0x11223344) (i32.const 0x55667788))
  )
  (global $empty (ref $i32_array) (array.new_default $i32_array (i32.const 0)))

  (func (export "clear")
    (v128.store (type $i8_array) (global.get $i8) (i32.const 0) (v128.const i32x4 0 0 0 0))
    (v128.store (type $i16_array) (global.get $i16) (i32.const 0) (v128.const i32x4 0 0 0 0))
    (v128.store (type $i32_array) (global.get $i32) (i32.const 0) (v128.const i32x4 0 0 0 0))
    (v128.store (type $i64_array) (global.get $i64) (i32.const 0) (v128.const i32x4 0 0 0 0))
    (v128.store (type $f32_array) (global.get $f32) (i32.const 0) (v128.const i32x4 0 0 0 0))
    (v128.store (type $f64_array) (global.get $f64) (i32.const 0) (v128.const i32x4 0 0 0 0))
    (v128.store (type $v128_array) (global.get $v128) (i32.const 0) (v128.const i32x4 0 0 0 0))
  )

  ;; Store an i32 and read it back, for an array of each element type.

  (func (export "i8_arr_i32") (param $i i32) (param $v i32) (result i32)
    (i32.store (type $i8_array) (global.get $i8) (local.get $i) (local.get $v))
    (i32.load (type $i8_array) (global.get $i8) (local.get $i))
  )
  (func (export "i16_arr_i32") (param $i i32) (param $v i32) (result i32)
    (i32.store (type $i16_array) (global.get $i16) (local.get $i) (local.get $v))
    (i32.load (type $i16_array) (global.get $i16) (local.get $i))
  )
  (func (export "i32_arr_i32") (param $i i32) (param $v i32) (result i32)
    (i32.store (type $i32_array) (global.get $i32) (local.get $i) (local.get $v))
    (i32.load (type $i32_array) (global.get $i32) (local.get $i))
  )
  (func (export "i64_arr_i32") (param $i i32) (param $v i32) (result i32)
    (i32.store (type $i64_array) (global.get $i64) (local.get $i) (local.get $v))
    (i32.load (type $i64_array) (global.get $i64) (local.get $i))
  )
  (func (export "f32_arr_i32") (param $i i32) (param $v i32) (result i32)
    (i32.store (type $f32_array) (global.get $f32) (local.get $i) (local.get $v))
    (i32.load (type $f32_array) (global.get $f32) (local.get $i))
  )
  (func (export "f64_arr_i32") (param $i i32) (param $v i32) (result i32)
    (i32.store (type $f64_array) (global.get $f64) (local.get $i) (local.get $v))
    (i32.load (type $f64_array) (global.get $f64) (local.get $i))
  )
  (func (export "v128_arr_i32") (param $i i32) (param $v i32) (result i32)
    (i32.store (type $v128_array) (global.get $v128) (local.get $i) (local.get $v))
    (i32.load (type $v128_array) (global.get $v128) (local.get $i))
  )

  ;; Store an i64 and read it back, for an array of each element type.

  (func (export "i8_arr_i64") (param $i i32) (param $v i64) (result i64)
    (i64.store (type $i8_array) (global.get $i8) (local.get $i) (local.get $v))
    (i64.load (type $i8_array) (global.get $i8) (local.get $i))
  )
  (func (export "i16_arr_i64") (param $i i32) (param $v i64) (result i64)
    (i64.store (type $i16_array) (global.get $i16) (local.get $i) (local.get $v))
    (i64.load (type $i16_array) (global.get $i16) (local.get $i))
  )
  (func (export "i32_arr_i64") (param $i i32) (param $v i64) (result i64)
    (i64.store (type $i32_array) (global.get $i32) (local.get $i) (local.get $v))
    (i64.load (type $i32_array) (global.get $i32) (local.get $i))
  )
  (func (export "i64_arr_i64") (param $i i32) (param $v i64) (result i64)
    (i64.store (type $i64_array) (global.get $i64) (local.get $i) (local.get $v))
    (i64.load (type $i64_array) (global.get $i64) (local.get $i))
  )
  (func (export "f32_arr_i64") (param $i i32) (param $v i64) (result i64)
    (i64.store (type $f32_array) (global.get $f32) (local.get $i) (local.get $v))
    (i64.load (type $f32_array) (global.get $f32) (local.get $i))
  )
  (func (export "f64_arr_i64") (param $i i32) (param $v i64) (result i64)
    (i64.store (type $f64_array) (global.get $f64) (local.get $i) (local.get $v))
    (i64.load (type $f64_array) (global.get $f64) (local.get $i))
  )
  (func (export "v128_arr_i64") (param $i i32) (param $v i64) (result i64)
    (i64.store (type $v128_array) (global.get $v128) (local.get $i) (local.get $v))
    (i64.load (type $v128_array) (global.get $v128) (local.get $i))
  )

  ;; Float accesses on arrays of integer, float, and vector elements.

  (func (export "i32_arr_f32") (param $i i32) (param $v f32) (result f32)
    (f32.store (type $i32_array) (global.get $i32) (local.get $i) (local.get $v))
    (f32.load (type $i32_array) (global.get $i32) (local.get $i))
  )
  (func (export "i16_arr_f64") (param $i i32) (param $v f64) (result f64)
    (f64.store (type $i16_array) (global.get $i16) (local.get $i) (local.get $v))
    (f64.load (type $i16_array) (global.get $i16) (local.get $i))
  )
  (func (export "f64_arr_f32") (param $i i32) (param $v f32) (result f32)
    (f32.store (type $f64_array) (global.get $f64) (local.get $i) (local.get $v))
    (f32.load (type $f64_array) (global.get $f64) (local.get $i))
  )
  (func (export "v128_arr_f64") (param $i i32) (param $v f64) (result f64)
    (f64.store (type $v128_array) (global.get $v128) (local.get $i) (local.get $v))
    (f64.load (type $v128_array) (global.get $v128) (local.get $i))
  )

  ;; v128 accesses, including on an array of v128 elements.

  (func (export "i32_arr_v128") (param $i i32) (param $v v128) (result v128)
    (v128.store (type $i32_array) (global.get $i32) (local.get $i) (local.get $v))
    (v128.load (type $i32_array) (global.get $i32) (local.get $i))
  )
  (func (export "i8_arr_v128_lane0") (param $i i32) (param $v v128) (result i64)
    (v128.store (type $i8_array) (global.get $i8) (local.get $i) (local.get $v))
    (i64.load (type $i8_array) (global.get $i8) (local.get $i))
  )
  (func (export "v128_arr_v128_lane1") (param $i i32) (param $v v128) (result i64)
    (v128.store (type $v128_array) (global.get $v128) (local.get $i) (local.get $v))
    (i64.load (type $v128_array) (global.get $v128) (i32.add (local.get $i) (i32.const 8)))
  )
  (func (export "v128_arr_unaligned") (param $v0 v128) (param $v1 v128) (result v128)
    (v128.store (type $v128_array) (global.get $v128_2) (i32.const 0) (local.get $v0))
    (v128.store (type $v128_array) (global.get $v128_2) (i32.const 16) (local.get $v1))
    (v128.load (type $v128_array) align=1 (global.get $v128_2) (i32.const 8))
  )

  ;; Sign and zero extension when loading from an array of wider elements.

  (func (export "i64_arr_load8_s") (param $i i32) (param $v i32) (result i32)
    (i32.store8 (type $i64_array) (global.get $i64) (local.get $i) (local.get $v))
    (i32.load8_s (type $i64_array) (global.get $i64) (local.get $i))
  )
  (func (export "i64_arr_load8_u") (param $i i32) (param $v i32) (result i32)
    (i32.store8 (type $i64_array) (global.get $i64) (local.get $i) (local.get $v))
    (i32.load8_u (type $i64_array) (global.get $i64) (local.get $i))
  )
  (func (export "i64_arr_load16_s") (param $i i32) (param $v i32) (result i32)
    (i32.store16 (type $i64_array) (global.get $i64) (local.get $i) (local.get $v))
    (i32.load16_s (type $i64_array) (global.get $i64) (local.get $i))
  )
  (func (export "i64_arr_load16_u") (param $i i32) (param $v i32) (result i32)
    (i32.store16 (type $i64_array) (global.get $i64) (local.get $i) (local.get $v))
    (i32.load16_u (type $i64_array) (global.get $i64) (local.get $i))
  )
  (func (export "f64_arr_load8_s") (param $i i32) (param $v i64) (result i64)
    (i64.store8 (type $f64_array) (global.get $f64) (local.get $i) (local.get $v))
    (i64.load8_s (type $f64_array) (global.get $f64) (local.get $i))
  )
  (func (export "f64_arr_load8_u") (param $i i32) (param $v i64) (result i64)
    (i64.store8 (type $f64_array) (global.get $f64) (local.get $i) (local.get $v))
    (i64.load8_u (type $f64_array) (global.get $f64) (local.get $i))
  )
  (func (export "f64_arr_load16_s") (param $i i32) (param $v i64) (result i64)
    (i64.store16 (type $f64_array) (global.get $f64) (local.get $i) (local.get $v))
    (i64.load16_s (type $f64_array) (global.get $f64) (local.get $i))
  )
  (func (export "f64_arr_load16_u") (param $i i32) (param $v i64) (result i64)
    (i64.store16 (type $f64_array) (global.get $f64) (local.get $i) (local.get $v))
    (i64.load16_u (type $f64_array) (global.get $f64) (local.get $i))
  )
  (func (export "f64_arr_load32_s") (param $i i32) (param $v i64) (result i64)
    (i64.store32 (type $f64_array) (global.get $f64) (local.get $i) (local.get $v))
    (i64.load32_s (type $f64_array) (global.get $f64) (local.get $i))
  )
  (func (export "f64_arr_load32_u") (param $i i32) (param $v i64) (result i64)
    (i64.store32 (type $f64_array) (global.get $f64) (local.get $i) (local.get $v))
    (i64.load32_u (type $f64_array) (global.get $f64) (local.get $i))
  )

  ;; Narrow stores wrap the value and leave surrounding bytes of wider elements
  ;; untouched.

  (func (export "i32_arr_store_widths") (param $init i32) (param $b0 i32) (param $h1 i32) (result i32)
    (i32.store (type $i32_array) (global.get $i32) (i32.const 0) (local.get $init))
    (i32.store8 (type $i32_array) (global.get $i32) (i32.const 0) (local.get $b0))
    (i32.store16 (type $i32_array) (global.get $i32) (i32.const 2) (local.get $h1))
    (i32.load (type $i32_array) (global.get $i32) (i32.const 0))
  )
  (func (export "i64_arr_store_widths") (param $init i64) (param $b0 i64) (param $h1 i64) (param $w1 i64) (result i64)
    (i64.store (type $i64_array) (global.get $i64) (i32.const 0) (local.get $init))
    (i64.store8 (type $i64_array) (global.get $i64) (i32.const 0) (local.get $b0))
    (i64.store16 (type $i64_array) (global.get $i64) (i32.const 2) (local.get $h1))
    (i64.store32 (type $i64_array) (global.get $i64) (i32.const 4) (local.get $w1))
    (i64.load (type $i64_array) (global.get $i64) (i32.const 0))
  )

  ;; Multibyte accesses and element accesses see the same payload bytes.

  (func (export "i32_arr_store_then_get") (param $v i32) (result i32)
    (i32.store (type $i32_array) (global.get $i32) (i32.const 8) (local.get $v))
    (array.get $i32_array (global.get $i32) (i32.const 2))
  )
  (func (export "i32_arr_set_then_load") (param $v i32) (result i32)
    (array.set $i32_array (global.get $i32) (i32.const 2) (local.get $v))
    (i32.load (type $i32_array) (global.get $i32) (i32.const 8))
  )
  (func (export "i16_arr_store_then_get_u") (param $v i32) (param $elem i32) (result i32)
    (i32.store (type $i16_array) (global.get $i16) (i32.const 4) (local.get $v))
    (array.get_u $i16_array (global.get $i16) (local.get $elem))
  )
  (func (export "i16_arr_store_then_get_s") (param $v i32) (param $elem i32) (result i32)
    (i32.store (type $i16_array) (global.get $i16) (i32.const 4) (local.get $v))
    (array.get_s $i16_array (global.get $i16) (local.get $elem))
  )
  (func (export "i16_arr_set_then_load") (param $v0 i32) (param $v1 i32) (result i32)
    (array.set $i16_array (global.get $i16) (i32.const 2) (local.get $v0))
    (array.set $i16_array (global.get $i16) (i32.const 3) (local.get $v1))
    (i32.load (type $i16_array) (global.get $i16) (i32.const 4))
  )
  (func (export "f64_arr_store_then_get") (param $v f64) (result f64)
    (f64.store (type $f64_array) (global.get $f64) (i32.const 8) (local.get $v))
    (array.get $f64_array (global.get $f64) (i32.const 1))
  )
  (func (export "i32_arr_v128_store_then_get") (param $v v128) (param $elem i32) (result i32)
    (v128.store (type $i32_array) (global.get $i32) (i32.const 0) (local.get $v))
    (array.get $i32_array (global.get $i32) (local.get $elem))
  )

  ;; Loads from an immutable array are allowed.

  (func (export "immutable_load") (param $i i32) (result i32)
    (i32.load (type $imm_i32_array) (global.get $imm_i32) (local.get $i))
  )

  ;; Any access on an empty array is out of bounds.

  (func (export "empty_load")
    (drop (i32.load8_u (type $i32_array) (global.get $empty) (i32.const 0)))
  )

  ;; Null references trap, before the bounds check.

  (func (export "null_load") (result i32)
    (i32.load (type $v128_array) (ref.null $v128_array) (i32.const 999))
  )
  (func (export "null_store")
    (f64.store (type $f64_array) (ref.null $f64_array) (i32.const 999) (f64.const 0))
  )
)

;; i32 accesses work the same on all element types.
(invoke "clear")
(assert_return (invoke "i8_arr_i32" (i32.const 3) (i32.const 0x12345678)) (i32.const 0x12345678))
(assert_return (invoke "i16_arr_i32" (i32.const 3) (i32.const 0x12345678)) (i32.const 0x12345678))
(assert_return (invoke "i32_arr_i32" (i32.const 3) (i32.const 0x12345678)) (i32.const 0x12345678))
(assert_return (invoke "i64_arr_i32" (i32.const 3) (i32.const 0x12345678)) (i32.const 0x12345678))
(assert_return (invoke "f32_arr_i32" (i32.const 3) (i32.const 0x12345678)) (i32.const 0x12345678))
(assert_return (invoke "f64_arr_i32" (i32.const 3) (i32.const 0x12345678)) (i32.const 0x12345678))
(assert_return (invoke "v128_arr_i32" (i32.const 3) (i32.const 0x12345678)) (i32.const 0x12345678))

;; The last in-bounds i32 access of a 16-byte payload is at index 12.
(invoke "clear")
(assert_return (invoke "i8_arr_i32" (i32.const 12) (i32.const -1)) (i32.const -1))
(assert_return (invoke "i16_arr_i32" (i32.const 12) (i32.const -1)) (i32.const -1))
(assert_return (invoke "i32_arr_i32" (i32.const 12) (i32.const -1)) (i32.const -1))
(assert_return (invoke "i64_arr_i32" (i32.const 12) (i32.const -1)) (i32.const -1))
(assert_return (invoke "f32_arr_i32" (i32.const 12) (i32.const -1)) (i32.const -1))
(assert_return (invoke "f64_arr_i32" (i32.const 12) (i32.const -1)) (i32.const -1))
(assert_return (invoke "v128_arr_i32" (i32.const 12) (i32.const -1)) (i32.const -1))

(assert_trap (invoke "i8_arr_i32" (i32.const 13) (i32.const 0)) "out of bounds")
(assert_trap (invoke "i16_arr_i32" (i32.const 13) (i32.const 0)) "out of bounds")
(assert_trap (invoke "i32_arr_i32" (i32.const 13) (i32.const 0)) "out of bounds")
(assert_trap (invoke "i64_arr_i32" (i32.const 13) (i32.const 0)) "out of bounds")
(assert_trap (invoke "f32_arr_i32" (i32.const 13) (i32.const 0)) "out of bounds")
(assert_trap (invoke "f64_arr_i32" (i32.const 13) (i32.const 0)) "out of bounds")
(assert_trap (invoke "v128_arr_i32" (i32.const 13) (i32.const 0)) "out of bounds")

;; The index is unsigned, so a negative index is far out of bounds.
(assert_trap (invoke "i8_arr_i32" (i32.const -1) (i32.const 0)) "out of bounds")
(assert_trap (invoke "i32_arr_i32" (i32.const -4) (i32.const 0)) "out of bounds")
(assert_trap (invoke "v128_arr_i32" (i32.const -16) (i32.const 0)) "out of bounds")

;; i64 accesses work the same on all element types.
(invoke "clear")
(assert_return (invoke "i8_arr_i64" (i32.const 5) (i64.const 0x1122334455667788)) (i64.const 0x1122334455667788))
(assert_return (invoke "i16_arr_i64" (i32.const 5) (i64.const 0x1122334455667788)) (i64.const 0x1122334455667788))
(assert_return (invoke "i32_arr_i64" (i32.const 5) (i64.const 0x1122334455667788)) (i64.const 0x1122334455667788))
(assert_return (invoke "i64_arr_i64" (i32.const 5) (i64.const 0x1122334455667788)) (i64.const 0x1122334455667788))
(assert_return (invoke "f32_arr_i64" (i32.const 5) (i64.const 0x1122334455667788)) (i64.const 0x1122334455667788))
(assert_return (invoke "f64_arr_i64" (i32.const 5) (i64.const 0x1122334455667788)) (i64.const 0x1122334455667788))
(assert_return (invoke "v128_arr_i64" (i32.const 5) (i64.const 0x1122334455667788)) (i64.const 0x1122334455667788))

;; The last in-bounds i64 access of a 16-byte payload is at index 8.
(invoke "clear")
(assert_return (invoke "i8_arr_i64" (i32.const 8) (i64.const -1)) (i64.const -1))
(assert_return (invoke "i16_arr_i64" (i32.const 8) (i64.const -1)) (i64.const -1))
(assert_return (invoke "i32_arr_i64" (i32.const 8) (i64.const -1)) (i64.const -1))
(assert_return (invoke "i64_arr_i64" (i32.const 8) (i64.const -1)) (i64.const -1))
(assert_return (invoke "f32_arr_i64" (i32.const 8) (i64.const -1)) (i64.const -1))
(assert_return (invoke "f64_arr_i64" (i32.const 8) (i64.const -1)) (i64.const -1))
(assert_return (invoke "v128_arr_i64" (i32.const 8) (i64.const -1)) (i64.const -1))
(assert_trap (invoke "i8_arr_i64" (i32.const 9) (i64.const 0)) "out of bounds")
(assert_trap (invoke "i16_arr_i64" (i32.const 9) (i64.const 0)) "out of bounds")
(assert_trap (invoke "i32_arr_i64" (i32.const 9) (i64.const 0)) "out of bounds")
(assert_trap (invoke "i64_arr_i64" (i32.const 9) (i64.const 0)) "out of bounds")
(assert_trap (invoke "f32_arr_i64" (i32.const 9) (i64.const 0)) "out of bounds")
(assert_trap (invoke "f64_arr_i64" (i32.const 9) (i64.const 0)) "out of bounds")
(assert_trap (invoke "v128_arr_i64" (i32.const 9) (i64.const 0)) "out of bounds")

;; Floats keep their bits, even when the element type is an integer type, and
;; even for NaNs with a payload.
(invoke "clear")
(assert_return (invoke "i32_arr_f32" (i32.const 2) (f32.const 3.3)) (f32.const 3.3))
(assert_return (invoke "i32_arr_f32" (i32.const 2) (f32.const -nan:0x654321)) (f32.const -nan:0x654321))
(assert_return (invoke "i16_arr_f64" (i32.const 3) (f64.const 3.3)) (f64.const 3.3))
(assert_return (invoke "i16_arr_f64" (i32.const 3) (f64.const nan:0x123456789ABCD)) (f64.const nan:0x123456789ABCD))
(assert_return (invoke "f64_arr_f32" (i32.const 6) (f32.const -1)) (f32.const -1))
(assert_return (invoke "v128_arr_f64" (i32.const 4) (f64.const 1.5)) (f64.const 1.5))

;; v128 accesses read and write 16 bytes.
(invoke "clear")
(assert_return (invoke "i32_arr_v128" (i32.const 0) (v128.const i32x4 1 2 3 4)) (v128.const i32x4 1 2 3 4))
(assert_return (invoke "i8_arr_v128_lane0" (i32.const 0) (v128.const i64x2 1 2)) (i64.const 1))
(assert_return (invoke "v128_arr_v128_lane1" (i32.const 0) (v128.const i64x2 1 2)) (i64.const 2))
(assert_return (invoke "v128_arr_unaligned" (v128.const i64x2 1 2) (v128.const i64x2 3 4)) (v128.const i64x2 2 3))
(assert_trap (invoke "i8_arr_v128_lane0" (i32.const 1) (v128.const i64x2 0 0)) "out of bounds")

;; Sign and zero extension.
(invoke "clear")
(assert_return (invoke "i64_arr_load8_s" (i32.const 1) (i32.const 0x80)) (i32.const 0xFFFFFF80))
(assert_return (invoke "i64_arr_load8_u" (i32.const 1) (i32.const 0x80)) (i32.const 0x00000080))
(assert_return (invoke "i64_arr_load8_s" (i32.const 1) (i32.const 0x7F)) (i32.const 0x0000007F))
(assert_return (invoke "i64_arr_load16_s" (i32.const 2) (i32.const 0x8000)) (i32.const 0xFFFF8000))
(assert_return (invoke "i64_arr_load16_u" (i32.const 2) (i32.const 0x8000)) (i32.const 0x00008000))
(assert_return (invoke "i64_arr_load16_s" (i32.const 2) (i32.const 0x7FFF)) (i32.const 0x00007FFF))
(assert_return (invoke "i64_arr_load16_u" (i32.const 2) (i32.const 0x7FFF)) (i32.const 0x00007FFF))
(assert_return (invoke "f64_arr_load8_s" (i32.const 1) (i64.const 0x80)) (i64.const 0xFFFFFFFFFFFFFF80))
(assert_return (invoke "f64_arr_load8_u" (i32.const 1) (i64.const 0x80)) (i64.const 0x0000000000000080))
(assert_return (invoke "f64_arr_load16_s" (i32.const 2) (i64.const 0x8000)) (i64.const 0xFFFFFFFFFFFF8000))
(assert_return (invoke "f64_arr_load16_u" (i32.const 2) (i64.const 0x8000)) (i64.const 0x0000000000008000))
(assert_return (invoke "f64_arr_load32_s" (i32.const 4) (i64.const 0x80000000)) (i64.const 0xFFFFFFFF80000000))
(assert_return (invoke "f64_arr_load32_u" (i32.const 4) (i64.const 0x80000000)) (i64.const 0x0000000080000000))

;; Narrow stores wrap the value and preserve surrounding bytes.
(invoke "clear")
(assert_return
  (invoke "i32_arr_store_widths" (i32.const 0xFFFFFFFF) (i32.const 0xDEAD12) (i32.const 0xDEAD3456))
  (i32.const 0x3456FF12)
)
(assert_return
  (invoke "i64_arr_store_widths" (i64.const 0xFFFFFFFFFFFFFFFF) (i64.const 0xDEAD12) (i64.const 0xDEAD3456) (i64.const 0xDEAD789ABCDE))
  (i64.const 0x789ABCDE3456FF12)
)

;; Multibyte accesses and element accesses agree.
(invoke "clear")
(assert_return (invoke "i32_arr_store_then_get" (i32.const 1337)) (i32.const 1337))
(assert_return (invoke "i32_arr_set_then_load" (i32.const 1337)) (i32.const 1337))
(assert_return (invoke "i16_arr_store_then_get_u" (i32.const 0x80001234) (i32.const 2)) (i32.const 0x00001234))
(assert_return (invoke "i16_arr_store_then_get_u" (i32.const 0x80001234) (i32.const 3)) (i32.const 0x00008000))
(assert_return (invoke "i16_arr_store_then_get_s" (i32.const 0x80001234) (i32.const 3)) (i32.const 0xFFFF8000))
(assert_return (invoke "i16_arr_set_then_load" (i32.const 0x1234) (i32.const 0x5678)) (i32.const 0x56781234))
(assert_return (invoke "f64_arr_store_then_get" (f64.const 3.3)) (f64.const 3.3))
(assert_return (invoke "i32_arr_v128_store_then_get" (v128.const i32x4 10 20 30 40) (i32.const 1)) (i32.const 20))
(assert_return (invoke "i32_arr_v128_store_then_get" (v128.const i32x4 10 20 30 40) (i32.const 3)) (i32.const 40))

;; Loads from immutable arrays.
(assert_return (invoke "immutable_load" (i32.const 0)) (i32.const 0x11223344))
(assert_return (invoke "immutable_load" (i32.const 4)) (i32.const 0x55667788))
(assert_return (invoke "immutable_load" (i32.const 2)) (i32.const 0x77881122))
(assert_trap (invoke "immutable_load" (i32.const 5)) "out of bounds")

;; Empty arrays and null references.
(assert_trap (invoke "empty_load") "out of bounds")
(assert_trap (invoke "null_load") "null array")
(assert_trap (invoke "null_store") "null array")

;; ============================================================================
;; Static offset and alignment immediates.
;; ============================================================================

(module
  (type $i8_array (array (mut i8)))
  (type $i32_array (array (mut i32)))

  (global $i8 (ref $i8_array) (array.new_default $i8_array (i32.const 16)))
  (global $i32 (ref $i32_array) (array.new_default $i32_array (i32.const 4)))

  ;; The effective address is the sum of the dynamic index and the static
  ;; offset, so these two functions access the same bytes.
  (func (export "store_offset") (param $i i32) (param $v i32)
    (i32.store (type $i8_array) offset=4 (global.get $i8) (local.get $i) (local.get $v))
  )
  (func (export "load_index") (param $i i32) (result i32)
    (i32.load (type $i8_array) (global.get $i8) (local.get $i))
  )
  (func (export "load_offset") (param $i i32) (result i32)
    (i32.load (type $i8_array) offset=4 (global.get $i8) (local.get $i))
  )

  ;; The offset alone can address the array.
  (func (export "load_offset_only") (result i32)
    (i32.load (type $i8_array) offset=12 (global.get $i8) (i32.const 0))
  )

  ;; The offset is included in the bounds check, and the sum of the index and
  ;; the offset does not wrap around.
  (func (export "load_offset_oob") (result i32)
    (i32.load (type $i8_array) offset=13 (global.get $i8) (i32.const 0))
  )
  (func (export "load_offset_no_wrap") (result i32)
    (i32.load8_u (type $i8_array) offset=1 (global.get $i8) (i32.const -1))
  )
  (func (export "load_offset_max") (result i32)
    (i32.load8_u (type $i8_array) offset=4294967295 (global.get $i8) (i32.const 1))
  )

  ;; Alignment is only a hint: it does not affect the result, and it does not
  ;; need to match the alignment of the array's elements.
  (func (export "unaligned_store") (param $i i32) (param $v i32)
    (i32.store (type $i32_array) align=1 (global.get $i32) (local.get $i) (local.get $v))
  )
  (func (export "aligned_store") (param $i i32) (param $v i32)
    (i32.store (type $i32_array) align=4 (global.get $i32) (local.get $i) (local.get $v))
  )
  (func (export "unaligned_load") (param $i i32) (result i32)
    (i32.load (type $i32_array) align=1 (global.get $i32) (local.get $i))
  )
  (func (export "aligned_load") (param $i i32) (result i32)
    (i32.load (type $i32_array) align=4 (global.get $i32) (local.get $i))
  )
)

(invoke "store_offset" (i32.const 2) (i32.const 0x12345678))
(assert_return (invoke "load_index" (i32.const 6)) (i32.const 0x12345678))
(assert_return (invoke "load_offset" (i32.const 2)) (i32.const 0x12345678))
(invoke "store_offset" (i32.const 0) (i32.const 0x11223344))
(assert_return (invoke "load_index" (i32.const 4)) (i32.const 0x11223344))
;; The second store overwrote the first two bytes of the first one.
(assert_return (invoke "load_index" (i32.const 6)) (i32.const 0x12341122))

(invoke "store_offset" (i32.const 8) (i32.const 0x55667788))
(assert_return (invoke "load_offset_only") (i32.const 0x55667788))

(assert_trap (invoke "load_offset_oob") "out of bounds")
(assert_trap (invoke "load_offset_no_wrap") "out of bounds")
(assert_trap (invoke "load_offset_max") "out of bounds")

;; An unaligned store of an i32 array crosses two elements.
(invoke "aligned_store" (i32.const 0) (i32.const 0))
(invoke "aligned_store" (i32.const 4) (i32.const 0))
(invoke "unaligned_store" (i32.const 2) (i32.const 0x12345678))
(assert_return (invoke "unaligned_load" (i32.const 2)) (i32.const 0x12345678))
(assert_return (invoke "aligned_load" (i32.const 0)) (i32.const 0x56780000))
(assert_return (invoke "aligned_load" (i32.const 4)) (i32.const 0x00001234))

;; ============================================================================
;; Binary format: memarg ::= flags:u32 typeidx:u32 offset:u32
;; ============================================================================

(module binary
  "\00asm\01\00\00\00"

  "\01\0a\03"         ;; Type section: 3 types
    "\5f\00"          ;; Type 0: (struct)
    "\5e\78\01"       ;; Type 1: (array (mut i8))
    "\60\00\01\7f"    ;; Type 2: (func (result i32))

  "\03\02\01\02"      ;; Function section: 1 function of type 2

  "\07\08\01"         ;; Export section: 1 export
    "\04test\00\00"   ;; (export "test" (func 0))

  "\0a\1e\01"         ;; Code section: 1 function
    "\1c\01"          ;; Body size 28, 1 local entry
      "\01\63\01"     ;; (local (ref null 1))
      "\41\08"        ;; i32.const 8
      "\fb\07\01"     ;; array.new_default 1
      "\22\00"        ;; local.tee 0
      "\41\00"        ;; i32.const 0
      "\41\2a"        ;; i32.const 42
      "\36\22\01\04"  ;; i32.store flags=0x22 (array, align=4) typeidx=1 offset=4
      "\20\00"        ;; local.get 0
      "\41\00"        ;; i32.const 0
      "\28\22\01\04"  ;; i32.load flags=0x22 (array, align=4) typeidx=1 offset=4
      "\0b"           ;; end
)

(assert_return (invoke "test") (i32.const 42))
