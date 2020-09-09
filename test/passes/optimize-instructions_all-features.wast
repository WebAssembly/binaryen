(module
  (memory 0)
  (type $0 (func (param i32 i64)))
  (func $f (type $0) (param $i1 i32) (param $i2 i64)
    (if
      (i32.eqz
        (local.get $i1)
      )
      (drop
        (i32.const 10)
      )
    )
    (if
      (i32.eqz
        (local.get $i1)
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
        (local.get $i2)
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
    ;; we handle only 0 in the right position, as we assume a const is there, and don't care about if
    ;; both are consts here (precompute does that, so no need)
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
    (drop
      (i64.eq
        (i64.const 100)
        (i64.const 0)
      )
    )
    (drop
      (i64.eq
        (i64.const 0)
        (i64.const 100)
      )
    )
    (drop
      (i64.eq
        (i64.const 0)
        (i64.const 0)
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
    (if
      (try (result i32)
        (do
          (i32.eqz
            (i32.eqz
              (i32.const 123)
            )
          )
        )
        (catch
          (drop
            (exnref.pop)
          )
          (i32.eqz
            (i32.eqz
              (i32.const 456)
            )
          )
        )
      )
      (nop)
    )
    (drop
      (select
        (i32.const 101)
        (i32.const 102)
        (i32.eqz
          (local.get $i1)
        )
      )
    )
    (drop
      (select
        (local.tee $i1
          (i32.const 103)
        ) ;; these conflict
        (local.tee $i1
          (i32.const 104)
        )
        (i32.eqz
          (local.get $i1)
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
    (i32.store8 (i32.const 11) (i32.wrap_i64 (i64.const 1)))
    (i32.store16 (i32.const 11) (i32.wrap_i64 (i64.const 2)))
    (i32.store (i32.const 11) (i32.wrap_i64 (i64.const 3)))
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
  (func $canonicalize (param $x i32) (param $y i32) (param $fx f64) (param $fy f64)
    (drop (i32.and (unreachable) (i32.const 1))) ;; ok to reorder
    (drop (i32.and (i32.const 1) (unreachable)))
    (drop (i32.div_s (unreachable) (i32.const 1))) ;; not ok
    (drop (i32.div_s (i32.const 1) (unreachable)))
    ;; the various orderings
    (drop (i32.and (i32.const 1) (i32.const 2)))
    (drop (i32.and (local.get $x) (i32.const 3)))
    (drop (i32.and (i32.const 4) (local.get $x)))
    (drop (i32.and (local.get $x) (local.get $y)))
    (drop (i32.and (local.get $y) (local.get $x)))
    (drop (i32.and (local.get $y) (local.tee $x (i32.const -4))))
    (drop (i32.and
      (block (result i32)
        (i32.const -5)
      )
      (local.get $x)
    ))
    (drop (i32.and
      (local.get $x)
      (block (result i32)
        (i32.const -6)
      )
    ))
    (drop (i32.and
      (block (result i32)
        (i32.const 5)
      )
      (loop (result i32)
        (i32.const 6)
      )
    ))
    (drop (i32.and
      (loop (result i32)
        (i32.const 7)
      )
      (block (result i32)
        (i32.const 8)
      )
    ))
    (drop (i32.and
      (loop (result i32)
        (call $and-pos1)
        (i32.const 9)
      )
      (block (result i32)
        (i32.const 10)
      )
    ))
    (drop (i32.and
      (loop (result i32)
        (i32.const 11)
      )
      (block (result i32)
        (call $and-pos1)
        (i32.const 12)
      )
    ))
    (drop (i32.and
      (loop (result i32)
        (call $and-pos1)
        (i32.const 13)
      )
      (block (result i32)
        (call $and-pos1)
        (i32.const 14)
      )
    ))
    (drop (i32.and
      (block (result i32)
        (call $and-pos1)
        (i32.const 14)
      )
      (loop (result i32)
        (call $and-pos1)
        (i32.const 13)
      )
    ))
    (drop (i32.and
      (block (result i32)
        (i32.const 15)
      )
      (local.get $x)
    ))
    (drop (i32.and
      (local.get $x)
      (block (result i32)
        (i32.const 15)
      )
    ))
    (drop (i32.and
      (i32.gt_s
        (i32.const 16)
        (i32.const 17)
      )
      (i32.gt_u
        (i32.const 18)
        (i32.const 19)
      )
    ))
    (drop (i32.and
      (i32.gt_u
        (i32.const 20)
        (i32.const 21)
      )
      (i32.gt_s
        (i32.const 22)
        (i32.const 23)
      )
    ))
    (drop (i32.add (i32.ctz (local.get $x)) (i32.ctz (local.get $y))))
    (drop (i32.add (i32.ctz (local.get $y)) (i32.ctz (local.get $x))))
    (drop (i32.add (i32.ctz (local.get $x)) (i32.eqz (local.get $y))))
    (drop (i32.add (i32.eqz (local.get $x)) (i32.ctz (local.get $y))))
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
      (if (result i32)
        (i32.const 1)
        (i32.ne (call $ne0) (i32.const 0))
        (i32.ne (call $ne1) (i32.const 0))
      )
      (nop)
    )
    (if
      (block (result i32)
        (nop)
        (i32.ne (call $ne0) (i32.const 0))
      )
      (nop)
    )
  )
  (func $ne1 (result i32)
    (unreachable)
  )
  (func $load-off-2 "load-off-2" (param $0 i32) (result i32)
    (i32.store offset=2
      (i32.add
        (i32.const 1)
        (i32.const 3)
      )
      (local.get $0)
    )
    (i32.store offset=2
      (i32.add
        (i32.const 3)
        (i32.const 1)
      )
      (local.get $0)
    )
    (i32.store offset=2
      (i32.add
        (local.get $0)
        (i32.const 5)
      )
      (local.get $0)
    )
    (i32.store offset=2
      (i32.add
        (i32.const 7)
        (local.get $0)
      )
      (local.get $0)
    )
    (i32.store offset=2
      (i32.add
        (i32.const -11) ;; do not fold this!
        (local.get $0)
      )
      (local.get $0)
    )
    (i32.store offset=2
      (i32.add
        (local.get $0)
        (i32.const -13) ;; do not fold this!
      )
      (local.get $0)
    )
    (i32.store offset=2
      (i32.add
        (i32.const -15)
        (i32.const 17)
      )
      (local.get $0)
    )
    (i32.store offset=2
      (i32.add
        (i32.const -21)
        (i32.const 19)
      )
      (local.get $0)
    )
    (i32.store offset=2
      (i32.const 23)
      (local.get $0)
    )
    (i32.store offset=2
      (i32.const -25)
      (local.get $0)
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
          (local.get $0)
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
        (local.get $0)
      )
    )
  )
  (func $sign-ext (param $0 i32) (param $1 i32)
    ;; eq of sign-ext to const, can be a zext
    (drop
      (i32.eq
        (i32.shr_s
          (i32.shl
            (local.get $0)
            (i32.const 24)
          )
          (i32.const 24)
        )
        (i32.const 0)
      )
    )
    (drop
      (i32.eq
        (i32.shr_s
          (i32.shl
            (local.get $0)
            (i32.const 16)
          )
          (i32.const 16)
        )
        (i32.const 0)
      )
    )
    (drop
      (i32.eq
        (i32.shr_s
          (i32.shl
            (local.get $0)
            (i32.const 5) ;; weird size, but still valid
          )
          (i32.const 5)
        )
        (i32.const 0)
      )
    )
    (drop
      (i32.eq
        (i32.shr_s
          (i32.shl
            (local.get $0)
            (i32.const 24)
          )
          (i32.const 24)
        )
        (i32.const 100) ;; non-zero
      )
    )
    (drop
      (i32.eq
        (i32.shr_s
          (i32.shl
            (local.get $0)
            (i32.const 24)
          )
          (i32.const 24)
        )
        (i32.const 32767) ;; non-zero and bigger than the mask, with sign bit
      )
    )
    (drop
      (i32.eq
        (i32.shr_s
          (i32.shl
            (local.get $0)
            (i32.const 24)
          )
          (i32.const 24)
        )
        (i32.const -149) ;; non-zero and bigger than the mask, without sign bit
      )
    )
    ;; eq of two sign-ext, can both be a zext
    (drop
      (i32.eq
        (i32.shr_s
          (i32.shl
            (local.get $0)
            (i32.const 24)
          )
          (i32.const 24)
        )
        (i32.shr_s
          (i32.shl
            (local.get $1)
            (i32.const 24)
          )
          (i32.const 24)
        )
      )
    )
    (drop
      (i32.eq
        (i32.shr_s
          (i32.shl
            (local.get $0)
            (i32.const 16)
          )
          (i32.const 16)
        )
        (i32.shr_s
          (i32.shl
            (local.get $1)
            (i32.const 16)
          )
          (i32.const 16)
        )
      )
    )
    ;; corner cases we should not opt
    (drop
      (i32.eq
        (i32.shr_s
          (i32.shl
            (local.get $0)
            (i32.const 24)
          )
          (i32.const 23) ;; different shift, smaller
        )
        (i32.const 0)
      )
    )
    (drop
      (i32.eq
        (i32.shr_u ;; unsigned
          (i32.shl
            (local.get $0)
            (i32.const 24)
          )
          (i32.const 24)
        )
        (i32.const 0)
      )
    )
    (drop
      (i32.lt_s ;; non-eq
        (i32.shr_s
          (i32.shl
            (local.get $0)
            (i32.const 24)
          )
          (i32.const 24)
        )
        (i32.const 0)
      )
    )
  )
  (func $sign-ext-input (param $0 i32) (param $1 i32)
    (drop
      (i32.shr_s
        (i32.shl
          (i32.const 100) ;; small!
          (i32.const 24)
        )
        (i32.const 24)
      )
    )
    (drop
      (i32.shr_s
        (i32.shl
          (i32.const 127) ;; just small enough
          (i32.const 24)
        )
        (i32.const 24)
      )
    )
    (drop
      (i32.shr_s
        (i32.shl
          (i32.const 128) ;; just too big
          (i32.const 24)
        )
        (i32.const 24)
      )
    )
    (drop
      (i32.shr_s
        (i32.shl
          (local.get $0) ;; who knows...
          (i32.const 24)
        )
        (i32.const 24)
      )
    )
    (drop
      (i32.shr_s
        (i32.shl
          (unreachable) ;; ignore
          (i32.const 24)
        )
        (i32.const 24)
      )
    )
    (drop
      (i32.shr_s
        (i32.shl
          (i32.div_s ;; this could be optimizable in theory, but currently we don't look into adds etc.
            (i32.const 1)
            (i32.const 2)
          )
          (i32.const 24)
        )
        (i32.const 24)
      )
    )
    (drop
      (i32.shr_s
        (i32.shl
          (i32.and ;; takes the min, here it is ok
            (i32.const 127)
            (i32.const 128)
          )
          (i32.const 24)
        )
        (i32.const 24)
      )
    )
    (drop
      (i32.shr_s
        (i32.shl
          (i32.and ;; takes the min, here it is not
            (i32.const 128)
            (i32.const 129)
          )
          (i32.const 24)
        )
        (i32.const 24)
      )
    )
    (drop
      (i32.shr_s
        (i32.shl
          (i32.xor ;; takes the max, here it is ok
            (i32.const 127)
            (i32.const 126)
          )
          (i32.const 24)
        )
        (i32.const 24)
      )
    )
    (drop
      (i32.shr_s
        (i32.shl
          (i32.xor ;; takes the max, here it is not
            (i32.const 127)
            (i32.const 128)
          )
          (i32.const 24)
        )
        (i32.const 24)
      )
    )
    (drop
      (i32.shr_s
        (i32.shl
          (i32.or ;; takes the max, here it is ok
            (i32.const 127)
            (i32.const 126)
          )
          (i32.const 24)
        )
        (i32.const 24)
      )
    )
    (drop
      (i32.shr_s
        (i32.shl
          (i32.or ;; takes the max, here it is not
            (i32.const 127)
            (i32.const 128)
          )
          (i32.const 24)
        )
        (i32.const 24)
      )
    )
    (drop
      (i32.shr_s
        (i32.shl
          (i32.shl ;; adds, here it is too much
            (i32.const 32)
            (i32.const 2)
          )
          (i32.const 24)
        )
        (i32.const 24)
      )
    )
    (drop
      (i32.shr_s
        (i32.shl
          (i32.shl ;; adds, here it is ok
            (i32.const 32)
            (i32.const 1)
          )
          (i32.const 24)
        )
        (i32.const 24)
      )
    )
    (drop
      (i32.shr_s
        (i32.shl
          (i32.shl ;; adds, here it is too much and "overflows"
            (i32.const 32)
            (i32.const 35)
          )
          (i32.const 24)
        )
        (i32.const 24)
      )
    )
    (drop
      (i32.shr_s
        (i32.shl
          (i32.shr_u ;; subtracts, here it is still too much
            (i32.const 256)
            (i32.const 1)
          )
          (i32.const 24)
        )
        (i32.const 24)
      )
    )
    (drop
      (i32.shr_s
        (i32.shl
          (i32.shr_u ;; subtracts, here it is ok
            (i32.const 256)
            (i32.const 2)
          )
          (i32.const 24)
        )
        (i32.const 24)
      )
    )
    (drop
      (i32.shr_s
        (i32.shl
          (i32.shr_u ;; subtracts, here it "overflows"
            (i32.const 128)
            (i32.const 35)
          )
          (i32.const 24)
        )
        (i32.const 24)
      )
    )
    (drop
      (i32.shr_s
        (i32.shl
          (i32.shr_s ;; subtracts, here it is still too much
            (i32.const 256)
            (i32.const 1)
          )
          (i32.const 24)
        )
        (i32.const 24)
      )
    )
    (drop
      (i32.shr_s
        (i32.shl
          (i32.shr_s ;; subtracts, here it is ok
            (i32.const 256)
            (i32.const 2)
          )
          (i32.const 24)
        )
        (i32.const 24)
      )
    )
    (drop
      (i32.shr_s
        (i32.shl
          (i32.shr_s ;; subtracts, here it "overflows"
            (i32.const 128)
            (i32.const 35)
          )
          (i32.const 24)
        )
        (i32.const 24)
      )
    )
    (drop
      (i32.shr_s
        (i32.shl
          (i32.shr_s ;; subtracts, here there is a sign bit, so it stays 32 bits no matter how much we shift
            (i32.const -1)
            (i32.const 32)
          )
          (i32.const 24)
        )
        (i32.const 24)
      )
    )
    (drop
      (i32.shr_s
        (i32.shl
          (i32.shr_s ;; subtracts, here we mask out that sign bit
            (i32.and
              (i32.const -1)
              (i32.const 2147483647)
            )
            (i32.const 31) ;; adjusted after we fixed shift computation to just look at lower 5 bits
          )
          (i32.const 24)
        )
        (i32.const 24)
      )
    )
    (drop
      (i32.shr_s
        (i32.shl
          (i32.ne ;; 1 bit
            (i32.const -1)
            (i32.const -1)
          )
          (i32.const 24)
        )
        (i32.const 24)
      )
    )
    (drop
      (i32.shr_s
        (i32.shl
          (f32.le
            (f32.const -1)
            (f32.const -1)
          )
          (i32.const 24)
        )
        (i32.const 24)
      )
    )
    (drop
      (i32.shr_s
        (i32.shl
          (i32.clz ;; assumed 5 bits
            (i32.const 0)
          )
          (i32.const 24)
        )
        (i32.const 24)
      )
    )
    (drop
      (i32.shr_s
        (i32.shl
          (i32.shl
            (i32.clz ;; assumed 5 bits
              (i32.const 0)
            )
            (i32.const 2) ;; + 2, so 7
          )
          (i32.const 24)
        )
        (i32.const 24)
      )
    )
    (drop
      (i32.shr_s
        (i32.shl
          (i32.shl
            (i32.clz ;; assumed 5 bits
              (i32.const 0)
            )
            (i32.const 3) ;; + 3, so 8, too much
          )
          (i32.const 24)
        )
        (i32.const 24)
      )
    )
    (drop
      (i32.shr_s
        (i32.shl
          (i32.wrap_i64 ;; preserves 6
            (i64.clz ;; assumed 6 bits
              (i64.const 0)
            )
          )
          (i32.const 24)
        )
        (i32.const 24)
      )
    )
    (drop
      (i32.shr_s
        (i32.shl
          (i32.shl
            (i32.wrap_i64 ;; preserves 6
              (i64.clz ;; assumed 6 bits
                (i64.const 0)
              )
            )
            (i32.const 1) ;; + 1, so 7
          )
          (i32.const 24)
        )
        (i32.const 24)
      )
    )
    (drop
      (i32.shr_s
        (i32.shl
          (i32.shl
            (i32.wrap_i64 ;; preserves 6
              (i64.clz ;; assumed 6 bits
                (i64.const 0)
              )
            )
            (i32.const 2) ;; + 2, so 8, too much
          )
          (i32.const 24)
        )
        (i32.const 24)
      )
    )
    (drop
      (i32.shr_s
        (i32.shl
          (i32.eqz ;; 1 bit
            (i32.const -1)
          )
          (i32.const 24)
        )
        (i32.const 24)
      )
    )
    (drop
      (i32.shr_s
        (i32.shl
          (i32.shr_u
            (i32.wrap_i64 ;; down to 32
              (i64.const -1) ;; 64
            )
            (i32.const 24) ;; 32 - 24 = 8
          )
          (i32.const 24)
        )
        (i32.const 24)
      )
    )
    (drop
      (i32.shr_s
        (i32.shl
          (i32.shr_u
            (i32.wrap_i64 ;; down to 32
              (i64.const -1) ;; 64
            )
            (i32.const 25) ;; 32 - 25 = 7, ok
          )
          (i32.const 24)
        )
        (i32.const 24)
      )
    )
    (drop
      (i32.shr_s
        (i32.shl
          (i32.shr_u
            (i32.wrap_i64 ;; stay 32
              (i64.extend_i32_s
                (i32.const -1)
              )
            )
            (i32.const 24) ;; 32 - 24 = 8
          )
          (i32.const 24)
        )
        (i32.const 24)
      )
    )
    (drop
      (i32.shr_s
        (i32.shl
          (i32.shr_u
            (i32.wrap_i64 ;; stay 32
              (i64.extend_i32_s
                (i32.const -1)
              )
            )
            (i32.const 25) ;; 32 - 25 = 7, ok
          )
          (i32.const 24)
        )
        (i32.const 24)
      )
    )
    (drop ;; fuzz testcase
      (i32.shr_s
        (i32.shl
          (i32.xor ;; should be 32 bits
            (i32.le_u ;; 1 bit
              (local.get $0)
              (i32.const 2)
            )
            (local.get $0) ;; unknown, so 32 bits
          )
          (i32.const 24)
        )
        (i32.const 24)
      )
    )
  )
  (func $linear-sums (param $0 i32) (param $1 i32)
    (drop
      (i32.add
        (i32.add
          (local.get $1)
          (i32.const 16)
        )
        (i32.shl
          (i32.add
            (local.get $0)
            (i32.const -1) ;; -16, so cancels out!
          )
          (i32.const 4)
        )
      )
    )
    (drop
      (i32.add
        (i32.add
          (local.get $1)
          (i32.const 20)
        )
        (i32.shl
          (i32.add
            (local.get $0)
            (i32.const -1) ;; -8, so sum is +12
          )
          (i32.const 3)
        )
      )
    )
    (drop
      (i32.add ;; simple sum
        (i32.const 1)
        (i32.const 3)
      )
    )
    (drop
      (i32.add ;; nested sum
        (i32.add
          (i32.const 1)
          (i32.const 3)
        )
        (i32.add
          (i32.const 5)
          (i32.const 9)
        )
      )
    )
    (drop
      (i32.add
        (i32.add
          (i32.const 1)
          (i32.const 3)
        )
        (i32.sub ;; internal sub
          (i32.const 5)
          (i32.const 3)
        )
      )
    )
    (drop
      (i32.sub ;; external sub
        (i32.add
          (i32.const 1)
          (i32.const 3)
        )
        (i32.add
          (i32.const 5)
          (i32.const 3)
        )
      )
    )
    (drop
      (i32.sub ;; external sub
        (i32.add
          (i32.const 1)
          (i32.const 3)
        )
        (i32.sub ;; and also internal sub
          (i32.const 5)
          (i32.const 3)
        )
      )
    )
    (drop
      (i32.add
        (i32.add
          (i32.const 1)
          (i32.const 3)
        )
        (i32.sub ;; negating sub
          (i32.const 0)
          (i32.const 3)
        )
      )
    )
    (drop
      (i32.add
        (i32.sub
          (i32.const 0)
          (i32.sub ;; two negating subs
            (i32.const 0)
            (i32.add
              (i32.const 3)
              (i32.const 20)
            )
          )
        )
        (i32.add
          (i32.const 1)
          (i32.const 2)
        )
      )
    )
    (drop
      (i32.add
        (i32.add
          (i32.const 0)
          (i32.sub ;; one negating sub
            (i32.const 0)
            (i32.add
              (i32.const 3)
              (i32.const 20)
            )
          )
        )
        (i32.add
          (i32.const 1)
          (i32.const 2)
        )
      )
    )
    (drop
      (i32.add
        (i32.shl ;; shifted value
          (i32.const 1)
          (i32.const 3)
        )
        (i32.add
          (i32.const 5)
          (i32.const 9)
        )
      )
    )
    (drop
      (i32.add
        (i32.shl ;; shifted value
          (i32.const 1)
          (local.get $0) ;; but not by const
        )
        (i32.add
          (i32.const 5)
          (i32.const 9)
        )
      )
    )
    (drop
      (i32.add
        (i32.shl ;; shifted nested value
          (i32.sub
            (local.get $1)
            (i32.const 10)
          )
          (i32.const 3)
        )
        (i32.add
          (i32.const 5)
          (i32.const 9)
        )
      )
    )
    (drop
      (i32.add
        (i32.mul ;; multiplied
          (i32.const 10)
          (i32.const 3)
        )
        (i32.add
          (i32.const 5)
          (i32.const 9)
        )
      )
    )
    (drop
      (i32.add
        (i32.mul ;; multiplied by nonconstant - can't recurse
          (i32.const 10)
          (local.get $0)
        )
        (i32.add
          (i32.const 5)
          (i32.const 9)
        )
      )
    )
    (drop
      (i32.add
        (i32.mul ;; nested mul
          (i32.add
            (i32.const 10)
            (local.get $0)
          )
          (i32.const 2)
        )
        (i32.add
          (i32.const 5)
          (i32.const 9)
        )
      )
    )
    (drop
      (i32.add
        (i32.add
          (local.get $0)
          (i32.const 10) ;; cancelled out with the below
        )
        (i32.sub
          (i32.const -5)
          (i32.const 5)
        )
      )
    )
  )
  (func $almost-sign-ext (param $0 i32)
    (drop
      (i32.shr_s
        (i32.shl
          (i32.const 100) ;; too big, there is a sign bit, due to the extra shift
          (i32.const 25)
        )
        (i32.const 24) ;; different shift, but larger, so ok to opt if we leave a shift, in theory
      )
    )
    (drop
      (i32.shr_s
        (i32.shl
          (i32.const 50) ;; small enough, no sign bit
          (i32.const 25)
        )
        (i32.const 24) ;; different shift, but larger, so ok to opt if we leave a shift
      )
    )
  )
  (func $squaring (param $0 i32) (param $1 i32)
    (drop
      (i32.and
        (i32.and
          (local.get $0)
          (i32.const 11)
        )
        (i32.const 200)
      )
    )
    (drop
      (i32.and
        (i32.and
          (local.get $0)
          (i32.const 11)
        )
        (local.get $0) ;; non-const, cannot optimize this!
      )
    )
    (drop
      (i32.and
        (i32.and
          (i32.const 11) ;; flipped order
          (local.get $0)
        )
        (i32.const 200)
      )
    )
    (drop
      (i32.or
        (i32.or
          (local.get $0)
          (i32.const 11)
        )
        (i32.const 200)
      )
    )
    (drop
      (i32.shl
        (i32.shl
          (local.get $0)
          (i32.const 11)
        )
        (i32.const 200)
      )
    )
    (drop
      (i32.shr_s
        (i32.shr_s
          (local.get $0)
          (i32.const 11)
        )
        (i32.const 200)
      )
    )
    (drop
      (i32.shr_u
        (i32.shr_u
          (local.get $0)
          (i32.const 11)
        )
        (i32.const 200)
      )
    )
    (drop
      (i32.shr_u
        (i32.shr_s ;; but do not optimize a mixture or different shifts!
          (local.get $0)
          (i32.const 11)
        )
        (i32.const 200)
      )
    )
  )
  (func $sign-ext-ne (param $0 i32) (param $1 i32)
    ;; ne of sign-ext to const, can be a zext
    (drop
      (i32.ne
        (i32.shr_s
          (i32.shl
            (local.get $0)
            (i32.const 24)
          )
          (i32.const 24)
        )
        (i32.const 65000)
      )
    )
    (drop
      (i32.ne
        (i32.shr_s
          (i32.shl
            (local.get $0)
            (i32.const 24)
          )
          (i32.const 24)
        )
        (i32.const 64872) ;; no sign bit
      )
    )
    (drop
      (i32.ne
        (i32.shr_s
          (i32.shl
            (local.get $0)
            (i32.const 24)
          )
          (i32.const 24)
        )
        (i32.const -149) ;; no sign bit, not all ones
      )
    )
    (drop
      (i32.ne
        (i32.shr_s
          (i32.shl
            (local.get $0)
            (i32.const 24)
          )
          (i32.const 24)
        )
        (i32.const 111)
      )
    )
    (drop
      (i32.ne
        (i32.shr_s
          (i32.shl
            (local.get $0)
            (i32.const 24)
          )
          (i32.const 24)
        )
        (i32.shr_s
          (i32.shl
            (local.get $1)
            (i32.const 24)
          )
          (i32.const 24)
        )
      )
    )
  )
  (func $sign-ext-eqz (param $0 i32) (param $1 i32)
    (drop
      (i32.eqz
        (i32.shr_s
          (i32.shl
            (local.get $0)
            (i32.const 24)
          )
          (i32.const 24)
        )
      )
    )
  )
  (func $sign-ext-boolean (param $0 i32) (param $1 i32)
    (drop
      (if (result i32)
        (i32.shr_s
          (i32.shl
            (local.get $0)
            (i32.const 24)
          )
          (i32.const 24)
        )
        (i32.const 100)
        (i32.const 200)
      )
    )
  )
  (func $add-sub-zero (param $0 i32) (param $1 i32)
    (drop
      (i32.add
        (local.get $0)
        (i32.const 0)
      )
    )
    (drop
      (i32.sub
        (local.get $0)
        (i32.const 0)
      )
    )
  )
  (func $store-signext (param $0 i32)
    (i32.store8
      (i32.const 8)
      (i32.shr_s
        (i32.shl
          (local.get $0)
          (i32.const 24) ;; exact size we store, sign-ext of 8 bits
        )
        (i32.const 24)
      )
    )
    (i32.store8
      (i32.const 8)
      (i32.shr_s
        (i32.shl
          (local.get $0)
          (i32.const 25) ;; 7 bits. so the ext can alter a bit we store, do not optimize
        )
        (i32.const 25)
      )
    )
    (i32.store8
      (i32.const 8)
      (i32.shr_s
        (i32.shl
          (local.get $0)
          (i32.const 23) ;; 9 bits, this is good to optimize
        )
        (i32.const 23)
      )
    )
    (i32.store16
      (i32.const 8)
      (i32.shr_s
        (i32.shl
          (local.get $0)
          (i32.const 16) ;; exact size we store, sign-ext of 16 bits
        )
        (i32.const 16)
      )
    )
    (i32.store16
      (i32.const 8)
      (i32.shr_s
        (i32.shl
          (local.get $0)
          (i32.const 17) ;; 15 bits. so the ext can alter a bit we store, do not optimize
        )
        (i32.const 17)
      )
    )
    (i32.store16
      (i32.const 8)
      (i32.shr_s
        (i32.shl
          (local.get $0)
          (i32.const 14) ;; 17 bits, this is good to optimize
        )
        (i32.const 14)
      )
    )
    (i32.store
      (i32.const 8)
      (i32.shr_s
        (i32.shl
          (local.get $0)
          (i32.const 16) ;; 4 bytes stored, do nothing
        )
        (i32.const 16)
      )
    )
    (i32.store
      (i32.const 8)
      (i32.shr_s
        (i32.shl
          (local.get $0)
          (i32.const 8) ;; 4 bytes stored, do nothing
        )
        (i32.const 8)
      )
    )
  )
  (func $sign-ext-tee (param $0 i32) (param $1 i32)
    (drop
      (i32.shr_s
        (i32.shl
          (local.tee $0
            (i32.const 128) ;; too big
          )
          (i32.const 24)
        )
        (i32.const 24)
      )
    )
    (drop
      (i32.shr_s
        (i32.shl
          (local.tee $0
            (i32.const 127) ;; just right
          )
          (i32.const 24)
        )
        (i32.const 24)
      )
    )
  )
  (func $sign-ext-load (param $0 i32) (param $1 i32)
    (drop
      (i32.shr_s
        (i32.shl
          (i32.load8_s ;; one byte, so perfect
            (i32.const 256)
          )
          (i32.const 24)
        )
        (i32.const 24)
      )
    )
    (drop
      (i32.shr_s
        (i32.shl
          (i32.shr_u
            (i32.load8_s ;; one byte, but sexted to 32
              (i32.const 256)
            )
            (i32.const 1)
          )
          (i32.const 24)
        )
        (i32.const 24)
      )
    )
    (drop
      (i32.shr_s
        (i32.shl
          (i32.shr_u
            (i32.load8_u ;; one byte, but reduced to 7
              (i32.const 256)
            )
            (i32.const 1)
          )
          (i32.const 24)
        )
        (i32.const 24)
      )
    )
    (drop
      (i32.shr_s
        (i32.shl
          (i32.load16_s ;; two, so perfect
            (i32.const 256)
          )
          (i32.const 16)
        )
        (i32.const 16)
      )
    )
    ;; through tees, we cannot alter the load sign
    (drop
      (i32.shr_s
        (i32.shl
          (local.tee $1
            (i32.load8_s
              (i32.const 1)
            )
          )
          (i32.const 24)
        )
        (i32.const 24)
      )
    )
    (drop
      (i32.shr_s
        (i32.shl
          (local.tee $1
            (i32.load8_u
              (i32.const 1)
            )
          )
          (i32.const 24)
        )
        (i32.const 24)
      )
    )
    (drop
      (i32.and
        (local.tee $1
          (i32.load8_s
            (i32.const 1)
          )
        )
        (i32.const 255)
      )
    )
    (drop
      (i32.and
        (local.tee $1
          (i32.load8_u
            (i32.const 1)
          )
        )
        (i32.const 255)
      )
    )
  )
  (func $mask-bits (param $0 i32) (param $1 i32)
    (drop
      (i32.and
        (local.tee $0
          (i32.const 127) ;; 7 bits
        )
        (i32.const 255) ;; mask 8, so we don't need this
      )
    )
    (drop
      (i32.and
        (local.tee $0
          (i32.const 128) ;; 8 bits
        )
        (i32.const 255) ;; mask 8, so we don't need this
      )
    )
    (drop
      (i32.and
        (local.tee $0
          (i32.const 128)
        )
        (i32.const 254) ;; improper mask, small
      )
    )
    (drop
      (i32.and
        (local.tee $0
          (i32.const 128)
        )
        (i32.const 1279) ;; improper mask, large
      )
    )
    (drop
      (i32.and
        (local.tee $0
          (i32.const 128)
        )
        (i32.const 1290) ;; improper mask, large
      )
    )
    (drop
      (i32.and
        (local.tee $0
          (i32.const 128)
        )
        (i32.const 4095) ;; proper mask, huge
      )
    )
    (drop
      (i32.and
        (local.tee $0
          (i32.const 128)
        )
        (i32.const 511) ;; proper mask, large
      )
    )
    (drop
      (i32.and
        (local.tee $0
          (i32.const 128)
        )
        (i32.const 127) ;; proper mask, just too small
      )
    )
  )
  (func $local-info-zero-ext (param $0 i32) (param $1 i32)
    (local $x i32)
    (local $y i32)
    (local $z i32)
    (local $w i32)
    (local.set $x
      (i32.const 212) ;; mask is unneeded, we are small
    )
    (drop
      (i32.and
        (local.get $x)
        (i32.const 255)
      )
    )
    (local.set $y
      (i32.const 500) ;; mask is needed, we are too big
    )
    (drop
      (i32.and
        (local.get $y)
        (i32.const 255)
      )
    )
    (local.set $0
      (i32.const 212) ;; mask is unneeded, but we are a param, not a var, so no
    )
    (drop
      (i32.and
        (local.get $0)
        (i32.const 255)
      )
    )
    (local.set $z
      (i32.const 212) ;; mask is unneeded, we are small
    )
    (local.set $z
      (i32.const 220) ;; mask is still unneeded even with 2 uses
    )
    (drop
      (i32.and
        (local.get $z)
        (i32.const 255)
      )
    )
    (local.set $w
      (i32.const 212) ;; mask is unneeded, we are small
    )
    (local.set $w
      (i32.const 1000) ;; mask is needed, one use is too big
    )
    (drop
      (i32.and
        (local.get $w)
        (i32.const 255)
      )
    )
  )
  (func $local-info-sign-ext-bitsize (param $0 i32) (param $1 i32)
    (local $x i32)
    (local $y i32)
    (local $z i32)
    (local $w i32)
    (local.set $x
      (i32.const 127) ;; mask is unneeded, we are small
    )
    (drop
      (i32.shr_s
        (i32.shl
          (local.get $x)
          (i32.const 24)
        )
        (i32.const 24)
      )
    )
    (local.set $y
      (i32.const 128) ;; mask is needed, we are too big
    )
    (drop
      (i32.shr_s
        (i32.shl
          (local.get $y)
          (i32.const 24)
        )
        (i32.const 24)
      )
    )
    (local.set $0
      (i32.const 127) ;; mask is unneeded, but we are a param, not a var, so no
    )
    (drop
      (i32.shr_s
        (i32.shl
          (local.get $0)
          (i32.const 24)
        )
        (i32.const 24)
      )
    )
    (local.set $z
      (i32.const 127) ;; mask is unneeded, we are small
    )
    (local.set $z
      (i32.const 100) ;; mask is still unneeded even with 2 uses
    )
    (drop
      (i32.shr_s
        (i32.shl
          (local.get $z)
          (i32.const 24)
        )
        (i32.const 24)
      )
    )
    (local.set $w
      (i32.const 127) ;; mask is unneeded, we are small
    )
    (local.set $w
      (i32.const 150) ;; mask is needed, one use is too big
    )
    (drop
      (i32.shr_s
        (i32.shl
          (local.get $w)
          (i32.const 24)
        )
        (i32.const 24)
      )
    )
  )
  (func $local-info-sign-ext-already-exted (param $0 i32) (param $1 i32)
    (local $x i32)
    (local $y i32)
    (local $z i32)
    (local $w i32)
    (local.set $x
      (i32.shr_s
        (i32.shl
          (local.get $0) ;; already sign-exted here, so no need later
          (i32.const 24)
        )
        (i32.const 24)
      )
    )
    (drop
      (i32.shr_s
        (i32.shl
          (local.get $x)
          (i32.const 24)
        )
        (i32.const 24)
      )
    )
    (local.set $y
      (i32.shr_s
        (i32.shl
          (local.get $0) ;; already sign-exted here, but wrong bit size
          (i32.const 16)
        )
        (i32.const 16)
      )
    )
    (drop
      (i32.shr_s
        (i32.shl
          (local.get $y)
          (i32.const 24)
        )
        (i32.const 24)
      )
    )
    (local.set $0
      (i32.shr_s
        (i32.shl
          (local.get $0) ;; already sign-exted here, so no need later, but we are a param
          (i32.const 24)
        )
        (i32.const 24)
      )
    )
    (drop
      (i32.shr_s
        (i32.shl
          (local.get $0)
          (i32.const 24)
        )
        (i32.const 24)
      )
    )
    (local.set $z
      (i32.shr_s
        (i32.shl
          (local.get $0) ;; already sign-exted here, so no need later
          (i32.const 24)
        )
        (i32.const 24)
      )
    )
    (local.set $z
      (i32.shr_s
        (i32.shl
          (local.get $1) ;; already sign-exted here, so no need later
          (i32.const 24)
        )
        (i32.const 24)
      )
    )
    (drop
      (i32.shr_s
        (i32.shl
          (local.get $z)
          (i32.const 24)
        )
        (i32.const 24)
      )
    )
    (local.set $w
      (i32.shr_s
        (i32.shl
          (local.get $0) ;; already sign-exted here, so no need later
          (i32.const 24)
        )
        (i32.const 24)
      )
    )
    (local.set $w
      (i32.shr_s
        (i32.shl
          (local.get $0) ;; not quite a sign-ext
          (i32.const 23)
        )
        (i32.const 24)
      )
    )
    (drop
      (i32.shr_s
        (i32.shl
          (local.get $w)
          (i32.const 24)
        )
        (i32.const 24)
      )
    )
    (drop ;; odd corner case
      (i32.shr_s
        (i32.shl
          (local.get $0) ;; param, so we should know nothing
          (i32.const 24)
        )
        (i32.const 23) ;; different shift, smaller
      )
    )
  )
  (func $signed-loads-fill-the-bits (param $$e i32) (result i32)
    (local $$0 i32)
    (local $$conv i32)
    (local.set $$0
      (i32.load8_s ;; one byte, but 32 bits due to sign-extend
        (i32.const 1024)
      )
    )
    (local.set $$conv
      (i32.and
        (local.get $$0)
        (i32.const 255) ;; so we need this zexting!
      )
    )
    (return
      (i32.eq
        (local.get $$conv)
        (local.get $$e)
      )
    )
  )
  (func $local-info-sign-ext-already-exted-by-load (param $0 i32) (param $1 i32)
    (local $x i32)
    (local $y i32)
    (local $z i32)
    (local $w i32)
    (local.set $x
      (i32.load8_s (i32.const 1024)) ;; 8 bits, sign extended, no need to do it again
    )
    (drop
      (i32.shr_s
        (i32.shl
          (local.get $x)
          (i32.const 24)
        )
        (i32.const 24)
      )
    )
    (local.set $y
      (i32.load8_u (i32.const 1024)) ;; 8 bits, zext, so bad
    )
    (drop
      (i32.shr_s
        (i32.shl
          (local.get $y)
          (i32.const 24)
        )
        (i32.const 24)
      )
    )
    (local.set $z
      (i32.load16_s (i32.const 1024)) ;; 16 bits sign-extended, wrong size
    )
    (drop
      (i32.shr_s
        (i32.shl
          (local.get $z)
          (i32.const 24)
        )
        (i32.const 24)
      )
    )
  )
  (func $compare-load-s-sign-extend (param $0 i32) (param $1 i32)
    (drop
      (i32.eq
        (i32.load8_s
          (local.get $0)
        )
        (i32.shr_s
          (i32.shl
            (local.get $1)
            (i32.const 24)
          )
          (i32.const 24)
        )
      )
    )
    (drop
      (i32.eq
        (i32.shr_s
          (i32.shl
            (local.get $1)
            (i32.const 24)
          )
          (i32.const 24)
        )
        (i32.load8_s
          (local.get $0) ;; flip order, we should canonicalize
        )
      )
    )
    (drop
      (i32.eq
        (i32.load8_u ;; unsigned, bad
          (local.get $0)
        )
        (i32.shr_s
          (i32.shl
            (local.get $1)
            (i32.const 24)
          )
          (i32.const 24)
        )
      )
    )
    (drop
      (i32.eq
        (i32.load8_s
          (local.get $0)
        )
        (i32.shr_s
          (i32.shl
            (local.get $1)
            (i32.const 16) ;; wrong size
          )
          (i32.const 16)
        )
      )
    )
    (drop
      (i32.eq
        (i32.shr_s
          (i32.shl
            (local.get $1)
            (i32.const 24)
          )
          (i32.const 24)
        )
        (i32.load8_u ;; unsigned, bad
          (local.get $0)
        )
      )
    )
    (drop
      (i32.eq
        (i32.shr_s
          (i32.shl
            (local.get $1)
            (i32.const 16) ;; wrong size
          )
          (i32.const 16)
        )
        (i32.load8_s
          (local.get $0)
        )
      )
    )
  )
  (func $unsign-diff-sizes (param $x i32) (param $y i32) (result i32)
    (i32.ne
      (i32.shr_s
        (i32.shl
          (call $unsign-diff-sizes
            (i32.const -1)
            (i32.const 5)
          )
          (i32.const 24)
        )
        (i32.const 24)
      )
      (i32.shr_s
        (i32.shl
          (call $unsign-diff-sizes
            (i32.const 1)
            (i32.const 2006)
          )
          (i32.const 16)
        )
        (i32.const 16)
      )
    )
  )
  (func $unsign-same-sizes (param $x i32) (param $y i32) (result i32)
    (i32.ne
      (i32.shr_s
        (i32.shl
          (call $unsign-same-sizes
            (i32.const -1)
            (i32.const 5)
          )
          (i32.const 24)
        )
        (i32.const 24)
      )
      (i32.shr_s
        (i32.shl
          (call $unsign-same-sizes
            (i32.const 1)
            (i32.const 2006)
          )
          (i32.const 24)
        )
        (i32.const 24)
      )
    )
  )
  (func $fuzz-almost-sign-ext
    (drop
      (i32.shr_s
        (i32.shl
          (i32.load16_u
            (i32.const 2278)
          )
          (i32.const 17)
        )
        (i32.const 16)
      )
    )
    (drop
      (i32.shr_s
        (i32.shl
          (i32.shl
            (i32.load16_u
              (i32.const 2278)
            )
            (i32.const 1)
          )
          (i32.const 16)
        )
        (i32.const 16)
      )
    )
  )
  (func $fuzz-comp-impossible (param $x i32)
    (drop
      (i32.eq
        (i32.shr_s
          (i32.shl
            (local.get $x)
            (i32.const 16)
          )
          (i32.const 16)
        )
        (i32.const 65535) ;; impossible to be equal, the effective sign bit is set, but not the higher bits, which the sign-ext will set on the non-const value
      )
    )
    (drop
      (i32.eq
        (i32.shr_s
          (i32.shl
            (local.get $x)
            (i32.const 24)
          )
          (i32.const 24)
        )
        (i32.const 255)
      )
    )
    (drop
      (i32.eq
        (i32.shr_s
          (i32.shl
            (local.get $x)
            (i32.const 24)
          )
          (i32.const 24)
        )
        (i32.const 127) ;; safe
      )
    )
    (drop
      (i32.eq
        (i32.shr_s
          (i32.shl
            (local.get $x)
            (i32.const 24)
          )
          (i32.const 24)
        )
        (i32.const 128) ;; unsafe again
      )
    )
    (drop
      (i32.eq
        (i32.shr_s
          (i32.shl
            (local.get $x)
            (i32.const 24)
          )
          (i32.const 24)
        )
        (i32.const 4223) ;; more big bits, so sign bit though
      )
    )
    (drop
      (i32.eq
        (i32.shr_s
          (i32.shl
            (local.get $x)
            (i32.const 24)
          )
          (i32.const 24)
        )
        (i32.const 4224) ;; more big bits
      )
    )
    (drop
      (i32.eq
        (i32.shr_s
          (i32.shl
            (local.get $x)
            (i32.const 24)
          )
          (i32.const 24)
        )
        (i32.const -4) ;; safe even with more big bits, as they are all 1s
      )
    )
  )
  (func $if-parallel (param $0 i32) (param $1 i32)
    (drop
      (if (result i32)
        (local.get $0)
        (i32.add (local.get $1) (i32.const 1))
        (i32.add (local.get $1) (i32.const 1))
      )
    )
    (drop
      (if (result i32)
        (local.tee $0 (local.get $1)) ;; side effects!
        (i32.add (local.get $1) (i32.const 1))
        (i32.add (local.get $1) (i32.const 1))
      )
    )
    (drop
      (if (result i32)
        (local.get $0)
        (i32.add (local.get $1) (unreachable)) ;; folding them would change the type of the if
        (i32.add (local.get $1) (unreachable))
      )
    )
    (drop
      (if (result i32)
        (local.tee $0 (local.get $1)) ;; side effects!
        (i32.add (local.get $1) (unreachable)) ;; folding them would change the type of the if
        (i32.add (local.get $1) (unreachable))
      )
    )
    (drop
      (if (result i32)
        (unreachable) ;; !!!
        (i32.add (local.get $1) (unreachable)) ;; folding them would change the type of the if
        (i32.add (local.get $1) (unreachable))
      )
    )
  )
  (func $select-parallel (param $0 i32) (param $1 i32)
    (drop
      (select
        (i32.add (local.get $1) (i32.const 1))
        (i32.add (local.get $1) (i32.const 1))
        (local.get $0)
      )
    )
    (drop
      (select
        (local.tee $0 (local.get $1)) ;; side effects!
        (local.tee $0 (local.get $1)) ;; side effects!
        (local.get $0)
      )
    )
    (drop
      (select
        (i32.add (local.get $1) (i32.const 1))
        (i32.add (local.get $1) (i32.const 1))
        (local.tee $0 (local.get $1)) ;; side effects! (but no interference with values)
      )
    )
    (drop
      (select
        (local.tee $0 (local.get $1)) ;; side effects! interference!
        (local.tee $0 (local.get $1)) ;; side effects! interference!
        (local.tee $0 (local.get $1)) ;; side effects! interference!
      )
    )
    (drop
      (select
        (local.tee $0 (local.get $1)) ;; side effects!
        (local.tee $0 (local.get $1)) ;; side effects!
        (unreachable) ;; side effects! (but no interference with values)
      )
    )
  )
  (func $zero-shifts-is-not-sign-ext
   (drop
    (i32.eq
     (i32.const -5431187)
     (i32.add
      (i32.const 0)
      (i32.shr_s
       (i32.shl
        (i32.load16_s align=1
         (i32.const 790656516)
        )
        (i32.const 0)
       )
       (i32.const 0)
      )
     )
    )
   )
   (drop
    (i32.eq
     (i32.const -5431187)
     (i32.add
      (i32.const 0)
      (i32.shr_s
       (i32.shl
        (i32.load16_s align=1
         (i32.const 790656516)
        )
        (i32.const 1)
       )
       (i32.const 0)
      )
     )
    )
   )
  )
  (func $zero-ops (result i32)
   (return
    (i32.eq
     (i32.const -1337)
     (i32.shr_u
      (i32.add
       (i32.const 0)
       (i32.shr_s
        (i32.shl
         (i32.load16_s align=1
          (i32.const 790656516)
         )
         (i32.const 0)
        )
        (i32.const 0)
       )
      )
      (i32.const 0)
     )
    )
   )
  )
  (func $sign-ext-1-and-ne (result i32)
   (select
    (i32.ne
     (i32.const 1333788672)
     (i32.shr_s
      (i32.shl
       (call $sign-ext-1-and-ne)
       (i32.const 1)
      )
      (i32.const 1)
     )
    )
    (i32.const 2)
    (i32.const 1)
   )
  )
  (func $neg-shifts-and-255 (result i32)
    (i32.and
     (i32.shr_u
      (i32.const -99)
      (i32.const -32) ;; this shift does nothing
     )
     (i32.const 255)
    )
  )
  (func $neg-shifts-and-255-b (result i32)
   (i32.and
    (i32.shl
     (i32.const -2349025)
     (i32.const -32) ;; this shift does nothing
    )
    (i32.const 255)
   )
  )
  (func $shifts-square-overflow (param $x i32) (result i32)
   (i32.shr_u
    (i32.shr_u
     (local.get $x)
     (i32.const 65535) ;; 31 bits effectively
    )
    (i32.const 32767) ;; also 31 bits, so two shifts that force the value into nothing for sure
   )
  )
  (func $shifts-square-no-overflow-small (param $x i32) (result i32)
   (i32.shr_u
    (i32.shr_u
     (local.get $x)
     (i32.const 1031) ;; 7 bits effectively
    )
    (i32.const 4098) ;; 2 bits effectively
   )
  )
  (func $shifts-square-overflow-64 (param $x i64) (result i64)
   (i64.shr_u
    (i64.shr_u
     (local.get $x)
     (i64.const 65535) ;; 63 bits effectively
    )
    (i64.const 64767) ;; also 63 bits, so two shifts that force the value into nothing for sure
   )
  )
  (func $shifts-square-no-overflow-small-64 (param $x i64) (result i64)
   (i64.shr_u
    (i64.shr_u
     (local.get $x)
     (i64.const 1031) ;; 7 bits effectively
    )
    (i64.const 4098) ;; 2 bits effectively
   )
  )
  (func $shifts-square-unreachable (param $x i32) (result i32)
   (i32.shr_u
    (i32.shr_u
     (unreachable)
     (i32.const 1031) ;; 7 bits effectively
    )
    (i32.const 4098) ;; 2 bits effectively
   )
  )
  (func $mix-shifts (result i32)
    (i32.shr_s
     (i32.shl
      (i32.const 23)
      (i32.const -61)
     )
     (i32.const 168)
    )
  )
  (func $actually-no-shifts (result i32)
    (i32.add
      (i32.shl
        (i32.const 23)
        (i32.const 32) ;; really 0
      )
      (i32.const 10)
    )
  )
  (func $less-shifts-than-it-seems (param $x i32) (result i32)
    (i32.add
      (i32.shl
        (i32.const 200)
        (i32.const 36) ;; really 4
      )
      (i32.shl
        (i32.const 100)
        (i32.const 4)
      )
    )
  )
  (func $and-popcount32 (result i32)
    (i32.and
      (i32.popcnt
        (i32.const -1)
      )
      (i32.const 31)
    )
  )
  (func $and-popcount32-big (result i32)
    (i32.and
      (i32.popcnt
        (i32.const -1)
      )
      (i32.const 63)
    )
  )
  (func $and-popcount64 (result i64) ;; these are TODOs
    (i64.and
      (i64.popcnt
        (i64.const -1)
      )
      (i64.const 63)
    )
  )
  (func $and-popcount64-big (result i64)
    (i64.and
      (i64.popcnt
        (i64.const -1)
      )
      (i64.const 127)
    )
  )
  (func $and-popcount64-bigger (result i64)
    (i64.and
      (i64.popcnt
        (i64.const -1)
      )
      (i64.const 255)
    )
  )
  (func $optimizeAddedConstants-filters-through-nonzero (result i32)
   (i32.sub
    (i32.add
     (i32.shl
      (i32.const -536870912)
      (i32.wrap_i64
       (i64.const 0)
      )
     )
     (i32.const -32768)
    )
    (i32.const -1024)
   )
  )
  (func $optimizeAddedConstants-filters-through-nonzero-b (result i32)
   (i32.sub
    (i32.add
     (i32.shl
      (i32.const -536870912)
      (i32.wrap_i64
       (i64.const -1)
      )
     )
     (i32.const -32768)
    )
    (i32.const -1024)
   )
  )
  (func $return-proper-value-from-shift-left-by-zero (result i32)
   (if (result i32)
    (i32.sub
     (i32.add
      (loop $label$0 (result i32)
       (block $label$1
        (br_if $label$1
         (i32.shl
          (i32.load
           (i32.const 0)
          )
          (i32.const -31904) ;; really 0 shifts
         )
        )
       )
       (i32.const -62)
      )
      (i32.const 38)
     )
     (i32.const -2)
    )
    (i32.const 1)
    (i32.const 0)
   )
  )
  (func $de-morgan-2 (param $x i32) (param $y i32)
    (drop
      (i32.and (i32.eqz (local.get $x)) (i32.eqz (local.get $y)))
    )
    (drop
      (i32.or (i32.eqz (local.get $x)) (i32.eqz (local.get $y)))
    )
    (drop
      (i32.xor (i32.eqz (local.get $x)) (i32.eqz (local.get $y)))
    )
    (drop
      (i32.and (i32.eqz (local.get $x)) (local.get $y))
    )
    (drop
      (i32.and (local.get $x) (i32.eqz (local.get $y)))
    )
    (drop
      (i32.and (i32.eqz (local.get $x)) (i32.wrap_i64 (i64.const 2)))
    )
    (drop
      (i32.and (i32.wrap_i64 (i64.const 1)) (i32.eqz (local.get $y)))
    )
  )
  (func $subzero1 (param $0 i32) (result i32)
    (i32.add
     (i32.sub
      (i32.const 1)
      (i32.clz
       (local.get $0)
      )
     )
     (i32.const 31)
    )
  )
  (func $subzero2 (param $0 i32) (result i32)
    (i32.add
     (i32.const 31)
     (i32.sub
      (i32.const 1)
      (i32.clz
       (local.get $0)
      )
     )
    )
  )
  (func $subzero3 (param $0 i32) (param $1 i32) (result i32)
    (i32.add
     (i32.sub
      (i32.const 0)
      (i32.clz
       (local.get $0)
      )
     )
     (local.get $1)
    )
  )
  (func $subzero4 (param $0 i32) (param $1 i32) (result i32)
    (i32.add
     (local.get $0)
     (i32.sub
      (i32.const 0)
      (i32.clz
       (local.get $1)
      )
     )
    )
  )
  (func $mul-32-power-2 (param $x i32) (result i32)
    (drop
      (call $mul-32-power-2
        (i32.mul
          (local.get $x)
          (i32.const 4)
        )
      )
    )
    (drop
      (call $mul-32-power-2
        (i32.mul
          (local.get $x)
          (i32.const 5)
        )
      )
    )
    (drop
      (call $mul-32-power-2
        (i32.mul
          (local.get $x)
          (i32.const 1)
        )
      )
    )
    (drop
      (call $mul-32-power-2
        (i32.mul
          (local.get $x)
          (i32.const 0)
        )
      )
    )
    (drop
      (call $mul-32-power-2
        (i32.mul
          (call $mul-32-power-2 (i32.const 123)) ;; side effects
          (i32.const 0)
        )
      )
    )
    (drop
      (call $mul-32-power-2
        (i32.mul
          (local.get $x)
          (i32.const 0xffffffff)
        )
      )
    )
    (drop
      (call $mul-32-power-2
        (i32.mul
          (local.get $x)
          (i32.const 0x80000000)
        )
      )
    )
    (unreachable)
  )
    (func $mul-64-power-2 (param $x i64) (result i64)
    (drop
      (call $mul-64-power-2
        (i64.mul
          (local.get $x)
          (i64.const 4)
        )
      )
    )
    (drop
      (call $mul-64-power-2
        (i64.mul
          (local.get $x)
          (i64.const 5)
        )
      )
    )
    (drop
      (call $mul-64-power-2
        (i64.mul
          (local.get $x)
          (i64.const 1)
        )
      )
    )
    (drop
      (call $mul-64-power-2
        (i64.mul
          (local.get $x)
          (i64.const 0)
        )
      )
    )
    (drop
      (call $mul-64-power-2
        (i64.mul
          (call $mul-64-power-2 (i64.const 123)) ;; side effects
          (i64.const 0)
        )
      )
    )
    (drop
      (call $mul-64-power-2
        (i64.mul
          (local.get $x)
          (i64.const 0xffffffffffffffff)
        )
      )
    )
    (drop
      (call $mul-64-power-2
        (i64.mul
          (local.get $x)
          (i64.const 0x8000000000000000)
        )
      )
    )
    (unreachable)
  )
  (func $div-32-power-2 (param $x i32) (result i32)
    (drop
      (call $div-32-power-2
        (i32.div_u
          (local.get $x)
          (i32.const 4)
        )
      )
    )
    (drop
      (call $div-32-power-2
        (i32.div_u
          (local.get $x)
          (i32.const 5)
        )
      )
    )
    (drop
      (call $div-32-power-2
        (i32.div_u
          (local.get $x)
          (i32.const 1)
        )
      )
    )
    (drop
      (call $div-32-power-2
        (i32.div_u
          (local.get $x)
          (i32.const 0)
        )
      )
    )
    (drop
      (call $div-32-power-2
        (i32.div_u
          (call $div-32-power-2 (i32.const 123)) ;; side effects
          (i32.const 0)
        )
      )
    )
    (drop
      (call $div-32-power-2
        (i32.div_u
          (local.get $x)
          (i32.const 0xffffffff)
        )
      )
    )
    (drop
      (call $div-32-power-2
        (i32.div_u
          (local.get $x)
          (i32.const 0x80000000)
        )
      )
    )
    (unreachable)
  )
  (func $urem-32-power-2 (param $x i32) (result i32)
    (drop
      (call $urem-32-power-2
        (i32.rem_u
          (local.get $x)
          (i32.const 4)
        )
      )
    )
    (drop
      (call $urem-32-power-2
        (i32.rem_u
          (local.get $x)
          (i32.const 5)
        )
      )
    )
    (drop
      (call $urem-32-power-2
        (i32.rem_u
          (local.get $x)
          (i32.const 1)
        )
      )
    )
    (drop
      (call $urem-32-power-2
        (i32.rem_u
          (local.get $x)
          (i32.const 0)
        )
      )
    )
    (drop
      (call $urem-32-power-2
        (i32.rem_u
          (local.get $x)
          (i32.const 0xffffffff)
        )
      )
    )
    (drop
      (call $urem-32-power-2
        (i32.rem_u
          (local.get $x)
          (i32.const 0x80000000)
        )
      )
    )
    ;; (unsigned)x % 1
    (drop
      (call $urem-32-power-2
        (i32.rem_u
          (local.get $x)
          (i32.const 1)
        )
      )
    )
    (unreachable)
  )
  (func $srem-by-1 (param $x i32) (param $y i64)
    ;; (signed)x % 1
    (drop (i32.rem_s
      (local.get $x)
      (i32.const 1)
    ))
    (drop (i64.rem_s
      (local.get $y)
      (i64.const 1)
    ))
  )
  (func $orZero (param $0 i32) (result i32)
    (i32.or
      (local.get $0)
      (i32.const 0)
    )
  )
  (func $andZero (param $0 i32) (result i32)
    (drop
      (i32.and
        (local.get $0)
        (i32.const 0)
      )
    )
    (drop
      (i32.and
        (call $andZero (i32.const 1234)) ;; side effects
        (i32.const 0)
      )
    )
    (unreachable)
  )
  (func $abstract-additions (param $x32 i32) (param $x64 i64) (param $y32 f32) (param $y64 f64)
    (drop
      (i32.or
        (i32.const 0)
        (local.get $x32)
      )
    )
    (drop
      (i32.shl
        (local.get $x32)
        (i32.const 0)
      )
    )
    (drop
      (i32.shr_u
        (local.get $x32)
        (i32.const 0)
      )
    )
    (drop
      (i32.shr_s
        (local.get $x32)
        (i32.const 0)
      )
    )
    (drop
      (i64.or
        (i64.const 0)
        (local.get $x64)
      )
    )
    (drop
      (i64.shl
        (local.get $x64)
        (i64.const 0)
      )
    )
    (drop
      (i64.shr_u
        (local.get $x64)
        (i64.const 0)
      )
    )
    (drop
      (i64.shr_s
        (local.get $x64)
        (i64.const 0)
      )
    )
    (drop
      (i32.mul
        (local.get $x32)
        (i32.const 0)
      )
    )
    (drop
      (i64.mul
        (local.get $x64)
        (i64.const 0)
      )
    )
    (drop
      (f32.mul
        (local.get $y32)
        (f32.const 0)
      )
    )
    (drop
      (f64.mul
        (local.get $y64)
        (f64.const 0)
      )
    )
    (drop
      (i32.mul
        (local.get $x32)
        (i32.const 1)
      )
    )
    (drop
      (i64.mul
        (local.get $x64)
        (i64.const 1)
      )
    )
    (drop
      (f32.mul
        (local.get $y32)
        (f32.const 1)
      )
    )
    (drop
      (f64.mul
        (local.get $y64)
        (f64.const 1)
      )
    )
    (drop
      (i32.and
        (local.get $x32)
        (i32.const 0)
      )
    )
    (drop
      (i64.and
        (local.get $x64)
        (i64.const 0)
      )
    )
    (drop
      (i32.and
        (unreachable)
        (i32.const 0)
      )
    )
    (drop
      (i64.and
        (unreachable)
        (i64.const 0)
      )
    )
    (drop
      (i32.div_s
        (local.get $x32)
        (i32.const 1)
      )
    )
    (drop
      (i32.div_u
        (local.get $x32)
        (i32.const 1)
      )
    )
    (drop
      (i64.div_s
        (local.get $x64)
        (i64.const 1)
      )
    )
    (drop
      (i64.div_u
        (local.get $x64)
        (i64.const 1)
      )
    )
    (drop
      (f32.div
        (local.get $y32)
        (f32.const 1)
      )
    )
    (drop
      (f64.div
        (local.get $y64)
        (f64.const 1)
      )
    )
    (drop
      (f32.div
        (local.get $y32)
        (f32.const 1.2)
      )
    )
    (drop
      (i32.mul
        (local.get $x32)
        (i32.const -1)
      )
    )
    (drop
      (i64.mul
        (local.get $x64)
        (i64.const -1)
      )
    )
    (drop
      (f32.mul
        (local.get $y32)
        (f32.const -1)
      )
    )
    (drop
      (f64.mul
        (local.get $y64)
        (f64.const -1)
      )
    )
    (drop
      (i32.eq
        (i32.add
          (local.get $x32)
          (i32.const 10)
        )
        (i32.const 20)
      )
    )
    (drop
      (i32.le_u
        (i32.add
          (local.get $x32)
          (i32.const 10)
        )
        (i32.const 20)
      )
    )
    (drop
      (i32.eq
        (i32.sub
          (local.get $x32)
          (i32.const 10)
        )
        (i32.const 20)
      )
    )
    (drop
      (i64.eq
        (i64.add
          (local.get $x64)
          (i64.const 10)
        )
        (i64.const 20)
      )
    )
    (drop
      (i32.eq
        (i32.const 20)
        (i32.add
          (local.get $x32)
          (i32.const 10)
        )
      )
    )
    (drop
      (i32.eq
        (i32.add
          (local.get $x32)
          (i32.const 10)
        )
        (i32.add
          (local.get $x32)
          (i32.const 20)
        )
      )
    )
    (drop
      (i32.eq
        (i32.sub
          (local.get $x32)
          (i32.const 10)
        )
        (i32.const 20)
      )
    )
    (drop
      (i32.eq
        (i32.add
          (local.get $x32)
          (i32.const 10)
        )
        (i32.sub
          (local.get $x32)
          (i32.const 20)
        )
      )
    )
    (drop
      (i32.eq
        (i32.sub
          (local.get $x32)
          (i32.const 10)
        )
        (i32.add
          (local.get $x32)
          (i32.const 20)
        )
      )
    )
    (drop
      (i32.eq
        (i32.sub
          (local.get $x32)
          (i32.const 10)
        )
        (i32.sub
          (local.get $x32)
          (i32.const 20)
        )
      )
    )
    (drop
      (i64.le_s
        (i64.sub
          (local.get $x64)
          (i64.const 288230376151711744)
        )
        (i64.const 9223372036854775807)
      )
    )
  )
  (func $negatives-are-sometimes-better (param $x i32) (param $y i64) (param $z f32)
    (drop (i32.add (local.get $x) (i32.const 0x40)))
    (drop (i32.sub (local.get $x) (i32.const 0x40)))
    (drop (i32.add (local.get $x) (i32.const 0x2000)))
    (drop (i32.add (local.get $x) (i32.const 0x100000)))
    (drop (i32.add (local.get $x) (i32.const 0x8000000)))

    (drop (i64.add (local.get $y) (i64.const 0x40)))
    (drop (i64.sub (local.get $y) (i64.const 0x40)))
    (drop (i64.add (local.get $y) (i64.const 0x2000)))
    (drop (i64.add (local.get $y) (i64.const 0x100000)))
    (drop (i64.add (local.get $y) (i64.const 0x8000000)))

    (drop (i64.add (local.get $y) (i64.const 0x400000000)))
    (drop (i64.add (local.get $y) (i64.const 0x20000000000)))
    (drop (i64.add (local.get $y) (i64.const 0x1000000000000)))
    (drop (i64.add (local.get $y) (i64.const 0x80000000000000)))
    (drop (i64.add (local.get $y) (i64.const 0x4000000000000000)))

    (drop (f32.add (local.get $z) (f32.const 0x40)))
  )
  (func $shift-a-zero (param $x i32) (param $y i64) (param $z f32)
    (drop
      (i32.shl
        (i32.const 0)
        (local.get $x)
      )
    )
    (drop
      (i32.shr_u
        (i32.const 0)
        (local.get $x)
      )
    )
    (drop
      (i32.shr_s
        (i32.const 0)
        (local.get $x)
      )
    )
    (drop
      (i64.shl
        (i64.const 0)
        (local.get $y)
      )
    )
    (drop
      (i32.shl
        (i32.const 0)
        (unreachable)
      )
    )
  )
  (func $identical-siblings (param $x i32) (param $y i64) (param $z f64) (param $xx i32)
    (drop
      (i32.sub
        (local.get $x)
        (local.get $x)
      )
    )
    (drop
      (i64.sub
        (local.get $y)
        (local.get $y)
      )
    )
    (drop
      (f64.sub
        (local.get $z)
        (local.get $z)
      )
    )
    (drop
      (i32.sub
        (local.get $x)
        (local.get $xx)
      )
    )
    (drop
      (i32.sub
        (unreachable)
        (unreachable)
      )
    )
    (drop
      (i32.add
        (local.get $x)
        (local.get $x)
      )
    )
    ;; more ops
    (drop
      (i32.xor
        (local.get $x)
        (local.get $x)
      )
    )
    (drop
      (i32.ne
        (local.get $x)
        (local.get $x)
      )
    )
    (drop
      (i32.lt_s
        (local.get $x)
        (local.get $x)
      )
    )
    (drop
      (i32.lt_u
        (local.get $x)
        (local.get $x)
      )
    )
    (drop
      (i32.gt_s
        (local.get $x)
        (local.get $x)
      )
    )
    (drop
      (i32.gt_u
        (local.get $x)
        (local.get $x)
      )
    )
    (drop
      (i32.and
        (local.get $x)
        (local.get $x)
      )
    )
    (drop
      (i32.or
        (local.get $x)
        (local.get $x)
      )
    )
    (drop
      (i32.eq
        (local.get $x)
        (local.get $x)
      )
    )
    (drop
      (i32.le_s
        (local.get $x)
        (local.get $x)
      )
    )
    (drop
      (i32.le_u
        (local.get $x)
        (local.get $x)
      )
    )
    (drop
      (i32.ge_s
        (local.get $x)
        (local.get $x)
      )
    )
    (drop
      (i32.ge_u
        (local.get $x)
        (local.get $x)
      )
    )
    (drop
      (i64.xor
        (local.get $y)
        (local.get $y)
      )
    )
    (drop
      (i64.ne
        (local.get $y)
        (local.get $y)
      )
    )
    (drop
      (i64.lt_s
        (local.get $y)
        (local.get $y)
      )
    )
    (drop
      (i64.lt_u
        (local.get $y)
        (local.get $y)
      )
    )
    (drop
      (i64.gt_s
        (local.get $y)
        (local.get $y)
      )
    )
    (drop
      (i64.gt_u
        (local.get $y)
        (local.get $y)
      )
    )
    (drop
      (i64.and
        (local.get $y)
        (local.get $y)
      )
    )
    (drop
      (i64.or
        (local.get $y)
        (local.get $y)
      )
    )
    (drop
      (i64.eq
        (local.get $y)
        (local.get $y)
      )
    )
    (drop
      (i64.le_s
        (local.get $y)
        (local.get $y)
      )
    )
    (drop
      (i64.le_u
        (local.get $y)
        (local.get $y)
      )
    )
    (drop
      (i64.ge_s
        (local.get $y)
        (local.get $y)
      )
    )
    (drop
      (i64.ge_u
        (local.get $y)
        (local.get $y)
      )
    )
  )
  (func $all_ones (param $x i32) (param $y i64)
    (drop
      (i32.and
        (local.get $x)
        (i32.const -1)
      )
    )
    (drop
      (i32.or
        (local.get $x)
        (i32.const -1)
      )
    )
    (drop
      (i32.or
        (local.tee $x
          (i32.const 1337)
        )
        (i32.const -1)
      )
    )
    (drop
      (i64.and
        (local.get $y)
        (i64.const -1)
      )
    )
    (drop
      (i64.or
        (local.get $y)
        (i64.const -1)
      )
    )
  )
  (func $xor (param $x i32) (param $y i64)
    (drop
      (i32.xor
        (local.get $x)
        (i32.const 0)
      )
    )
  )
  (func $select-on-const (param $x i32) (param $y i64)
    (drop
      (select
        (i32.const 2)
        (local.get $x)
        (i32.const 0)
      )
    )
    (drop
      (select
        (i32.const 3)
        (local.get $x)
        (i32.const 1)
      )
    )
    (drop
      (select
        (i32.const 4)
        (local.tee $x
          (i32.const 5)
        )
        (i32.const 0)
      )
    )
    (drop
      (select
        (local.tee $x
          (i32.const 6)
        )
        (i32.const 7)
        (i32.const 0)
      )
    )
    (drop
      (select
        (i32.const 4)
        (local.tee $x
          (i32.const 5)
        )
        (i32.const 1)
      )
    )
    (drop
      (select
        (local.tee $x
          (i32.const 6)
        )
        (i32.const 7)
        (i32.const 1)
      )
    )
    (drop
      (select
        (i32.const 1)
        (i32.const 0)
        (local.get $x)
      )
    )
    (drop
      (select
        (i32.const 0)
        (i32.const 1)
        (local.get $x)
      )
    )
    (drop
      (select
        (i32.const 0)
        (i32.const 1)
        (i32.lt_s
          (local.get $x)
          (i32.const 0)
        )
      )
    )
    (drop
      (select
        (i32.const 1)
        (i32.const 0)
        (i32.lt_s
          (local.get $x)
          (i32.const 0)
        )
      )
    )
    (drop
      (select
        (i32.const 0)
        (i32.const 1)
        (i32.ge_s
          (local.get $x)
          (i32.const 0)
        )
      )
    )
    (drop
      (select
        (i32.const 1)
        (i32.const 0)
        (i32.gt_s
          (local.get $x)
          (i32.const 0)
        )
      )
    )
    (drop
      (select
        (i32.const 0)
        (i32.const 1)
        (i32.gt_s
          (local.get $x)
          (i32.const 0)
        )
      )
    )
    (drop
      (select
        (i32.const 1)
        (i32.const 0)
        (i32.ge_s
          (local.get $x)
          (i32.const 0)
        )
      )
    )
    (drop
      (select
        (i64.const 1)
        (i64.const 0)
        (local.get $x)
      )
    )
    (drop
      (select
        (i64.const 0)
        (i64.const 1)
        (local.get $x)
      )
    )
    (drop
      (select
        (i64.const 1)
        (i64.const 0)
        (i64.eqz
          (local.get $y)
        )
      )
    )
    (drop
      (select
        (i64.const 0)
        (i64.const 1)
        (i64.eqz
          (local.get $y)
        )
      )
    )
    (drop
      (select
        (i64.const 0)
        (i64.const 1)
        (i64.lt_s
          (local.get $y)
          (i64.const 0)
        )
      )
    )
    (drop
      (select
        (i64.const 1)
        (i64.const 0)
        (i64.lt_s
          (local.get $y)
          (i64.const 0)
        )
      )
    )
    (drop
      (select
        (i64.const 0)
        (i64.const 1)
        (i64.ge_s
          (local.get $y)
          (i64.const 0)
        )
      )
    )
    (drop
      (select
        (i64.const 1)
        (i64.const 0)
        (i64.ge_s
          (local.get $y)
          (i64.const 0)
        )
      )
    )
    ;; optimize boolean
    (drop
      (select
        (local.get $x)
        (i32.const 0)
        (i32.eqz
          (i32.const 0)
        )
      )
    )
    (drop
      (select
        (local.get $x)
        (i32.const 2)
        (i32.eqz
          (i32.const 2)
        )
      )
    )
    (drop
      (select
        (local.get $x)
        (i32.const 2)
        (i32.eqz
          (i32.eqz
            (local.get $x)
          )
        )
      )
    )
    (drop
      (select
        (local.get $y)
        (i64.const 0)
        (i64.eqz
          (i64.const 0)
        )
      )
    )
    (drop
      (select
        (local.get $y)
        (i64.const 2)
        (i64.eqz
          (i64.const 2)
        )
      )
    )
  )
  (func $optimize-boolean (param $x i32)
    (drop
      (select
        (i32.const 1)
        (i32.const 2)
        (i32.sub        ;; bool(-x) -> bool(x)
          (i32.const 0)
          (local.get $x)
        )
      )
    )
  )
  (func $getFallthrough ;; unit tests for Properties::getFallthrough
    (local $x0 i32)
    (local $x1 i32)
    (local $x2 i32)
    (local $x3 i32)
    (local $x4 i32)
    (local $x5 i32)
    (local $x6 i32)
    (local $x7 i32)
    ;; the trivial case
    (local.set $x0 (i32.const 1))
    (drop (i32.and (local.get $x0) (i32.const 7)))
    ;; tees
    (local.set $x1 (local.tee $x2 (i32.const 1)))
    (drop (i32.and (local.get $x1) (i32.const 7)))
    ;; loop
    (local.set $x3 (loop (result i32) (i32.const 1)))
    (drop (i32.and (local.get $x3) (i32.const 7)))
    ;; if - two sides, can't
    (local.set $x4 (if (result i32) (i32.const 1) (i32.const 2) (i32.const 3)))
    (drop (i32.and (local.get $x4) (i32.const 7)))
    ;; if - one side, can
    (local.set $x5 (if (result i32) (i32.const 1) (unreachable) (i32.const 3)))
    (drop (i32.and (local.get $x5) (i32.const 7)))
    ;; if - one side, can
    (local.set $x6 (if (result i32) (i32.const 1) (i32.const 3) (unreachable)))
    (drop (i32.and (local.get $x6) (i32.const 7)))
    ;; br_if with value
    (drop
      (block $out (result i32)
        (local.set $x7 (br_if $out (i32.const 1) (i32.const 1)))
        (drop (i32.and (local.get $x7) (i32.const 7)))
        (unreachable)
      )
    )
  )
  (func $tee-with-unreachable-value (result f64)
   (local $var$0 i32)
   (block $label$1 (result f64)
    (local.tee $var$0
     (br_if $label$1 ;; the f64 does not actually flow through this, it's unreachable (and the type is wrong - but unchecked)
      (f64.const 1)
      (unreachable)
     )
    )
   )
  )
  (func $add-sub-zero-reorder-1 (param $temp i32) (result i32)
   (i32.add
    (i32.add
     (i32.sub
      (i32.const 0) ;; this zero looks like we could remove it by subtracting the get of $temp from the parent, but that would reorder it *after* the tee :(
      (local.get $temp)
     )
     (local.tee $temp ;; cannot move this tee before the get
      (i32.const 1)
     )
    )
    (i32.const 2)
   )
  )
  (func $add-sub-zero-reorder-2 (param $temp i32) (result i32)
   (i32.add
    (i32.add
     (local.tee $temp ;; in this order, the tee already comes first, so all is good for the optimization
      (i32.const 1)
     )
     (i32.sub
      (i32.const 0)
      (local.get $temp)
     )
    )
    (i32.const 2)
   )
  )
  (func $rhs-is-neg-one (param $x i32) (param $y i64) (param $fx f32) (param $fy f64)
    (drop (i32.sub
      (local.get $x)
      (i32.const -1)
    ))
    (drop (i64.sub
      (local.get $y)
      (i64.const -1)
    ))
    (drop (i32.gt_u
      (local.get $x)
      (i32.const -1)
    ))
    (drop (i64.gt_u
      (local.get $y)
      (i64.const -1)
    ))
    (drop (i32.gt_s
      (local.get $x)
      (i32.const -1)
    ))
    (drop (i64.gt_s
      (local.get $y)
      (i64.const -1)
    ))
    (drop (i64.extend_i32_s
      (i64.gt_u
        (i64.const 0)
        (i64.const -1)
      )
    ))
    ;; (unsigned)x <= -1   ==>   1
    (drop (i32.le_u
      (local.get $x)
      (i32.const -1)
    ))
    (drop (i64.le_u
      (local.get $y)
      (i64.const -1)
    ))
    (drop (i32.le_s
      (local.get $x)
      (i32.const -1)
    ))
    (drop (i64.le_s
      (local.get $y)
      (i64.const -1)
    ))
    ;; x * -1
    (drop (i32.mul
      (local.get $x)
      (i32.const -1)
    ))
    (drop (i64.mul
      (local.get $y)
      (i64.const -1)
    ))
    (drop (f32.mul    ;; skip
      (local.get $fx)
      (f32.const -1)
    ))
    (drop (f64.mul    ;; skip
      (local.get $fy)
      (f64.const -1)
    ))
    ;; (unsigned)x / -1
    (drop (i32.div_u
      (local.get $x)
      (i32.const -1)
    ))
    (drop (i64.div_u
      (local.get $y)
      (i64.const -1)
    ))
  )
  (func $pre-combine-or (param $x i32) (param $y i32)
    (drop (i32.or
      (i32.gt_s
        (local.get $x)
        (local.get $y)
      )
      (i32.eq
        (local.get $y) ;; ordering should not stop us
        (local.get $x)
      )
    ))
    (drop (i32.or
      (i32.eq ;; ordering should not stop us
        (local.get $y)
        (local.get $x)
      )
      (i32.gt_s
        (local.get $x)
        (local.get $y)
      )
    ))
    (drop (i32.or
      (i32.gt_s
        (local.get $x)
        (local.get $y)
      )
      (i32.eq
        (local.get $x)
        (i32.const 1) ;; not equal
      )
    ))
    (drop (i32.or
      (i32.gt_s
        (local.get $x)
        (i32.const 1) ;; not equal
      )
      (i32.eq
        (local.get $x)
        (local.get $y)
      )
    ))
    (drop (i32.or
      (i32.gt_s
        (call $ne0) ;; side effects
        (local.get $y)
      )
      (i32.eq
        (call $ne0)
        (local.get $y)
      )
    ))
    (drop (i32.or
      (i32.gt_s
        (local.get $y)
        (call $ne0) ;; side effects
      )
      (i32.eq
        (local.get $y)
        (call $ne0)
      )
    ))
  )
  (func $combine-or (param $x i32) (param $y i32)
    (drop (i32.or
      (i32.gt_s
        (local.get $x)
        (local.get $y)
      )
      (i32.eq
        (local.get $x)
        (local.get $y)
      )
    ))
    ;; TODO: more stuff here
  )
  (func $select-into-arms (param $x i32) (param $y i32)
    (if
      (select
        (i32.eqz (i32.eqz (local.get $x)))
        (i32.eqz (i32.eqz (local.get $y)))
        (local.get $y)
      )
      (unreachable)
    )
  )
  ;; Tests when if arms are subtype of if's type
  (func $if-arms-subtype (result anyref)
    (if (result anyref)
      (i32.const 0)
      (ref.null extern)
      (ref.null func)
    )
  )
  (func $optimize-boolean-context (param $x i32) (param $y i32)
    ;; 0 - x   ==>   x
    (if
      (i32.sub
        (i32.const 0)
        (local.get $x)
      )
      (unreachable)
    )
    (drop (select
      (local.get $x)
      (local.get $y)
      (i32.sub
        (i32.const 0)
        (local.get $x)
      )
    ))
  )
  (func $optimize-bulk-memory-copy (param $dst i32) (param $src i32) (param $sz i32)
    (memory.copy  ;; skip
      (local.get $dst)
      (local.get $dst)
      (local.get $sz)
    )

    (memory.copy  ;; skip
      (local.get $dst)
      (local.get $src)
      (i32.const 0)
    )

    (memory.copy
      (local.get $dst)
      (local.get $src)
      (i32.const 1)
    )

    (memory.copy
      (local.get $dst)
      (local.get $src)
      (i32.const 2)
    )

    (memory.copy
      (local.get $dst)
      (local.get $src)
      (i32.const 3)
    )

    (memory.copy
      (local.get $dst)
      (local.get $src)
      (i32.const 4)
    )

    (memory.copy
      (local.get $dst)
      (local.get $src)
      (i32.const 5)
    )

    (memory.copy
      (local.get $dst)
      (local.get $src)
      (i32.const 6)
    )

    (memory.copy
      (local.get $dst)
      (local.get $src)
      (i32.const 7)
    )

    (memory.copy
      (local.get $dst)
      (local.get $src)
      (i32.const 8)
    )

    (memory.copy
      (local.get $dst)
      (local.get $src)
      (i32.const 16)
    )

    (memory.copy  ;; skip
      (local.get $dst)
      (local.get $src)
      (local.get $sz)
    )

    (memory.copy  ;; skip
      (i32.const 0)
      (i32.const 0)
      (i32.load
        (i32.const 3) ;; side effect
      )
    )
  )
)
(module
  (import "env" "memory" (memory $0 (shared 256 256)))
  (func $x
   (drop
    (i32.shr_s
     (i32.shl
      (i32.atomic.load8_u ;; can't be signed
       (i32.const 100)
      )
      (i32.const 24)
     )
     (i32.const 24)
    )
   )
  )
)
