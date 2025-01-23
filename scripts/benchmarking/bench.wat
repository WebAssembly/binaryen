;; See bench.js.

(module
  ;; A chain of three types. Each type has a "next" field, so we can form linked
  ;; lists.
  (type $A (sub (struct (field $next (ref null $A)))))
  (type $B (sub $A (struct (field $next (ref null $A)))))
  (type $C (sub $B (struct (field $next (ref null $A)))))

  (type $func (func (param (ref $A)) (result i32)))

  ;; Internal helper to iterate over a linked list and call a function on each
  ;; item, and return the sum of those calls' results.
  (func $iter (param $list (ref null $A)) (param $func (ref $func)) (result i32)
    (local $sum i32)
    (loop $loop
      (if
        (ref.is_null
          (local.get $list)
        )
        (then
          (return
            (local.get $sum)
          )
        )
        (else
          (local.set $sum
            (i32.add
              (local.get $sum)
              (call_ref $func
                (ref.as_non_null
                  (local.get $list)
                )
                (local.get $func)
              )
            )
          )
          (local.set $list
            (struct.get $A $next
              (local.get $list)
            )
          )
          (br $loop)
        )
      )
    )
  )

  ;; Using the helper, and depending on inlining to optimize this, lets us
  ;; write the exports concisely. First, code to compute the length of the list
  ;; (for comparison purposes).
  (func $len (export "len") (param $list (ref $A)) (result i32)
    (call $iter
      (local.get $list)
      ;; Add one each time this is called.
      (ref.func $one)
    )
  )
  (func $one (param $list (ref $A)) (result i32)
    (i32.const 1)
  )

  ;; At each point in the linked list, check if both the current and next item
  ;; are inputs are $B, using an if to short-circuit when possible.
  (func $iff-both (export "iff-both") (param $list (ref $A)) (result i32)
    (call $iter
      (local.get $list)
      (ref.func $do-iff-both)
    )
  )
  (func $do-iff-both (param $list (ref $A)) (result i32)
    (if (result i32)
      (ref.test (ref $B)
        (struct.get $A $next
          (local.get $list)
        )
      )
      (then
        (ref.test (ref $B)
          (local.get $list)
        )
      )
      (else
        (i32.const 0)
      )
    )
  )

  ;; The same computation, but using an and, so both tests always execute.
  (func $and (export "and") (param $list (ref $A)) (result i32)
    (call $iter
      (local.get $list)
      (ref.func $do-and)
    )
  )
  (func $do-and (param $list (ref $A)) (result i32)
    (i32.and
      (ref.test (ref $B)
        (struct.get $A $next
          (local.get $list)
        )
      )
      (ref.test (ref $B)
        (local.get $list)
      )
    )
  )

  ;; Similar, but return 1 if either test succeeds (using an if).
  (func $iff-either (export "iff-either") (param $list (ref $A)) (result i32)
    (call $iter
      (local.get $list)
      (ref.func $do-iff-either)
    )
  )
  (func $do-iff-either (param $list (ref $A)) (result i32)
    (if (result i32)
      (ref.test (ref $B)
        (struct.get $A $next
          (local.get $list)
        )
      )
      (then
        (i32.const 1)
      )
      (else
        (ref.test (ref $B)
          (local.get $list)
        )
      )
    )
  )


  ;; The same computation, but using an or, so both tests always execute.
  (func $or (export "or") (param $list (ref $A)) (result i32)
    (call $iter
      (local.get $list)
      (ref.func $do-or)
    )
  )
  (func $do-or (param $list (ref $A)) (result i32)
    (i32.or
      (ref.test (ref $B)
        (struct.get $A $next
          (local.get $list)
        )
      )
      (ref.test (ref $B)
        (local.get $list)
      )
    )
  )

  ;; Use a select to do a test of "is next null ? 0 : test curr".
  (func $select (export "select") (param $list (ref $A)) (result i32)
    (call $iter
      (local.get $list)
      (ref.func $do-select)
    )
  )
  (func $do-select (param $list (ref $A)) (result i32)
    (select
      (i32.const 0)
      (ref.test (ref $B)
        (local.get $list)
      )
      (ref.is_null
        (struct.get $A $next
          (local.get $list)
        )
      )
    )
  )

  ;; Use an iff to do the same.
  (func $iff-nextor (export "iff-nextor") (param $list (ref $A)) (result i32)
    (call $iter
      (local.get $list)
      (ref.func $do-iff-nextor)
    )
  )
  (func $do-iff-nextor (param $list (ref $A)) (result i32)
    (if (result i32)
      (ref.is_null
        (struct.get $A $next
          (local.get $list)
        )
      )
      (then
        (i32.const 0)
      )
      (else
        (ref.test (ref $B)
          (local.get $list)
        )
      )
    )
  )

  ;; Use an if over three tests: "test if next is B or C depending on if curr is
  ;; B."
  (func $iff-three (export "iff-three") (param $list (ref $A)) (result i32)
    (call $iter
      (local.get $list)
      (ref.func $do-iff-three)
    )
  )
  (func $do-iff-three (param $list (ref $A)) (result i32)
    (local $next (ref null $A))
    (local.set $next
      (struct.get $A $next
        (local.get $list)
      )
    )
    (if (result i32)
      (ref.test (ref $B)
        (local.get $list)
      )
      (then
        (ref.test (ref $C)
          (local.get $next)
        )
      )
      (else
        (ref.test (ref $B)
          (local.get $next)
        )
      )
    )
  )

  ;; Use a select for the same.
  (func $select-three (export "select-three") (param $list (ref $A)) (result i32)
    (call $iter
      (local.get $list)
      (ref.func $do-select-three)
    )
  )
  (func $do-select-three (param $list (ref $A)) (result i32)
    (local $next (ref null $A))
    (local.set $next
      (struct.get $A $next
        (local.get $list)
      )
    )
    (select
      (ref.test (ref $C)
        (local.get $next)
      )
      (ref.test (ref $B)
        (local.get $next)
      )
      (ref.test (ref $B)
        (local.get $list)
      )
    )
  )

  ;; Creation functions.

  (func $makeA (export "makeA") (param $next (ref null $A)) (result anyref)
    (struct.new $A
      (local.get $next)
    )
  )

  (func $makeB (export "makeB") (param $next (ref null $A)) (result anyref)
    (struct.new $B
      (local.get $next)
    )
  )

  (func $makeC (export "makeC") (param $next (ref null $A)) (result anyref)
    ;; This function is not used in benchmarks yet, but it keeps the type $C
    ;; alive, which prevents $B from looking like it could be final, which might
    ;; allow the optimizer to simplify more than we want.
    (struct.new $C
      (local.get $next)
    )
  )
)

