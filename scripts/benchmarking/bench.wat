(module
  ;; A chain of three types. Each type has a "next" field, so we can form linked
  ;; lists.
  (type $A (sub (struct (field $next anyref))))
  (type $B (sub $A (struct (field $next anyref))))
  (type $C (sub $B (struct (field $next anyref))))

  (type $func (func (param (ref $A)) (result i32)))

  ;; Internal helper to iterate over a linked list and call a function on each
  ;; item, and return the sum of those calls' results.
  (func $iter (param $list (ref $A)) (param $func (ref $func)) (result i32)
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
                (local.get $list)
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
  (func $iff (export "iff") (param $list (ref $A)) (result i32)
    (call $iter
      (local.get $list)
      (ref.func $do-iff)
    )
  )
  (func $do-iff (param $list (ref $A)) (result i32)
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

  ;; Creation functions.

  (func $makeA (export "makeA") (param $next anyref) (result anyref)
    (struct.new $A
      (local.get $next)
    )
  )

  (func $makeB (export "makeA") (param $next anyref) (result anyref)
    (struct.new $B
      (local.get $next)
    )
  )

  (func $makeC (export "makeA") (param $next anyref) (result anyref)
    (struct.new $C
      (local.get $next)
    )
  )
)

