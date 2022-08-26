(module
  (type $t0  (struct))
  (type $t1  (struct (field i32)))
  (type $t1' (struct (field i32)))
  (type $t2  (struct (field i32) (field i32)))
  (type $t2' (struct (field i32) (field i32)))
  (type $t3  (struct (field i32) (field i32)))

  (global $tab.0  (mut (ref null data)) (ref.null data))
  (global $tab.1  (mut (ref null data)) (ref.null data))
  (global $tab.2  (mut (ref null data)) (ref.null data))
  (global $tab.3  (mut (ref null data)) (ref.null data))
  (global $tab.4  (mut (ref null data)) (ref.null data))
  (global $tab.10 (mut (ref null data)) (ref.null data))
  (global $tab.11 (mut (ref null data)) (ref.null data))
  (global $tab.12 (mut (ref null data)) (ref.null data))

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

    (drop (ref.cast_static $t0 (ref.null data)))
    (drop (ref.cast_static $t0 (global.get $tab.0)))
    (drop (ref.cast_static $t0 (global.get $tab.1)))
    (drop (ref.cast_static $t0 (global.get $tab.2)))
    (drop (ref.cast_static $t0 (global.get $tab.3)))
    (drop (ref.cast_static $t0 (global.get $tab.4)))

    (drop (ref.cast_static $t0 (ref.null data)))
    (drop (ref.cast_static $t1 (global.get $tab.1)))
    (drop (ref.cast_static $t1 (global.get $tab.2)))

    (drop (ref.cast_static $t0 (ref.null data)))
    (drop (ref.cast_static $t2 (global.get $tab.2)))

    (drop (ref.cast_static $t0 (ref.null data)))
    (drop (ref.cast_static $t3 (global.get $tab.3)))

    (drop (ref.cast_static $t0 (ref.null data)))
  )

  (func (export "test-canon")
    (call $init)

    (drop (ref.cast_static $t0 (global.get $tab.10)))
    (drop (ref.cast_static $t0 (global.get $tab.11)))
    (drop (ref.cast_static $t0 (global.get $tab.12)))

    (drop (ref.cast_static $t1' (global.get $tab.1)))
    (drop (ref.cast_static $t1' (global.get $tab.2)))

    (drop (ref.cast_static $t1 (global.get $tab.11)))
    (drop (ref.cast_static $t1 (global.get $tab.12)))

    (drop (ref.cast_static $t2' (global.get $tab.2)))

    (drop (ref.cast_static $t2 (global.get $tab.12)))
  )
)

(invoke "test-sub")
(invoke "test-canon")
