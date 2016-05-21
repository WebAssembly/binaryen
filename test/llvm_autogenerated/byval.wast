(module
  (memory 1
    (segment 4 "\10\04\00\00")
  )
  (export "memory" memory)
  (type $FUNCSIG$vi (func (param i32)))
  (type $FUNCSIG$iiii (func (param i32 i32 i32) (result i32)))
  (import $big_byval_callee "env" "big_byval_callee" (param i32))
  (import $ext_byval_func "env" "ext_byval_func" (param i32))
  (import $ext_byval_func_align8 "env" "ext_byval_func_align8" (param i32))
  (import $ext_byval_func_alignedstruct "env" "ext_byval_func_alignedstruct" (param i32))
  (import $ext_byval_func_empty "env" "ext_byval_func_empty" (param i32))
  (import $ext_func "env" "ext_func" (param i32))
  (import $ext_func_empty "env" "ext_func_empty" (param i32))
  (import $memcpy "env" "memcpy" (param i32 i32 i32) (result i32))
  (export "byval_arg" $byval_arg)
  (export "byval_arg_align8" $byval_arg_align8)
  (export "byval_arg_double" $byval_arg_double)
  (export "byval_param" $byval_param)
  (export "byval_empty_caller" $byval_empty_caller)
  (export "byval_empty_callee" $byval_empty_callee)
  (export "big_byval" $big_byval)
  (func $byval_arg (param $0 i32)
    (local $1 i32)
    (i32.store offset=12
      (set_local $1
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
      (i32.load
        (get_local $0)
      )
    )
    (call_import $ext_byval_func
      (i32.add
        (get_local $1)
        (i32.const 12)
      )
    )
    (i32.store
      (i32.const 4)
      (i32.add
        (get_local $1)
        (i32.const 16)
      )
    )
    (return)
  )
  (func $byval_arg_align8 (param $0 i32)
    (local $1 i32)
    (i32.store offset=8
      (set_local $1
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
      (i32.load
        (get_local $0)
      )
    )
    (call_import $ext_byval_func_align8
      (i32.add
        (get_local $1)
        (i32.const 8)
      )
    )
    (i32.store
      (i32.const 4)
      (i32.add
        (get_local $1)
        (i32.const 16)
      )
    )
    (return)
  )
  (func $byval_arg_double (param $0 i32)
    (local $1 i32)
    (i64.store
      (i32.add
        (set_local $1
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
        (i32.const 8)
      )
      (i64.load
        (i32.add
          (get_local $0)
          (i32.const 8)
        )
      )
    )
    (i64.store
      (get_local $1)
      (i64.load
        (get_local $0)
      )
    )
    (call_import $ext_byval_func_alignedstruct
      (get_local $1)
    )
    (i32.store
      (i32.const 4)
      (i32.add
        (get_local $1)
        (i32.const 16)
      )
    )
    (return)
  )
  (func $byval_param (param $0 i32)
    (call_import $ext_func
      (get_local $0)
    )
    (return)
  )
  (func $byval_empty_caller (param $0 i32)
    (call_import $ext_byval_func_empty
      (get_local $0)
    )
    (return)
  )
  (func $byval_empty_callee (param $0 i32)
    (call_import $ext_func_empty
      (get_local $0)
    )
    (return)
  )
  (func $big_byval (param $0 i32)
    (call_import $big_byval_callee
      (set_local $0
        (call_import $memcpy
          (i32.store
            (i32.const 4)
            (i32.sub
              (i32.load
                (i32.const 4)
              )
              (i32.const 131072)
            )
          )
          (get_local $0)
          (i32.const 131072)
        )
      )
    )
    (i32.store
      (i32.const 4)
      (i32.add
        (get_local $0)
        (i32.const 131072)
      )
    )
    (return)
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 1040, "initializers": [] }
