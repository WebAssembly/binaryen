(module
  (memory 1)
  (data (i32.const 4) "\10\04\00\00")
  (export "memory" memory)
  (type $FUNCSIG$vi (func (param i32)))
  (type $1 (func))
  (type $2 (func (param i32 i32)))
  (import $ext_func "env" "ext_func" (param i32))
  (import $ext_func_i32 "env" "ext_func_i32" (param i32))
  (import $use_i8_star "env" "use_i8_star" (param i32))
  (export "alloca32" $alloca32)
  (export "alloca3264" $alloca3264)
  (export "allocarray" $allocarray)
  (export "non_mem_use" $non_mem_use)
  (export "allocarray_inbounds" $allocarray_inbounds)
  (export "dynamic_alloca" $dynamic_alloca)
  (export "dynamic_alloca_redzone" $dynamic_alloca_redzone)
  (export "dynamic_static_alloca" $dynamic_static_alloca)
  (export "copytoreg_fi" $copytoreg_fi)
  (export "frameaddress_0" $frameaddress_0)
  (export "frameaddress_1" $frameaddress_1)
  (export "inline_asm" $inline_asm)
  (func $alloca32 (type $1)
    (local $0 i32)
    (local $1 i32)
    (i32.store offset=12
      (tee_local $0
        (block
          (block
            (set_local $1
              (i32.sub
                (i32.load
                  (i32.const 4)
                )
                (i32.const 16)
              )
            )
            (i32.store
              (i32.const 4)
              (get_local $1)
            )
          )
          (get_local $1)
        )
      )
      (i32.const 0)
    )
    (i32.store
      (i32.const 4)
      (i32.add
        (get_local $0)
        (i32.const 16)
      )
    )
    (return)
  )
  (func $alloca3264 (type $1)
    (local $0 i32)
    (i32.store offset=12
      (tee_local $0
        (i32.sub
          (i32.load
            (i32.const 4)
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
  (func $allocarray (type $1)
    (local $0 i32)
    (local $1 i32)
    (local $2 i32)
    (i32.store offset=12
      (tee_local $0
        (block
          (block
            (set_local $1
              (i32.sub
                (i32.load
                  (i32.const 4)
                )
                (i32.const 144)
              )
            )
            (i32.store
              (i32.const 4)
              (get_local $1)
            )
          )
          (get_local $1)
        )
      )
      (block
        (block
          (set_local $2
            (i32.const 1)
          )
          (i32.store
            (i32.add
              (get_local $0)
              (i32.const 24)
            )
            (get_local $2)
          )
        )
        (get_local $2)
      )
    )
    (i32.store
      (i32.const 4)
      (i32.add
        (get_local $0)
        (i32.const 144)
      )
    )
    (return)
  )
  (func $non_mem_use (type $FUNCSIG$vi) (param $0 i32)
    (local $1 i32)
    (local $2 i32)
    (call_import $ext_func
      (i32.add
        (tee_local $1
          (block
            (block
              (set_local $2
                (i32.sub
                  (i32.load
                    (i32.const 4)
                  )
                  (i32.const 48)
                )
              )
              (i32.store
                (i32.const 4)
                (get_local $2)
              )
            )
            (get_local $2)
          )
        )
        (i32.const 8)
      )
    )
    (call_import $ext_func
      (get_local $1)
    )
    (i32.store
      (get_local $0)
      (i32.add
        (get_local $1)
        (i32.const 16)
      )
    )
    (i32.store
      (i32.const 4)
      (i32.add
        (get_local $1)
        (i32.const 48)
      )
    )
    (return)
  )
  (func $allocarray_inbounds (type $1)
    (local $0 i32)
    (local $1 i32)
    (local $2 i32)
    (i32.store offset=12
      (tee_local $0
        (block
          (block
            (set_local $1
              (i32.sub
                (i32.load
                  (i32.const 4)
                )
                (i32.const 32)
              )
            )
            (i32.store
              (i32.const 4)
              (get_local $1)
            )
          )
          (get_local $1)
        )
      )
      (block
        (block
          (set_local $2
            (i32.const 1)
          )
          (i32.store offset=24
            (get_local $0)
            (get_local $2)
          )
        )
        (get_local $2)
      )
    )
    (call_import $ext_func
      (i32.const 0)
    )
    (i32.store
      (i32.const 4)
      (i32.add
        (get_local $0)
        (i32.const 32)
      )
    )
    (return)
  )
  (func $dynamic_alloca (type $FUNCSIG$vi) (param $0 i32)
    (local $1 i32)
    (i32.store
      (i32.const 4)
      (tee_local $0
        (i32.sub
          (tee_local $1
            (i32.load
              (i32.const 4)
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
    (call_import $ext_func_i32
      (get_local $0)
    )
    (i32.store
      (i32.const 4)
      (get_local $1)
    )
    (return)
  )
  (func $dynamic_alloca_redzone (type $FUNCSIG$vi) (param $0 i32)
    (local $1 i32)
    (set_local $1
      (i32.load
        (i32.const 4)
      )
    )
    (set_local $0
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
    (i32.store
      (get_local $0)
      (i32.const 0)
    )
    (return)
  )
  (func $dynamic_static_alloca (type $FUNCSIG$vi) (param $0 i32)
    (local $1 i32)
    (local $2 i32)
    (i32.store
      (i32.const 4)
      (tee_local $0
        (i32.sub
          (block
            (block
              (set_local $2
                (tee_local $1
                  (i32.sub
                    (i32.load
                      (i32.const 4)
                    )
                    (i32.const 16)
                  )
                )
              )
              (i32.store
                (i32.const 4)
                (get_local $2)
              )
            )
            (get_local $2)
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
    (i32.store
      (get_local $0)
      (i32.const 0)
    )
    (i32.store
      (i32.const 4)
      (i32.add
        (get_local $1)
        (i32.const 16)
      )
    )
    (return)
  )
  (func $copytoreg_fi (type $2) (param $0 i32) (param $1 i32)
    (local $2 i32)
    (set_local $2
      (i32.add
        (i32.sub
          (i32.load
            (i32.const 4)
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
    (loop $label$1 $label$0
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
  (func $frameaddress_0 (type $1)
    (local $0 i32)
    (call_import $use_i8_star
      (tee_local $0
        (i32.load
          (i32.const 4)
        )
      )
    )
    (i32.store
      (i32.const 4)
      (get_local $0)
    )
    (return)
  )
  (func $frameaddress_1 (type $1)
    (call_import $use_i8_star
      (i32.const 0)
    )
    (return)
  )
  (func $inline_asm (type $1)
    (local $0 i32)
    (set_local $0
      (i32.add
        (i32.sub
          (i32.load
            (i32.const 4)
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
