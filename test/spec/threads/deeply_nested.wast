(module $Mem
  (memory (export "shared") 1 1 shared)
)

(register "mem" $Mem)


(thread $T1 (shared (module $Mem))
  (register "mem" $Mem)
  (module
    (memory (import "mem" "shared") 1 10 shared)
    (func (export "run")
      (local i32)
      (i32.store (i32.const 0) (i32.const 1))
      (i32.load (i32.const 4))
      (local.set 0)

      (i32.store (i32.const 24) (local.get 0))
    )
  )

  (thread $T11 (shared (module $Mem))
    (register "mem" $Mem)
    (module
      (memory (import "mem" "shared") 1 1 shared)
      (func (export "run_inner")
        (i32.store (i32.const 24) (i32.const 42))
      )
    )
    (invoke "run_inner")
  )

  (thread $T12 (shared (module $Mem))
    (register "mem" $Mem)
    (module
      (memory (import "mem" "shared") 1 1 shared)
      (func (export "run_inner")
        (i32.store (i32.const 32) (i32.const 43))
      )
    )

    (thread $T121 (shared (module $Mem))
      (register "mem" $Mem)
      (module
        (memory (import "mem" "shared") 1 1 shared)
        (func (export "run_innermost")
          (i32.store (i32.const 24) (i32.const 44))
        )
      )
      (invoke "run_innermost")
    )
    (thread $T122 (shared (module $Mem))
      (register "mem" $Mem)
      (module
        (memory (import "mem" "shared") 1 1 shared)
        (func (export "run_innermost")
          (i32.store (i32.const 32) (i32.const 45))
        )
      )
      (invoke "run_innermost")
    )

    (wait $T121)
    (wait $T122)

    (invoke "run_inner")
  )


  (wait $T11)
  (wait $T12)
  (invoke "run")
)

(thread $T2 (shared (module $Mem))
  (register "mem" $Mem)
  (module
    (memory (import "mem" "shared") 1 1 shared)
    (func (export "run")
      (local i32)
      (i32.store (i32.const 4) (i32.const 1))
      (i32.load (i32.const 0))
      (local.set 0)

      (i32.store (i32.const 32) (local.get 0))
    )
  )

  (invoke "run")
)

(wait $T1)
(wait $T2)
