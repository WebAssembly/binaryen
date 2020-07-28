(module
 (memory $0 1 1)
 (export "func_0" (func $func_0))
 (export "func_1" (func $func_1))
 (func $func_0 (result i64)
  (block $label$0 (result i64)
   (loop $label$1 (result i64)
    (br_if $label$0
     (i64.const 1234)
     (i32.load16_s offset=22 align=1
      (i32.const -1)
     )
    )
   )
  )
 )
 (func $func_1 (result i32)
  (i32.load16_s offset=22 align=1
   (i32.const -1)
  )
 )
)
(module
 (type $f32_=>_none (func (param f32)))
 (type $none_=>_i64 (func (result i64)))
 (import "fuzzing-support" "log-f32" (func $fimport$0 (param f32)))
 (export "func_113" (func $0))
 (func $0 (result i64)
  (call $fimport$0
   (f32.div
    (f32.const -nan:0x23017a) ;; div by 1 can be removed, leaving this nan
    (f32.const 1)             ;; as it is. wasm semantics allow nan bits to
   )                          ;; change, but the interpreter should not do so,
  )                           ;; so that it does not fail on that opt.
  (i64.const 113)
 )
)

