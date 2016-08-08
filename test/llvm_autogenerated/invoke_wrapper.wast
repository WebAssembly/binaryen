(module
  (memory 1
    (segment 4 " \04\00\00")
    (segment 16 "\00")
    (segment 20 "\00\00\00\00")
    (segment 24 "\00\00\00\00")
  )
  (export "memory" memory)
  (type $FUNCSIG$i (func (result i32)))
  (type $FUNCSIG$ii (func (param i32) (result i32)))
  (type $FUNCSIG$v (func))
  (type $FUNCSIG$vi (func (param i32)))
  (type $FUNCSIG$iiiii (func (param i32 i32 i32 i32) (result i32)))
  (type $FUNCSIG$fifd (func (param i32 f32 f64) (result f32)))
  (type $FUNCSIG$iiii (func (param i32 i32 i32) (result i32)))
  (type $FUNCSIG$ffd (func (param f32 f64) (result f32)))
  (type $FUNCSIG$iii (func (param i32 i32) (result i32)))
  (import $__cxa_begin_catch "env" "__cxa_begin_catch" (param i32) (result i32))
  (import $__cxa_end_catch "env" "__cxa_end_catch")
  (import $__cxa_find_matching_catch_3 "env" "__cxa_find_matching_catch_3" (param i32) (result i32))
  (import $invoke_ffd "env" "invoke_ffd" (param i32 f32 f64) (result f32))
  (import $invoke_iii "env" "invoke_iii" (param i32 i32 i32) (result i32))
  (import $invoke_iiii "env" "invoke_iiii" (param i32 i32 i32 i32) (result i32))
  (import $invoke_v "env" "invoke_v" (param i32))
  (export "_Z5func1v" $_Z5func1v)
  (export "_Z5func2iii" $_Z5func2iii)
  (export "_Z5func3fd" $_Z5func3fd)
  (export "_Z5func4P8mystructS_" $_Z5func4P8mystructS_)
  (export "main" $main)
  (export "setThrew" $setThrew)
  (export "setTempRet0" $setTempRet0)
  (export "dynCall_v" $dynCall_v)
  (export "dynCall_iiii" $dynCall_iiii)
  (export "dynCall_ffd" $dynCall_ffd)
  (export "dynCall_iii" $dynCall_iii)
  (table $__wasm_nullptr $_Z5func1v $_Z5func2iii $_Z5func3fd $_Z5func4P8mystructS_)
  (func $_Z5func1v (type $FUNCSIG$v)
  )
  (func $_Z5func2iii (type $FUNCSIG$iiii) (param $0 i32) (param $1 i32) (param $2 i32) (result i32)
    (i32.const 3)
  )
  (func $_Z5func3fd (type $FUNCSIG$ffd) (param $0 f32) (param $1 f64) (result f32)
    (f32.const 1)
  )
  (func $_Z5func4P8mystructS_ (type $FUNCSIG$iii) (param $0 i32) (param $1 i32) (result i32)
    (i32.const 0)
  )
  (func $main (result i32)
    (local $0 i32)
    (local $1 i32)
    (local $2 i32)
    (local $3 i32)
    (set_local $1
      (i32.store offset=4
        (i32.const 0)
        (i32.sub
          (i32.load offset=4
            (i32.const 0)
          )
          (i32.const 48)
        )
      )
    )
    (set_local $0
      (i32.store8 offset=16
        (i32.const 0)
        (i32.const 0)
      )
    )
    (call_import $invoke_v
      (i32.const 1)
    )
    (set_local $2
      (i32.load8_u offset=16
        (get_local $0)
      )
    )
    (i32.store8 offset=16
      (get_local $0)
      (get_local $0)
    )
    (block $label$0
      (block $label$1
        (br_if $label$1
          (get_local $2)
        )
        (set_local $2
          (i32.store8 offset=16
            (get_local $0)
            (get_local $0)
          )
        )
        (call_import $invoke_iiii
          (i32.const 2)
          (i32.const 1)
          (i32.const 2)
          (i32.const 3)
        )
        (set_local $3
          (i32.load8_u offset=16
            (get_local $2)
          )
        )
        (i32.store8 offset=16
          (get_local $2)
          (get_local $2)
        )
        (br_if $label$1
          (get_local $3)
        )
        (set_local $2
          (i32.store8 offset=16
            (i32.const 0)
            (i32.const 0)
          )
        )
        (call_import $invoke_ffd
          (i32.const 3)
          (f32.const 1.5)
          (f64.const 3.4)
        )
        (set_local $3
          (i32.load8_u offset=16
            (get_local $2)
          )
        )
        (i32.store8 offset=16
          (get_local $2)
          (get_local $2)
        )
        (br_if $label$1
          (get_local $3)
        )
        (i32.store
          (set_local $3
            (i32.add
              (i32.add
                (get_local $1)
                (i32.const 16)
              )
              (i32.const 8)
            )
          )
          (i32.load
            (i32.add
              (i32.add
                (get_local $1)
                (i32.const 32)
              )
              (i32.const 8)
            )
          )
        )
        (i32.store offset=20
          (get_local $1)
          (i32.load offset=36
            (get_local $1)
          )
        )
        (i32.store offset=16
          (get_local $1)
          (i32.load offset=32
            (get_local $1)
          )
        )
        (i32.store8 offset=16
          (get_local $2)
          (get_local $2)
        )
        (i32.store
          (i32.add
            (i32.add
              (get_local $1)
              (i32.const 4)
            )
            (i32.const 8)
          )
          (i32.load
            (get_local $3)
          )
        )
        (i32.store
          (i32.add
            (get_local $1)
            (i32.const 8)
          )
          (i32.load offset=20
            (get_local $1)
          )
        )
        (i32.store offset=4
          (get_local $1)
          (i32.load offset=16
            (get_local $1)
          )
        )
        (call_import $invoke_iii
          (i32.const 4)
          (i32.add
            (get_local $1)
            (i32.const 32)
          )
          (i32.add
            (get_local $1)
            (i32.const 4)
          )
        )
        (set_local $3
          (i32.load8_u offset=16
            (get_local $2)
          )
        )
        (i32.store8 offset=16
          (get_local $2)
          (get_local $2)
        )
        (br_if $label$0
          (i32.eqz
            (get_local $3)
          )
        )
      )
      (call_import $__cxa_begin_catch
        (call_import $__cxa_find_matching_catch_3
          (get_local $0)
        )
      )
      (call_import $__cxa_end_catch)
    )
    (i32.store offset=4
      (i32.const 0)
      (i32.add
        (get_local $1)
        (i32.const 48)
      )
    )
    (i32.const 0)
  )
  (func $setThrew (param $0 i32) (param $1 i32)
    (block $label$0
      (br_if $label$0
        (i32.load8_u offset=16
          (i32.const 0)
        )
      )
      (i32.store8 offset=16
        (i32.const 0)
        (i32.and
          (get_local $0)
          (i32.const 1)
        )
      )
      (i32.store offset=20
        (i32.const 0)
        (get_local $1)
      )
    )
  )
  (func $setTempRet0 (param $0 i32)
    (i32.store offset=24
      (i32.const 0)
      (get_local $0)
    )
  )
  (func $__wasm_nullptr (type $FUNCSIG$v)
    (unreachable)
  )
  (func $dynCall_v (param $fptr i32)
    (call_indirect $FUNCSIG$v
      (get_local $fptr)
    )
  )
  (func $dynCall_iiii (param $fptr i32) (param $0 i32) (param $1 i32) (param $2 i32) (result i32)
    (call_indirect $FUNCSIG$iiii
      (get_local $fptr)
      (get_local $0)
      (get_local $1)
      (get_local $2)
    )
  )
  (func $dynCall_ffd (param $fptr i32) (param $0 f32) (param $1 f64) (result f32)
    (call_indirect $FUNCSIG$ffd
      (get_local $fptr)
      (get_local $0)
      (get_local $1)
    )
  )
  (func $dynCall_iii (param $fptr i32) (param $0 i32) (param $1 i32) (result i32)
    (call_indirect $FUNCSIG$iii
      (get_local $fptr)
      (get_local $0)
      (get_local $1)
    )
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 1056, "initializers": [] }
