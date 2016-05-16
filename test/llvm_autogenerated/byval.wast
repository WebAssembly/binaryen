(module
  (memory 1
    (segment 4 "\10\04\00\00")
  )
  (export "memory" memory)
  (type $FUNCSIG$vi (func (param i32)))
  (import $ext_byval_func "env" "ext_byval_func" (param i32))
  (import $ext_byval_func_align8 "env" "ext_byval_func_align8" (param i32))
  (import $ext_byval_func_alignedstruct "env" "ext_byval_func_alignedstruct" (param i32))
  (import $ext_byval_func_bigarray "env" "ext_byval_func_bigarray" (param i32))
  (import $ext_func "env" "ext_func" (param i32))
  (export "byval_arg" $byval_arg)
  (export "byval_arg_align8" $byval_arg_align8)
  (export "byval_arg_double" $byval_arg_double)
  (export "byval_arg_big" $byval_arg_big)
  (export "byval_param" $byval_param)
  (func $byval_arg (param $$0 i32)
    (local $$1 i32)
    (local $$2 i32)
    (local $$3 i32)
    (local $$4 i32)
    (local $$5 i32)
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
    (set_local $$5
      (i32.sub
        (get_local $$1)
        (get_local $$2)
      )
    )
    (set_local $$2
      (i32.const 4)
    )
    (set_local $$5
      (i32.store
        (get_local $$2)
        (get_local $$5)
      )
    )
    (i32.store offset=12
      (get_local $$5)
      (i32.load
        (get_local $$0)
      )
    )
    (set_local $$4
      (i32.const 12)
    )
    (set_local $$4
      (i32.add
        (get_local $$5)
        (get_local $$4)
      )
    )
    (call_import $ext_byval_func
      (get_local $$4)
    )
    (set_local $$3
      (i32.const 16)
    )
    (set_local $$5
      (i32.add
        (get_local $$5)
        (get_local $$3)
      )
    )
    (set_local $$3
      (i32.const 4)
    )
    (set_local $$5
      (i32.store
        (get_local $$3)
        (get_local $$5)
      )
    )
    (return)
  )
  (func $byval_arg_align8 (param $$0 i32)
    (local $$1 i32)
    (local $$2 i32)
    (local $$3 i32)
    (local $$4 i32)
    (local $$5 i32)
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
    (set_local $$5
      (i32.sub
        (get_local $$1)
        (get_local $$2)
      )
    )
    (set_local $$2
      (i32.const 4)
    )
    (set_local $$5
      (i32.store
        (get_local $$2)
        (get_local $$5)
      )
    )
    (i32.store offset=8 align=8
      (get_local $$5)
      (i32.load align=8
        (get_local $$0)
      )
    )
    (set_local $$4
      (i32.const 8)
    )
    (set_local $$4
      (i32.add
        (get_local $$5)
        (get_local $$4)
      )
    )
    (call_import $ext_byval_func_align8
      (get_local $$4)
    )
    (set_local $$3
      (i32.const 16)
    )
    (set_local $$5
      (i32.add
        (get_local $$5)
        (get_local $$3)
      )
    )
    (set_local $$3
      (i32.const 4)
    )
    (set_local $$5
      (i32.store
        (get_local $$3)
        (get_local $$5)
      )
    )
    (return)
  )
  (func $byval_arg_double (param $$0 i32)
    (local $$1 i32)
    (local $$2 i32)
    (local $$3 i32)
    (local $$4 i32)
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
    (set_local $$4
      (i32.sub
        (get_local $$1)
        (get_local $$2)
      )
    )
    (set_local $$2
      (i32.const 4)
    )
    (set_local $$4
      (i32.store
        (get_local $$2)
        (get_local $$4)
      )
    )
    (i64.store
      (i32.add
        (get_local $$4)
        (i32.const 8)
      )
      (i64.load
        (i32.add
          (get_local $$0)
          (i32.const 8)
        )
      )
    )
    (i64.store
      (get_local $$4)
      (i64.load
        (get_local $$0)
      )
    )
    (call_import $ext_byval_func_alignedstruct
      (get_local $$4)
    )
    (set_local $$3
      (i32.const 16)
    )
    (set_local $$4
      (i32.add
        (get_local $$4)
        (get_local $$3)
      )
    )
    (set_local $$3
      (i32.const 4)
    )
    (set_local $$4
      (i32.store
        (get_local $$3)
        (get_local $$4)
      )
    )
    (return)
  )
  (func $byval_arg_big (param $$0 i32)
    (local $$1 i32)
    (local $$2 i32)
    (local $$3 i32)
    (local $$4 i32)
    (local $$5 i32)
    (local $$6 i32)
    (local $$7 i32)
    (local $$8 i32)
    (local $$9 i32)
    (set_local $$1
      (i32.const 4)
    )
    (set_local $$1
      (i32.load
        (get_local $$1)
      )
    )
    (set_local $$2
      (i32.const 48)
    )
    (set_local $$9
      (i32.sub
        (get_local $$1)
        (get_local $$2)
      )
    )
    (set_local $$2
      (i32.const 4)
    )
    (set_local $$9
      (i32.store
        (get_local $$2)
        (get_local $$9)
      )
    )
    (set_local $$4
      (i32.const 12)
    )
    (set_local $$4
      (i32.add
        (get_local $$9)
        (get_local $$4)
      )
    )
    (i32.store8 align=4
      (i32.add
        (get_local $$4)
        (i32.const 32)
      )
      (i32.load8_u
        (i32.add
          (get_local $$0)
          (i32.const 32)
        )
      )
    )
    (set_local $$5
      (i32.const 12)
    )
    (set_local $$5
      (i32.add
        (get_local $$9)
        (get_local $$5)
      )
    )
    (i64.store align=4
      (i32.add
        (get_local $$5)
        (i32.const 24)
      )
      (i64.load align=1
        (i32.add
          (get_local $$0)
          (i32.const 24)
        )
      )
    )
    (set_local $$6
      (i32.const 12)
    )
    (set_local $$6
      (i32.add
        (get_local $$9)
        (get_local $$6)
      )
    )
    (i64.store align=4
      (i32.add
        (get_local $$6)
        (i32.const 16)
      )
      (i64.load align=1
        (i32.add
          (get_local $$0)
          (i32.const 16)
        )
      )
    )
    (set_local $$7
      (i32.const 12)
    )
    (set_local $$7
      (i32.add
        (get_local $$9)
        (get_local $$7)
      )
    )
    (i64.store align=4
      (i32.add
        (get_local $$7)
        (i32.const 8)
      )
      (i64.load align=1
        (i32.add
          (get_local $$0)
          (i32.const 8)
        )
      )
    )
    (i64.store offset=12 align=4
      (get_local $$9)
      (i64.load align=1
        (get_local $$0)
      )
    )
    (set_local $$8
      (i32.const 12)
    )
    (set_local $$8
      (i32.add
        (get_local $$9)
        (get_local $$8)
      )
    )
    (call_import $ext_byval_func_bigarray
      (get_local $$8)
    )
    (set_local $$3
      (i32.const 48)
    )
    (set_local $$9
      (i32.add
        (get_local $$9)
        (get_local $$3)
      )
    )
    (set_local $$3
      (i32.const 4)
    )
    (set_local $$9
      (i32.store
        (get_local $$3)
        (get_local $$9)
      )
    )
    (return)
  )
  (func $byval_param (param $$0 i32)
    (call_import $ext_func
      (get_local $$0)
    )
    (return)
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 1040, "initializers": [] }