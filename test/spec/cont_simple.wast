(module $state
  (type $f (func))
  (type $k (cont $f))

  (import "spectest" "print" (func $print (param i32)))

  (tag $more)

  (func $run (export "run")
    (local $k (ref $k))
    (local.set $k
      (cont.new $k (ref.func $f))
    )
    (loop $loop
      (call $print (i32.const 100))
      (block $on (result (ref $k))
        (resume $k (on $more $on)
          (local.get $k)
        )
        (call $print (i32.const 200))
        (return)
      )
      ;; on
      (call $print (i32.const 300))
      (local.set $k)
      (br $loop)
    )
    (unreachable)
  )

  (func $f
    (call $print (i32.const -1))
    (suspend $more)
    (call $print (i32.const -2))
    (suspend $more)
    (call $print (i32.const -3))
  )
)

(assert_return (invoke "run") (i32.const 19))

