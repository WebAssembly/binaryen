(module
 (memory $0 256 256)
 (func $__ZN10WasmAssertC2Ev__async_cb (param $$0 i32)
  (block $switch-default
   (block $switch-case
    (br_table $switch-case $switch-default
     (i32.const 0)
    )
   )
   (block
    (i32.store
     (i32.const 12)
     (i32.const 26)
    )
    (return)
   )
  )
  (block
   (set_local $$0
    (i32.const 4)
   )
   (i32.store
    (get_local $$0)
    (i32.const 1)
   )
  )
 )
)
