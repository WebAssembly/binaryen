(module
  (memory 0)
  (type $0 (func (param i32 i64)))
  (func $f (type $0) (param $i1 i32) (param $i2 i64)
    (if
      (i32.eqz
        (get_local $i1)
      )
      (drop
        (i32.const 10)
      )
    )
    (if
      (i32.eqz
        (get_local $i1)
      )
      (drop
        (i32.const 11)
      )
      (drop
        (i32.const 12)
      )
    )
    (if
      (i64.eqz
        (get_local $i2)
      )
      (drop
        (i32.const 11)
      )
      (drop
        (i32.const 12)
      )
    )
    (drop
      (i32.eqz
        (i32.gt_s
          (i32.const 1)
          (i32.const 2)
        )
      )
    )
    (drop
      (i32.eqz
        (i32.ge_s
          (i32.const 1)
          (i32.const 2)
        )
      )
    )
    (drop
      (i32.eqz
        (i32.lt_s
          (i32.const 1)
          (i32.const 2)
        )
      )
    )
    (drop
      (i32.eqz
        (i32.le_s
          (i32.const 1)
          (i32.const 2)
        )
      )
    )
    (drop
      (i32.eqz
        (i32.gt_u
          (i32.const 1)
          (i32.const 2)
        )
      )
    )
    (drop
      (i32.eqz
        (i32.ge_u
          (i32.const 1)
          (i32.const 2)
        )
      )
    )
    (drop
      (i32.eqz
        (i32.lt_u
          (i32.const 1)
          (i32.const 2)
        )
      )
    )
    (drop
      (i32.eqz
        (i32.le_u
          (i32.const 1)
          (i32.const 2)
        )
      )
    )
    (drop
      (i32.eqz
        (f32.gt
          (f32.const 1)
          (f32.const 2)
        )
      )
    )
    (drop
      (i32.eqz
        (f32.ge
          (f32.const 1)
          (f32.const 2)
        )
      )
    )
    (drop
      (i32.eqz
        (f32.lt
          (f32.const 1)
          (f32.const 2)
        )
      )
    )
    (drop
      (i32.eqz
        (f32.le
          (f32.const 1)
          (f32.const 2)
        )
      )
    )
    (drop
      (i32.eqz
        (f64.gt
          (f64.const 1)
          (f64.const 2)
        )
      )
    )
    (drop
      (i32.eqz
        (f64.ge
          (f64.const 1)
          (f64.const 2)
        )
      )
    )
    (drop
      (i32.eqz
        (f64.lt
          (f64.const 1)
          (f64.const 2)
        )
      )
    )
    (drop
      (i32.eqz
        (f64.le
          (f64.const 1)
          (f64.const 2)
        )
      )
    )
    (drop
      (i32.eqz
        (f32.eq
          (f32.const 1)
          (f32.const 2)
        )
      )
    )
    (drop
      (i32.eqz
        (f32.ne
          (f32.const 1)
          (f32.const 2)
        )
      )
    )
    (drop
      (i32.eqz
        (f64.eq
          (f64.const 1)
          (f64.const 2)
        )
      )
    )
    (drop
      (i32.eqz
        (f64.ne
          (f64.const 1)
          (f64.const 2)
        )
      )
    )
    (drop
      (i32.eq
        (i32.const 100)
        (i32.const 0)
      )
    )
    (drop
      (i32.eq
        (i32.const 0)
        (i32.const 100)
      )
    )
    (drop
      (i32.eq
        (i32.const 0)
        (i32.const 0)
      )
    )
    (if
      (i32.eqz
        (i32.eqz
          (i32.const 123)
        )
      )
      (nop)
    )
    (drop
      (select
        (i32.const 101)
        (i32.const 102)
        (i32.eqz
          (get_local $i1)
        )
      )
    )
    (drop
      (select
        (tee_local $i1
          (i32.const 103)
        ) ;; these conflict
        (tee_local $i1
          (i32.const 104)
        )
        (i32.eqz
          (get_local $i1)
        )
      )
    )
    (drop
      (select
        (i32.const 0)
        (i32.const 1)
        (i32.eqz
          (i32.eqz
            (i32.const 2)
          )
        )
      )
    )
  )
  (func $load-store
    (drop (i32.and (i32.load8_s (i32.const 0)) (i32.const 255)))
    (drop (i32.and (i32.load8_u (i32.const 1)) (i32.const 255)))
    (drop (i32.and (i32.load8_s (i32.const 2)) (i32.const 254)))
    (drop (i32.and (i32.load8_u (i32.const 3)) (i32.const 1)))
    (drop (i32.and (i32.load16_s (i32.const 4)) (i32.const 65535)))
    (drop (i32.and (i32.load16_u (i32.const 5)) (i32.const 65535)))
    (drop (i32.and (i32.load16_s (i32.const 6)) (i32.const 65534)))
    (drop (i32.and (i32.load16_u (i32.const 7)) (i32.const 1)))
    ;;
    (i32.store8 (i32.const 8) (i32.and (i32.const -1) (i32.const 255)))
    (i32.store8 (i32.const 9) (i32.and (i32.const -2) (i32.const 254)))
    (i32.store16 (i32.const 10) (i32.and (i32.const -3) (i32.const 65535)))
    (i32.store16 (i32.const 11) (i32.and (i32.const -4) (i32.const 65534)))
    ;;
    (i32.store8 (i32.const 11) (i32.wrap/i64 (i64.const 1)))
    (i32.store16 (i32.const 11) (i32.wrap/i64 (i64.const 2)))
    (i32.store (i32.const 11) (i32.wrap/i64 (i64.const 3)))
  )
  (func $and-neg1
    (drop (i32.and (i32.const 100) (i32.const -1)))
    (drop (i32.and (i32.const 100) (i32.const  1)))
  )
  (func $and-pos1
    (drop (i32.and (i32.eqz (i32.const 1000)) (i32.const 1)))
    (drop (i32.and (i32.const 1) (i32.eqz (i32.const 1000))))
    (drop (i32.and (i32.const 100) (i32.const 1)))
    (drop (i32.and (i32.lt_s (i32.const 2000) (i32.const 3000)) (i32.const 1)))
  )
  (func $canonicalize-binary
    (drop (i32.and (unreachable) (i32.const 1))) ;; ok to reorder
    (drop (i32.and (i32.const 1) (unreachable)))
    (drop (i32.div_s (unreachable) (i32.const 1))) ;; not ok
    (drop (i32.div_s (i32.const 1) (unreachable)))
  )
  (func $ne0 (result i32)
    (if (i32.ne (call $ne0) (i32.const 0))
      (nop)
    )
    (if (i32.ne (i32.const 0) (call $ne0))
      (nop)
    )
    ;; through an or
    (if
      (i32.or
        (i32.ne (i32.const 0) (call $ne0))
        (i32.ne (i32.const 0) (call $ne0))
      )
      (nop)
    )
    ;; but not an and
    (if
      (i32.and
        (i32.ne (i32.const 0) (call $ne0))
        (i32.ne (i32.const 0) (call $ne0))
      )
      (nop)
    )
    (i32.const 1)
  )
  (func $recurse-bool
    (if
      (if i32
        (i32.const 1)
        (i32.ne (call $ne0) (i32.const 0))
        (i32.ne (call $ne0) (i32.const 0))
      )
      (nop)
    )
    (if
      (block i32
        (nop)
        (i32.ne (call $ne0) (i32.const 0))
      )
      (nop)
    )
  )
  (func $load-off-2 "load-off-2" (param $0 i32) (result i32)
    (i32.store offset=2
      (i32.add
        (i32.const 1)
        (i32.const 3)
      )
      (get_local $0)
    )
    (i32.store offset=2
      (i32.add
        (i32.const 3)
        (i32.const 1)
      )
      (get_local $0)
    )
    (i32.store offset=2
      (i32.add
        (get_local $0)
        (i32.const 5)
      )
      (get_local $0)
    )
    (i32.store offset=2
      (i32.add
        (i32.const 7)
        (get_local $0)
      )
      (get_local $0)
    )
    (i32.store offset=2
      (i32.add
        (i32.const -11) ;; do not fold this!
        (get_local $0)
      )
      (get_local $0)
    )
    (i32.store offset=2
      (i32.add
        (get_local $0)
        (i32.const -13) ;; do not fold this!
      )
      (get_local $0)
    )
    (i32.store offset=2
      (i32.add
        (i32.const -15)
        (i32.const 17)
      )
      (get_local $0)
    )
    (i32.store offset=2
      (i32.add
        (i32.const -21)
        (i32.const 19)
      )
      (get_local $0)
    )
    (i32.store offset=2
      (i32.const 23)
      (get_local $0)
    )
    (i32.store offset=2
      (i32.const -25)
      (get_local $0)
    )
    (drop
      (i32.load offset=2
        (i32.add
          (i32.const 2)
          (i32.const 4)
        )
      )
    )
    (drop
      (i32.load offset=2
        (i32.add
          (i32.const 4)
          (i32.const 2)
        )
      )
    )
    (drop
      (i32.load offset=2
        (i32.add
          (get_local $0)
          (i32.const 6)
        )
      )
    )
    (drop
      (i32.load offset=2
        (i32.const 8)
      )
    )
    (i32.load offset=2
      (i32.add
        (i32.const 10)
        (get_local $0)
      )
    )
  )
)
