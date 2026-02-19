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

  ;; Read i32 from an i8 array using regular array get instructions.
  ;; TODO remove this and use the load instructions when implemented.
  (func $load_i32_from_array
    (export "load_i32_from_array")
    (param $arr (ref $i8_array))
    (param $idx i32)
    (result i32)

    ;; 1. Load the first byte (least significant)
    (array.get_u $i8_array (local.get $arr) (local.get $idx))

    ;; 2. Load the second byte and shift it left by 8 bits
    (array.get_u $i8_array (local.get $arr) (i32.add (local.get $idx) (i32.const 1)))
    (i32.const 8)
    (i32.shl)
    (i32.or)

    ;; 3. Load the third byte and shift it left by 16 bits
    (array.get_u $i8_array (local.get $arr) (i32.add (local.get $idx) (i32.const 2)))
    (i32.const 16)
    (i32.shl)
    (i32.or)

    ;; 4. Load the fourth byte (most significant) and shift it left by 24 bits
    (array.get_u $i8_array (local.get $arr) (i32.add (local.get $idx) (i32.const 3)))
    (i32.const 24)
    (i32.shl)
    (i32.or)
  )

  ;; TODO remove this and use the load instructions when implemented.
  (func $load_i64_from_array
    (export "load_i64_from_array")
    (param $arr (ref $i8_array))
    (param $idx i32)
    (result i64)
    (call $load_i32_from_array (local.get $arr) (local.get $idx))
    (i64.extend_i32_u)

    (call $load_i32_from_array (local.get $arr) (i32.add (local.get $idx) (i32.const 4)))
    (i64.extend_i32_u)
    (i64.const 32)
    (i64.shl)
    (i64.or)
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

  ;; ??? Do we even want to spec out this instruction since array.store is the
  ;; same thing?
  (func $i32_set_and_get_i8 (export "i32_set_and_get_i8") (param $value i32) (result i32)
    (i32.store8 (type $i8_array)
      (global.get $arr_4)
      (i32.const 0)
      (local.get $value)
    )
    ;; TODO: when multibyte get is supported use that instead here.
    (call $load_i32_from_array (global.get $arr_4) (i32.const 0))
  )

  (func $i32_set_and_get_i16 (export "i32_set_and_get_i16") (param $value i32) (result i32)
    (i32.store16 (type $i8_array)
      (global.get $arr_4)
      (i32.const 0)
      (local.get $value)
    )
    ;; TODO: when multibyte get is supported use that instead here.
    (call $load_i32_from_array (global.get $arr_4) (i32.const 0))
  )

  (func $i32_set_and_get_i32 (export "i32_set_and_get_i32") (param $value i32) (result i32)
    (i32.store (type $i8_array)
      (global.get $arr_4)
      (i32.const 0)
      (local.get $value)
    )
    ;; TODO: when multibyte get is supported use that instead here.
    (call $load_i32_from_array (global.get $arr_4) (i32.const 0))
  )

  (func $set_and_get_f32 (export "set_and_get_f32") (param $value f32) (result f32)
    (f32.store (type $i8_array)
      (global.get $arr_4)
      (i32.const 0)
      (local.get $value)
    )
    ;; TODO: when multibyte get is supported use that instead here.
    (call $load_i32_from_array (global.get $arr_4) (i32.const 0))
    (f32.reinterpret_i32)
  )

  (func $i64_set_and_get_i8 (export "i64_set_and_get_i8") (param $value i64) (result i64)
    (i64.store8 (type $i8_array)
      (global.get $arr_8)
      (i32.const 0)
      (local.get $value)
    )
    ;; TODO: when multibyte get is supported use that instead here.
    (call $load_i64_from_array (global.get $arr_8) (i32.const 0))
  )

  (func $i64_set_and_get_i16 (export "i64_set_and_get_i16") (param $value i64) (result i64)
    (i64.store16 (type $i8_array)
      (global.get $arr_8)
      (i32.const 0)
      (local.get $value)
    )
    ;; TODO: when multibyte get is supported use that instead here.
    (call $load_i64_from_array (global.get $arr_8) (i32.const 0))
  )

  (func $i64_set_and_get_i32 (export "i64_set_and_get_i32") (param $value i64) (result i64)
    (i64.store32 (type $i8_array)
      (global.get $arr_8)
      (i32.const 0)
      (local.get $value)
    )
    ;; TODO: when multibyte get is supported use that instead here.
    (call $load_i64_from_array (global.get $arr_8) (i32.const 0))
  )

  (func $i64_set_and_get_i64 (export "i64_set_and_get_i64") (param $value i64) (result i64)
    (i64.store (type $i8_array)
      (global.get $arr_8)
      (i32.const 0)
      (local.get $value)
    )
    ;; TODO: when multibyte get is supported use that instead here.
    (call $load_i64_from_array (global.get $arr_8) (i32.const 0))
  )

  (func $set_and_get_f64 (export "set_and_get_f64") (param $value f64) (result f64)
    (f64.store (type $i8_array)
      (global.get $arr_8)
      (i32.const 0)
      (local.get $value)
    )
    ;; TODO: when multibyte get is supported use that instead here.
    (call $load_i64_from_array (global.get $arr_8) (i32.const 0))
    (f64.reinterpret_i64)
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

;;
;; Bounds checks (32 bit with a 4-byte array)
;;

;; i32_set_i8: Writes 1 byte
;; Valid range: [0, 3]
(assert_trap (invoke "i32_set_i8" (i32.const -1) (i32.const 0)) "out of bounds")
(assert_return (invoke "i32_set_i8" (i32.const 0) (i32.const 0)))
(assert_return (invoke "i32_set_i8" (i32.const 1) (i32.const 0)))
(assert_return (invoke "i32_set_i8" (i32.const 2) (i32.const 0)))
(assert_return (invoke "i32_set_i8" (i32.const 3) (i32.const 0)))
(assert_trap (invoke "i32_set_i8" (i32.const 4) (i32.const 0)) "out of bounds")

;; i32_set_i16: Writes 2 bytes
;; Valid range: offset + 2 <= 4 -> Max offset 2
(assert_trap (invoke "i32_set_i16" (i32.const -1) (i32.const 0)) "out of bounds")
(assert_return (invoke "i32_set_i16" (i32.const 0) (i32.const 0)))
(assert_return (invoke "i32_set_i16" (i32.const 1) (i32.const 0)))
(assert_return (invoke "i32_set_i16" (i32.const 2) (i32.const 0)))
(assert_trap (invoke "i32_set_i16" (i32.const 3) (i32.const 0)) "out of bounds")

;; i32_set_i32: Writes 4 bytes
;; Valid range: offset + 4 <= 4 -> Max offset 0
(assert_trap (invoke "i32_set_i32" (i32.const -1) (i32.const 0)) "out of bounds")
(assert_return (invoke "i32_set_i32" (i32.const 0) (i32.const 0)))
(assert_trap (invoke "i32_set_i32" (i32.const 1) (i32.const 0)) "out of bounds")

;; f32_set: Writes 4 bytes
;; Valid range: offset + 4 <= 4 -> Max offset 0
(assert_trap (invoke "f32_set" (i32.const -1) (f32.const 0)) "out of bounds")
(assert_return (invoke "f32_set" (i32.const 0) (f32.const 0)))
(assert_trap (invoke "f32_set" (i32.const 1) (f32.const 0)) "out of bounds")

;;
;; Bounds checks (64 bit with an 8-byte array)
;;

;; i64_set_i8: Writes 1 byte
;; Valid range: [0, 7]
(assert_trap (invoke "i64_set_i8" (i32.const -1) (i64.const 0)) "out of bounds")
(assert_return (invoke "i64_set_i8" (i32.const 0) (i64.const 0)))
(assert_return (invoke "i64_set_i8" (i32.const 1) (i64.const 0)))
(assert_return (invoke "i64_set_i8" (i32.const 6) (i64.const 0)))
(assert_return (invoke "i64_set_i8" (i32.const 7) (i64.const 0)))
(assert_trap (invoke "i64_set_i8" (i32.const 8) (i64.const 0)) "out of bounds")

;; i64_set_i16: Writes 2 bytes
;; Valid range: offset + 2 <= 8 -> Max offset 6
(assert_trap (invoke "i64_set_i16" (i32.const -1) (i64.const 0)) "out of bounds")
(assert_return (invoke "i64_set_i16" (i32.const 0) (i64.const 0)))
(assert_return (invoke "i64_set_i16" (i32.const 1) (i64.const 0)))
(assert_return (invoke "i64_set_i16" (i32.const 5) (i64.const 0)))
(assert_return (invoke "i64_set_i16" (i32.const 6) (i64.const 0)))
(assert_trap (invoke "i64_set_i16" (i32.const 7) (i64.const 0)) "out of bounds")

;; i64_set_i32: Writes 4 bytes
;; Valid range: offset + 4 <= 8 -> Max offset 4
(assert_trap (invoke "i64_set_i32" (i32.const -1) (i64.const 0)) "out of bounds")
(assert_return (invoke "i64_set_i32" (i32.const 0) (i64.const 0)))
(assert_return (invoke "i64_set_i32" (i32.const 1) (i64.const 0)))
(assert_return (invoke "i64_set_i32" (i32.const 3) (i64.const 0)))
(assert_return (invoke "i64_set_i32" (i32.const 4) (i64.const 0)))
(assert_trap (invoke "i64_set_i32" (i32.const 5) (i64.const 0)) "out of bounds")

;; i64_set_i64: Writes 8 bytes
;; Valid range: offset + 8 <= 8 -> Max offset 0
(assert_trap (invoke "i64_set_i64" (i32.const -1) (i64.const 0)) "out of bounds")
(assert_return (invoke "i64_set_i64" (i32.const 0) (i64.const 0)))
(assert_trap (invoke "i64_set_i64" (i32.const 1) (i64.const 0)) "out of bounds")

;; f64_set: Writes 8 bytes
;; Valid range: offset + 8 <= 8 -> Max offset 0
(assert_trap (invoke "f64_set" (i32.const -1) (f64.const 0)) "out of bounds")
(assert_return (invoke "f64_set" (i32.const 0) (f64.const 0)))
(assert_trap (invoke "f64_set" (i32.const 1) (f64.const 0)) "out of bounds")


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
