(module
 (type $FUNCSIG$ddd (func (param f64 f64) (result f64)))
 (type $FUNCSIG$fff (func (param f32 f32) (result f32)))
 (import "env" "memory" (memory $0 1))
 (table 0 anyfunc)
 (data (i32.const 4) "\10\04\00\00")
 (export "fold_promote" (func $fold_promote))
 (export "fold_demote" (func $fold_demote))
 (func $fold_promote (param $0 f64) (param $1 f32) (result f64)
  (f64.copysign
   (get_local $0)
   (f64.promote/f32
    (get_local $1)
   )
  )
 )
 (func $fold_demote (param $0 f32) (param $1 f64) (result f32)
  (f32.copysign
   (get_local $0)
   (f32.demote/f64
    (get_local $1)
   )
  )
 )
)
;; METADATA: { "asmConsts": {},"staticBump": 1040, "initializers": [] }
