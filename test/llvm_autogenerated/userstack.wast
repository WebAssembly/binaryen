(module
 (type $FUNCSIG$vi (func (param i32)))
 (import "env" "ext_func" (func $ext_func (param i32)))
 (import "env" "ext_func_i32" (func $ext_func_i32 (param i32)))
 (import "env" "use_i8_star" (func $use_i8_star (param i32)))
 (import "env" "memory" (memory $0 1))
 (table 0 anyfunc)
 (data (i32.const 4) "\10\04\00\00")
 (export "alloca32" (func $alloca32))
 (export "alloca3264" (func $alloca3264))
 (export "allocarray" (func $allocarray))
 (export "non_mem_use" (func $non_mem_use))
 (export "allocarray_inbounds" (func $allocarray_inbounds))
 (export "dynamic_alloca" (func $dynamic_alloca))
 (export "dynamic_alloca_redzone" (func $dynamic_alloca_redzone))
 (export "dynamic_static_alloca" (func $dynamic_static_alloca))
 (export "llvm_stack_builtins" (func $llvm_stack_builtins))
 (export "dynamic_alloca_nouse" (func $dynamic_alloca_nouse))
 (export "copytoreg_fi" (func $copytoreg_fi))
 (export "frameaddress_0" (func $frameaddress_0))
 (export "frameaddress_1" (func $frameaddress_1))
 (export "inline_asm" (func $inline_asm))
 (func $alloca32
  (local $0 i32)
  (i32.store offset=4
   (i32.const 0)
   (tee_local $0
    (i32.sub
     (i32.load offset=4
      (i32.const 0)
     )
     (i32.const 16)
    )
   )
  )
  (i32.store offset=12
   (get_local $0)
   (i32.const 0)
  )
  (i32.store offset=4
   (i32.const 0)
   (i32.add
    (get_local $0)
    (i32.const 16)
   )
  )
  (return)
 )
 (func $alloca3264
  (local $0 i32)
  (i32.store offset=12
   (tee_local $0
    (i32.sub
     (i32.load offset=4
      (i32.const 0)
     )
     (i32.const 16)
    )
   )
   (i32.const 0)
  )
  (i64.store
   (get_local $0)
   (i64.const 0)
  )
  (return)
 )
 (func $allocarray
  (local $0 i32)
  (i32.store offset=4
   (i32.const 0)
   (tee_local $0
    (i32.sub
     (i32.load offset=4
      (i32.const 0)
     )
     (i32.const 144)
    )
   )
  )
  (i32.store
   (i32.add
    (get_local $0)
    (i32.const 24)
   )
   (i32.const 1)
  )
  (i32.store offset=12
   (get_local $0)
   (i32.const 1)
  )
  (i32.store offset=4
   (i32.const 0)
   (i32.add
    (get_local $0)
    (i32.const 144)
   )
  )
  (return)
 )
 (func $non_mem_use (param $0 i32)
  (local $1 i32)
  (i32.store offset=4
   (i32.const 0)
   (tee_local $1
    (i32.sub
     (i32.load offset=4
      (i32.const 0)
     )
     (i32.const 48)
    )
   )
  )
  (call $ext_func
   (i32.add
    (get_local $1)
    (i32.const 8)
   )
  )
  (call $ext_func
   (get_local $1)
  )
  (i32.store
   (get_local $0)
   (i32.add
    (get_local $1)
    (i32.const 16)
   )
  )
  (i32.store offset=4
   (i32.const 0)
   (i32.add
    (get_local $1)
    (i32.const 48)
   )
  )
  (return)
 )
 (func $allocarray_inbounds
  (local $0 i32)
  (i32.store offset=4
   (i32.const 0)
   (tee_local $0
    (i32.sub
     (i32.load offset=4
      (i32.const 0)
     )
     (i32.const 32)
    )
   )
  )
  (i32.store offset=24
   (get_local $0)
   (i32.const 1)
  )
  (i32.store offset=12
   (get_local $0)
   (i32.const 1)
  )
  (call $ext_func
   (i32.const 0)
  )
  (i32.store offset=4
   (i32.const 0)
   (i32.add
    (get_local $0)
    (i32.const 32)
   )
  )
  (return)
 )
 (func $dynamic_alloca (param $0 i32)
  (local $1 i32)
  (i32.store offset=4
   (i32.const 0)
   (tee_local $0
    (i32.sub
     (tee_local $1
      (i32.load offset=4
       (i32.const 0)
      )
     )
     (i32.and
      (i32.add
       (i32.shl
        (get_local $0)
        (i32.const 2)
       )
       (i32.const 15)
      )
      (i32.const -16)
     )
    )
   )
  )
  (call $ext_func_i32
   (get_local $0)
  )
  (i32.store offset=4
   (i32.const 0)
   (get_local $1)
  )
  (return)
 )
 (func $dynamic_alloca_redzone (param $0 i32)
  (local $1 i32)
  (drop
   (tee_local $1
    (i32.load offset=4
     (i32.const 0)
    )
   )
  )
  (drop
   (tee_local $0
    (i32.sub
     (get_local $1)
     (i32.and
      (i32.add
       (i32.shl
        (get_local $0)
        (i32.const 2)
       )
       (i32.const 15)
      )
      (i32.const -16)
     )
    )
   )
  )
  (i32.store
   (get_local $0)
   (i32.const 0)
  )
  (return)
 )
 (func $dynamic_static_alloca (param $0 i32)
  (local $1 i32)
  (local $2 i32)
  (local $3 i32)
  (i32.store offset=4
   (i32.const 0)
   (tee_local $2
    (i32.sub
     (i32.load offset=4
      (i32.const 0)
     )
     (i32.const 16)
    )
   )
  )
  (i32.store offset=12
   (tee_local $1
    (get_local $2)
   )
   (i32.const 101)
  )
  (i32.store offset=4
   (i32.const 0)
   (tee_local $3
    (tee_local $2
     (i32.sub
      (get_local $2)
      (tee_local $0
       (i32.and
        (i32.add
         (i32.shl
          (get_local $0)
          (i32.const 2)
         )
         (i32.const 15)
        )
        (i32.const -16)
       )
      )
     )
    )
   )
  )
  (i32.store offset=12
   (get_local $1)
   (i32.const 102)
  )
  (i32.store
   (get_local $2)
   (i32.const 103)
  )
  (i32.store offset=4
   (i32.const 0)
   (tee_local $0
    (i32.sub
     (get_local $3)
     (get_local $0)
    )
   )
  )
  (i32.store offset=12
   (get_local $1)
   (i32.const 104)
  )
  (i32.store
   (get_local $2)
   (i32.const 105)
  )
  (i32.store
   (get_local $0)
   (i32.const 106)
  )
  (i32.store offset=4
   (i32.const 0)
   (i32.add
    (get_local $1)
    (i32.const 16)
   )
  )
  (return)
 )
 (func $llvm_stack_builtins (param $0 i32)
  (local $1 i32)
  (local $2 i32)
  (local $3 i32)
  (set_local $2
   (tee_local $3
    (i32.load offset=4
     (i32.const 0)
    )
   )
  )
  (set_local $1
   (get_local $3)
  )
  (i32.store offset=4
   (i32.const 0)
   (i32.sub
    (get_local $3)
    (i32.and
     (i32.add
      (i32.shl
       (get_local $0)
       (i32.const 2)
      )
      (i32.const 15)
     )
     (i32.const -16)
    )
   )
  )
  (drop
   (get_local $1)
  )
  (i32.store offset=4
   (i32.const 0)
   (get_local $2)
  )
  (return)
 )
 (func $dynamic_alloca_nouse (param $0 i32)
  (local $1 i32)
  (local $2 i32)
  (set_local $1
   (tee_local $2
    (i32.load offset=4
     (i32.const 0)
    )
   )
  )
  (i32.store offset=4
   (i32.const 0)
   (i32.sub
    (get_local $2)
    (i32.and
     (i32.add
      (i32.shl
       (get_local $0)
       (i32.const 2)
      )
      (i32.const 15)
     )
     (i32.const -16)
    )
   )
  )
  (i32.store offset=4
   (i32.const 0)
   (get_local $1)
  )
  (return)
 )
 (func $copytoreg_fi (param $0 i32) (param $1 i32)
  (local $2 i32)
  (set_local $2
   (i32.add
    (i32.sub
     (i32.load offset=4
      (i32.const 0)
     )
     (i32.const 16)
    )
    (i32.const 12)
   )
  )
  (set_local $0
   (i32.and
    (get_local $0)
    (i32.const 1)
   )
  )
  (loop $label$0
   (i32.store
    (get_local $2)
    (i32.const 1)
   )
   (set_local $2
    (get_local $1)
   )
   (br_if $label$0
    (get_local $0)
   )
  )
  (return)
 )
 (func $frameaddress_0
  (local $0 i32)
  (call $use_i8_star
   (tee_local $0
    (i32.load offset=4
     (i32.const 0)
    )
   )
  )
  (i32.store offset=4
   (i32.const 0)
   (get_local $0)
  )
  (return)
 )
 (func $frameaddress_1
  (call $use_i8_star
   (i32.const 0)
  )
  (return)
 )
 (func $inline_asm
  (local $0 i32)
  (set_local $0
   (i32.add
    (i32.sub
     (i32.load offset=4
      (i32.const 0)
     )
     (i32.const 16)
    )
    (i32.const 15)
   )
  )
  (return)
 )
)
;; METADATA: { "asmConsts": {},"staticBump": 1040, "initializers": [] }
