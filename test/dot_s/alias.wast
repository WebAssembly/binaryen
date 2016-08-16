(module
  (memory 1
    (segment 16 "\d2\04\00\00\00\00\00\00)\t\00\00")
  )
  (export "memory" memory)
  (type $FUNCSIG$v (func))
  (type $anyfunc (func (param none)))
  (export "__exit" $__exit)
  (export "__needs_exit" $__needs_exit)
  (export "dynCall_v" $dynCall_v)
  (table $0 default (type $anyfunc (func (param none))) $__wasm_nullptr_0 $__exit)
  (func $__exit (type $FUNCSIG$v)
    (return
      (i32.add
        (i32.load
          (i32.const 16)
        )
        (i32.load
          (i32.const 24)
        )
      )
    )
  )
  (func $__needs_exit (result i32)
    (call $__exit)
    (return
      (i32.const 1)
    )
  )
  (func $__wasm_nullptr_0 (type $FUNCSIG$v)
    (unreachable)
  )
  (func $dynCall_v (param $fptr i32)
    (call_indirect $0 $FUNCSIG$v
      (get_local $fptr)
    )
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 28, "initializers": [] }
