(module
  (type $ii (param i32) (result i32))
  (memory (shared 1 1))
  (table 0 funcref)
  (global $g (mut f32) (f32.const 0))
  (event $e (attr 0) (param i32))

  (func $foo (param i32) (result i32) (i32.const 0))

  (func $test_function_block
    ;; block, which has unreachable type, can be omitted here because it is the
    ;; only expression within a function. We emit an extra unreachable at the
    ;; end.
    (block
      (unreachable)
      (nop)
    )
  )

  (func $test
    ;; block has unreachable type. We emit an unreachable at the end of the
    ;; block and also outside the block too.
    (block
      (i32.eqz (unreachable))
    )

    ;; If an if's condition is unreachable, don't emit the if and emit an
    ;; unreachable instead.
    (if
      (unreachable)
      (nop)
      (nop)
    )

    ;; If an if is unreachable, i.e., the both sides are unreachable, we emit
    ;; an extra unreachable after the if.
    (if
      (i32.const 1)
      (unreachable)
      (unreachable)
    )

    ;; If a try is unreachable, i.e., both the 'try' and 'catch' bodies are
    ;; unreachable, we emit an extra unreachable after the try.
    (try
      (unreachable)
      (catch
        (unreachable)
      )
    )

    ;; If a br_if/br_on_exn's type is unreachable, emit an extra unreachable
    ;; after it
    (block
      (br_if 0 (unreachable))
    )
    (drop
      (block (result i32)
        (br_on_exn 0 $e (unreachable))
      )
    )

    ;; If a br_table is not reachable, emit an unreachable instead
    (block $l
      (block $default
        (br_table $l $default
          (unreachable)
        )
      )
    )

    ;; For all tests below, when a value-returning expression is unreachable,
    ;; emit an unreachable instead of the operation, to prevent it from being
    ;; consumed by the next operation.
    ;;
    ;; Here global.set is used to consume the value. If an unreachable is not
    ;; emitted, the instruction itself will be consumed by global.set and will
    ;; result in a type validation failure, because it expects a f32 but gets an
    ;; i32. The reason we use global.set is the instruction does not return a
    ;; value, so it will be emitted even if its argument is unreachable.

    ;; call / call_indirect
    (global.set $g
      (call $foo (unreachable))
    )
    (global.set $g
      (call_indirect (type $ii) (unreachable))
    )

    ;; unary
    (global.set $g
      (i32.eqz (unreachable))
    )

    ;; binary
    (global.set $g
      (i32.add
        (unreachable)
        (i32.const 0)
      )
    )

    ;; select
    (global.set $g
      (select
        (unreachable)
        (i32.const 0)
        (i32.const 0)
      )
    )

    ;; load
    (global.set $g
      (i32.load (unreachable))
    )
    (global.set $g
      (i32.atomic.load (unreachable))
    )

    ;; atomic.rmw
    (global.set $g
      (i32.atomic.rmw.add
        (unreachable)
        (i32.const 0)
      )
    )

    ;; atomic.cmpxchg
    (global.set $g
      (i32.atomic.rmw.cmpxchg
        (unreachable)
        (i32.const 0)
        (i32.const 0)
      )
    )

    ;; atomic.wait
    (global.set $g
      (i32.atomic.wait
        (unreachable)
        (i32.const 0)
        (i64.const 0)
      )
    )

    ;; atomic.notify
    (global.set $g
      (atomic.notify
        (unreachable)
        (i32.const 0)
      )
    )

    ;; SIMD extract
    (global.set $g
      (i32x4.extract_lane 0
        (unreachable)
      )
    )

    ;; SIMD replace
    (global.set $g
      (i32x4.replace_lane 0
        (unreachable)
        (i32.const 0)
      )
    )

    ;; SIMD shuffle
    (global.set $g
      (v8x16.shuffle 0 17 2 19 4 21 6 23 8 25 10 27 12 29 14 31
        (unreachable)
        (unreachable)
      )
    )

    ;; SIMD bitselect
    (global.set $g
      (v128.bitselect
        (unreachable)
        (unreachable)
        (unreachable)
      )
    )

    ;; SIMD shift
    (global.set $g
      (i32x4.shl
        (unreachable)
        (i32.const 0)
      )
    )
  )
)
