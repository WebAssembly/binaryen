(module
  (type $st (sub (shared (struct))))
  (type $st' (sub (shared (struct (field i32)))))
  (type $at (shared (array i8)))
  (type $st-sub1 (sub $st (shared (struct))))
  (type $st-sub2 (sub $st (shared (struct))))
  (type $st'-sub1 (sub $st' (shared (struct (field i32)))))
  (type $st'-sub2 (sub $st' (shared (struct (field i32)))))

  (table 20 (ref null (shared eq)))

  (func (export "init")
    (table.set (i32.const 0) (ref.null (shared eq)))
    (table.set (i32.const 1) (ref.null (shared i31)))
    (table.set (i32.const 2) (ref.i31_shared (i32.const 7)))
    (table.set (i32.const 3) (ref.i31_shared (i32.const 7)))
    (table.set (i32.const 4) (ref.i31_shared (i32.const 8)))
    (table.set (i32.const 5) (struct.new_default $st))
    (table.set (i32.const 6) (struct.new_default $st))
    (table.set (i32.const 7) (array.new_default $at (i32.const 0)))
    (table.set (i32.const 8) (array.new_default $at (i32.const 0)))
  )

  (func (export "eq") (param $i i32) (param $j i32) (result i32)
    (ref.eq (table.get (local.get $i)) (table.get (local.get $j)))
  )
)

(invoke "init")

(assert_return (invoke "eq" (i32.const 0) (i32.const 0)) (i32.const 1))
(assert_return (invoke "eq" (i32.const 0) (i32.const 1)) (i32.const 1))
(assert_return (invoke "eq" (i32.const 0) (i32.const 2)) (i32.const 0))
(assert_return (invoke "eq" (i32.const 0) (i32.const 3)) (i32.const 0))
(assert_return (invoke "eq" (i32.const 0) (i32.const 4)) (i32.const 0))
(assert_return (invoke "eq" (i32.const 0) (i32.const 5)) (i32.const 0))
(assert_return (invoke "eq" (i32.const 0) (i32.const 6)) (i32.const 0))
(assert_return (invoke "eq" (i32.const 0) (i32.const 7)) (i32.const 0))
(assert_return (invoke "eq" (i32.const 0) (i32.const 8)) (i32.const 0))

(assert_return (invoke "eq" (i32.const 1) (i32.const 0)) (i32.const 1))
(assert_return (invoke "eq" (i32.const 1) (i32.const 1)) (i32.const 1))
(assert_return (invoke "eq" (i32.const 1) (i32.const 2)) (i32.const 0))
(assert_return (invoke "eq" (i32.const 1) (i32.const 3)) (i32.const 0))
(assert_return (invoke "eq" (i32.const 1) (i32.const 4)) (i32.const 0))
(assert_return (invoke "eq" (i32.const 1) (i32.const 5)) (i32.const 0))
(assert_return (invoke "eq" (i32.const 1) (i32.const 6)) (i32.const 0))
(assert_return (invoke "eq" (i32.const 1) (i32.const 7)) (i32.const 0))
(assert_return (invoke "eq" (i32.const 1) (i32.const 8)) (i32.const 0))

(assert_return (invoke "eq" (i32.const 2) (i32.const 0)) (i32.const 0))
(assert_return (invoke "eq" (i32.const 2) (i32.const 1)) (i32.const 0))
(assert_return (invoke "eq" (i32.const 2) (i32.const 2)) (i32.const 1))
(assert_return (invoke "eq" (i32.const 2) (i32.const 3)) (i32.const 1))
(assert_return (invoke "eq" (i32.const 2) (i32.const 4)) (i32.const 0))
(assert_return (invoke "eq" (i32.const 2) (i32.const 5)) (i32.const 0))
(assert_return (invoke "eq" (i32.const 2) (i32.const 6)) (i32.const 0))
(assert_return (invoke "eq" (i32.const 2) (i32.const 7)) (i32.const 0))
(assert_return (invoke "eq" (i32.const 2) (i32.const 8)) (i32.const 0))

(assert_return (invoke "eq" (i32.const 3) (i32.const 0)) (i32.const 0))
(assert_return (invoke "eq" (i32.const 3) (i32.const 1)) (i32.const 0))
(assert_return (invoke "eq" (i32.const 3) (i32.const 2)) (i32.const 1))
(assert_return (invoke "eq" (i32.const 3) (i32.const 3)) (i32.const 1))
(assert_return (invoke "eq" (i32.const 3) (i32.const 4)) (i32.const 0))
(assert_return (invoke "eq" (i32.const 3) (i32.const 5)) (i32.const 0))
(assert_return (invoke "eq" (i32.const 3) (i32.const 6)) (i32.const 0))
(assert_return (invoke "eq" (i32.const 3) (i32.const 7)) (i32.const 0))
(assert_return (invoke "eq" (i32.const 3) (i32.const 8)) (i32.const 0))

(assert_return (invoke "eq" (i32.const 4) (i32.const 0)) (i32.const 0))
(assert_return (invoke "eq" (i32.const 4) (i32.const 1)) (i32.const 0))
(assert_return (invoke "eq" (i32.const 4) (i32.const 2)) (i32.const 0))
(assert_return (invoke "eq" (i32.const 4) (i32.const 3)) (i32.const 0))
(assert_return (invoke "eq" (i32.const 4) (i32.const 4)) (i32.const 1))
(assert_return (invoke "eq" (i32.const 4) (i32.const 5)) (i32.const 0))
(assert_return (invoke "eq" (i32.const 4) (i32.const 6)) (i32.const 0))
(assert_return (invoke "eq" (i32.const 4) (i32.const 7)) (i32.const 0))
(assert_return (invoke "eq" (i32.const 4) (i32.const 8)) (i32.const 0))

(assert_return (invoke "eq" (i32.const 5) (i32.const 0)) (i32.const 0))
(assert_return (invoke "eq" (i32.const 5) (i32.const 1)) (i32.const 0))
(assert_return (invoke "eq" (i32.const 5) (i32.const 2)) (i32.const 0))
(assert_return (invoke "eq" (i32.const 5) (i32.const 3)) (i32.const 0))
(assert_return (invoke "eq" (i32.const 5) (i32.const 4)) (i32.const 0))
(assert_return (invoke "eq" (i32.const 5) (i32.const 5)) (i32.const 1))
(assert_return (invoke "eq" (i32.const 5) (i32.const 6)) (i32.const 0))
(assert_return (invoke "eq" (i32.const 5) (i32.const 7)) (i32.const 0))
(assert_return (invoke "eq" (i32.const 5) (i32.const 8)) (i32.const 0))

(assert_return (invoke "eq" (i32.const 6) (i32.const 0)) (i32.const 0))
(assert_return (invoke "eq" (i32.const 6) (i32.const 1)) (i32.const 0))
(assert_return (invoke "eq" (i32.const 6) (i32.const 2)) (i32.const 0))
(assert_return (invoke "eq" (i32.const 6) (i32.const 3)) (i32.const 0))
(assert_return (invoke "eq" (i32.const 6) (i32.const 4)) (i32.const 0))
(assert_return (invoke "eq" (i32.const 6) (i32.const 5)) (i32.const 0))
(assert_return (invoke "eq" (i32.const 6) (i32.const 6)) (i32.const 1))
(assert_return (invoke "eq" (i32.const 6) (i32.const 7)) (i32.const 0))
(assert_return (invoke "eq" (i32.const 6) (i32.const 8)) (i32.const 0))

(assert_return (invoke "eq" (i32.const 7) (i32.const 0)) (i32.const 0))
(assert_return (invoke "eq" (i32.const 7) (i32.const 1)) (i32.const 0))
(assert_return (invoke "eq" (i32.const 7) (i32.const 2)) (i32.const 0))
(assert_return (invoke "eq" (i32.const 7) (i32.const 3)) (i32.const 0))
(assert_return (invoke "eq" (i32.const 7) (i32.const 4)) (i32.const 0))
(assert_return (invoke "eq" (i32.const 7) (i32.const 5)) (i32.const 0))
(assert_return (invoke "eq" (i32.const 7) (i32.const 6)) (i32.const 0))
(assert_return (invoke "eq" (i32.const 7) (i32.const 7)) (i32.const 1))
(assert_return (invoke "eq" (i32.const 7) (i32.const 8)) (i32.const 0))

(assert_return (invoke "eq" (i32.const 8) (i32.const 0)) (i32.const 0))
(assert_return (invoke "eq" (i32.const 8) (i32.const 1)) (i32.const 0))
(assert_return (invoke "eq" (i32.const 8) (i32.const 2)) (i32.const 0))
(assert_return (invoke "eq" (i32.const 8) (i32.const 3)) (i32.const 0))
(assert_return (invoke "eq" (i32.const 8) (i32.const 4)) (i32.const 0))
(assert_return (invoke "eq" (i32.const 8) (i32.const 5)) (i32.const 0))
(assert_return (invoke "eq" (i32.const 8) (i32.const 6)) (i32.const 0))
(assert_return (invoke "eq" (i32.const 8) (i32.const 7)) (i32.const 0))
(assert_return (invoke "eq" (i32.const 8) (i32.const 8)) (i32.const 1))

(assert_invalid
  (module
    (func (export "eq") (param $r (ref (shared any))) (result i32)
      (ref.eq (local.get $r) (local.get $r))
    )
  )
  "type mismatch"
)
(assert_invalid
  (module
    (func (export "eq") (param $r (ref null (shared any))) (result i32)
      (ref.eq (local.get $r) (local.get $r))
    )
  )
  "type mismatch"
)
(assert_invalid
  (module
    (func (export "eq") (param $r (ref null (shared func))) (result i32)
      (ref.eq (local.get $r) (local.get $r))
    )
  )
  "type mismatch"
)
(assert_invalid
  (module
    (func (export "eq") (param $r (ref null (shared func))) (result i32)
      (ref.eq (local.get $r) (local.get $r))
    )
  )
  "type mismatch"
)
(assert_invalid
  (module
    (func (export "eq") (param $r (ref (shared extern))) (result i32)
      (ref.eq (local.get $r) (local.get $r))
    )
  )
  "type mismatch"
)
(assert_invalid
  (module
    (func (export "eq") (param $r (ref null (shared extern))) (result i32)
      (ref.eq (local.get $r) (local.get $r))
    )
  )
  "type mismatch"
)

;; Mixed shared / unshared eq
(assert_invalid
  (module
    (func (export "eq") (param $r1 (ref eq)) (param $r2 (ref (shared eq))) (result i32)
      (ref.eq (local.get $r1) (local.get $r2))
    )
  )
  "type mismatch"
)
(assert_invalid
  (module
    (func (export "eq") (param $r1 (ref (shared eq))) (param $r2 (ref eq)) (result i32)
      (ref.eq (local.get $r1) (local.get $r2))
    )
  )
  "type mismatch"
)
(assert_invalid
  (module
    (func (export "eq") (param $r1 eqref) (param $r2 (ref null (shared eq))) (result i32)
      (ref.eq (local.get $r1) (local.get $r2))
    )
  )
  "type mismatch"
)
(assert_invalid
  (module
    (func (export "eq") (param $r1 (ref null (shared eq))) (param $r2 eqref) (result i32)
      (ref.eq (local.get $r1) (local.get $r2))
    )
  )
  "type mismatch"
)
