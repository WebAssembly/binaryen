(module
 (global $global$0 (mut f64) (f64.const -32768))
 (global $global$1 (mut i32) (i32.const 100))
 (memory $0 1 1)
 (export "func_217" (func $1))
 (func $0
  (if
   (get_global $global$1)
   (unreachable)
  )
  (set_global $global$1
   (i32.const 0)
  )
  (block $label$2
   (set_global $global$0
    (block $label$3 (result f64)
     (br_if $label$2
      (if (result i32)
       (i32.load16_u offset=3
        (i32.const 0)
       )
       (i32.const 1)
       (i32.const 0)
      )
     )
     (unreachable)
    )
   )
  )
 )
 (func $1 (param $var$0 i32)
  (drop
   (call $2
    (f32.const 1)
    (i32.const 1)
    (i32.const 0)
   )
  )
 )
 (func $2 (param $var$0 f32) (param $var$1 i32) (param $var$2 i32) (result i32)
  (call $0)
  (i32.const 0)
 )
)
