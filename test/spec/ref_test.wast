;; Abstract Types

(module
  (type $ft (func))
  (type $st (struct))
  (type $at (array i8))

  (table $ta 10 anyref)
  (table $tf 10 funcref)
  (table $te 10 externref)

  (elem declare func $f)
  (func $f)

  (func (export "init")
    (table.set $ta (i32.const 0) (ref.null any))
    (table.set $ta (i32.const 1) (ref.null struct))
    (table.set $ta (i32.const 2) (ref.null none))
    (table.set $ta (i32.const 3) (i31.new (i32.const 7)))
    (table.set $ta (i32.const 4) (struct.new_default $st))
    (table.set $ta (i32.const 5) (array.new_default $at (i32.const 0)))
    ;; (table.set $ta (i32.const 6) (extern.internalize (extern.externalize (i31.new (i32.const 0)))))
    ;; (table.set $ta (i32.const 7) (extern.internalize (ref.null extern)))

    (table.set $tf (i32.const 0) (ref.null nofunc))
    (table.set $tf (i32.const 1) (ref.null func))
    (table.set $tf (i32.const 2) (ref.func $f))

    (table.set $te (i32.const 0) (ref.null noextern))
    (table.set $te (i32.const 1) (ref.null extern))
    ;; (table.set $te (i32.const 2) (extern.externalize (i31.new (i32.const 0))))
    ;; (table.set $te (i32.const 3) (extern.externalize (i31.new (i32.const 8))))
    ;; (table.set $te (i32.const 4) (extern.externalize (struct.new_default $st)))
    ;; (table.set $te (i32.const 5) (extern.externalize (ref.null any)))
  )

  (func (export "ref_test_null_data") (param $i i32) (result i32)
    (i32.add
      (ref.is_null (table.get $ta (local.get $i)))
      (ref.test null none (table.get $ta (local.get $i)))
    )
  )
  (func (export "ref_test_any") (param $i i32) (result i32)
    (i32.add
      (ref.test any (table.get $ta (local.get $i)))
      (ref.test null any (table.get $ta (local.get $i)))
    )
  )
  (func (export "ref_test_eq") (param $i i32) (result i32)
    (i32.add
      (ref.test eq (table.get $ta (local.get $i)))
      (ref.test null eq (table.get $ta (local.get $i)))
    )
  )
  (func (export "ref_test_i31") (param $i i32) (result i32)
    (i32.add
      (ref.test i31 (table.get $ta (local.get $i)))
      (ref.test null i31 (table.get $ta (local.get $i)))
    )
  )
  (func (export "ref_test_struct") (param $i i32) (result i32)
    (i32.add
      (ref.test struct (table.get $ta (local.get $i)))
      (ref.test null struct (table.get $ta (local.get $i)))
    )
  )
  (func (export "ref_test_array") (param $i i32) (result i32)
    (i32.add
      (ref.test array (table.get $ta (local.get $i)))
      (ref.test null array (table.get $ta (local.get $i)))
    )
  )

  (func (export "ref_test_null_func") (param $i i32) (result i32)
    (i32.add
      (ref.is_null (table.get $tf (local.get $i)))
      (ref.test null nofunc (table.get $tf (local.get $i)))
    )
  )
  (func (export "ref_test_func") (param $i i32) (result i32)
    (i32.add
      (ref.test func (table.get $tf (local.get $i)))
      (ref.test null func (table.get $tf (local.get $i)))
    )
  )

  (func (export "ref_test_null_extern") (param $i i32) (result i32)
    (i32.add
      (ref.is_null (table.get $te (local.get $i)))
      (ref.test null noextern (table.get $te (local.get $i)))
    )
  )
  (func (export "ref_test_extern") (param $i i32) (result i32)
    (i32.add
      (ref.test extern (table.get $te (local.get $i)))
      (ref.test null extern (table.get $te (local.get $i)))
    )
  )
)

(invoke "init")

(assert_return (invoke "ref_test_null_data" (i32.const 0)) (i32.const 2))
(assert_return (invoke "ref_test_null_data" (i32.const 1)) (i32.const 2))
(assert_return (invoke "ref_test_null_data" (i32.const 2)) (i32.const 2))
(assert_return (invoke "ref_test_null_data" (i32.const 3)) (i32.const 0))
(assert_return (invoke "ref_test_null_data" (i32.const 4)) (i32.const 0))
(assert_return (invoke "ref_test_null_data" (i32.const 5)) (i32.const 0))
;; (assert_return (invoke "ref_test_null_data" (i32.const 6)) (i32.const 0))
;; (assert_return (invoke "ref_test_null_data" (i32.const 7)) (i32.const 2))

(assert_return (invoke "ref_test_any" (i32.const 0)) (i32.const 1))
(assert_return (invoke "ref_test_any" (i32.const 1)) (i32.const 1))
(assert_return (invoke "ref_test_any" (i32.const 2)) (i32.const 1))
(assert_return (invoke "ref_test_any" (i32.const 3)) (i32.const 2))
(assert_return (invoke "ref_test_any" (i32.const 4)) (i32.const 2))
(assert_return (invoke "ref_test_any" (i32.const 5)) (i32.const 2))
;; (assert_return (invoke "ref_test_any" (i32.const 6)) (i32.const 2))
;; (assert_return (invoke "ref_test_any" (i32.const 7)) (i32.const 1))

(assert_return (invoke "ref_test_eq" (i32.const 0)) (i32.const 1))
(assert_return (invoke "ref_test_eq" (i32.const 1)) (i32.const 1))
(assert_return (invoke "ref_test_eq" (i32.const 2)) (i32.const 1))
(assert_return (invoke "ref_test_eq" (i32.const 3)) (i32.const 2))
(assert_return (invoke "ref_test_eq" (i32.const 4)) (i32.const 2))
(assert_return (invoke "ref_test_eq" (i32.const 5)) (i32.const 2))
;; (assert_return (invoke "ref_test_eq" (i32.const 6)) (i32.const 0))
;; (assert_return (invoke "ref_test_eq" (i32.const 7)) (i32.const 1))

(assert_return (invoke "ref_test_i31" (i32.const 0)) (i32.const 1))
(assert_return (invoke "ref_test_i31" (i32.const 1)) (i32.const 1))
(assert_return (invoke "ref_test_i31" (i32.const 2)) (i32.const 1))
(assert_return (invoke "ref_test_i31" (i32.const 3)) (i32.const 2))
(assert_return (invoke "ref_test_i31" (i32.const 4)) (i32.const 0))
(assert_return (invoke "ref_test_i31" (i32.const 5)) (i32.const 0))
;; (assert_return (invoke "ref_test_i31" (i32.const 6)) (i32.const 0))
;; (assert_return (invoke "ref_test_i31" (i32.const 7)) (i32.const 1))

(assert_return (invoke "ref_test_struct" (i32.const 0)) (i32.const 1))
(assert_return (invoke "ref_test_struct" (i32.const 1)) (i32.const 1))
(assert_return (invoke "ref_test_struct" (i32.const 2)) (i32.const 1))
(assert_return (invoke "ref_test_struct" (i32.const 3)) (i32.const 0))
(assert_return (invoke "ref_test_struct" (i32.const 4)) (i32.const 2))
(assert_return (invoke "ref_test_struct" (i32.const 5)) (i32.const 0))
;; (assert_return (invoke "ref_test_struct" (i32.const 6)) (i32.const 0))
;; (assert_return (invoke "ref_test_struct" (i32.const 7)) (i32.const 1))

(assert_return (invoke "ref_test_array" (i32.const 0)) (i32.const 1))
(assert_return (invoke "ref_test_array" (i32.const 1)) (i32.const 1))
(assert_return (invoke "ref_test_array" (i32.const 2)) (i32.const 1))
(assert_return (invoke "ref_test_array" (i32.const 3)) (i32.const 0))
(assert_return (invoke "ref_test_array" (i32.const 4)) (i32.const 0))
(assert_return (invoke "ref_test_array" (i32.const 5)) (i32.const 2))
;; (assert_return (invoke "ref_test_array" (i32.const 6)) (i32.const 0))
;; (assert_return (invoke "ref_test_array" (i32.const 7)) (i32.const 1))

(assert_return (invoke "ref_test_null_func" (i32.const 0)) (i32.const 2))
(assert_return (invoke "ref_test_null_func" (i32.const 1)) (i32.const 2))
(assert_return (invoke "ref_test_null_func" (i32.const 2)) (i32.const 0))

(assert_return (invoke "ref_test_func" (i32.const 0)) (i32.const 1))
(assert_return (invoke "ref_test_func" (i32.const 1)) (i32.const 1))
(assert_return (invoke "ref_test_func" (i32.const 2)) (i32.const 2))

(assert_return (invoke "ref_test_null_extern" (i32.const 0)) (i32.const 2))
(assert_return (invoke "ref_test_null_extern" (i32.const 1)) (i32.const 2))
;; (assert_return (invoke "ref_test_null_extern" (i32.const 2)) (i32.const 0))
;; (assert_return (invoke "ref_test_null_extern" (i32.const 3)) (i32.const 0))
;; (assert_return (invoke "ref_test_null_extern" (i32.const 4)) (i32.const 0))
;; (assert_return (invoke "ref_test_null_extern" (i32.const 5)) (i32.const 2))

(assert_return (invoke "ref_test_extern" (i32.const 0)) (i32.const 1))
(assert_return (invoke "ref_test_extern" (i32.const 1)) (i32.const 1))
;; (assert_return (invoke "ref_test_extern" (i32.const 2)) (i32.const 2))
;; (assert_return (invoke "ref_test_extern" (i32.const 3)) (i32.const 2))
;; (assert_return (invoke "ref_test_extern" (i32.const 4)) (i32.const 2))
;; (assert_return (invoke "ref_test_extern" (i32.const 5)) (i32.const 1))


;; Concrete Types

(module
  (type $t0 (struct_subtype data))
  (type $t1 (struct_subtype i32 $t0))
  (type $t1' (struct_subtype i32 $t0))
  (type $t2 (struct_subtype i32 i32 $t1))
  (type $t2' (struct_subtype i32 i32 $t1'))
  (type $t3 (struct_subtype i32 i32 $t0))
  (type $t0' (struct_subtype $t0))
  (type $t4 (struct_subtype i32 i32 $t0'))

  (table $tab 20 (ref null struct))

  (func $init
    (table.set $tab (i32.const 0) (struct.new_default $t0))
    (table.set $tab (i32.const 10) (struct.new_default $t0))
    (table.set $tab (i32.const 1) (struct.new_default $t1))
    (table.set $tab (i32.const 11) (struct.new_default $t1'))
    (table.set $tab (i32.const 2) (struct.new_default $t2))
    (table.set $tab (i32.const 12) (struct.new_default $t2'))
    (table.set $tab (i32.const 3) (struct.new_default $t3))
    (table.set $tab (i32.const 4) (struct.new_default $t4))
  )

  (func (export "test-sub")
    (call $init)
    (block $l
      ;; must hold
      (br_if $l (i32.eqz (ref.test null $t0 (ref.null struct))))
      (br_if $l (i32.eqz (ref.test null $t0 (ref.null $t0))))
      (br_if $l (i32.eqz (ref.test null $t0 (ref.null $t1))))
      (br_if $l (i32.eqz (ref.test null $t0 (ref.null $t2))))
      (br_if $l (i32.eqz (ref.test null $t0 (ref.null $t3))))
      (br_if $l (i32.eqz (ref.test null $t0 (ref.null $t4))))
      (br_if $l (i32.eqz (ref.test null $t0 (table.get $tab (i32.const 0)))))
      (br_if $l (i32.eqz (ref.test null $t0 (table.get $tab (i32.const 1)))))
      (br_if $l (i32.eqz (ref.test null $t0 (table.get $tab (i32.const 2)))))
      (br_if $l (i32.eqz (ref.test null $t0 (table.get $tab (i32.const 3)))))
      (br_if $l (i32.eqz (ref.test null $t0 (table.get $tab (i32.const 4)))))

      (br_if $l (i32.eqz (ref.test null $t1 (ref.null struct))))
      (br_if $l (i32.eqz (ref.test null $t1 (ref.null $t0))))
      (br_if $l (i32.eqz (ref.test null $t1 (ref.null $t1))))
      (br_if $l (i32.eqz (ref.test null $t1 (ref.null $t2))))
      (br_if $l (i32.eqz (ref.test null $t1 (ref.null $t3))))
      (br_if $l (i32.eqz (ref.test null $t1 (ref.null $t4))))
      (br_if $l (i32.eqz (ref.test null $t1 (table.get $tab (i32.const 1)))))
      (br_if $l (i32.eqz (ref.test null $t1 (table.get $tab (i32.const 2)))))

      (br_if $l (i32.eqz (ref.test null $t2 (ref.null struct))))
      (br_if $l (i32.eqz (ref.test null $t2 (ref.null $t0))))
      (br_if $l (i32.eqz (ref.test null $t2 (ref.null $t1))))
      (br_if $l (i32.eqz (ref.test null $t2 (ref.null $t2))))
      (br_if $l (i32.eqz (ref.test null $t2 (ref.null $t3))))
      (br_if $l (i32.eqz (ref.test null $t2 (ref.null $t4))))
      (br_if $l (i32.eqz (ref.test null $t2 (table.get $tab (i32.const 2)))))

      (br_if $l (i32.eqz (ref.test null $t3 (ref.null struct))))
      (br_if $l (i32.eqz (ref.test null $t3 (ref.null $t0))))
      (br_if $l (i32.eqz (ref.test null $t3 (ref.null $t1))))
      (br_if $l (i32.eqz (ref.test null $t3 (ref.null $t2))))
      (br_if $l (i32.eqz (ref.test null $t3 (ref.null $t3))))
      (br_if $l (i32.eqz (ref.test null $t3 (ref.null $t4))))
      (br_if $l (i32.eqz (ref.test null $t3 (table.get $tab (i32.const 3)))))

      (br_if $l (i32.eqz (ref.test null $t4 (ref.null struct))))
      (br_if $l (i32.eqz (ref.test null $t4 (ref.null $t0))))
      (br_if $l (i32.eqz (ref.test null $t4 (ref.null $t1))))
      (br_if $l (i32.eqz (ref.test null $t4 (ref.null $t2))))
      (br_if $l (i32.eqz (ref.test null $t4 (ref.null $t3))))
      (br_if $l (i32.eqz (ref.test null $t4 (ref.null $t4))))
      (br_if $l (i32.eqz (ref.test null $t4 (table.get $tab (i32.const 4)))))

      (br_if $l (i32.eqz (ref.test $t0 (table.get $tab (i32.const 0)))))
      (br_if $l (i32.eqz (ref.test $t0 (table.get $tab (i32.const 1)))))
      (br_if $l (i32.eqz (ref.test $t0 (table.get $tab (i32.const 2)))))
      (br_if $l (i32.eqz (ref.test $t0 (table.get $tab (i32.const 3)))))
      (br_if $l (i32.eqz (ref.test $t0 (table.get $tab (i32.const 4)))))

      (br_if $l (i32.eqz (ref.test $t1 (table.get $tab (i32.const 1)))))
      (br_if $l (i32.eqz (ref.test $t1 (table.get $tab (i32.const 2)))))

      (br_if $l (i32.eqz (ref.test $t2 (table.get $tab (i32.const 2)))))

      (br_if $l (i32.eqz (ref.test $t3 (table.get $tab (i32.const 3)))))

      (br_if $l (i32.eqz (ref.test $t4 (table.get $tab (i32.const 4)))))

      ;; must not hold
      (br_if $l (ref.test $t0 (ref.null struct)))
      (br_if $l (ref.test $t1 (ref.null struct)))
      (br_if $l (ref.test $t2 (ref.null struct)))
      (br_if $l (ref.test $t3 (ref.null struct)))
      (br_if $l (ref.test $t4 (ref.null struct)))

      (br_if $l (ref.test $t1 (table.get $tab (i32.const 0))))
      (br_if $l (ref.test $t1 (table.get $tab (i32.const 3))))
      (br_if $l (ref.test $t1 (table.get $tab (i32.const 4))))

      (br_if $l (ref.test $t2 (table.get $tab (i32.const 0))))
      (br_if $l (ref.test $t2 (table.get $tab (i32.const 1))))
      (br_if $l (ref.test $t2 (table.get $tab (i32.const 3))))
      (br_if $l (ref.test $t2 (table.get $tab (i32.const 4))))

      (br_if $l (ref.test $t3 (table.get $tab (i32.const 0))))
      (br_if $l (ref.test $t3 (table.get $tab (i32.const 1))))
      (br_if $l (ref.test $t3 (table.get $tab (i32.const 2))))
      (br_if $l (ref.test $t3 (table.get $tab (i32.const 4))))

      (br_if $l (ref.test $t4 (table.get $tab (i32.const 0))))
      (br_if $l (ref.test $t4 (table.get $tab (i32.const 1))))
      (br_if $l (ref.test $t4 (table.get $tab (i32.const 2))))
      (br_if $l (ref.test $t4 (table.get $tab (i32.const 3))))

      (return)
    )
    (unreachable)
  )

  (func (export "test-canon")
    (call $init)
    (block $l
      (br_if $l (i32.eqz (ref.test $t0 (table.get $tab (i32.const 0)))))
      (br_if $l (i32.eqz (ref.test $t0 (table.get $tab (i32.const 1)))))
      (br_if $l (i32.eqz (ref.test $t0 (table.get $tab (i32.const 2)))))
      (br_if $l (i32.eqz (ref.test $t0 (table.get $tab (i32.const 3)))))
      (br_if $l (i32.eqz (ref.test $t0 (table.get $tab (i32.const 4)))))

      (br_if $l (i32.eqz (ref.test $t0 (table.get $tab (i32.const 10)))))
      (br_if $l (i32.eqz (ref.test $t0 (table.get $tab (i32.const 11)))))
      (br_if $l (i32.eqz (ref.test $t0 (table.get $tab (i32.const 12)))))

      (br_if $l (i32.eqz (ref.test $t1' (table.get $tab (i32.const 1)))))
      (br_if $l (i32.eqz (ref.test $t1' (table.get $tab (i32.const 2)))))

      (br_if $l (i32.eqz (ref.test $t1 (table.get $tab (i32.const 11)))))
      (br_if $l (i32.eqz (ref.test $t1 (table.get $tab (i32.const 12)))))

      (br_if $l (i32.eqz (ref.test $t2' (table.get $tab (i32.const 2)))))

      (br_if $l (i32.eqz (ref.test $t2 (table.get $tab (i32.const 12)))))

      (return)
    )
    (unreachable)
  )
)

(invoke "test-sub")
(invoke "test-canon")
