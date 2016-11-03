(module
  (type $FUNCSIG$ddd (func (param f64 f64) (result f64)))
  (type $FUNCSIG$fff (func (param f32 f32) (result f32)))
  (import "env" "fmod" (func $fmod (param f64 f64) (result f64)))
  (import "env" "fmodf" (func $fmodf (param f32 f32) (result f32)))
  (import "env" "memory" (memory $0 1))
  (table 0 anyfunc)
  (data (i32.const 4) "\10\04\00\00")
  (export "frem32" (func $frem32))
  (export "frem64" (func $frem64))
  (func $frem32 (param $0 f32) (param $1 f32) (result f32)
    (return
      (call $fmodf
        (get_local $0)
        (get_local $1)
      )
    )
  )
  (func $frem64 (param $0 f64) (param $1 f64) (result f64)
    (return
      (call $fmod
        (get_local $0)
        (get_local $1)
      )
    )
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 1040, "initializers": [] }
