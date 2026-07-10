(module $Mem
  (memory (export "shared") 1 1 shared)
)
(register "mem")

(thread $T1 (shared (module $Mem))
  (register "mem" $Mem)
  (module
    (memory (import "mem" "shared") 1 1 shared)
    (func (export "run")
      (i32.atomic.store (i32.const 0) (i32.const 1))
    )
  )
  (invoke "run")
)


(wait $T1)

(module $Check
  (memory (import "mem" "shared") 1 1 shared)

  (func (export "check") (result i32)
    (i32.load (i32.const 0))
    (return)
  )
)

(assert_return (invoke $Check "check") (i32.const 1))
