;; Bulk instructions

;; invalid uses

;; array.copy
(assert_invalid
  (module
    (type $a (array i8))
    (type $b (array (mut i8)))

    (func (export "array.copy-immutable") (param $1 (ref $a)) (param $2 (ref $b))
      (array.copy $a $b (local.get $1) (i32.const 0) (local.get $2) (i32.const 0) (i32.const 0))
    )
  )
  "destination array is immutable"
)

(assert_invalid
  (module
    (type $a (array (mut i8)))
    (type $b (array i16))

    (func (export "array.copy-packed-invalid") (param $1 (ref $a)) (param $2 (ref $b))
      (array.copy $a $b (local.get $1) (i32.const 0) (local.get $2) (i32.const 0) (i32.const 0))
    )
  )
  "array types do not match"
)

(assert_invalid
  (module
    (type $a (array (mut i8)))
    (type $b (array (mut (ref $a))))

    (func (export "array.copy-ref-invalid-1") (param $1 (ref $a)) (param $2 (ref $b))
      (array.copy $a $b (local.get $1) (i32.const 0) (local.get $2) (i32.const 0) (i32.const 0))
    )
  )
  "array types do not match"
)

(assert_invalid
  (module
    (type $a (array (mut i8)))
    (type $b (array (mut (ref $a))))
    (type $c (array (mut (ref $b))))

    (func (export "array.copy-ref-invalid-1") (param $1 (ref $b)) (param $2 (ref $c))
      (array.copy $b $c (local.get $1) (i32.const 0) (local.get $2) (i32.const 0) (i32.const 0))
    )
  )
  "array types do not match"
)

;; array.fill
(assert_invalid
  (module
    (type $a (array i8))

    (func (export "array.fill-immutable") (param $1 (ref $a)) (param $2 i32)
      (array.fill $a (local.get $1) (i32.const 0) (local.get $2) (i32.const 0))
    )
  )
  "array is immutable"
)

(assert_invalid
  (module
    (type $a (array (mut i8)))

    (func (export "array.fill-invalid-1") (param $1 (ref $a)) (param $2 funcref)
      (array.fill $a (local.get $1) (i32.const 0) (local.get $2) (i32.const 0))
    )
  )
  "type mismatch"
)

(assert_invalid
  (module
    (type $b (array (mut funcref)))

    (func (export "array.fill-invalid-1") (param $1 (ref $b)) (param $2 i32)
      (array.fill $b (local.get $1) (i32.const 0) (local.get $2) (i32.const 0))
    )
  )
  "type mismatch"
)

;; array.init_data
(assert_invalid
  (module
    (type $a (array i8))

    (data $d1 "a")

    (func (export "array.init_data-immutable") (param $1 (ref $a))
      (array.init_data $a $d1 (local.get $1) (i32.const 0) (i32.const 0) (i32.const 0))
    )
  )
  "array is immutable"
)

(assert_invalid
  (module
    (type $a (array (mut funcref)))

    (data $d1 "a")

    (func (export "array.init_data-invalid-1") (param $1 (ref $a))
      (array.init_data $a $d1 (local.get $1) (i32.const 0) (i32.const 0) (i32.const 0))
    )
  )
  "array type is not numeric or vector"
)

;; array.init_elem
(assert_invalid
  (module
    (type $a (array funcref))

    (elem $e1 funcref)

    (func (export "array.init_elem-immutable") (param $1 (ref $a))
      (array.init_elem $a $e1 (local.get $1) (i32.const 0) (i32.const 0) (i32.const 0))
    )
  )
  "array is immutable"
)

(assert_invalid
  (module
    (type $a (array (mut i8)))

    (elem $e1 funcref)

    (func (export "array.init_elem-invalid-1") (param $1 (ref $a))
      (array.init_elem $a $e1 (local.get $1) (i32.const 0) (i32.const 0) (i32.const 0))
    )
  )
  "type mismatch"
)

(assert_invalid
  (module
    (type $a (array (mut funcref)))

    (elem $e1 externref)

    (func (export "array.init_elem-invalid-2") (param $1 (ref $a))
      (array.init_elem $a $e1 (local.get $1) (i32.const 0) (i32.const 0) (i32.const 0))
    )
  )
  "type mismatch"
)

(module
  (type $t_f (func))
  (type $arr8 (array i8))
  (type $arr8_mut (array (mut i8)))
  (type $arr16_mut (array (mut i16)))
  (type $arrref (array (ref $t_f)))
  (type $arrref_mut (array (mut funcref)))

  (global $g_arr8 (ref $arr8) (array.new $arr8 (i32.const 10) (i32.const 12)))
  (global $g_arr8_mut (mut (ref $arr8_mut)) (array.new_default $arr8_mut (i32.const 12)))
  (global $g_arr16_mut (ref $arr16_mut) (array.new_default $arr16_mut (i32.const 6)))
  (global $g_arrref (ref $arrref) (array.new $arrref (ref.func $dummy) (i32.const 12)))
  (global $g_arrref_mut (ref $arrref_mut) (array.new_default $arrref_mut (i32.const 12)))

  (table $t 1 funcref)

  (data $d1 "abcdefghijkl")
  (elem $e1 func $dummy $dummy $dummy $dummy $dummy $dummy $dummy $dummy $dummy $dummy $dummy $dummy)

  (func $dummy
  )

  (func (export "array_get_nth") (param $1 i32) (result i32)
    (array.get_u $arr8_mut (global.get $g_arr8_mut) (local.get $1))
  )

  (func (export "array_get_nth_i16") (param $1 i32) (result i32)
    (array.get_u $arr16_mut (global.get $g_arr16_mut) (local.get $1))
  )

  (func (export "array_call_nth") (param $1 i32)
    (table.set $t (i32.const 0) (array.get $arrref_mut (global.get $g_arrref_mut) (local.get $1)))
    (call_indirect $t (i32.const 0))
  )

  (func (export "array_copy-null-left")
    (array.copy $arr8_mut $arr8 (ref.null $arr8_mut) (i32.const 0) (global.get $g_arr8) (i32.const 0) (i32.const 0))
  )

  (func (export "array_copy-null-right")
    (array.copy $arr8_mut $arr8 (global.get $g_arr8_mut) (i32.const 0) (ref.null $arr8) (i32.const 0) (i32.const 0))
  )

  (func (export "array_fill-null")
    (array.fill $arr8_mut (ref.null $arr8_mut) (i32.const 0) (i32.const 0) (i32.const 0))
  )

  (func (export "array_init_data-null")
    (array.init_data $arr8_mut $d1 (ref.null $arr8_mut) (i32.const 0) (i32.const 0) (i32.const 0))
  )

  (func (export "array_init_elem-null")
    (array.init_elem $arrref_mut $e1 (ref.null $arrref_mut) (i32.const 0) (i32.const 0) (i32.const 0))
  )

  (func (export "array_copy") (param $1 i32) (param $2 i32) (param $3 i32)
    (array.copy $arr8_mut $arr8 (global.get $g_arr8_mut) (local.get $1) (global.get $g_arr8) (local.get $2) (local.get $3))
  )

  (func (export "array_fill") (param $1 i32) (param $2 i32) (param $3 i32)
    (array.fill $arr8_mut (global.get $g_arr8_mut) (local.get $1) (local.get $2) (local.get $3))
  )

  (func (export "array_init_data") (param $1 i32) (param $2 i32) (param $3 i32)
    (array.init_data $arr8_mut $d1 (global.get $g_arr8_mut) (local.get $1) (local.get $2) (local.get $3))
  )

  (func (export "array_init_data_i16") (param $1 i32) (param $2 i32) (param $3 i32)
    (array.init_data $arr16_mut $d1 (global.get $g_arr16_mut) (local.get $1) (local.get $2) (local.get $3))
  )

  (func (export "array_init_elem") (param $1 i32) (param $2 i32) (param $3 i32)
    (array.init_elem $arrref_mut $e1 (global.get $g_arrref_mut) (local.get $1) (local.get $2) (local.get $3))
  )

  (func (export "array_copy_overlap_test-1")
    (local $1 (ref $arr8_mut))
    (local.set $1
      (array.new_data $arr8_mut $d1 (i32.const 0) (i32.const 12))
    )
    (array.copy $arr8_mut $arr8_mut (local.get $1) (i32.const 1) (local.get $1) (i32.const 0) (i32.const 11))
    (global.set $g_arr8_mut (local.get $1))
  )

  (func (export "array_copy_overlap_test-2")
    (local $1 (ref $arr8_mut))
    (local.set $1
      (array.new_data $arr8_mut $d1 (i32.const 0) (i32.const 12))
    )
    (array.copy $arr8_mut $arr8_mut (local.get $1) (i32.const 0) (local.get $1) (i32.const 1) (i32.const 11))
    (global.set $g_arr8_mut (local.get $1))
  )

  (func (export "drop_segs")
    (data.drop $d1)
    ;; (elem.drop $e1) ;; TODO: implement elem.drop
  )
)

;; null array argument traps
(assert_trap (invoke "array_copy-null-left") "null array reference")
(assert_trap (invoke "array_copy-null-right") "null array reference")
(assert_trap (invoke "array_fill-null") "null array reference")
(assert_trap (invoke "array_init_data-null") "null array reference")
(assert_trap (invoke "array_init_elem-null") "null array reference")

;; OOB initial index traps
(assert_trap (invoke "array_copy" (i32.const 13) (i32.const 0) (i32.const 0)) "out of bounds array access")
(assert_trap (invoke "array_copy" (i32.const 0) (i32.const 13) (i32.const 0)) "out of bounds array access")
(assert_trap (invoke "array_fill" (i32.const 13) (i32.const 0) (i32.const 0)) "out of bounds array access")
(assert_trap (invoke "array_init_data" (i32.const 13) (i32.const 0) (i32.const 0)) "out of bounds array access")
(assert_trap (invoke "array_init_data" (i32.const 0) (i32.const 13) (i32.const 0)) "out of bounds memory access")
(assert_trap (invoke "array_init_elem" (i32.const 13) (i32.const 0) (i32.const 0)) "out of bounds array access")
(assert_trap (invoke "array_init_elem" (i32.const 0) (i32.const 13) (i32.const 0)) "out of bounds table access")

;; OOB length traps
(assert_trap (invoke "array_copy" (i32.const 0) (i32.const 0) (i32.const 13)) "out of bounds array access")
(assert_trap (invoke "array_copy" (i32.const 0) (i32.const 0) (i32.const 13)) "out of bounds array access")
(assert_trap (invoke "array_fill" (i32.const 0) (i32.const 0) (i32.const 13)) "out of bounds array access")
(assert_trap (invoke "array_init_data" (i32.const 0) (i32.const 0) (i32.const 13)) "out of bounds array access")
(assert_trap (invoke "array_init_data" (i32.const 0) (i32.const 0) (i32.const 13)) "out of bounds array access")
(assert_trap (invoke "array_init_data_i16" (i32.const 0) (i32.const 0) (i32.const 7)) "out of bounds array access")
(assert_trap (invoke "array_init_elem" (i32.const 0) (i32.const 0) (i32.const 13)) "out of bounds array access")
(assert_trap (invoke "array_init_elem" (i32.const 0) (i32.const 0) (i32.const 13)) "out of bounds array access")

;; start index = array size, len = 0 doesn't trap
(assert_return (invoke "array_copy" (i32.const 12) (i32.const 0) (i32.const 0)))
(assert_return (invoke "array_copy" (i32.const 0) (i32.const 12) (i32.const 0)))
(assert_return (invoke "array_fill" (i32.const 12) (i32.const 0) (i32.const 0)))
(assert_return (invoke "array_init_data" (i32.const 12) (i32.const 0) (i32.const 0)))
(assert_return (invoke "array_init_data" (i32.const 0) (i32.const 12) (i32.const 0)))
(assert_return (invoke "array_init_data_i16" (i32.const 0) (i32.const 6) (i32.const 0)))
(assert_return (invoke "array_init_elem" (i32.const 12) (i32.const 0) (i32.const 0)))
(assert_return (invoke "array_init_elem" (i32.const 0) (i32.const 12) (i32.const 0)))

;; check arrays were not modified
(assert_return (invoke "array_get_nth" (i32.const 0)) (i32.const 0))
(assert_return (invoke "array_get_nth" (i32.const 5)) (i32.const 0))
(assert_return (invoke "array_get_nth" (i32.const 11)) (i32.const 0))
(assert_trap (invoke "array_get_nth" (i32.const 12)) "out of bounds array access")
(assert_return (invoke "array_get_nth_i16" (i32.const 0)) (i32.const 0))
(assert_return (invoke "array_get_nth_i16" (i32.const 2)) (i32.const 0))
(assert_return (invoke "array_get_nth_i16" (i32.const 5)) (i32.const 0))
(assert_trap (invoke "array_get_nth" (i32.const 12)) "out of bounds array access")
(assert_trap (invoke "array_call_nth" (i32.const 0)) "uninitialized element")
(assert_trap (invoke "array_call_nth" (i32.const 5)) "uninitialized element")
(assert_trap (invoke "array_call_nth" (i32.const 11)) "uninitialized element")
(assert_trap (invoke "array_call_nth" (i32.const 12)) "out of bounds array access")

;; normal cases
(assert_return (invoke "array_copy" (i32.const 0) (i32.const 0) (i32.const 2)))
(assert_return (invoke "array_get_nth" (i32.const 0)) (i32.const 10))
(assert_return (invoke "array_get_nth" (i32.const 1)) (i32.const 10))
(assert_return (invoke "array_get_nth" (i32.const 2)) (i32.const 0))

(assert_return (invoke "array_fill" (i32.const 2) (i32.const 11) (i32.const 2)))
(assert_return (invoke "array_get_nth" (i32.const 1)) (i32.const 10))
(assert_return (invoke "array_get_nth" (i32.const 2)) (i32.const 11))
(assert_return (invoke "array_get_nth" (i32.const 3)) (i32.const 11))
(assert_return (invoke "array_get_nth" (i32.const 4)) (i32.const 0))

(assert_return (invoke "array_init_data" (i32.const 4) (i32.const 2) (i32.const 2)))
(assert_return (invoke "array_get_nth" (i32.const 3)) (i32.const 11))
(assert_return (invoke "array_get_nth" (i32.const 4)) (i32.const 99))
(assert_return (invoke "array_get_nth" (i32.const 5)) (i32.const 100))
(assert_return (invoke "array_get_nth" (i32.const 6)) (i32.const 0))

(assert_return (invoke "array_init_data_i16" (i32.const 2) (i32.const 5) (i32.const 2)))
(assert_return (invoke "array_get_nth_i16" (i32.const 1)) (i32.const 0))
(assert_return (invoke "array_get_nth_i16" (i32.const 2)) (i32.const 0x6766))
(assert_return (invoke "array_get_nth_i16" (i32.const 3)) (i32.const 0x6968))
(assert_return (invoke "array_get_nth_i16" (i32.const 4)) (i32.const 0))

(assert_return (invoke "array_init_elem" (i32.const 2) (i32.const 3) (i32.const 2)))
(assert_trap (invoke "array_call_nth" (i32.const 1)) "uninitialized element")
(assert_return (invoke "array_call_nth" (i32.const 2)))
(assert_return (invoke "array_call_nth" (i32.const 3)))
(assert_trap (invoke "array_call_nth" (i32.const 4)) "uninitialized element")

;; test that overlapping array.copy works as if intermediate copy taken
(assert_return (invoke "array_copy_overlap_test-1"))
(assert_return (invoke "array_get_nth" (i32.const 0)) (i32.const 97))
(assert_return (invoke "array_get_nth" (i32.const 1)) (i32.const 97))
(assert_return (invoke "array_get_nth" (i32.const 2)) (i32.const 98))
(assert_return (invoke "array_get_nth" (i32.const 5)) (i32.const 101))
(assert_return (invoke "array_get_nth" (i32.const 10)) (i32.const 106))
(assert_return (invoke "array_get_nth" (i32.const 11)) (i32.const 107))

(assert_return (invoke "array_copy_overlap_test-2"))
(assert_return (invoke "array_get_nth" (i32.const 0)) (i32.const 98))
(assert_return (invoke "array_get_nth" (i32.const 1)) (i32.const 99))
(assert_return (invoke "array_get_nth" (i32.const 5)) (i32.const 103))
(assert_return (invoke "array_get_nth" (i32.const 9)) (i32.const 107))
(assert_return (invoke "array_get_nth" (i32.const 10)) (i32.const 108))
(assert_return (invoke "array_get_nth" (i32.const 11)) (i32.const 108))

;; init_data/elem with dropped segments traps for non-zero length
(assert_return (invoke "drop_segs"))
(assert_return (invoke "array_init_data" (i32.const 0) (i32.const 0) (i32.const 0)))
(assert_trap (invoke "array_init_data" (i32.const 0) (i32.const 0) (i32.const 1)) "out of bounds memory access")
(assert_return (invoke "array_init_elem" (i32.const 0) (i32.const 0) (i32.const 0)))
;; (assert_trap (invoke "array_init_elem" (i32.const 0) (i32.const 0) (i32.const 1)) "out of bounds table access") ;; TODO: implement elem.drop
