
;; Test for confusion regarding internal function names when using
;; call_indirect.

(module $primary
  (import "spectest" "print_i32" (func $log (param i32)))

  (func $run (export "run") (result funcref)
    (call $log (i32.const -1))
    (ref.func $run)
  )
)

(register "primary")

(module $secondary
  (type $func (func (result funcref)))

  (import "spectest" "print_i32" (func $log (param i32)))

  (import "primary" "run" (func $primary_run (result funcref)))

  (table $table 10 20 funcref)

  (global $sum (mut i32) (i32.const 0))

  (func $run (export "secondary_run") (result funcref)
    (global.set $sum
      (i32.add
        (global.get $sum)
        (i32.const 1)
      )
    )
    (call $log (i32.const 10))
    (table.set $table
      (i32.const 0)
      (call $primary_run)
    )
    (call $log (i32.const 20))
    ;; This should call primary's $run, not ours. The overlap in internal name
    ;; should not confuse us. If we do get confused, we'd recurse here and keep
    ;; incrementing $sum.
    (call_indirect (type $func)
      (i32.const 0)
    )
  )

  (func $sum (export "secondary_sum") (result i32)
    (global.get $sum)
  )
)

(invoke "secondary_run")
(assert_return (invoke "secondary_sum") (i32.const 1))

