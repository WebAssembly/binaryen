(module
  (memory 0 4294967295)
  (type $FUNCSIG$fff (func (param f32 f32) (result f32)))
  (type $FUNCSIG$ddd (func (param f64 f64) (result f64)))
  (import $fmodf "env" "fmodf" (param f32 f32) (result f32))
  (import $fmod "env" "fmod" (param f64 f64) (result f64))
  (export "frem32" $frem32)
  (export "frem64" $frem64)
  (func $frem32 (param $$0 f32) (param $$1 f32) (result f32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (call_import $fmodf
            (get_local $$0)
            (get_local $$1)
          )
        )
      )
    )
  )
  (func $frem64 (param $$0 f64) (param $$1 f64) (result f64)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (call_import $fmod
            (get_local $$0)
            (get_local $$1)
          )
        )
      )
    )
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 0 }
