(module
  (memory 1
    (segment 4 "\10\04\00\00")
  )
  (export "memory" memory)
  (type $FUNCSIG$vi (func (param i32)))
  (import $callee "env" "callee" (param i32))
  (export "start" $start)
  (export "end" $end)
  (export "copy" $copy)
  (export "arg_i8" $arg_i8)
  (export "arg_i32" $arg_i32)
  (export "arg_i128" $arg_i128)
  (export "caller_none" $caller_none)
  (export "caller_some" $caller_some)
  (export "startbb" $startbb)
  (func $start (param $0 i32) (param $1 i32)
    (i32.store
      (get_local $0)
      (get_local $1)
    )
    (return)
  )
  (func $end (param $0 i32)
    (return)
  )
  (func $copy (param $0 i32) (param $1 i32)
    (i32.store
      (get_local $0)
      (i32.load
        (get_local $1)
      )
    )
    (return)
  )
  (func $arg_i8 (param $0 i32) (result i32)
    (local $1 i32)
    (i32.store
      (get_local $0)
      (i32.add
        (set_local $1
          (i32.load
            (get_local $0)
          )
        )
        (i32.const 4)
      )
    )
    (return
      (i32.load
        (get_local $1)
      )
    )
  )
  (func $arg_i32 (param $0 i32) (result i32)
    (local $1 i32)
    (i32.store
      (get_local $0)
      (i32.add
        (set_local $1
          (i32.and
            (i32.add
              (i32.load
                (get_local $0)
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
        (get_local $1)
      )
    )
  )
  (func $arg_i128 (param $0 i32) (param $1 i32)
    (local $2 i32)
    (local $3 i32)
    (local $4 i64)
    (set_local $2
      (i32.store
        (get_local $1)
        (i32.add
          (set_local $3
            (i32.and
              (i32.add
                (i32.load
                  (get_local $1)
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
    (set_local $4
      (i64.load
        (get_local $3)
      )
    )
    (i32.store
      (get_local $1)
      (i32.add
        (get_local $3)
        (i32.const 16)
      )
    )
    (i64.store
      (i32.add
        (get_local $0)
        (i32.const 8)
      )
      (i64.load
        (get_local $2)
      )
    )
    (i64.store
      (get_local $0)
      (get_local $4)
    )
    (return)
  )
  (func $caller_none
    (call_import $callee
      (i32.const 0)
    )
    (return)
  )
  (func $caller_some
    (local $0 i32)
    (i64.store offset=8
      (set_local $0
        (i32.store
          (i32.const 4)
          (i32.sub
            (i32.load
              (i32.const 4)
            )
            (i32.const 16)
          )
        )
      )
      (i64.const 4611686018427387904)
    )
    (i32.store
      (get_local $0)
      (i32.const 0)
    )
    (call_import $callee
      (get_local $0)
    )
    (i32.store
      (i32.const 4)
      (i32.add
        (get_local $0)
        (i32.const 16)
      )
    )
    (return)
  )
  (func $startbb (param $0 i32) (param $1 i32) (param $2 i32)
    (block $label$0
      (br_if $label$0
        (i32.eqz
          (i32.and
            (get_local $0)
            (i32.const 1)
          )
        )
      )
      (return)
    )
    (i32.store
      (get_local $1)
      (get_local $2)
    )
    (return)
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 1040, "initializers": [] }
