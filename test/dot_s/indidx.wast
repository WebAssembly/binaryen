(module
  (memory 1
    (segment 16 "\01\00\00\00\02\00\00\00\03\00\00\00\04\00\00\00")
  )
  (export "memory" memory)
  (type $FUNCSIG$i (func (result i32)))
  (type $anyfunc (func (param none)))
  (type $FUNCSIG$v (func))
  (import $getchar "env" "getchar" (result i32))
  (export "main" $main)
  (export "dynCall_i" $dynCall_i)
  (table $0 default (type $anyfunc (func (param none))) $__wasm_nullptr_0)
  (table $1 (type $FUNCSIG$i (func (result i32))) $__wasm_nullptr_1 $a $b $c $d)
  (func $a (type $FUNCSIG$i) (result i32)
    (i32.const 0)
  )
  (func $b (type $FUNCSIG$i) (result i32)
    (i32.const 1)
  )
  (func $c (type $FUNCSIG$i) (result i32)
    (i32.const 2)
  )
  (func $d (type $FUNCSIG$i) (result i32)
    (i32.const 3)
  )
  (func $main (param $0 i32) (param $1 i32) (result i32)
    (local $2 i32)
    (block $label$0
      (br_if $label$0
        (i32.ge_u
          (set_local $2
            (i32.load
              (i32.add
                (i32.shl
                  (call_import $getchar)
                  (i32.const 2)
                )
                (i32.const -176)
              )
            )
          )
          (i32.const 4)
        )
      )
      (return
        (call_indirect $1 $FUNCSIG$i
          (get_local $2)
        )
      )
    )
    (unreachable)
    (unreachable)
  )
  (func $__wasm_nullptr_1 (type $FUNCSIG$i) (result i32)
    (unreachable)
  )
  (func $__wasm_nullptr_0 (type $FUNCSIG$v)
    (unreachable)
  )
  (func $dynCall_i (param $fptr i32) (result i32)
    (call_indirect $1 $FUNCSIG$i
      (get_local $fptr)
    )
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 32, "initializers": [] }
