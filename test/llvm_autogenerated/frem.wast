(module
  (memory 1
    (segment 4 "\10\04\00\00")
  )
  (export "memory" memory)
  (type $FUNCSIG$ddd (func (param f64 f64) (result f64)))
  (type $FUNCSIG$fff (func (param f32 f32) (result f32)))
  (import $fmod "env" "fmod" (param f64 f64) (result f64))
  (import $fmodf "env" "fmodf" (param f32 f32) (result f32))
  (export "frem32" $frem32)
  (export "frem64" $frem64)
  (func $frem32 (param $$0 f32) (param $$1 f32) (result f32)
    (return
      (call_import $fmodf
        (get_local $$0)
        (get_local $$1)
      )
    )
  )
  (func $frem64 (param $$0 f64) (param $$1 f64) (result f64)
    (return
      (call_import $fmod
        (get_local $$0)
        (get_local $$1)
      )
    )
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 1040, "initializers": [] }
