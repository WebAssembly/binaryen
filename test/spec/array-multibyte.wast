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
(assert_return (invoke "i32_set_and_get_i8" (i32.const 255)) (i32.const 255))
;; ensure high bits are ignored
(assert_return (invoke "i32_set_and_get_i8" (i32.const 0xFFFFFF00)) (i32.const 0))

(assert_return (invoke "i32_set_and_get_i16" (i32.const 0)) (i32.const 0))
(assert_return (invoke "i32_set_and_get_i16" (i32.const 65535)) (i32.const 65535))
;; ensure high bits are ignored
(assert_return (invoke "i32_set_and_get_i16" (i32.const 0xFFFF0000)) (i32.const 0))

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
(assert_return (invoke "i64_set_and_get_i8" (i64.const 255)) (i64.const 255))
;; ensure high bits are ignored
(assert_return (invoke "i64_set_and_get_i8" (i64.const 0xFFFFFFFFFFFFFF00)) (i64.const 0))

(assert_return (invoke "i64_set_and_get_i16" (i64.const 0)) (i64.const 0))
(assert_return (invoke "i64_set_and_get_i16" (i64.const 65535)) (i64.const 65535))
;; ensure high bits are ignored
(assert_return (invoke "i64_set_and_get_i16" (i64.const 0xFFFFFFFFFFFF0000)) (i64.const 0))

(assert_return (invoke "i64_set_and_get_i32" (i64.const 0)) (i64.const 0))
(assert_return (invoke "i64_set_and_get_i32" (i64.const 2147483647)) (i64.const 2147483647))
;; unsigned extend
(assert_return (invoke "i64_set_and_get_i32" (i64.const -2147483648)) (i64.const 2147483648))
;; ensure high bits are ignored
(assert_return (invoke "i64_set_and_get_i32" (i64.const 0xFFFFFFFF00000000)) (i64.const 0))

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

(invoke "i32_set_i8" (i32.const 1) (i32.const 0xFF))
(assert_return (invoke "load_i32_16_u" (i32.const 0)) (i32.const 0xFFFF))
(assert_return (invoke "load_i32_16_s" (i32.const 0)) (i32.const -1))

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
(assert_trap (invoke "i32_set_i16" (i32.const -1) (i32.const 0)) "out of bounds")
(assert_return (invoke "i32_set_i16" (i32.const 0) (i32.const 0)))
(assert_return (invoke "i32_set_i16" (i32.const 1) (i32.const 0)))
(assert_return (invoke "i32_set_i16" (i32.const 2) (i32.const 0)))
(assert_trap (invoke "i32_set_i16" (i32.const 3) (i32.const 0xFFFF)) "out of bounds")
(assert_return (invoke "get_array_4_byte" (i32.const 3)) (i32.const 0))

;; i32_set_i32: Writes 4 bytes
;; Valid range: offset + 4 <= 4 -> Max offset 0
(assert_trap (invoke "i32_set_i32" (i32.const -1) (i32.const 0)) "out of bounds")
(assert_return (invoke "i32_set_i32" (i32.const 0) (i32.const 0)))
(assert_trap (invoke "i32_set_i32" (i32.const 1) (i32.const 0xFFFFFFFF)) "out of bounds")
(assert_return (invoke "get_array_4_byte" (i32.const 1)) (i32.const 0))

;; f32_set: Writes 4 bytes
;; Valid range: offset + 4 <= 4 -> Max offset 0
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
(assert_trap (invoke "i64_set_i16" (i32.const -1) (i64.const 0)) "out of bounds")
(assert_return (invoke "i64_set_i16" (i32.const 0) (i64.const 0)))
(assert_return (invoke "i64_set_i16" (i32.const 1) (i64.const 0)))
(assert_return (invoke "i64_set_i16" (i32.const 5) (i64.const 0)))
(assert_return (invoke "i64_set_i16" (i32.const 6) (i64.const 0)))
(assert_trap (invoke "i64_set_i16" (i32.const 7) (i64.const 0xFFFF)) "out of bounds")
(assert_return (invoke "get_array_8_byte" (i32.const 7)) (i32.const 0))

;; i64_set_i32: Writes 4 bytes
;; Valid range: offset + 4 <= 8 -> Max offset 4
(assert_trap (invoke "i64_set_i32" (i32.const -1) (i64.const 0)) "out of bounds")
(assert_return (invoke "i64_set_i32" (i32.const 0) (i64.const 0)))
(assert_return (invoke "i64_set_i32" (i32.const 1) (i64.const 0)))
(assert_return (invoke "i64_set_i32" (i32.const 3) (i64.const 0)))
(assert_return (invoke "i64_set_i32" (i32.const 4) (i64.const 0)))
(assert_trap (invoke "i64_set_i32" (i32.const 5) (i64.const 0xFFFFFFFF)) "out of bounds")
(assert_return (invoke "get_array_8_byte" (i32.const 5)) (i32.const 0))

;; i64_set_i64: Writes 8 bytes
;; Valid range: offset + 8 <= 8 -> Max offset 0
(assert_trap (invoke "i64_set_i64" (i32.const -1) (i64.const 0)) "out of bounds")
(assert_return (invoke "i64_set_i64" (i32.const 0) (i64.const 0)))
(assert_trap (invoke "i64_set_i64" (i32.const 1) (i64.const 0xFFFFFFFFFFFFFFFF)) "out of bounds")
(assert_return (invoke "get_array_8_byte" (i32.const 1)) (i32.const 0))

;; f64_set: Writes 8 bytes
;; Valid range: offset + 8 <= 8 -> Max offset 0
(assert_trap (invoke "f64_set" (i32.const -1) (f64.const 0)) "out of bounds")
(assert_return (invoke "f64_set" (i32.const 0) (f64.const 0)))
(assert_trap (invoke "f64_set" (i32.const 1) (f64.const 1.0)) "out of bounds")
(assert_return (invoke "get_array_8_byte" (i32.const 1)) (i32.const 0))


(assert_invalid
  (module
    (type $a (array i8))
    (func (export "i32_set_immutable") (param $a (ref $a))
      (i32.store (type $i8_array) (local.get $a) (i32.const 0) (i32.const 1))
    )
  )
  "array is immutable"
)

(assert_invalid
  (module
    (type $a (array (mut i16)))
    (func (export "i32_set_mut_i16") (param $a (ref $a))
      (i32.store (type $i8_array) (local.get $a) (i32.const 0) (i32.const 1))
    )
  )
  "array element type must be i8"
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

(module
  (type $i8_array (array (mut i8)))
  (type $i16_array (array (mut i16)))
  (type $i32_array (array (mut i32)))
  (type $i64_array (array (mut i64)))
  (type $f32_array (array (mut f32)))
  (type $f64_array (array (mut f64)))
  (type $v128_array (array (mut v128)))
  (type $imm_array (array i8))

  (global $arr8 (ref $i8_array)
    (array.new_default $i8_array (i32.const 8))
  )
  (global $arr16 (ref $i16_array)
    (array.new_default $i16_array (i32.const 4))
  )
  (global $arr32 (ref $i32_array)
    (array.new_default $i32_array (i32.const 4))
  )
  (global $arr64 (ref $i64_array)
    (array.new_default $i64_array (i32.const 2))
  )
  (global $arrf32 (ref $f32_array)
    (array.new_default $f32_array (i32.const 2))
  )
  (global $arrf64 (ref $f64_array)
    (array.new_default $f64_array (i32.const 2))
  )
  (global $arrv128 (ref $v128_array)
    (array.new_default $v128_array (i32.const 2))
  )
  (global $arr_imm (ref $imm_array)
    (array.new_default $imm_array (i32.const 4))
  )

  (func (export "test_i8_array") (result i32)
    (i32.store (type $i8_array) (global.get $arr8) (i32.const 0) (i32.const 0x12345678))
    (i32.load (type $i8_array) (global.get $arr8) (i32.const 0))
  )

  (func (export "test_i16_array") (result i32)
    (i32.store (type $i16_array) offset=2 align=2 (global.get $arr16) (i32.const 0) (i32.const 0x12345678))
    (i32.load (type $i16_array) offset=2 align=2 (global.get $arr16) (i32.const 0))
  )

  (func (export "test_i32_array") (result i32)
    (i32.store (type $i32_array) (global.get $arr32) (i32.const 0) (i32.const 0xabcdef01))
    (i32.load (type $i32_array) (global.get $arr32) (i32.const 0))
  )

  (func (export "test_i64_array") (result i64)
    (i64.store (type $i64_array) (global.get $arr64) (i32.const 0) (i64.const 0x123456789abcdef0))
    (i64.load (type $i64_array) (global.get $arr64) (i32.const 0))
  )

  (func (export "test_f32_array") (result f32)
    (f32.store (type $f32_array) (global.get $arrf32) (i32.const 0) (f32.const 3.14159))
    (f32.load (type $f32_array) (global.get $arrf32) (i32.const 0))
  )

  (func (export "test_f64_array") (result f64)
    (f64.store (type $f64_array) (global.get $arrf64) (i32.const 0) (f64.const 2.718281828459))
    (f64.load (type $f64_array) (global.get $arrf64) (i32.const 0))
  )

  (func (export "test_v128_array") (result v128)
    (v128.store (type $v128_array) (global.get $arrv128) (i32.const 0) (v128.const i32x4 1 2 3 4))
    (v128.load (type $v128_array) (global.get $arrv128) (i32.const 0))
  )

  ;; Immutable array load
  (func (export "test_immutable_array_load") (result i32)
    (i32.load8_u (type $imm_array) (global.get $arr_imm) (i32.const 0))
  )

  ;; Alignment hint test
  (func (export "test_unaligned_hints") (result i64)
    (i32.store (type $i8_array) align=1 (global.get $arr8) (i32.const 0) (i32.const 0x12345678))
    (i64.store (type $i8_array) align=1 (global.get $arr8) (i32.const 0) (i64.const 0x123456789abcdef0))
    (i64.load (type $i8_array) align=1 (global.get $arr8) (i32.const 0))
  )

  ;; OOB load/store functions for non-i8 arrays
  (func (export "test_i8_oob_load") (result i32)
    (i32.load (type $i8_array) (global.get $arr8) (i32.const 5))
  )
  (func (export "test_i8_oob_store")
    (i32.store (type $i8_array) (global.get $arr8) (i32.const 5) (i32.const 1))
  )
  (func (export "test_i16_oob_load") (result i32)
    (i32.load16_u (type $i16_array) (global.get $arr16) (i32.const 7))
  )
  (func (export "test_i16_oob_store")
    (i32.store16 (type $i16_array) (global.get $arr16) (i32.const 7) (i32.const 1))
  )
  (func (export "test_i32_oob_load") (result i32)
    (i32.load (type $i32_array) (global.get $arr32) (i32.const 13))
  )
  (func (export "test_i32_oob_store")
    (i32.store (type $i32_array) (global.get $arr32) (i32.const 13) (i32.const 1))
  )
  (func (export "test_i64_oob_load") (result i64)
    (i64.load (type $i64_array) (global.get $arr64) (i32.const 9))
  )
  (func (export "test_i64_oob_store")
    (i64.store (type $i64_array) (global.get $arr64) (i32.const 9) (i64.const 1))
  )
  (func (export "test_f32_oob_load") (result f32)
    (f32.load (type $f32_array) (global.get $arrf32) (i32.const 5))
  )
  (func (export "test_f32_oob_store")
    (f32.store (type $f32_array) (global.get $arrf32) (i32.const 5) (f32.const 1.0))
  )
  (func (export "test_f64_oob_load") (result f64)
    (f64.load (type $f64_array) (global.get $arrf64) (i32.const 9))
  )
  (func (export "test_f64_oob_store")
    (f64.store (type $f64_array) (global.get $arrf64) (i32.const 9) (f64.const 1.0))
  )
  (func (export "test_v128_oob_load") (result v128)
    (v128.load (type $v128_array) (global.get $arrv128) (i32.const 17))
  )
  (func (export "test_v128_oob_store")
    (v128.store (type $v128_array) (global.get $arrv128) (i32.const 17) (v128.const i32x4 0 0 0 0))
  )
)

(assert_return (invoke "test_i8_array") (i32.const 0x12345678))
(assert_return (invoke "test_i16_array") (i32.const 0x12345678))
(assert_return (invoke "test_i32_array") (i32.const 0xabcdef01))
(assert_return (invoke "test_i64_array") (i64.const 0x123456789abcdef0))
(assert_return (invoke "test_f32_array") (f32.const 3.14159))
(assert_return (invoke "test_f64_array") (f64.const 2.718281828459))
(assert_return (invoke "test_v128_array") (v128.const i32x4 1 2 3 4))

(assert_return (invoke "test_immutable_array_load") (i32.const 0))
(assert_return (invoke "test_unaligned_hints") (i64.const 0x123456789abcdef0))

(assert_trap (invoke "test_i8_oob_load") "array oob")
(assert_trap (invoke "test_i8_oob_store") "array oob")
(assert_trap (invoke "test_i16_oob_load") "array oob")
(assert_trap (invoke "test_i16_oob_store") "array oob")
(assert_trap (invoke "test_i32_oob_load") "array oob")
(assert_trap (invoke "test_i32_oob_store") "array oob")
(assert_trap (invoke "test_i64_oob_load") "array oob")
(assert_trap (invoke "test_i64_oob_store") "array oob")
(assert_trap (invoke "test_f32_oob_load") "array oob")
(assert_trap (invoke "test_f32_oob_store") "array oob")
(assert_trap (invoke "test_f64_oob_load") "array oob")
(assert_trap (invoke "test_f64_oob_store") "array oob")
(assert_trap (invoke "test_v128_oob_load") "array oob")
(assert_trap (invoke "test_v128_oob_store") "array oob")

(assert_invalid
  (module
    (type $ref_arr (array (mut funcref)))
    (func (export "load_ref_arr") (param $a (ref $ref_arr)) (result i32)
      (i32.load (type $ref_arr) (local.get $a) (i32.const 0))
    )
  )
  "array element type must be i8"
)

(assert_invalid
  (module
    (type $i8_array (array (mut i8)))
    (memory 1)
    (func (export "load_with_memidx") (param $a (ref $i8_array)) (result i32)
      (i32.load 0 (type $i8_array) (local.get $a) (i32.const 0))
    )
  )
  "memory index is not allowed for array load"
)
