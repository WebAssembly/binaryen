(module
  (memory 1
    (segment 4 "\10\04\00\00")
  )
  (export "memory" memory)
  (type $FUNCSIG$v (func))
  (import $callee "env" "callee")
  (export "end" $end)
  (export "copy" $copy)
  (export "arg_i8" $arg_i8)
  (export "arg_i32" $arg_i32)
  (export "arg_i128" $arg_i128)
  (export "caller_none" $caller_none)
  (export "caller_some" $caller_some)
  (func $end (param $$0 i32)
    (return)
  )
  (func $copy (param $$0 i32) (param $$1 i32)
    (i32.store
      (get_local $$0)
      (i32.load
        (get_local $$1)
      )
    )
    (return)
  )
  (func $arg_i8 (param $$0 i32) (result i32)
    (local $$1 i32)
    (i32.store
      (get_local $$0)
      (i32.add
        (set_local $$1
          (i32.load
            (get_local $$0)
          )
        )
        (i32.const 4)
      )
    )
    (return
      (i32.load
        (get_local $$1)
      )
    )
  )
  (func $arg_i32 (param $$0 i32) (result i32)
    (local $$1 i32)
    (i32.store
      (get_local $$0)
      (i32.add
        (set_local $$1
          (i32.and
            (i32.add
              (i32.load
                (get_local $$0)
              )
              (i32.const 3)
            )
            (i32.const -4)
          )
        )
        (i32.const 4)
      )
    )
    (return
      (i32.load
        (get_local $$1)
      )
    )
  )
  (func $arg_i128 (param $$0 i32) (param $$1 i32)
    (local $$2 i32)
    (local $$3 i64)
    (local $$4 i32)
    (set_local $$2
      (i32.store
        (get_local $$1)
        (i32.add
          (set_local $$4
            (i32.and
              (i32.add
                (i32.load
                  (get_local $$1)
                )
                (i32.const 7)
              )
              (i32.const -8)
            )
          )
          (i32.const 8)
        )
      )
    )
    (set_local $$3
      (i64.load
        (get_local $$4)
      )
    )
    (i32.store
      (get_local $$1)
      (i32.add
        (get_local $$4)
        (i32.const 16)
      )
    )
    (i64.store
      (i32.add
        (get_local $$0)
        (i32.const 8)
      )
      (i64.load
        (get_local $$2)
      )
    )
    (i64.store
      (get_local $$0)
      (get_local $$3)
    )
    (return)
  )
  (func $caller_none
    (call_import $callee)
    (return)
  )
  (func $caller_some
    (local $$0 i32)
    (local $$1 i32)
    (local $$2 i32)
    (local $$3 i32)
    (local $$4 i32)
    (local $$5 i32)
    (local $$6 i32)
    (local $$7 i32)
    (local $$8 i32)
    (set_local $$5
      (i32.const 4)
    )
    (set_local $$5
      (i32.load
        (get_local $$5)
      )
    )
    (set_local $$6
      (i32.const 16)
    )
    (set_local $$8
      (i32.sub
        (get_local $$5)
        (get_local $$6)
      )
    )
    (set_local $$6
      (i32.const 4)
    )
    (set_local $$8
      (i32.store
        (get_local $$6)
        (get_local $$8)
      )
    )
    (set_local $$1
      (i32.const 4)
    )
    (set_local $$1
      (i32.load
        (get_local $$1)
      )
    )
    (set_local $$2
      (i32.const 16)
    )
    (set_local $$8
      (i32.sub
        (get_local $$1)
        (get_local $$2)
      )
    )
    (set_local $$2
      (i32.const 4)
    )
    (set_local $$8
      (i32.store
        (get_local $$2)
        (get_local $$8)
      )
    )
    (i32.store
      (get_local $$8)
      (i32.const 0)
    )
    (set_local $$0
      (i32.add
        (get_local $$8)
        (i32.const 8)
      )
    )
    (i64.store
      (get_local $$0)
      (i64.const 4611686018427387904)
    )
    (call_import $callee)
    (set_local $$3
      (i32.const 4)
    )
    (set_local $$3
      (i32.load
        (get_local $$3)
      )
    )
    (set_local $$4
      (i32.const 16)
    )
    (set_local $$8
      (i32.add
        (get_local $$3)
        (get_local $$4)
      )
    )
    (set_local $$4
      (i32.const 4)
    )
    (set_local $$8
      (i32.store
        (get_local $$4)
        (get_local $$8)
      )
    )
    (set_local $$7
      (i32.const 16)
    )
    (set_local $$8
      (i32.add
        (get_local $$8)
        (get_local $$7)
      )
    )
    (set_local $$7
      (i32.const 4)
    )
    (set_local $$8
      (i32.store
        (get_local $$7)
        (get_local $$8)
      )
    )
    (return)
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 1040, "initializers": [] }
