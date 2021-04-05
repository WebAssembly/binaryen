(module
  (type $t0  (struct))
  (type $t1  (struct (field i32)))
  (type $t1' (struct (field i32)))
  (type $t2  (struct (field i32) (field i32)))
  (type $t2' (struct (field i32) (field i32)))
  (type $t3  (struct (field i32) (field i32)))

  (global $t0  (rtt $t0)  (rtt.canon $t0))
  (global $t0' (rtt $t0)  (rtt.canon $t0))
  (global $t1  (rtt $t1)  (rtt.sub $t1  (global.get $t0)))
  (global $t1' (rtt $t1') (rtt.sub $t1' (global.get $t0)))
  (global $t2  (rtt $t2)  (rtt.sub $t2  (global.get $t1)))
  (global $t2' (rtt $t2') (rtt.sub $t2' (global.get $t1')))
  (global $t3  (rtt $t3)  (rtt.sub $t3  (global.get $t0)))
  (global $t4  (rtt $t3)  (rtt.sub $t3  (rtt.sub $t0 (global.get $t0))))

  (global $tab.0  (mut (ref null data)) (ref.null data))
  (global $tab.1  (mut (ref null data)) (ref.null data))
  (global $tab.2  (mut (ref null data)) (ref.null data))
  (global $tab.3  (mut (ref null data)) (ref.null data))
  (global $tab.4  (mut (ref null data)) (ref.null data))
  (global $tab.10 (mut (ref null data)) (ref.null data))
  (global $tab.11 (mut (ref null data)) (ref.null data))
  (global $tab.12 (mut (ref null data)) (ref.null data))

  (func $init
    (global.set $tab.0  (struct.new_default_with_rtt $t0  (global.get $t0)))
    (global.set $tab.10 (struct.new_default_with_rtt $t0  (global.get $t0')))
    (global.set $tab.1  (struct.new_default_with_rtt $t1  (global.get $t1)))
    (global.set $tab.11 (struct.new_default_with_rtt $t1' (global.get $t1')))
    (global.set $tab.2  (struct.new_default_with_rtt $t2  (global.get $t2)))
    (global.set $tab.12 (struct.new_default_with_rtt $t2' (global.get $t2')))
    (global.set $tab.3  (struct.new_default_with_rtt $t3  (global.get $t3)))
    (global.set $tab.4  (struct.new_default_with_rtt $t3  (global.get $t4)))
  )

  (func (export "test-sub")
    (call $init)

    (drop (ref.cast (ref.null data) (global.get $t0)))
    (drop (ref.cast (global.get $tab.0) (global.get $t0)))
    (drop (ref.cast (global.get $tab.1) (global.get $t0)))
    (drop (ref.cast (global.get $tab.2) (global.get $t0)))
    (drop (ref.cast (global.get $tab.3) (global.get $t0)))
    (drop (ref.cast (global.get $tab.4) (global.get $t0)))

    (drop (ref.cast (ref.null data) (global.get $t0)))
    (drop (ref.cast (global.get $tab.1) (global.get $t1)))
    (drop (ref.cast (global.get $tab.2) (global.get $t1)))

    (drop (ref.cast (ref.null data) (global.get $t0)))
    (drop (ref.cast (global.get $tab.2) (global.get $t2)))

    (drop (ref.cast (ref.null data) (global.get $t0)))
    (drop (ref.cast (global.get $tab.3) (global.get $t3)))

    (drop (ref.cast (ref.null data) (global.get $t0)))
    (drop (ref.cast (global.get $tab.4) (global.get $t4)))
  )

  (func (export "test-canon")
    (call $init)

    (drop (ref.cast (global.get $tab.0) (global.get $t0')))
    (drop (ref.cast (global.get $tab.1) (global.get $t0')))
    (drop (ref.cast (global.get $tab.2) (global.get $t0')))
    (drop (ref.cast (global.get $tab.3) (global.get $t0')))
    (drop (ref.cast (global.get $tab.4) (global.get $t0')))

    (drop (ref.cast (global.get $tab.10) (global.get $t0)))
    (drop (ref.cast (global.get $tab.11) (global.get $t0)))
    (drop (ref.cast (global.get $tab.12) (global.get $t0)))

    (drop (ref.cast (global.get $tab.1) (global.get $t1')))
    (drop (ref.cast (global.get $tab.2) (global.get $t1')))

    (drop (ref.cast (global.get $tab.11) (global.get $t1)))
    (drop (ref.cast (global.get $tab.12) (global.get $t1)))

    (drop (ref.cast (global.get $tab.2) (global.get $t2')))

    (drop (ref.cast (global.get $tab.12) (global.get $t2)))
  )
)

(invoke "test-sub")
(invoke "test-canon")
