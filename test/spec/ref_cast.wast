(module
  (type $t0  (sub (struct)))
  (type $t1  (sub $t0 (struct (field i32))))
  (type $t1' (sub $t1 (struct (field i32))))
  (type $t2  (sub $t1 (struct (field i32) (field i32))))
  (type $t2' (sub $t2 (struct (field i32) (field i32))))
  (type $t3  (sub $t2 (struct (field i32) (field i32))))

  (global $tab.0  (mut (ref null struct)) (ref.null struct))
  (global $tab.1  (mut (ref null struct)) (ref.null struct))
  (global $tab.2  (mut (ref null struct)) (ref.null struct))
  (global $tab.3  (mut (ref null struct)) (ref.null struct))
  (global $tab.4  (mut (ref null struct)) (ref.null struct))
  (global $tab.10 (mut (ref null struct)) (ref.null struct))
  (global $tab.11 (mut (ref null struct)) (ref.null struct))
  (global $tab.12 (mut (ref null struct)) (ref.null struct))

  (func $init
    (global.set $tab.0  (struct.new_default $t0))
    (global.set $tab.10 (struct.new_default $t0))
    (global.set $tab.1  (struct.new_default $t1))
    (global.set $tab.11 (struct.new_default $t1'))
    (global.set $tab.2  (struct.new_default $t2))
    (global.set $tab.12 (struct.new_default $t2'))
    (global.set $tab.3  (struct.new_default $t3))
    (global.set $tab.4  (struct.new_default $t3))
  )

  (func (export "test-sub")
    (call $init)

    (drop (ref.cast (ref null $t0) (ref.null struct)))
    (drop (ref.cast (ref null $t0) (struct.new_default $t0)))
    (drop (ref.cast (ref null $t0) (global.get $tab.0)))
    (drop (ref.cast (ref null $t0) (global.get $tab.1)))
    (drop (ref.cast (ref null $t0) (global.get $tab.2)))
    (drop (ref.cast (ref null $t0) (global.get $tab.3)))
    (drop (ref.cast (ref null $t0) (global.get $tab.4)))
    (drop (ref.cast (ref $t0) (global.get $tab.0)))
    (drop (ref.cast (ref $t0) (global.get $tab.1)))
    (drop (ref.cast (ref $t0) (global.get $tab.2)))
    (drop (ref.cast (ref $t0) (global.get $tab.3)))
    (drop (ref.cast (ref $t0) (global.get $tab.4)))

    (drop (ref.cast (ref null $t1) (ref.null struct)))
    (drop (ref.cast (ref null $t1) (struct.new_default $t1)))
    (drop (ref.cast (ref null $t1) (global.get $tab.1)))
    (drop (ref.cast (ref null $t1) (global.get $tab.2)))
    (drop (ref.cast (ref $t1) (global.get $tab.1)))
    (drop (ref.cast (ref $t1) (global.get $tab.2)))

    (drop (ref.cast (ref null $t2) (ref.null struct)))
    (drop (ref.cast (ref null $t2) (struct.new_default $t2)))
    (drop (ref.cast (ref null $t2) (global.get $tab.2)))
    (drop (ref.cast (ref $t2) (global.get $tab.2)))

    (drop (ref.cast (ref null $t3) (ref.null struct)))
    (drop (ref.cast (ref null $t3) (struct.new_default $t3)))
    (drop (ref.cast (ref null $t3) (global.get $tab.3)))
    (drop (ref.cast (ref $t3) (global.get $tab.3)))
  )

  (func (export "test-canon")
    (call $init)

    (drop (ref.cast (ref null $t0) (global.get $tab.10)))
    (drop (ref.cast (ref null $t0) (global.get $tab.11)))
    (drop (ref.cast (ref null $t0) (global.get $tab.12)))

    (drop (ref.cast (ref null $t1) (global.get $tab.11)))
    (drop (ref.cast (ref null $t1) (global.get $tab.12)))

    (drop (ref.cast (ref null $t2) (global.get $tab.12)))
  )

  (func (export "test-ref-test-t0") (result i32)
    (ref.test (ref $t0) (struct.new $t0))
  )

  (func (export "test-ref-test-struct") (result i32)
    (ref.test (ref struct) (struct.new $t0))
  )

  (func (export "test-ref-test-any") (result i32)
    (ref.test (ref any) (struct.new $t0))
  )

  (func (export "test-ref-cast-struct")
    (drop
      (ref.cast (ref struct) (struct.new $t0))
    )
  )

  (func (export "test-br-on-cast-struct") (result i32)
    (drop
      (block $l (result (ref struct))
        (drop
          (br_on_cast $l anyref (ref struct) (struct.new $t0))
        )
        (return (i32.const 0))
      )
    )
    (i32.const 1)
  )

  (func (export "test-br-on-cast-null-struct") (result i32)
    (drop
      (block $l (result (ref null struct))
        (drop
          (br_on_cast $l anyref structref (ref.null none))
        )
        (return (i32.const 0))
      )
    )
    (i32.const 1)
  )

  (func (export "test-br-on-cast-fail-struct") (result i32)
    (drop
      (block $l (result (ref struct))
        (drop
          (br_on_cast_fail $l anyref (ref struct) (struct.new $t0))
        )
        (return (i32.const 0))
      )
    )
    (i32.const 1)
  )

  (func (export "test-br-on-cast-fail-null-struct") (result i32)
    (drop
      (block $l (result (ref struct))
        (drop
          (br_on_cast_fail $l anyref structref (ref.null none))
        )
        (return (i32.const 0))
      )
    )
    (i32.const 1)
  )

  (func (export "test-trap-null")
    (drop
      (ref.cast (ref $t0)
        (ref.null $t0)
      )
    )
  )
)

(invoke "test-sub")
(invoke "test-canon")
(assert_return (invoke "test-ref-test-t0") (i32.const 1))
(assert_return (invoke "test-ref-test-struct") (i32.const 1))
(assert_return (invoke "test-ref-test-any") (i32.const 1))
(assert_return (invoke "test-ref-cast-struct"))
(assert_return (invoke "test-br-on-cast-struct") (i32.const 1))
(assert_return (invoke "test-br-on-cast-null-struct") (i32.const 1))
(assert_return (invoke "test-br-on-cast-fail-struct") (i32.const 0))
(assert_return (invoke "test-br-on-cast-fail-null-struct") (i32.const 0))
(assert_trap (invoke "test-trap-null") "null")

(assert_invalid
  (module
    (type $t0 (struct))
    (func (export "test-ref-test-extern") (result i32)
      (ref.test (ref extern) (struct.new $t0))
    )
  )
  "common supertype"
)

(assert_invalid
  (module
    (type $t0 (struct))
    (func (export "test-ref-cast-extern") (result anyref)
      (ref.cast (ref extern) (struct.new $t0))
    )
  )
  "common supertype"
)

(assert_malformed
  (module quote "(func (ref.cast i32 (unreachable)))")
  "expected reftype"
)
