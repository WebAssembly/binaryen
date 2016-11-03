(module
  (import "env" "memory" (memory $0 1))
  (table 0 anyfunc)
  (data (i32.const 4) "\10\04\00\00")
  (export "f0" (func $f0))
  (export "f1" (func $f1))
  (export "f2" (func $f2))
  (export "f3" (func $f3))
  (export "f4" (func $f4))
  (export "f5" (func $f5))
  (func $f0
    (return)
  )
  (func $f1 (result i32)
    (return
      (i32.const 0)
    )
  )
  (func $f2 (param $0 i32) (param $1 f32) (result i32)
    (return
      (i32.const 0)
    )
  )
  (func $f3 (param $0 i32) (param $1 f32)
    (return)
  )
  (func $f4 (param $0 i32) (result i32)
    (block $label$0
      (br_if $label$0
        (i32.eqz
          (i32.and
            (get_local $0)
            (i32.const 1)
          )
        )
      )
      (return
        (i32.const 0)
      )
    )
    (return
      (i32.const 1)
    )
  )
  (func $f5 (result f32)
    (unreachable)
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 1040, "initializers": [] }
